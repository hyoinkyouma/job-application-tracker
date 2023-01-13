class JobSearchController < ApplicationController
    def index
        @jobs = current_user.jobs
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

    def show
        @job = Job.find(params[:id])
    end

    def edit
        @job = Job.find(params[:id])
    end

    def update
        @job = Job.find(params[:id])
        @job.job_title = params[:details][:title]
        @job.salary = params[:details][:salary]
        @job.status = params[:details][:status]
        @job.accepted = params[:details][:accepted]
        redirect_to job_show_path(id:params[:id])
    end

    def newJob
        @job = Job.new
        @job.job_title = params[:job_title]
        @job.job_description = params[:job_description]
        @job.salary = 0.00  
        @job.status = 1
        @job.accepted = false
        @job.user_id = current_user.id

        if @job.save!
            redirect_to params[:job_link], allow_other_host: true
        else
            flash.now[:alert] = "Cannot redirect to link"
        end
    end

    def search
        @jobs = current_user.jobs
        keyword = params[:anything][:keyword]
        location = params[:anything][:location]
        isRemote = params[:anything][:isRemote] == 0 ? false : true
        @result = searchLinkedIn(keyword, location, isRemote)
    end

    private

    def searchLinkedIn (keyword, location, isRemote)
        endpoint = Faraday.new(url:"https://linkedin.romanaugusto.tk/", headers: {'Content-Type' => 'application/json'})
        res = endpoint.post('get-jobs') do |req|
            req.body = {
            "keywords": keyword,
            "companies": [""],
            "experience": ["1","2","3","4","5","6"],
            "job_type": ["F", "C", "P", "T", "I", "V","O"],
            "job_title": [""],
            "industries": [""],
            "location_name": location,
            "remote": true,
            "listed_at": 604800,
            "distance": 12,
            "limit": 10,
            "offset": 0
            }.to_json
        end
        puts JSON.parse(res.body)
        puts JSON.parse(res.body).length()
        return JSON.parse(res.body)
    end
end