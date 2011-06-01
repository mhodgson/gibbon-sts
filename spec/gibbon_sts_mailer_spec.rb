require 'spec_helper'

describe GibbonSTS::Mailer do
  def mail_message(to_address = 'jay.doe@example.com')
    Mail.new do
      from 'john.doe@exampl.com'
      to to_address
      subject 'This is a test email'
      body "This is sample body for test message"
    end
  end
  
  def response_from_sts_with_status(status = "sent") 
    { "message_id"=>"699ef71c-8c2c-13e0-ad3c-57e5aafd2c3", 
      "aws_code"=>nil, "msg"=>nil, "status"=>"#{status}" }
  end
  
  subject do
    ::GibbonSTS::Mailer.api = ::GibbonSTS::API.new('api-key')
    ::GibbonSTS::Mailer.new(:api_key => 'api-key')
  end
        
  it "should parse Mail::Message" do
    ::GibbonSTS::API.any_instance.stub(:send_email).and_return(response_from_sts_with_status("sent"))
    subject.send(:transform_to_sts_format, mail_message).should == 
      { :html=>"This is sample body for test message", :from_email=>["john.doe@exampl.com"], 
        :subject=>"This is a test email", :to_email=>["jay.doe@example.com"], 
        :reply_to=>nil, :from_name=>["john.doe@exampl.com"]}
  end
  
  it "should return hash about the delivery" do
    response = response_from_sts_with_status("sent")
    ::GibbonSTS::API.any_instance.stub(:send_email).and_return(response)
    subject.deliver(mail_message('joel@exmaple.com')).should == response
  end
  
  it "should raise exception if not api set" do
    expect { ::GibbonSTS::Mailer.new(:api_key => 'api-key').deliver(mail_message()) }.to raise_error
  end
  
end