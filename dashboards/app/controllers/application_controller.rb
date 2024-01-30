class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  
    include SessionsHelper

    private
    def require_logged_in_account
      unless account_signed_in?
        redirect_to entry_path
      end
    end

end