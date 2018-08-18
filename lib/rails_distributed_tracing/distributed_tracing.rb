require_relative './request_id_store'

module DistributedTracing
  REQUEST_HEADER_KEY = 'Request-ID'.freeze

  def self.request_id_tag
    lambda do |request|
      request_id = request.headers[REQUEST_HEADER_KEY] || request.request_id
      RequestIDStore.request_id = request_id
    end
  end

  def self.request_id_header
    {REQUEST_HEADER_KEY => RequestIDStore.request_id}
  end

  def self.current_request_id
    RequestIDStore.request_id
  end
end