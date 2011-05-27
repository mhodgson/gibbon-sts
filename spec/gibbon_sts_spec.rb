require 'spec_helper'

describe GibbonSTS::API do
  
  context "build api url" do
    
    before(:each) do
      @gibbon = GibbonSTS::API.new
    end
    
    it "handle empty api key" do
      expect_post("https://sts.mailchimp.com/1.0/SayHello", {:body=>{"apikey"=>nil}})
      @gibbon.say_hello()
    end
    
    it "handle timeout" do
      expect_post("https://sts.mailchimp.com/1.0/SayHello", {:body=>{"apikey"=>nil}})
      @gibbon.timeout=120
      @gibbon.say_hello
    end
    
    it "handle api key with dc" do
      @gibbon.apikey="TESTKEY-us1"
      expect_post("https://us1.sts.mailchimp.com/1.0/SayHello", {:body=>{"apikey"=>"TESTKEY-us1"}})
      @gibbon.say_hello
    end
  end
  
  context "build api body" do
    before(:each) do
      @key = "TESTKEY-us1"
      @gibbon = GibbonSTS::API.new(@key)
      @url = "https://us1.sts.mailchimp.com/1.0/SayHello"
    end

    # Httparty is cleaning up
    #it "should escape string parameters" do
    #  expect_post(@url, {:body=>{"apikey"=>"TESTKEY-us1", "message"=>"simon+says"}})
    #  @gibbon.say_hello("message" => "simon says")
    #end
    
    #it "escape string parameters in an array" do
    #  expect_post(@url, {:body=>{"apikey"=>"#{@key}", "messages"=>["simon+says", "do+this"]}})
    #  @gibbon.say_hello("messages" => ["simon says", "do this"])
    #end
    
    #it "escape string parameters in a hash" do
    #  expect_post(@url, {:body=>{"apikey" => @key, "messages" => {"simon+says" => "do+this"}}})
    #  @gibbon.say_hello("messages" => {"simon says" => "do this"})
    #end
    
    #it "escape nested string parameters" do 
    #  expect_post(@url, {:body=>{"apikey" => @key, "messages" => {"simon+says" => ["do+this", "and+this"]}}})
    #  @gibbon.say_hello("messages" => {"simon says" => ["do this", "and this"]})
    #end
    
    it "pass through non string parameters" do
      expect_post(@url, {:body=>{"apikey" => @key, "fee" => 99}})
      @gibbon.say_hello("fee" => 99)
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