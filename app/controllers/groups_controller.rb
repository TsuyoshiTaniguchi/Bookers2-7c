class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @book = Book.new
    @groups = Group.all
  end

  def show
    @book = Book.new
    @group = Group.find(params[:id])
  end

  def join
    @group = Group.find(params[:group_id])
    @group.users << current_user
    redirect_to  groups_path
  end

  
  def new_mail
    @group = Group.find(params[:id])  # ← `params[:group_id]` → `params[:id]` に変更
    @mail_title = ""
    @mail_content = ""
  end
  
  
  
  
  


  def send_mail
    @group = Group.find(params[:id])  # ← `params[:group_id]` → `params[:id]` に変更
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
  
    UserMailer.send_mail(@mail_title, @mail_content, @group.users).deliver_now
  
    render 'send_mail'  # 送信完了後、`send_mail.html.erb` を表示
  end
  
  


  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user
    if @group.save
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.users.delete(current_user)
    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end