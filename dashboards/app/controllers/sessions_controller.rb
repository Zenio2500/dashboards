class SessionsController < ApplicationController

    def new
        if account_signed_in?
            redirect_to account_path(current_account)
        end
    end

    def create
        account = Account.find_by(email: params[:session][:email])
        if account && account.authenticate(params[:session][:password])
            sign_in(account)
            flash[:notice] = "Login efetuado com sucesso!"
            #redirect_to contacts_path()
            redirect_to root_path
        else
            flash[:notice] = "Email e Senha inválidos."
            redirect_to entry_path
        end
    end

end