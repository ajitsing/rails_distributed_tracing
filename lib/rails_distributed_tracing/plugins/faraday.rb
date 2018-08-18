module DistributedTracing
  class FaradayMiddleware < ::Faraday::Middleware
    def call(env)
      env[:request_headers].merge!(DistributedTracing.request_id_header)
      @app.call(env)
    end
  end
end
