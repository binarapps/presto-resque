class AccessLogStatsController < ApplicationController
 def index
    @access_log_stats_4xx = AccessLogStatusStat.find_4xx_statuses
    @access_log_stats_5xx = AccessLogStatusStat.find_5xx_statuses
  end

  def run
      @status = :ok
    begin
      Resque.enqueue(AccessLogStatusStatsJob, 0)
    rescue Exception => e
      logger.error "#{e.message} #{e.backtrace.join("\n")}"
      @status = :internal_server_error
    end

    respond_to do |format|
      format.json { render layout: false, status: @status }
    end
  end

end
