class InProgressTasksController < ApplicationController
    before_action :require_logged_in_account
    before_action :set_refresh

    def new
        @in_progress_task = InProgressTask.new
    end

    def create
        @dashboard = Dashboard.find_by(id: params["dashboard_id"])
        @in_progress_task = @dashboard.in_progress_tasks.build(in_progress_task_params)
        if InProgressTask.find_by(name: @in_progress_task.name, dashboard_id: @dashboard.id) || ToDoTask.find_by(name: @in_progress_task.name, dashboard_id: @dashboard.id) || FinishedTask.find_by(name: @in_progress_task.name, dashboard_id: @dashboard.id)
            flash[:notice] = "Este nome de tarefa já está em uso neste dashboard."
            redirect_to new_account_dashboard_in_progress_task_path
        elsif @in_progress_task.save
            redirect_to account_dashboard_path(current_account, @dashboard)
        else
            flash[:notice] = "O nome da tarefa deve ter, no mínimo, 1 caracter e, no máximo, 30 caracteres."
            redirect_to new_account_dashboard_in_progress_task_path
        end
    end

    def update
        pam = in_progress_task_params
        if InProgressTask.find_by(name: pam["name"], dashboard_id: params["dashboard_id"])  || ToDoTask.find_by(name: pam["name"], dashboard_id: params["dashboard_id"]) || FinishedTask.find_by(name: pam["name"], dashboard_id: params["dashboard_id"])
            flash[:notice] = "Este nome de tarefa já está em uso neste dashboard."
            redirect_to edit_account_dashboard_in_progress_task_path
        else
            @in_progress_task = InProgressTask.find_by(id: params["id"], dashboard_id: params["dashboard_id"])
            if @in_progress_task.update(pam)
                @dashboard = Dashboard.find_by(id: params["dashboard_id"])
                redirect_to account_dashboard_path(current_account, @dashboard)
            else
                flash[:notice] = "O nome da tarefa deve ter, no mínimo, 1 caracter e, no máximo, 30 caracteres."
                redirect_to edit_account_dashboard_in_progress_task_path
            end
        end
    end

    def destroy
        @in_progress_task = InProgressTask.find_by(id: params["id"])
        @in_progress_task.destroy
        redirect_to account_dashboard_path(current_account, params["dashboard_id"])
    end

    private

    def in_progress_task_params
        params.require(:in_progress_task).permit(:name)
    end

end
