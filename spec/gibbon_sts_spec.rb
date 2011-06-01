require 'spec_helper'

describe GibbonSTS::API do
  
  context "build api url" do
    
    before(:each) do
      @gibbon = GibbonSTS::API.new
    end
    
    it "handle empty api key" do
      expect_post("https://sts.mailchimp.com/1.0/SayHello", {:body=>{:apikey=>nil}, :timeout=>nil})
      @gibbon.say_hello()
    end
    
    it "handle timeout" do
      expect_post("https://sts.mailchimp.com/1.0/SayHello", {:body=>{:apikey=>nil}, :timeout=>120})
      @gibbon.timeout=120
      @gibbon.say_hello
    end
    
    it "handle api key with dc" do
      @gibbon.apikey="TESTKEY-us1"
      expect_post("https://us1.sts.mailchimp.com/1.0/SayHello", {:body=>{:apikey=>"TESTKEY-us1"}, :timeout=>nil})
      @gibbon.say_hello
    end
  end
    
  private
  
  def expect_post(expected_url, expected_options)
    GibbonSTS::API.should_receive(:post).with(expected_url, expected_options) { (Struct.new(:body).new("") ) }
  end
  
  def params_parser(params)
    GibbonSTS::API.new.send(:escape_params, params)
  end
  
end