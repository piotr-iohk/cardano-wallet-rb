# frozen_string_literal: true

module CardanoWallet
  ##
  # Base class for all APIs
  class Base
    include HTTParty

    attr_accessor :opt

    # Initialize CardanoWallet.
    # @example Initialize CardanoWallet with default settings
    #  @cw = CardanoWallet.new
    #
    # @example Initialize CardanoWallet with custom settings
    #  @cw = CardanoWallet.new({ port: 4445,
    #                            protocol: 'https',
    #                            cacert: '/path/to/cacert',
    #                            pem: '/path/to/client.pem',
    #                            timeout: 600 })
    def initialize(opt = {})
      raise ArgumentError, 'argument should be Hash' unless opt.is_a?(Hash)

      opt[:protocol] ||= 'http'
      opt[:host] ||= 'localhost'
      opt[:port] ||= 8090
      opt[:url] ||= "#{opt[:protocol]}://#{opt[:host]}:#{opt[:port]}/v2"
      opt[:cacert] ||= ''
      opt[:pem] ||= ''
      opt[:timeout] ||= -1
      self.class.base_uri opt[:url]
      self.class.default_timeout(opt[:timeout].to_i) unless opt[:timeout] == -1

      unless opt[:cacert].empty?
        ENV['SSL_CERT_FILE'] = opt[:cacert]
        self.class.ssl_ca_file(File.read(ENV.fetch('SSL_CERT_FILE', nil)))
      end
      self.class.pem(File.read(opt[:pem])) unless opt[:pem].empty?

      @opt = opt
    end

    # Init API for Shelley
    def shelley
      Shelley.new @opt
    end

    # Init API for Shared wallets
    def shared
      Shared.new @opt
    end

    # Init API for Byron
    def byron
      Byron.new @opt
    end

    # Init API for Misc
    def misc
      Misc.new @opt
    end

    # Init API for Utils
    def utils
      Utils.new @opt
    end
  end
end
