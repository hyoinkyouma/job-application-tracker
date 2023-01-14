require "google/apis/calendar_v3"
require "google/api_client/client_secrets.rb"

class EventsController < ApplicationController
    before_action :authenticate_user!
    def new
        @event = Event.new
        @event = Event.new
        @jobs = current_user.jobs
    end

    def show
        @event = Event.find params[:id]
    end

    def edit
        @event = Event.find(params[:id])
        @jobs = current_user.jobs
    end

    def update
        @event = Event.find(params[:id])
        if @event.update(event_params)
            redirect_to root_path
        else
            redirect_to edit_event_path(event)
        end
    end

    def destroy
        @event = Event.find(params[:id])
        @event.destroy
        redirect_to '/'
    end

    def create
        client = get_google_calendar_client(current_user)
        @job = Job.find(params[:event][:job_id])
        @event = @job.events.new
        @event.title = "#{@job[:job_title]} Interview"
        #2023-01-15T09:00
        @event.date_of_event = params[:event][:date_of_event].to_datetime
        @event.description = params[:event][:description]

        google_event = make_event(params[:event], @job)
        client.insert_event('primary', google_event)

        if @event.save!
            redirect_to "/"
        else
            flash[:alert] = 'Your token has been expired. Please login again with google.'
            redirect_to :back
        end
    end

    def make_event (event, job)
        attendees = [{email: current_user.email}]
        event = Google::Apis::CalendarV3::Event.new(
            summary: "#{job[:job_title]} Interview",
            location: job[:description],
            description: "#{job[:job_title]} Interview: " + event[:description],
            start: {
                date_time: event[:date_of_event].to_datetime.rfc3339,
                time_zone: "Asia/Manila"
                # date_time: '2019-09-07T09:00:00-07:00',
                # time_zone: 'Asia/Kolkata',
            },
            end: {
            date_time: event[:date_of_event].to_datetime.advance(hours:1).rfc3339,
            time_zone: "Asia/Manila"
            },
      attendees: attendees,
      reminders: {
        use_default: false,
        overrides: [
          Google::Apis::CalendarV3::EventReminder.new(reminder_method:"popup", minutes: 10),
          Google::Apis::CalendarV3::EventReminder.new(reminder_method:"email", minutes: 20)
        ]
      },
      notification_settings: {
        notifications: [
                        {type: 'event_creation', method: 'email'},
                        {type: 'event_change', method: 'email'},
                        {type: 'event_cancellation', method: 'email'},
                        {type: 'event_response', method: 'email'}
                       ]
      }, 'primary': true
    )
    end


    def get_google_calendar_client current_user
        client = Google::Apis::CalendarV3::CalendarService.new

        return unless (current_user.present? && current_user.auth_key_google.present? && current_user.auth_google_refresh_token.present?)

        secrets = Google::APIClient::ClientSecrets.new({
        web: {
            access_token: current_user.auth_key_google,
            refresh_token: current_user.auth_google_refresh_token,
            client_id: ENV["CLIENT_ID"],
            client_secret: ENV["CLIENT_SECRET"]
            }
        })

        begin
            client.authorization = secrets.to_authorization
            client.authorization.grant_type = "refresh_token"

        if !current_user.present?
            client.authorization.refresh!
            current_user.update_attributes(
                auth_key_google: client.authorization.access_token,
                auth_google_refresh_token: client.authorization.refresh_token,
                auth_google_expiry: client.authorization.expires_at.to_s
            )

        end
    
        rescue => e
            flash[:error] = 'Your token has been expired. Please login again with google.'
            redirect_to :back
        end
        client
    end
        # Only allow a list of trusted parameters through.
        def event_params
            params.require(:event).permit(:title, :date_of_event, :description)
        end
          
end