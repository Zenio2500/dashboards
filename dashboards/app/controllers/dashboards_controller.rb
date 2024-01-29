class DashboardsController < ApplicationController

    def new
        @dashboard = Dashboard.new
    end

    def index
        @dashboards = current_account.dashboards
    end

    def create
        if !account_signed_in?
            redirect_to root_path
        else
            @dashboard = current_account.dashboards.build(dashboard_params)
            if Dashboard.find_by(name: @dashboard.name, account_id: current_account.id)
                flash[:notice] = "Este nome de dashboard já está em uso por você."
                redirect_to new_dashboard_path
            elsif @dashboard.save
                flash[:notice] = "Dashboard criado com sucesso."
                redirect_to new_dashboard_path
            else
                flash[:notice] = "O nome do dashboard deve ter, no mínimo, 1 caracter."
                redirect_to new_dashboard_path
            end
        end
    end

    private

    def dashboard_params
        params.require(:dashboard).permit(:name)
    end

end
