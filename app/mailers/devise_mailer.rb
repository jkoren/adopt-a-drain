# frozen_string_literal: true

class DeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts = {})
    city_domain = record.city_domain
    config = CityHelper.config(city_domain)

    @program_name = "#{config.brand.name} #{config.city.name}"
    @reset_password_url = edit_user_password_url(@resource, reset_password_token: token, host: config.site.main_url)
    
    mail = super
    mail.reply_to = config.org.email,
    mail.from = "#{@program_name} <noreply@mysticdrains.org>",
    mail.subject = t('devise.mailer.reset_password_instructions.subject',
                     title: t('titles.main', brand_name: config.brand.name, city: config.city.name))
    mail
  end
end
