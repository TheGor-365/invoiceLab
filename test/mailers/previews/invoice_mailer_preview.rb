# Preview all emails at http://localhost:3000/rails/mailers/invoice_mailer
class InvoiceMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/invoice_mailer/created
  def created
    InvoiceMailer.created
  end

  # Preview this email at http://localhost:3000/rails/mailers/invoice_mailer/due_reminder
  def due_reminder
    InvoiceMailer.due_reminder
  end

  # Preview this email at http://localhost:3000/rails/mailers/invoice_mailer/overdue_reminder
  def overdue_reminder
    InvoiceMailer.overdue_reminder
  end

  # Preview this email at http://localhost:3000/rails/mailers/invoice_mailer/thank_you
  def thank_you
    InvoiceMailer.thank_you
  end
end
