# frozen_string_literal: true

class InfoWindowController < ApplicationController
  def index
    @thing = Thing.find_by(id: params[:thing_id])
    view = begin
      if @thing.adopted?

        # need to pull @user.munical_admin from database
        municipal_admin = true

        if user_signed_in?
          if municipal_admin
            'things/drain_admin'
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
