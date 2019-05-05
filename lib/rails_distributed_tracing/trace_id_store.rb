module DistributedTracing
  class TraceIdStore
    def self.trace_id=(id)
      Thread.current[DistributedTracing::TRACE_ID] = id
    end

    def self.trace_id
      Thread.current[DistributedTracing::TRACE_ID]
    end

    def self.clear!
      Thread.current[DistributedTracing::TRACE_ID] = nil
    end
  end
end