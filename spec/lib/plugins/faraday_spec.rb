module Faraday; end
class Faraday::Middleware
  attr_accessor :app
end

load 'lib/rails_distributed_tracing.rb'

describe DistributedTracing::FaradayMiddleware do
  it 'should add trace id header to request headers' do
    DistributedTracing::TraceIdStore.trace_id = '00bfc934-b429-4606-b0c8-318ffa82e884'
    middleware = DistributedTracing::FaradayMiddleware.new
    middleware.app = double(:app)

    expect(middleware.app).to receive(:call).with({request_headers: {DistributedTracing::TRACE_ID => DistributedTracing.trace_id}})

    middleware.call({request_headers: {}})
  end
end