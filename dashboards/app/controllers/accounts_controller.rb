class AccountsController < ApplicationController

    def new
        @account = Account.new
    end

    def create
        pam = account_params()
        if Account.find_by(email: pam["email"])
            flash[:notice] = "E-mail já cadastrado no sistema!"
        elsif pam["email"].length==0 || pam["name"].length==0 || pam["password"].length==0 || pam["password_confirmation"].length==0
            flash[:notice] = "Preencha todos os campos!"
        elsif pam["email"].length>25 || pam["name"].length>50 || pam["password"].length<7 || pam["password_confirmation"].length<7
            flash[:notice] = "Tamanho inválido em um dos campos!"
        elsif pam["password"] != pam["password_confirmation"]
            flash[:notice] = "Senhas diferentes!"
        else
            @account = Account.new(pam)
            if @account.save
                flash[:sucess] = "Usuário cadastrado com sucesso."
                redirect_to root_path
            else
                flash[:notice] = "Email inválido!"
            end
        end
        redirect_to new_account_path
    end

    private
    def account_params()
        params.require(:account).permit(:email, :name, :password, :password_confirmation)
    end
end