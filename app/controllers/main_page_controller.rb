class MainPageController < ApplicationControlle

    def index
        @jobs = current_user.jobs
        @events = current_user.events
    end


end