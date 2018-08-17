require_relative './request_id_store'

module DistributedTracing
  def self.request_id_tag
    lambda do |request|
      request_id = request.headers['Request-ID'] || request.request_id
      RequestIDStore.request_id = request_id
    end
  end

  def self.request_id_header
    {'Request-ID' => RequestIDStore.request_id}
  end

  def self.current_request_id
    RequestIDStore.request_id
  end
end