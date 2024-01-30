class ToDoTasksController < ApplicationController
    before_action :require_logged_in_account

    def new
        @to_do_task = ToDoTask.new
    end

    def create
        @dashboard = Dashboard.find_by(id: params["dashboard_id"])
        @to_do_task = @dashboard.to_do_tasks.build(to_do_task_params)
        if ToDoTask.find_by(name: @to_do_task.name, dashboard_id: @dashboard.id) || InProgressTask.find_by(name: @to_do_task.name, dashboard_id: @dashboard.id) || FinishedTask.find_by(name: @to_do_task.name, dashboard_id: @dashboard.id)
            flash[:notice] = "Este nome de tarefa já está em uso neste dashboard."
            redirect_to new_account_dashboard_to_do_task_path
        elsif @to_do_task.save
            flash[:notice] = "'Tarefa a Fazer' adicionada com sucesso."
            redirect_to account_dashboard_path(current_account, @dashboard)
        else
            flash[:notice] = "O nome da tarefa deve ter, no mínimo, 1 caracter."
            redirect_to new_account_dashboard_to_do_task_path
        end
    end

    def update
        pam = to_do_task_params
        if ToDoTask.find_by(name: pam["name"], dashboard_id: params["dashboard_id"])
            flash[:notice] = "Este nome de tarefa já está em uso neste dashboard."
            redirect_to edit_account_dashboard_to_do_task_path
        else
            @to_do_task = ToDoTask.find_by(id: params["id"], dashboard_id: params["dashboard_id"])
            if @to_do_task.update(pam)
                flash[:notice] = "Tarefa atualizada com sucesso."
                redirect_to account_dashboard_path(current_account, @dashboard)
            else
                flash[:notice] = "O nome da tarefa deve ter, no mínimo, 1 caracter."
                redirect_to edit_account_dashboard_to_do_task_path
            end
        end
    end

    def destroy
        @to_do_task = ToDoTask.find_by(id: params["id"])
        @to_do_task.destroy
        flash[:notice] = "Tarefa excluída com sucesso!"
        redirect_to account_dashboard_path(current_account, params["dashboard_id"])
    end

    private

    def to_do_task_params
        params.require(:to_do_task).permit(:name)
    end

end