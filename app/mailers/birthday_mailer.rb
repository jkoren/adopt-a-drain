# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize

# see adoptions_mailer.rb

class BirthdayMailer < ApplicationMailer
  # Birthday message for all drains for a single city.
  def birthday_letter
    # for all drains in the city
    @city_drains = Thing.where(city_domain: @city.name)
    @city_adopted_drains = @city_drains.where.not(user_id: nil)
    # do filter here or in mail_adoptions.rake?
    @anniversary_drains = @city_adopted_drains.where(updated_at.month == Date.today.month && updated_at.day == Date.today.day && Date.today.year > updated_at.year)

    mail(
      from: "Adopt-a-Drain Mystic River <noreply@mysticdrains.org>",
      to: @thing.user.email_address,
      subject: "Happy Birthday to Our Storm Drain!",
    )
  end

end
