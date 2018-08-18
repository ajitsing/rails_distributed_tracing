module DistributedTracing
  class TraceIdStore
    def self.trace_id=(id)
      @trace_id = id
    end

    def self.trace_id
      @trace_id
    end

    def self.clear!
      @trace_id = nil
    end
  end
end