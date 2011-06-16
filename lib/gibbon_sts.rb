require 'httparty'
require 'json'
require 'cgi'

module GibbonSTS
  class API
    include HTTParty
    default_timeout 30

    attr_accessor :apikey, :timeout

    def initialize(apikey = nil, extra_params = {})
      @apikey = apikey
      @default_params = { :apikey => apikey }.merge(extra_params)
    end

    def apikey=(value)
      @apikey = value
      @default_params = @default_params.merge({:apikey => @apikey})
    end

    def base_api_url
      dc = @apikey.blank? ? '' : "#{@apikey.split("-").last}."
      "https://#{dc}sts.mailchimp.com/1.0/"
    end

    def call(method, params = {})
      url = base_api_url + method
      params = @default_params.merge(params)
      response = API.post(url, :body => params, :timeout => @timeout)        
      begin
        response = JSON.parse(response.body)
      rescue
        response = response.body
      end
      response
    end

    def method_missing(method, *args)
      method = method.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase } #Thanks for the gsub, Rails
      method = method[0].chr.upcase + method[1..-1].gsub(/aim$/i, 'AIM')
      args = {} unless args.length > 0
      args = args[0] if (args.class.to_s == "Array")
      call(method, args)
    end
  end
  
  class Mailer
    attr_accessor :settings
  
    def self.api
      @@api || raise("Missing connection to MailChimp using GibbonSTS::API")
    end
  
    def self.api=(sts_api)
      @@api = sts_api
    end
  
    def new(*args)
      self
    end

    def deliver!(message)
      deliver message
    end
    
    def deliver(message)
      sts_message = transform_to_sts_format(message)
      Mailer.api.send_email({:message => sts_message, :track_opens => true, :track_cliks => false, :tags => ['notifications']})
    end
      
    protected
    
      def transform_to_sts_format(message)
        # Message will be Mail::Message
        sts_message = handle_multipart(message.body)
        sts_message[:html] = message.body.to_s
        sts_message[:from_email] = message.from.is_a?(Array) ? message.from.first : message.from
        sts_message[:subject] = message.subject
        sts_message[:to_email] = message.to
        sts_message[:reply_to] = message.reply_to.is_a?(Array) ? message.reply_to.first : message.reply_to unless message.reply_to.nil?
        sts_message[:from_name] = message.from.first
        sts_message
      end
      
      def handle_multipart(message)
        sts_message = {}
        if message.multipart?
          sts_message[:html] = message.html_part.body if message.html_part
          sts_message[:text] = message.text_part.body if message.text_part
        else
          sts_message[:html] = message.body.to_s
        end  
        sts_message
      end
  end
  
end