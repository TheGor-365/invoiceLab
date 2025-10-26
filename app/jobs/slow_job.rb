class SlowJob < ApplicationJob
  queue_as :default
  def perform
    sleep 10
  end
end
