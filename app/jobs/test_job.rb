# frozen_string_literal: true

class TestJob < ApplicationJob

  queue_as :default

  def perform(message)
    SolidQueue.logger.info "Processing job with message: #{message}"
  end

end
