require 'spec_helper'

describe GibbonSTS::Mailer do
  context "ActionMailer" do
    subject do
      GibbonSTS::Mailer.new
    end
 
    let(:mail_message) {
      Mail.new do
        from 'john.doe@exampl.com'
        to 'jay.doe@example.com'
        subject 'This is a test email'
        body "This is sample body for test message"
      end
    }
    
    let(:mail_hash) {
      message = {}
      message['html'] = mail_message.body
      message['from_email'] = mail_message.from
      message['subject'] = mail_message.subject
      message['to_email'] = [mail_message.to]
      message['reply_to'] = mail_message.reply_to
      message['from_name'] = mail_message.from
      message
    }
        
    it "should parse Mail::Message" do
      subject.send(:transform_to_sts_format, mail_message).should == mail_hash[nil]
    end
  end
end