require 'spec_helper'

describe Appsignal::Grape::Middleware do

  class TestAPI < Grape::API
    use Appsignal::Grape::Middleware
    get 'hello/:name' do
      "hello #{params['name']}"
    end
  end

  def app; TestAPI; end

  let(:event) { @events.pop }
  subject { event.payload }

  before(:all) do
    @events     = []
    ActiveSupport::Notifications.subscribe('process_action.grape') do |*args|
      @events << ActiveSupport::Notifications::Event.new(*args)
    end
  end

  before(:each) do
    get "/hello/mark"
  end

  it do
    should == { method: "GET" , path: "hello/:name"}
  end

  context "verify the api request" do
    subject{ last_response }

    its(:body){ should == "hello mark" }
    its(:status){ should == 200 }
  end
end
