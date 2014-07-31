require 'spec_helper'

describe Appsignal::Grape::Middleware do

  class ComplexAPI < Grape::API
    prefix "api"
    version "v1"
    use Appsignal::Grape::Middleware

    resource :hello do
      get ':name' do
        "hello #{params['name']}"
      end
    end
  end

  class SimpleAPI < Grape::API
    use Appsignal::Grape::Middleware

    resource :hello do
      get ':id' do
        "hello #{params['id']}"
      end
    end
  end

  context "with a simple API" do
    let(:events){ [] }
    let(:app){ SimpleAPI }
    before do
      ActiveSupport::Notifications.subscribe(/^[^!]/) do |*args|
        events << ActiveSupport::Notifications::Event.new(*args)
      end
    end

    subject { get "/hello/1337"; events.last}

    it "delivers a payload consistent with the API call."do
      expect(subject.payload ).to eq(
        { method: "GET" , path: "hello/:id", action: "GRAPE::hello::1337", class: "API"}
      )
    end

    it "names the payload consistent with the API call."do
      expect(subject.name ).to eq("grape.GET.hello.id")
    end

    context "verify the api request" do
      subject{ get "/hello/1337"; last_response }

      it "returns the correct body" do
        expect(subject.body).to eq("hello 1337")
      end
      it "returns the correct status code" do
        expect(subject.status).to eq(200)
      end
    end
  end

  context "with a complex API" do
    let(:events){ [] }
    let(:app){ ComplexAPI }
    before do
      ActiveSupport::Notifications.subscribe(/^[^!]/) do |*args|
        events << ActiveSupport::Notifications::Event.new(*args)
      end
    end

    subject { get "api/v1/hello/mark"; events.last}

    it "delivers a payload consistent with the API call."do
      expect(subject.payload ).to eq(
        { method: "GET" , path: "api/:version/hello/:name", action: "GRAPE::api::v1::hello::mark", class: "API"}
      )
    end

    it "names the payload consistent with the API call."do
      expect(subject.name ).to eq("grape.GET.api.version.hello.name")
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
end
