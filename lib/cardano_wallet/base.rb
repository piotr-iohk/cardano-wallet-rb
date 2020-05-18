module CardanoWallet
  class Base
    include HTTParty

    attr_reader :opt

    def initialize(opt = {})
      raise ArgumentError, "argument should be Hash" unless opt.is_a?(Hash)

      opt[:protocol] ||= 'http'
      opt[:host] ||= 'localhost'
      opt[:port] ||= 8090
      opt[:url] ||= "#{opt[:protocol]}://#{opt[:host]}:#{opt[:port]}/v2"
      opt[:cacert] ||= ''
      opt[:pem] ||= ''
      self.class.base_uri opt[:url]

      unless opt[:cacert].empty?
        ENV['SSL_CERT_FILE'] = opt[:cacert]
        self.class.ssl_ca_file(File.read ENV['SSL_CERT_FILE'])
      end
      self.class.pem(File.read opt[:pem]) unless opt[:pem].empty?

      @opt = opt
    end

    # Init API for Shelley
    def shelley
      Shelley.new @opt
    end

    # Init API for Byron
    def byron
      Byron.new @opt
    end

    # Init API for Misc
    def misc
      Misc.new @opt
    end
  end
end
