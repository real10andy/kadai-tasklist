class TasksController < ApplicationController
  
  before_action :require_user_logged_in
  
  def index
    if logged_in?
      @task = current_user.tasks.build  # form_with 用
      @tasks = current_user.tasks.order(id: :desc)
    end
  end

  def show
    set_task
  end

  def new
    @task=Task.new
  end

  def create
    @task=current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success]="Taskが正常に投稿されました"
      redirect_to "/"
    else
      flash.now[:danger]="Taskが投稿されませんでした"
      render :new
    end
  end

  def edit
    set_task
  end

  def update
    set_task
    
    if @task.update(task_params)
      flash[:success]="Taskは正常に更新されました"
      redirect_to @task
    else
      flash[:danger]="Taskは更新されませんでした"
      render :edit
    end
  end

  def destroy
    set_task
    @task.destroy
    
    flash[:success]="Taskは正常に削除されました"
    redirect_to tasks_url
  end

  private
  
  def set_task
    @task=Task.find(params[:id])
  end
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
end
