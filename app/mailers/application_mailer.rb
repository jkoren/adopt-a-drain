# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Mystic River <noreply@mysticdrains.org>'
  layout 'mailer'
  helper CityHelper
end
