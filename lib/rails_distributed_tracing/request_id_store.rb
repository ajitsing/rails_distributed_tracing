module DistributedTracing
  class RequestIDStore
    def self.request_id=(id)
      @request_id = id
    end

    def self.request_id
      @request_id
    end

    def self.clear!
      @request_id = nil
    end
  end
end