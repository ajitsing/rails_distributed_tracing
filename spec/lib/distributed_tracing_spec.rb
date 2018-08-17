describe DistributedTracing do
  describe '#request_id_tag' do
    it 'should return request id from request object' do
      request = double('request')
      request_id = 'f914eb91-c550-48c4-af35-d14db95bd49f'

      expect(request).to receive(:request_id).and_return(request_id)
      expect(request).to receive(:headers).and_return({})

      expect(DistributedTracing.request_id_tag.call(request)).to eq(request_id)
    end

    it 'should return request id from header' do
      request = double('request')
      request_id = '00bfc934-b429-4606-b0c8-318ffa82e884'

      expect(request).to receive(:headers).and_return({'Request-ID' => request_id})

      expect(DistributedTracing.request_id_tag.call(request)).to eq(request_id)
    end
  end

  describe '#current_request_id' do
    it 'should return current request id' do
      request = double('request')
      request_id = '00bfc934-b429-4606-b0c8-318ffa82e884'

      expect(request).to receive(:headers).and_return({'Request-ID' => request_id})

      DistributedTracing.request_id_tag.call(request)

      expect(DistributedTracing.current_request_id).to eq(request_id)
    end
  end

  describe '#request_id_header' do
    it 'should return request id in a header' do
      request = double('request')
      request_id = '00bfc934-b429-4606-b0c8-318ffa82e884'

      expect(request).to receive(:headers).and_return({'Request-ID' => request_id})

      DistributedTracing.request_id_tag.call(request)

      expect(DistributedTracing.request_id_header).to eq({'Request-ID' => request_id})
    end
  end
end