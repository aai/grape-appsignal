require 'spec_helper'

describe Appsignal::Grape::Middleware do

  class TestAPI < Grape::API
    prefix "api"
    version "v1"
    use Appsignal::Grape::Middleware

    resource :hello do
      get ':name' do
        "hello #{params['name']}"
      end
    end
  end

  def app; TestAPI; end

  let(:event) { @events.pop }
  subject { event.payload }

  before(:all) do
    @events     = []
    ActiveSupport::Notifications.subscribe('process_action.grape.api.v1.hello.mark') do |*args|
      @events << ActiveSupport::Notifications::Event.new(*args)
    end
  end

  before(:each) do
    get "api/v1/hello/mark"
  end

  it do
    should == { method: "GET" , path: "api/:version/hello/:name", action: "GET.api.v1.hello.mark"}
  end

  context "verify the api request" do
    subject{ last_response }

    its(:body){ should == "hello mark" }
    its(:status){ should == 200 }
  end
end
