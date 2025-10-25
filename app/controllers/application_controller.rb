class ApplicationController < ActionController::Base
  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] ||
                  session[:locale] ||
                  extract_locale_from_accept_language ||
                  I18n.default_locale
    session[:locale] = I18n.locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def extract_locale_from_accept_language
    header = request.env["HTTP_ACCEPT_LANGUAGE"]
    return unless header.present?
    langs = header.scan(/[a-z]{2}/).map(&:to_sym)
    langs.find { |l| I18n.available_locales.include?(l) }
  end
end
