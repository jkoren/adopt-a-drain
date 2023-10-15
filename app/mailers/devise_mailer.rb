# frozen_string_literal: true

class DeviseMailer < Devise::Mailer
  helper :city

  def reset_password_instructions(record, token, opts = {})
    config = CityHelper.config(record.city_domain)

    mail = super
    mail.subject = t('devise.mailer.reset_password_instructions.subject',
                     title: t('titles.main',
                              brand_name: config.brand.name, city: 'Mystic River'))
    mail
  end
end
