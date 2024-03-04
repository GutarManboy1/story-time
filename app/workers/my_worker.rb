class MyWorker
  include Sidekiq::Worker

  def perform
    # Your background job logic goes here
  end
end
