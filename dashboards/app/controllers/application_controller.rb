class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  
    include SessionsHelper

    private
    def require_logged_in_account
      unless account_signed_in?
        flash[:danger] = 'Área restrita. Por favor, realize o login.'
        redirect_to entry_path
      end
    end

end