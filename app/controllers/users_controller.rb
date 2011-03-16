class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update]
layout :resolve_layout
  def new
    @user = User.new
  end
  
  def create
	
    @user = User.new(params[:user])
@user.active=1
@user.roles << :user
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default user_path(@user)
    else
      render :action => :new
    end
  end
  
  def show
    @user = current_user
  end

  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
	def site
		@users=User.all(:conditions => ["roles_mask=?",User.mask_for(:user)]);
	end
	def admin
			@users=User.all(:conditions => ["roles_mask=?",User.mask_for(:admin)]);
	end
	private

  def resolve_layout
    case action_name
    when "site", "admin"
      "admin"
    else
      "application"
    end
  end
end