require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton
schedule = ENV['SCAN_SCHEDULE'] || '1m'

scheduler.every schedule do
  Rails.logger.info "checking for builds, it's #{Time.now}"
  Rails.logger.flush
  CheckForBuildsJob.perform_later
end