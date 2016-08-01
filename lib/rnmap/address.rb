require 'ipaddr'
require 'uri'

module Rnmap
  class Address

    def initialize(host_or_url)
      @host_or_url = host_or_url
      @host        = nil
      @ipaddr      = nil
      @hostname    = nil
    end

    def ipaddr
      return @ipaddr unless @ipaddr.nil?
      begin
        address = IPAddr.new(@host_or_url)
        @host   = address.to_s
      rescue IPAddr::InvalidAddressError
        @ipaddr = nil
      end
    end

    def hostname
      return @hostname unless @hostname.nil?
      begin
        hostname = URI.parse(@host_or_url).host
        @host    = hostname if hostname
      rescue URI::InvalidURIError
        @hostname = nil
      end
    end

    def is_valid?
      ipaddr or hostname
    end

    def to_filename
      "#{@host.gsub('.', '-')}.xml" if is_valid?
    end

    def to_s
      return @host if is_valid?
    end
  end
end
