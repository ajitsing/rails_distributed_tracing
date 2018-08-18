module DistributedTracing
  module SidekiqMiddleware
    class Client
      def call(worker_class, job, queue, redis_pool)
        job[DistributedTracing::REQUEST_HEADER_KEY] = trace_id
        yield
      end

      private
      def trace_id
        DistributedTracing.current_request_id || SecureRandom.uuid
      end
    end

    class Server
      def call(worker, job, queue)
        logger = worker.logger

        if logger.respond_to?(:tagged)
          logger.tagged(job[DistributedTracing::REQUEST_HEADER_KEY]) {yield}
        else
          yield
        end
      end
    end
  end
end