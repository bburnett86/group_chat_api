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
      @event.event_guests.create(user_id: current_user.id, role: 'ORGANIZER', status: 'GOING')
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

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def user_not_guest_check
    guest = @event.event_guests.find_by(user_id: current_user.id)
    unless guest.role.in?(['ORGANIZER', 'HOST']) || current_user.admin? || current_user.superadmin?
      render json: { error: 'You do not have permission to perform this action' }, status: :unauthorized
    end
  end
  
  def user_organizer_check
    guest = @event.event_guests.find_by(user_id: current_user.id)
    unless guest.role == 'ORGANIZER' || current_user.admin? || current_user.superadmin?
      render json: { error: 'You do not have permission to perform this action' }, status: :unauthorized
    end
  end

  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time, :active)
  end
end
