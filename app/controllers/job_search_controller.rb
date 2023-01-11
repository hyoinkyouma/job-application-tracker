class JobSearchController < ApplicationController
    def index
    end

    def search
        keyword = params[:anything][:keyword]
        location = params[:anything][:location]
        isRemote = params[:anything][:isRemote]
        @result = searchLinkedIn(keyword, "Manila", false)
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