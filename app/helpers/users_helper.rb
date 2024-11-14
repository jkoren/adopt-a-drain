# frozen_string_literal: true

module UsersHelper
  def admin_emails
      users = User.all.select { |u| u.admin} # select only admins
      user_emails = users.map{|user| user.email}
      return user_emails
  end

  def non_admin_emails
      users = User.all.select { |u| !u.admin} # select only non-admins
    user_emails = users.map{|user| user.email}
    return user_emails
  end

end
