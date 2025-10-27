# frozen_string_literal: true

require "i18n/backend/fallbacks"
I18n::Backend::Simple.include I18n::Backend::Fallbacks

Rails.application.config.i18n.available_locales = %i[en ru es]
Rails.application.config.i18n.default_locale    = :en
Rails.application.config.i18n.fallbacks         = { ru: [:ru, :en], es: [:es, :en] }
