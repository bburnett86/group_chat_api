class Api::V1::EventGuestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:index, :create, :add_multiple_guests, :update_multiple_guest_roles]
  before_action :set_event_guest, only: [:destroy]
  before_action :current_user_authorized?, only: [:create, :destroy, :add_multiple_guests, :update_multiple_guest_roles]

  # GET /events/:event_id/event_guests
  def index
    @event_guests = @event.event_guests
    render json: @event_guests
  end

  # POST /events/:event_id/event_guests
  def create
    event_guest = @event.event_guests.new(event_guest_params)
    if event_guest.save
      render json: event_guest, status: :created
    else
      render json: event_guest.errors, status: :unprocessable_entity
    end
  end

  # DELETE /events/:event_id/event_guests/:id
  def destroy
    @event_guest.destroy
  end

  # PATCH /events/:event_id/event_guests/add_multiple_guests
  def add_multiple_guests
      params[:guest_id_array].each do |guest_id|
        @event.event_guests.create!(user_id: guest_id, status: 'PENDING', role: 'GUEST')
      end
      render json: { message: 'Guests added successfully' }
  end

  # PATCH /events/:event_id/event_guests/update_multiple_guest_roles
  def update_multiple_guest_roles
    params[:guest_role_pairs].each do |guest_role_pair|
      event_guest = @event.event_guests.find_by(user_id: guest_role_pair[:user_id])
      event_guest.update!(role: guest_role_pair[:role])
    end
    render json: { message: 'Roles successfully updated' }
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_event_guest
    @event_guest = EventGuest.find(params[:id])
  end

  def current_user_authorized?
    if !current_user.role === "ADMIN" && !current_user.role = "SUPERADMIN"
      event_guest = Event.find(@event.id).event_guests.find_by(user_id: current_user.id)
      if event_guest.nil? || !(event_guest.organizer? || event_guest.host?)
        render json: { error: 'You do not have permission to perform this action' }, status: :unauthorized
      end
    end
  end

  def event_guest_params
    params.require(:event_guest).permit(:user_id, :event_id, :status, :role)
  end
end