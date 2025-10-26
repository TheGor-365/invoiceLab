# frozen_string_literal: true

require "prawn"
require "prawn/table"
require "action_view"
require "action_view/helpers/number_helper"

class InvoicePdf
  include ActionView::Helpers::NumberHelper

  attr_reader :invoice

  def initialize(invoice, locale: I18n.locale)
    @invoice = invoice
    @locale  = locale

    I18n.with_locale(@locale) do
      @pdf = Prawn::Document.new(page_size: "A4", margin: 36) # 0.5 inch
      setup_font!
      build
    end
  end

  def render
    @pdf.render
  end

  private

  # ---------- Build ----------

  def build
    header
    move_down 8
    meta_block
    move_down 12
    bill_to
    move_down 12
    items_table
    move_down 10
    subtotal_row
    move_down 10
    notes_block if invoice.notes.present?
    footer
  end

  # ---------- Sections ----------

  def header
    @pdf.text I18n.t("invoices.pdf.title"), size: 18, style: :bold
    @pdf.stroke_horizontal_rule
  end

  def meta_block
    data = [
      [I18n.t("invoices.pdf.invoice_number"), invoice.number.to_s],
      [I18n.t("invoices.pdf.issued_on"),      l(invoice.issued_on)],
      [I18n.t("invoices.pdf.due_date"),       l(invoice.due_date)],
      [I18n.t("invoices.pdf.status"),         I18n.t("invoices.statuses.#{invoice.status}")],
      [I18n.t("invoices.pdf.currency"),       invoice.currency]
    ]

    @pdf.table(data,
      cell_style: { size: 10, borders: [] },
      column_widths: { 0 => 140, 1 => (@pdf.bounds.width - 140) }
    ) do |t|
      t.column(0).font_style = :bold
    end
  end

  def bill_to
    @pdf.text I18n.t("invoices.pdf.bill_to"), style: :bold, size: 12
    @pdf.text invoice.client.name.to_s
    @pdf.text invoice.client.email.to_s
  end

  def items_table
    headings = [
      I18n.t("invoices.pdf.item"),
      I18n.t("invoices.pdf.qty"),
      I18n.t("invoices.pdf.unit_price"),
      I18n.t("invoices.pdf.total")
    ]

    rows = invoice.invoice_items.map do |it|
      [
        it.name.to_s,
        format_qty(it.quantity),
        money_cents(it.unit_price_cents, invoice.currency),
        money_cents(it.total_cents,       invoice.currency)
      ]
    end

    table_data = [headings] + rows
    bounds_w = @pdf.bounds.width

    @pdf.table(table_data,
      header: true,
      width: bounds_w,
      row_colors: %w[F8F9FA FFFFFF],
      cell_style: { size: 10, padding: 5 }
    ) do |t|
      # стили заголовка
      t.row(0).font_style = :bold
      t.row(0).background_color = "EEEEEE"

      # выравнивание
      t.columns(1..3).align = :right

      # фикс вместо несуществующего `columns=` — задаём ширины корректно
      t.column_widths = {
        0 => (bounds_w * 0.50).round(2), # item
        1 => (bounds_w * 0.15).round(2), # qty
        2 => (bounds_w * 0.20).round(2), # unit price
        3 => (bounds_w * 0.15).round(2)  # line total
      }
    end
  end

  def subtotal_row
    data = [
      [
        { content: I18n.t("invoices.pdf.subtotal"), colspan: 3, borders: [] , align: :right, font_style: :bold },
        { content: money_cents(invoice.total_cents, invoice.currency), borders: [] , align: :right, font_style: :bold }
      ]
    ]
    @pdf.table(data, width: @pdf.bounds.width, cell_style: { size: 11, padding: 5 })
  end

  def notes_block
    @pdf.move_down 5
    @pdf.text I18n.t("invoices.pdf.notes"), style: :bold, size: 12
    @pdf.text invoice.notes.to_s, size: 10
  end

  def footer
    @pdf.move_down 20
    @pdf.stroke_horizontal_rule
    @pdf.move_down 6
    @pdf.text I18n.t("invoices.pdf.generated_at", at: l(Time.current)), size: 8, color: "666666"
  end

  # ---------- Helpers ----------

  def setup_font!
    # Пытаемся найти DejaVuSans.ttf (кириллица) в проекте или в системе
    candidates = [
      Rails.root.join("app/assets/fonts/DejaVuSans.ttf").to_s,
      Rails.root.join("app/assets/fonts/dejavu/DejaVuSans.ttf").to_s,
      "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",                                # Ubuntu/Debian
      "/Library/Fonts/DejaVuSans.ttf",                                                  # macOS (если установлен)
      "/System/Library/Fonts/Supplemental/DejaVu Sans.ttf"                              # macOS другая локация
    ].uniq

    path = candidates.find { |p| File.exist?(p) }

    if path
      @pdf.font_families.update(
        "DejaVu" => {
          normal:      path,
          bold:        path,
          italic:      path,
          bold_italic: path
        }
      )
      @pdf.font "DejaVu"
    else
      Rails.logger.warn "[InvoicePdf] Missing DejaVuSans.ttf — Cyrillic may not render. Checked: #{candidates.join(', ')}"
      # Без внешнего шрифта Prawn попытается рендерить Windows-1252 и упадёт на кириллице
    end
  end

  def money_cents(cents, currency)
    number_to_currency(
      (cents.to_i / 100.0),
      unit: "#{currency} ",
      separator: I18n.t("number.format.separator"),
      delimiter: I18n.t("number.format.delimiter"),
      precision: 2
    )
  end

  def format_qty(qty)
    q = qty.to_f
    precision = (q % 1.0).zero? ? 0 : 2
    number_with_precision(q, precision: precision, delimiter: I18n.t("number.format.delimiter"))
  end

  def move_down(px) = @pdf.move_down(px)
  def l(obj)        = I18n.l(obj)
end
