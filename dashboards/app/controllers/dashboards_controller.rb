class DashboardsController < ApplicationController
    before_action :require_logged_in_account
    before_action :set_refresh, except: [:show, :changeTasks]
    
    def new
        @dashboard = Dashboard.new
    end

    def index
        @dashboards = current_account.dashboards
    end

    def create
        @dashboard = current_account.dashboards.build(dashboard_params)
        if Dashboard.find_by(name: @dashboard.name, account_id: current_account.id)
            flash[:notice] = "Este nome de dashboard já está em uso por você."
            redirect_to new_account_dashboard_path
        elsif @dashboard.save
            flash[:notice] = "Dashboard criado com sucesso."
            redirect_to account_dashboards_path
        else
            flash[:notice] = "O nome do dashboard deve ter, no mínimo, 1 caracter."
            redirect_to new_account_dashboard_path
        end
    end

    def update
        pam = dashboard_params
        if Dashboard.find_by(name: pam["name"], account_id: current_account.id)
            flash[:notice] = "Este nome de dashboard já está em uso por você."
            redirect_to edit_account_dashboard_path
        else
            @dashboard = Dashboard.find_by(id: params["id"])
            if @dashboard.update(pam)
                flash[:notice] = "Dashboard atualizado com sucesso."
                redirect_to edit_account_dashboard_path
            else
                flash[:notice] = "O nome do dashboard deve ter, no mínimo, 1 caracter."
                redirect_to edit_account_dashboard_path
            end
        end
    end

    def destroy
        @dashboard = Dashboard.find_by(id: params["id"])
        @to_do_tasks = @dashboard.to_do_tasks
        @to_do_tasks.each do |to_do_task|
            to_do_task.destroy
        end
        @in_progress_tasks = @dashboard.in_progress_tasks
        @in_progress_tasks.each do |in_progress_task|
            in_progress_task.destroy
        end
        @finished_tasks = @dashboard.finished_tasks
        @finished_tasks.each do |finished_task|
            finished_task.destroy
        end
        @dashboard.destroy
        flash[:notice] = "Dashboard excluído com sucesso!"
        redirect_to account_dashboards_path
    end

    def saveReference
        #puts params
        @dashboard = Dashboard.find_by(id: params["dashboard"])
        #puts @dashboard.reference
        @dashboard.reference = params["reference"]
        #puts @dashboard.reference
        @dashboard.save
    end

    def changeTasks
        #puts params
        @dashboard = Dashboard.find_by(id: params["dashboard"])
        if params["posX"] < @dashboard.reference # todo
            if InProgressTask.find_by(name: params["task"], dashboard_id: @dashboard.id)
                InProgressTask.find_by(name: params["task"], dashboard_id: @dashboard.id).destroy
                @to_do_task = ToDoTask.new(name: params["task"], dashboard_id: @dashboard.id)
                @to_do_task.save
            elsif FinishedTask.find_by(name: params["task"], dashboard_id: @dashboard.id)
                FinishedTask.find_by(name: params["task"], dashboard_id: @dashboard.id).destroy
                @to_do_task = ToDoTask.new(name: params["task"], dashboard_id: @dashboard.id)
                @to_do_task.save
            end
        elsif params["posX"] > @dashboard.reference + 500 # finished
            if InProgressTask.find_by(name: params["task"], dashboard_id: @dashboard.id)
                InProgressTask.find_by(name: params["task"], dashboard_id: @dashboard.id).destroy
                @finished_task = FinishedTask.new(name: params["task"], finishDate: DateTime.current.to_date, dashboard_id: @dashboard.id)
                @finished_task.save
            elsif ToDoTask.find_by(name: params["task"], dashboard_id: @dashboard.id)
                ToDoTask.find_by(name: params["task"], dashboard_id: @dashboard.id).destroy
                @finished_task = FinishedTask.new(name: params["task"], finishDate: DateTime.current.to_date, dashboard_id: @dashboard.id)
                @finished_task.save
            end
        else
            if ToDoTask.find_by(name: params["task"], dashboard_id: @dashboard.id)
                ToDoTask.find_by(name: params["task"], dashboard_id: @dashboard.id).destroy
                @in_progress_task = InProgressTask.new(name: params["task"], dashboard_id: @dashboard.id)
                @in_progress_task.save
            elsif FinishedTask.find_by(name: params["task"], dashboard_id: @dashboard.id)
                FinishedTask.find_by(name: params["task"], dashboard_id: @dashboard.id).destroy
                @in_progress_task = InProgressTask.new(name: params["task"], dashboard_id: @dashboard.id)
                @in_progress_task.save
            end
        end
    end

    private

    def dashboard_params
        params.require(:dashboard).permit(:name)
    end

end
