class MainPageController < ApplicationController

    def index
        @jobs = current_user.jobs
        @events = current_user.events

        job_tally = @jobs.size
        job_inprogress = 0
        job_accepted = 0
        job_rejected = 0
        
        @jobs.each do |job|
            if job.status.between?(0,3)
                job_inprogress += 1
            elsif job.status == 4
                if job.accepted
                    job_accepted +=1
                else
                    job_rejected +=1
                end
            end
        end

        @trackers = {
            tally: job_tally,
            inprogress: job_inprogress,
            accepted: job_accepted,
            rejected: job_rejected
        }

    end

end