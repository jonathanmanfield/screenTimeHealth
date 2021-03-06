class AnalyticsController < ApplicationController
  def start
    @kid = Kid.find_by(:unique_token => params[:unique_token].to_s)

    tracking = false

    @kid.sessions.each do |s| 
      if s.endtime.nil?
        tracking = true
      end
    end

    if tracking = false
      Session.create(:starttime => Time.now, :kid_id => @kid.id)
    end
  end

  def end
    @kid = Kid.find_by(:unique_token => params[:unique_token].to_s)
    @session = @kid.session.last.update(:endtime => Time.now)
    starttime = @kid.session.starttime
    difference = (endtime - starttime) / 60

    puts 'difference'
    puts difference

    threshold = @kid.threshold
    @family = @kid.family

    NotificationMailer.send_alert(@family, @kid).deliver_now

    # if(threshold < difference)
    #   puts 'in case'
    #   NotificationMailer.send_alert(@family, @kid).deliver_now
    # end
  end

  def track
    @kid = Kid.find_by(:id => params[:id].to_s)
    gon.kid = @kid
  end
end
