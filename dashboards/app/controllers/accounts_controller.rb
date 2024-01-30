class AccountsController < ApplicationController
    before_action :require_logged_in_account, only: [:show, :edit, :confirm_edit_get, :confirm_edit_post, :update, :confirm_destroy_get, :confirm_destroy_post, :destroyer, :destroy]

    def new
        if account_signed_in?
            redirect_to account_path(current_account)
        end
        @account = Account.new
    end

    def confirm_edit_get
    end

    def confirm_edit_post
        if params[:session][:email] != current_account.email
            flash[:notice] = "Confirmação de Usuário mal-sucedida!"
            redirect_to account_path(current_account)
        else
            account = Account.find_by(email: params[:session][:email])
            if account && account.authenticate(params[:session][:password])
                flash[:notice] = "Confirmação de Usuário bem-sucedida!"
                session[:permission] = 1
                redirect_to edit_account_path(current_account)
            else
                flash[:notice] = "Confirmação de Usuário mal-sucedida!"
                redirect_to account_path(current_account)
            end
        end
    end

    def confirm_destroy_get
    end

    def confirm_destroy_post
        if params[:session][:email] != current_account.email
            flash[:notice] = "Confirmação de Usuário mal-sucedida!"
            redirect_to account_path(current_account)
        else
            account = Account.find_by(email: params[:session][:email])
            if account && account.authenticate(params[:session][:password])
                flash[:notice] = "Confirmação de Usuário bem-sucedida!"
                session[:permission] = 1
                redirect_to destroyer_path
            else
                flash[:notice] = "Confirmação de Usuário mal-sucedida!"
                redirect_to account_path(current_account)
            end
        end
    end

    def create
        if !account_signed_in?
            pam = account_params()
            if Account.find_by(email: pam["email"])
                flash[:notice] = "E-mail já cadastrado no sistema!"
                redirect_to new_account_path
            elsif pam["email"].length==0 || pam["name"].length==0 || pam["password"].length==0 || pam["password_confirmation"].length==0
                flash[:notice] = "Preencha todos os campos!"
                redirect_to new_account_path
            elsif pam["email"].length>25 || pam["name"].length>50 || pam["password"].length<7 || pam["password_confirmation"].length<7
                flash[:notice] = "Tamanho inválido em um dos campos!"
                redirect_to new_account_path
            elsif pam["password"] != pam["password_confirmation"]
                flash[:notice] = "Senhas diferentes!"
                redirect_to new_account_path
            else
                @account = Account.new(pam)
                if @account.save
                    flash[:notice] = "Usuário cadastrado com sucesso."
                    redirect_to entry_path
                else
                    flash[:notice] = "Email inválido!"
                    redirect_to new_account_path
                end
            end
        else
            redirect_to account_path(current_account)
        end
    end

    def edit
        if session[:permission] == 0
            redirect_to entry_path(current_account)
        end
        session[:permission] = 0
    end

    def update
        pam = account_params()
        if current_account.update(pam)
          flash[:notice] = "Dados atualizados com sucesso."
          redirect_to account_path(current_account)
        else
            flash[:notice] = "Dados não atualizados."
          redirect_to edit_account_path(current_account)
        end
    end

    def destroyer
        if session[:permission] == 0
            redirect_to entry_path(current_account)
        end
        session[:permission] = 0
    end

    def destroy
        @dashboards = current_account.dashboards
        @dashboards.each do |dashboard|
            @to_do_tasks = dashboard.to_do_tasks
            @to_do_tasks.each do |to_do_task|
                to_do_task.destroy
            end
            @in_progress_tasks = dashboard.in_progress_tasks
            @in_progress_tasks.each do |in_progress_task|
                in_progress_task.destroy
            end
            @finished_tasks = dashboard.finished_tasks
            @finished_tasks.each do |finished_task|
                finished_task.destroy
            end
            dashboard.destroy
        end
        current_account.destroy
        flash[:notice] = "Conta excluída com sucesso!"
        redirect_to root_path
    end

    def show
        if !account_signed_in?
            redirect_to entry_path(current_account)
        end
    end

    private
    def account_params()
        params.require(:account).permit(:email, :name, :password, :password_confirmation)
    end
end