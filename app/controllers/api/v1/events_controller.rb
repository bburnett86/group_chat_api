class Api::V1::EventsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_event, only: [:show, :update, :destroy, :pending_guests, :going_guests, :not_going_guests, :maybe_guests, :hosts, :organizers]
	before_action :user_not_guest_check, only: [:update]
	before_action :user_organizer_check, only: [:destroy]

  def index
    @events = Event.all
    render json: @events
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      @event.participants.create(user_id: current_user.id, role: 'SUPERADMIN', status: 'ACCEPTED')
      render json: @event, status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @event
  end

  def update
    if @event.update(event_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # get 'pending_guests'
  def pending_guests
    render json: @event.pending_guests
  end
  # get 'going_guests'
  def going_guests
    render json: @event.going_guests
  end
  # get 'not_going_guests'
  def not_going_guests
    render json: @event.not_going_guests
  end
  # get 'maybe_guests'
  def maybe_guests
    render json: @event.maybe_guests
  end
  # get 'hosts'
  def hosts
    render json: @event.hosts
  end
  # get 'organizers'
  def organizers
    render json: @event.organizers
  end

  def destroy
    @event.destroy
  end

  def bulk_invite_guests
    invited_count = 0
    params[:guests].each do |guest|
      event = Event.find(guest[:event_id])
      participant = event.participants.build(user_id: guest[:user_id], status: 'PENDING')
      invited_count += 1 if participant.save
    end
    if invited_count > 0
      render json: { message: "#{invited_count} Guests invited successfully" }, status: :ok
    else
      render json: { error: "No guests were invited" }, status: :unprocessable_entity
    end
  end

  def bulk_role_updates
    params[:users].each do |user|
      event = Event.find(user[:event_id])
      event.participants.find_by(user_id: user[:user_id]).update!(role: user[:role])
    end
    render json: { message: 'Roles updated successfully' }
  end

  private

  def set_event
    @event = Event.find(params[:id])
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
