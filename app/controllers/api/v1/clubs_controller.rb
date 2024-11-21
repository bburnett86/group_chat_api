class Api::V1::ClubsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_club, only: [:show, :update, :destroy, :invite_members, :role_updates]
	before_action :user_admin_check, only: [:update]
	before_action :user_superadmin_check, only: [:destroy]

	def index
		@clubs = Club.select(:id, :name, :about_us, :public)
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
    @club = Club.includes(posts: {comments: :user}).find(params[:id])
    club_details = @club.as_json(
      include: {
        posts: {
          only: [:id, :description],
          include: {
            user: { only: [:id, :username] },
            comments: {
              only: [:id, :content],
              include: {
                user: { only: [:id, :username] }
              }
            }
          }
        }
      }
    )

    custom_member_details = {
      accepted_members: @club.accepted_members.includes(:user).as_json(only: [:id, :status], include: { user: { only: [:id, :username] }}),
      pending_members: @club.pending_members.includes(:user).as_json(only: [:id, :status], include: { user: { only: [:id, :username] }}),
      rejected_members: @club.rejected_members.includes(:user).as_json(only: [:id, :status], include: { user: { only: [:id, :username] }}),
      admins: @club.admins.includes(:user).as_json(only: [:id, :role], include: { user: { only: [:id, :username] }}),
      superadmins: @club.superadmins.includes(:user).as_json(only: [:id, :role], include: { user: { only: [:id, :username] }}),
      members: @club.members.includes(:user).as_json(only: [:id, :role], include: { user: { only: [:id, :username] }})
    }

    render json: club_details.merge(custom_member_details)
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

	def invite_members
    invited_count = 0
    params[:members].each do |member|
      participant = @club.participants.build(user_id: member[:user_id], status: 'PENDING')
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

  def role_updates
    params[:users].each do |user|
      participant = @club.participants.find_by(user_id: user[:user_id])
			if participant && participant.role != user[:role]
				participant.update!(role: user[:role])
			end
    end
    render json: { message: 'Roles updated successfully' }
  end

  private

  def set_club
    @club = Club.find(params[:id] || params[:club_id])
    render json: { error: 'Club not found' }, status: :not_found if @club.nil?
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