class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
	before_filter :correct_user,   only: [:edit, :update]
	before_filter :admin_user,     only: :destroy

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			flash[:success] = "Account Created!"
			sign_in @user
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		if @user.update_attributes(params[:user])
			flash[:success] = "Account Updated!"
			sign_in @user
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User Deleted!"
		redirect_to users_path
	end

	def index
		@users = User.paginate(page: params[:page])
	end

		private

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user? (@user)
		end

		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end

end
