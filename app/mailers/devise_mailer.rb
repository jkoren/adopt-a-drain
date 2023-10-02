# frozen_string_literal: true

class DeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts = {})
    mail = super
    mail.subject = t('devise.mailer.reset_password_instructions.subject',
                     title: t('titles.main',
                              brand_name: c('brand.brand_name'), city: 'Mystic River'))
    mail
  end
end
