require 'rails_distributed_tracing/trace_id_store'

module DistributedTracing
  TRACE_ID = 'X-Request-Id'.freeze

  def self.log_tag
    lambda do |request|
      request_id = request.headers[TRACE_ID] || request.request_id
      TraceIdStore.trace_id = request_id
    end
  end

  def self.trace_id
    TraceIdStore.trace_id
  end

  def self.trace_id=(id)
    TraceIdStore.trace_id = id
  end
end