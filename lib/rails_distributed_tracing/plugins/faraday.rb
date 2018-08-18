module DistributedTracing
  class FaradayMiddleware < ::Faraday::Middleware
    def call(env)
      env[:request_headers].merge!({DistributedTracing::TRACE_ID => DistributedTracing.trace_id})
      @app.call(env)
    end
  end
end
