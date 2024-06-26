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
			@club.participants.create(user_id: current_user.id, role: 'SUPERADMIN', status: 'ACCEPTED')
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

	def bulk_invite_members
    invited_count = 0
    params[:members].each do |member|
      club = Club.find(member[:club_id])
      participant = club.participants.build(user_id: member[:user_id], status: 'PENDING')
      invited_count += 1 if participant && participant.save
    end
		if invited_count == 1
			render json: { message: "#{invited_count} Member invited successfully" }, status: :ok
    elsif invited_count > 0
      render json: { message: "#{invited_count} Members invited successfully" }, status: :ok
    else
      render json: { error: "No members were invited" }, status: :unprocessable_entity
    end
  end

  def bulk_role_updates
    params[:users].each do |user|
      club = Club.find(user[:club_id])
      participant = club.participants.find_by(user_id: user[:user_id])
			if participant && participant.role != user[:role]
				participant.update!(role: user[:role])
			end
    end
    render json: { message: 'Roles updated successfully' }
  end

  private

  def set_club
    @club = Club.find(params[:id])
  end

	def club_params
		params.require(:club).permit(:name, :about_us, :private)
	end

	def user_admin_check
    member = @club.participants.find_by(user_id: current_user.id)
    unless member&.role.in?(['ADMIN', 'SUPERADMIN']) || current_user.admin? || current_user.superadmin?
      render json: { error: 'You do not have permission to perform this action' }, status: :unauthorized
    end
  end

  def user_superadmin_check
    member = @club.participants.find_by(user_id: current_user.id)
    unless member&.role == 'SUPERADMIN' || current_user.admin? || current_user.superadmin?
      render json: { error: 'You do not have permission to perform this action' }, status: :unauthorized
    end
  end
end