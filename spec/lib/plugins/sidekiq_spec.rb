module Sidekiq; end

load 'lib/rails_distributed_tracing.rb'

describe DistributedTracing::SidekiqMiddleware do
  describe DistributedTracing::SidekiqMiddleware::Client do
    it 'should add trace id parameter to job' do
      DistributedTracing::TraceIdStore.trace_id = '00bfc934-b429-4606-b0c8-318ffa82e884'
      middleware = DistributedTracing::SidekiqMiddleware::Client.new

      job = {}
      middleware.call(nil, job, nil, nil) {}

      expect(job).to eq({DistributedTracing::TRACE_ID => DistributedTracing.trace_id})
    end

    it 'should add random trace id parameter to job when request id is not present' do
      middleware = DistributedTracing::SidekiqMiddleware::Client.new

      job = {}
      middleware.call(nil, job, nil, nil) {}

      expect(job[DistributedTracing::TRACE_ID]).to_not be_nil
    end
  end

  describe DistributedTracing::SidekiqMiddleware::Server do
    let(:worker) {double(:worker)}
    let(:logger) {double(:logger)}
    let(:trace_id) {'00bfc934-b429-4606-b0c8-318ffa82e884'}

    it 'should log trace id as tag for tagger logger' do
      middleware = DistributedTracing::SidekiqMiddleware::Server.new
      job = {DistributedTracing::TRACE_ID => trace_id}

      expect(worker).to receive(:logger).and_return(logger)

      expect(DistributedTracing).to receive(:trace_id=).with(trace_id).ordered
      expect(logger).to receive(:tagged).with(trace_id).ordered
      expect(DistributedTracing).to receive(:trace_id=).with(nil).ordered

      middleware.call(worker, job, nil) {}
    end

    it 'should skip trace id logging for a non tagged logger' do
      middleware = DistributedTracing::SidekiqMiddleware::Server.new
      job = {DistributedTracing::TRACE_ID => trace_id}

      expect(worker).to receive(:logger).and_return(double(:logger))
      expect(logger).to_not receive(:tagged)

      middleware.call(worker, job, nil) {}
    end
  end
end