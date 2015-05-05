#load a pure Ruby DNS resolver that works concurrently
require 'resolv-replace'

Sidekiq.logger.level = Logger::WARN if Rails.env.test?
