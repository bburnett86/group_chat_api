class Api::V1::EventsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_event, only: [:show, :update, :destroy, :invite_guests, :role_updates]
	before_action :user_not_guest_check, only: [:update]
	before_action :user_organizer_check, only: [:destroy]

  def index
    @events = Event.select(:id, :title, :description, :start_time, :end_time, :active)
    render json: @events
  end

  def create
    event = Event.new(event_params)
    if event.save
      event.participants.build(user_id: current_user.id, role: 'SUPERADMIN', status: 'ACCEPTED')
      render json: event, status: :created
    else
      render json: event.errors, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.includes(posts: [:comments => :user]).find(params[:id])
    event_details = @event.as_json(
      include: {
        posts: {
          only: [:id, :description],
          include: {
            # Post user
            user: { only: [:id, :username] },
            comments: {
              only: [:id, :content],
              include: {
                # Comment user
                user: { only: [:id, :username] } 
              }
            }
          }
        }
      }
    )
  
    custom_guest_details = {
      pending_guests: @event.pending_guests.includes(:user).as_json(only: [:id, :status], include: { user: { only: [:id, :username] }}),
      going_guests: @event.going_guests.includes(:user).as_json(only: [:id, :status], include: { user: { only: [:id, :username] }}),
      not_going_guests: @event.not_going_guests.includes(:user).as_json(only: [:id, :status], include: { user: { only: [:id, :username] }}),
      maybe_guests: @event.maybe_guests.includes(:user).as_json(only: [:id, :status], include: { user: { only: [:id, :username] }}),
      guests: @event.guests.includes(:user).as_json(only: [:id, :status], include: { user: { only: [:id, :username] }}),
      hosts: @event.hosts.includes(:user).as_json(only: [:id, :role], include: { user: { only: [:id, :username] }}),
      organizers: @event.organizers.includes(:user).as_json(only: [:id, :role], include: { user: { only: [:id, :username] }})
    }

    render json: event_details.merge(custom_guest_details)
  end

  def update
    if @event.update(event_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
  end

  def invite_guests
    invited_count = 0
    params[:guests].each do |guest|
      participant = @event.participants.build(user_id: guest[:user_id], status: 'PENDING')
      invited_count += 1 if participant && participant.save
    end
    if invited_count == 1
			render json: { message: "#{invited_count} Guest invited successfully" }, status: :ok
    elsif invited_count > 0
      render json: { message: "#{invited_count} Guests invited successfully" }, status: :ok
    else
      render json: { error: "No guests were invited" }, status: :unprocessable_entity
    end
  end

  def role_updates
    params[:users].each do |user|
      participant = @event.participants.find_by(user_id: user[:user_id])
			if participant && participant.role != user[:role]
				participant.update!(role: user[:role])
      end
    end
    render json: { message: 'Roles updated successfully' }
  end

  private

  def set_event
    @event = Event.find(params[:id] || params[:event_id])
    render json: { error: 'Event not found' }, status: :not_found if @event.nil?
  end

  def user_not_guest_check
    guest = @event.participants.find_by(user_id: current_user.id)
    unless guest.role.in?(['ADMIN', 'SUPERADMIN']) || current_user.admin? || current_user.superadmin?
      render json: { error: 'You do not have permission to perform this action' }, status: :unauthorized
    end
  end
  
  def user_organizer_check
    guest = @event.participants.find_by(user_id: current_user.id)
    unless guest.role == 'ADMIN' || current_user.admin? || current_user.superadmin?
      render json: { error: 'You do not have permission to perform this action' }, status: :unauthorized
    end
  end

  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time, :active)
  end
end
