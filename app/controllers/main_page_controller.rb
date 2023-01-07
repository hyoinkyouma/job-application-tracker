class MainPageController < ApplicationController

    def index
        @jobs = current_user.jobs
        
        @events = []
    
    end

end