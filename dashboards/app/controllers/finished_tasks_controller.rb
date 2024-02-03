class FinishedTasksController < ApplicationController
    before_action :require_logged_in_account
    before_action :set_refresh

    def new
        @finished_task = FinishedTask.new
    end

    def create
        @dashboard = Dashboard.find_by(id: params["dashboard_id"])
        @finished_task = @dashboard.finished_tasks.build(finished_task_params)
        if FinishedTask.find_by(name: @finished_task.name, dashboard_id: @dashboard.id) || ToDoTask.find_by(name: @finished_task.name, dashboard_id: @dashboard.id) || InProgressTask.find_by(name: @finished_task.name, dashboard_id: @dashboard.id)
            flash[:notice] = "Este nome de tarefa já está em uso neste dashboard."
            redirect_to new_account_dashboard_finished_task_path
        elsif @finished_task.name.length < 1 || @finished_task.name.length > 30
            flash[:notice] = "O nome da tarefa deve ter, no mínimo, 1 caracter e, no máximo, 30 caracteres."
            redirect_to new_account_dashboard_finished_task_path
        elsif @finished_task.finishDate == nil
            flash[:notice] = "Insira uma data!"
            redirect_to new_account_dashboard_finished_task_path
        elsif @finished_task.save
            redirect_to account_dashboard_path(current_account, @dashboard)
        end
    end

    def update
        pam = finished_task_params
        if FinishedTask.find_by(name: pam["name"], dashboard_id: params["dashboard_id"]) || ToDoTask.find_by(name: pam["name"], dashboard_id: params["dashboard_id"]) || InProgressTask.find_by(name: pam["name"], dashboard_id: params["dashboard_id"])
            if FinishedTask.find_by(id: params["id"], name: pam["name"], dashboard_id: params["dashboard_id"])
                @finished_task = FinishedTask.find_by(id: params["id"], dashboard_id: params["dashboard_id"])
                if @finished_task.update(pam)
                    @dashboard = Dashboard.find_by(id: params["dashboard_id"])
                    redirect_to account_dashboard_path(current_account, @dashboard)
                end
            else
                flash[:notice] = "Este nome de tarefa já está em uso neste dashboard."
                redirect_to edit_account_dashboard_finished_task_path
            end
        else
            @finished_task = FinishedTask.find_by(id: params["id"], dashboard_id: params["dashboard_id"])
            if pam["name"].length < 1 || @finished_task.name.length > 30
                flash[:notice] = "O nome da tarefa deve ter, no mínimo, 1 caracter e, no máximo, 30 caracteres."
                redirect_to edit_account_dashboard_finished_task_path
            elsif pam["finishDate"] == ""
                flash[:notice] = "Insira uma data!"
                redirect_to edit_account_dashboard_finished_task_path
            elsif @finished_task.update(pam)
                @dashboard = Dashboard.find_by(id: params["dashboard_id"])
                redirect_to account_dashboard_path(current_account, @dashboard)
            end
        end
    end

    def destroy
        @finished_task = FinishedTask.find_by(id: params["id"])
        @finished_task.destroy
        redirect_to account_dashboard_path(current_account, params["dashboard_id"])
    end

    private

    def finished_task_params
        params.require(:finished_task).permit(:name, :finishDate)
    end

end
