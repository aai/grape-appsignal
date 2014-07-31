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

  let(:events){ [] }
  before do
    ActiveSupport::Notifications.subscribe(/^[^!]/) do |*args|
      events << ActiveSupport::Notifications::Event.new(*args)
    end
  end

  subject { get "api/v1/hello/mark"; events.pop.payload }

  it "should pass along the corret info."do
    expect(subject).to eq(
      { method: "GET" , path: "api/:version/hello/:name", action: "GET/api/v1/hello/mark", class: "API"}
    )
  end

  context "verify the api request" do
    subject{ get "api/v1/hello/mark"; last_response }

    it "returns the correct body" do
      expect(subject.body).to eq("hello mark")
    end
    it "returns the correct status code" do
      expect(subject.status).to eq(200)
    end
  end
end
