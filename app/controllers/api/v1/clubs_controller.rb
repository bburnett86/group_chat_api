class Api::V1::ClubsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_club, only: [:show, :update, :destroy, :accepted_members, :pending_members, :rejected_members, :admins, :superadmins, :members]
	before_action :user_admin_check, only: [:update]
	before_action :user_superadmin_check, only: [:destroy]

	def index
		@clubs = Club.all
		render json: @clubs
	end

	def create
		@club = Club.new(club_params)
		if @club.save
			@club.club_members.create(user_id: current_user.id, role: 'SUPERADMIN', status: 'ACCEPTED')
			render json: @club, status: :created
		else
			render json: @club.errors, status: :unprocessable_entity
		end
	end

	def show
		render json: @club
	end

	def update
		if @club.update(club_params)
			render json: @club
		else
			render json: @club.errors, status: :unprocessable_entity
		end
	end

	def destroy
		@club.destroy
	end

  def accepted_members
    render json: @club.accepted_members
  end

  def pending_members
    render json: @club.pending_members
  end

  def rejected_members
    render json: @club.rejected_members
  end

  def admins
   render json:  @club.admins
  end

  def superadmins
    render json: @club.superadmins
  end

  def members
    render json: @club.members
  end

  private

  def set_club
    @club = Club.find(params[:id])
  end

	def club_params
		params.require(:club).permit(:name, :about_us, :private)
	end

	def user_admin_check
    member = @club.club_members.find_by(user_id: current_user.id)
    unless member&.role.in?(['ADMIN', 'SUPERADMIN']) || current_user.admin? || current_user.superadmin?
      render json: { error: 'You do not have permission to perform this action' }, status: :unauthorized
    end
  end

  def user_superadmin_check
    member = @club.club_members.find_by(user_id: current_user.id)
    unless member&.role == 'SUPERADMIN' || current_user.admin? || current_user.superadmin?
      render json: { error: 'You do not have permission to perform this action' }, status: :unauthorized
    end
  end
end