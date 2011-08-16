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
  
    def settings
      @settings || Hash.new
    end
    
    def self.api
      @@api || raise("Missing connection to MailChimp using GibbonSTS::API")
    end
  
    def self.api=(sts_api)
      @@api = sts_api
    end
  
    def initialize(*args)
      self
    end

    def deliver!(message)
      deliver message
    end
    
    def deliver(message)
      sts_message = transform_to_sts_format(message)
      sts_tags = message.header['sts-tags'] ? message.header['sts-tags'].value.split(",") : []
      track_clicks = (message.header['sts-track-clicks'] || 'false') == 'true'
      track_opens = (message.header['sts-track-opens'] || 'false') == 'true'
      Mailer.api.send_email({:message => sts_message, :track_opens => track_opens, :track_clicks => track_clicks, :tags => sts_tags})
    end
      
    protected
    
      def transform_to_sts_format(message)
        # Message will be Mail::Message
        sts_message = handle_multipart(message)
        sts_message[:from_email] = message.from.is_a?(Array) ? message.from.first : message.from
        sts_message[:from_name] = message[:from].to_s.gsub(/\s<([A-Z0-9_\.%\+\-\']+@(?:[A-Z0-9\-]+\.)+(?:[A-Z]{2,4}|museum|travel))>/i, '')
        sts_message[:subject] = message.subject
        sts_message[:to_email] = message.to.to_a
        sts_message[:cc_email] = message.cc.to_a unless message.cc.nil?
        sts_message[:bcc_email] = message.bcc.to_a unless message.bcc.nil?
        sts_message[:reply_to] = message.reply_to.to_a unless message.reply_to.nil?
        sts_message
      end
      
      def handle_multipart(message)
        sts_message = {}
        if message.multipart?
          if message.html_part
            sts_message[:html] = message.html_part.body
            sts_message[:autogen_html] = false
          else
            sts_message[:html] = ""
            sts_message[:autogen_html] = true
          end
          sts_message[:text] = message.text_part.body
        else
          sts_message[:html] = message.body
          sts_message[:autogen_html] = false
        end  
        sts_message
      end
  end
  
end