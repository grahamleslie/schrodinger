# frozen_string_literal: true

require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton
schedule = ENV['SCAN_SCHEDULE'] || '1m'

scheduler.every schedule do
  Rails.logger.info 'Running CheckForBuildsJob'
  Rails.logger.flush
  CheckForBuildsJob.perform_later
end
