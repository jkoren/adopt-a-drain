# frozen_string_literal: true

class InfoWindowController < ApplicationController
  def index
    @thing = Thing.find_by(id: params[:thing_id])
    view = begin
      if @thing.adopted?
        municipal_admin = current_user.admin

        if user_signed_in?
          if municipal_admin
            'things/free_or_rename'
          else
            current_user == @thing.user ? 'users/thank_you' : 'users/profile'
          end
        end
      else
        user_signed_in? ? 'things/adopt' : 'users/sign_in'
      end
    end
    render view
  end
end
