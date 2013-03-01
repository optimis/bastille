require 'bastille/server'
require 'fakeredis'

module TestServer
  extend self

  HOST   = '127.0.0.1'
  PORT   = 9000
  SERVER = 'webrick'

  def run!
    @thread = Thread.fork do
      ENV['RACK_ENV'] = 'test'
      Rack::Server.start :app => Bastille::Server.new,
        :Host      => HOST,
        :Port      => PORT,
        :server    => SERVER,
        :Logger    => WEBrick::Log::new("/dev/null", 7),
        :AccessLog => []
    end
    wait_for_service
  end

  def stop!
    @thread.kill
  end

  def listening?
    begin
      socket = TCPSocket.new(HOST, PORT)
      socket.close unless socket.nil?
      true
    rescue Errno::ECONNREFUSED, SocketError
      false
    end
  end

  def wait_for_service(timeout = 5)
    start_time = Time.now

    until listening?
      if timeout && (Time.now > (start_time + timeout))
        raise SocketError.new("Socket did not open within #{timeout} seconds")
      end
    end
  end
end

at_exit do
  TestServer.stop!
end

Octokit.api_endpoint = OCTOKIT_DOMAIN
Octokit.web_endpoint = OCTOKIT_DOMAIN
TestServer.run!
