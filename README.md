# rails_distributed_tracing
Distributed tracing for rails microservices

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/ajitsing/rails_distributed_tracing/graphs/commit-activity)
[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=102)](https://opensource.org/licenses/MIT)
[![Gem Version](https://badge.fury.io/rb/rails_distributed_tracing.svg)](https://badge.fury.io/rb/rails_distributed_tracing)
[![HitCount](http://hits.dwyl.io/ajitsing/rails_distributed_tracing.svg)](http://hits.dwyl.io/ajitsing/rails_distributed_tracing)
![Gem Downloads](http://ruby-gem-downloads-badge.herokuapp.com/rails_distributed_tracing?type=total)
[![Build Status](https://travis-ci.org/ajitsing/rails_distributed_tracing.svg?branch=master)](https://travis-ci.org/ajitsing/rails_distributed_tracing)
[![Twitter Follow](https://img.shields.io/twitter/follow/Ajit5ingh.svg?style=social)](https://twitter.com/Ajit5ingh)

## Installation
Add this line to Gemfile of your microservice:
```ruby
gem 'rails_distributed_tracing'
```

## Configuration
Add request id tag to log tags in `application.rb`. This config will make sure that the logs are tagged with a request id.
If the service is origin service, `DistributedTracing.request_id_tag` will create a new request id else it will reuse the request id passed from the origin service.

```ruby
require 'rails_distributed_tracing'

class Application < Rails::Application
  config.log_tags = [DistributedTracing.log_tag]
end
```

## Passing request id tag to downstream services
To make the distributed tracing work every service has to the request id to all its downstream services. 
For example lets assume that we have 3 services:   
`OriginService`, `SecondService` and `ThirdService` .  

Now a request comes to `OriginService`, the above config will create a new request_id for that request.
When `OriginService` makes a request to `SecondService` it should pass the same requst_id to it,
so that the request can be traced. The same should happen when `SecondService` calls the `ThirdService`.   

The bottomline is whenever there is a communication between two services, 
source service should always pass the request id to the destination service.

## How to pass request id tag to downstream services
When a request id is generated `rails_distributed_tracing` holds that request id till the request returns the response. You can access that request_id anywhere in your application code with the help of below APIs.

```ruby
DistributedTracing.trace_id
#=> '8ed7e37b-94e8-4875-afb4-6b4cf1783817'
```

## Sidekiq
```ruby
Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add DistributedTracing::SidekiqMiddleware::Server
  end
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add DistributedTracing::SidekiqMiddleware::Client
  end
end
```

## Faraday
```ruby
connection = Faraday.new("http://google.com/") do |conn|
  conn.use DistributedTracing::FaradayMiddleware
end
```

## Important Note
Make sure that faraday and sidekiq gems are loaded before `rails_distributed_tracing`. Otherwise rails_distributed_tracing will not load the faraday and sidekiq related classes.   

To ensure that `sidekiq` and `faraday` are loaded before `rails_distributed_tracing`, add sidekiq and faraday gem before rails_distributed_tracing in Gemfile. So that when rails load the Gemfile, sidekiq and faraday loaded before rails_distributed_tracing gem.

## Other
Add below headers to the outgoing request headers.
```ruby
{DistributedTracing::TRACE_ID => DistributedTracing.trace_id}
```

## Contributing

1. Fork it ( https://github.com/ajitsing/rails_distributed_tracing/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## License
```LICENSE
MIT License

Copyright (c) 2018 Ajit Singh

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

