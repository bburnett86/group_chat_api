class Api::V1::EventsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_event, only: [:show, :update, :destroy]
	before_action :user_not_guest_check, only: [:update]
	before_action :user_organizer_check, only: [:destroy]

  def index
    @events = Event.all
    render json: @events
  end

  def create
    @event = Event.new(event_params)
    if @event.save
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

  def destroy
    @event.destroy
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

	def user_not_guest_check
		guest = @event.event_guests.find_by(user_id: current_user.id)
		if guest.role != 'ORGANIZER' && guest.role != 'HOST'
			render json: { error: 'You do not have permission to perform this action' }, status: :unauthorized
		end
	end

	def user_organizer_check
		guest = @event.event_guests.find_by(user_id: current_user.id)
		if guest.role != 'ORGANIZER'
			render json: { error: 'You do not have permission to perform this action' }, status: :unauthorized
		end
	end

  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time, :active)
  end
end
