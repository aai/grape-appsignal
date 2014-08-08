require 'spec_helper'
describe Appsignal::Grape::Middleware do

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
        { method: "GET" , path: "hello/:id", action: "Grape::GET/hello/:id", class: "API"}
      )
    end

    it "names the payload consistent with the API call."do
      expect(subject.name ).to eq("process_action.grape.GET.hello.id")
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
    let(:app){ ComplexAPI::Root }
    before do
      ActiveSupport::Notifications.subscribe(/^[^!]/) do |*args|
        events << ActiveSupport::Notifications::Event.new(*args)
      end
    end

    subject { get "api/v1/hello/name/mark"; events.last}

    it "delivers a payload consistent with the API call."do
      expect(subject.payload ).to eq(
        { method: "GET" , path: "api/:version/hello/name/:name", action: "Grape(v1)(api)::GET/api/v1/hello/name/:name", class: "API"}
      )
    end

    it "names the payload consistent with the API call."do
      expect(subject.name).to eq("process_action.grape.GET.api.version.hello.name.name")
    end

    context "verify the api request" do
      subject{ get "api/v1/hello/name/mark"; last_response }

      it "returns the correct body" do
        expect(subject.body).to eq("hello mark")
      end
      it "returns the correct status code" do
        expect(subject.status).to eq(200)
      end
    end

    context "with a complex API" do
      let(:events){ [] }
      let(:app){ ComplexAPI::Root }
      before do
        ActiveSupport::Notifications.subscribe(/^[^!]/) do |*args|
          events << ActiveSupport::Notifications::Event.new(*args)
        end
      end

      subject { get "/api/v1/hello/goodbye/"; events.last}

      it "delivers a payload consistent with the API call."do
        expect(subject.payload ).to eq(
          { method: "GET" , path: "api/:version/hello/goodbye", action: "Grape(v1)(api)::GET/api/v1/hello/goodbye", class: "API"}
        )
      end

      it "names the payload consistent with the API call."do
        expect(subject.name ).to eq("process_action.grape.GET.api.version.hello.goodbye")
      end
    end

    context 'with a complex nested API' do
      let(:events){ [] }
      let(:app){ ComplexAPI::Root }
      before do
        ActiveSupport::Notifications.subscribe(/^[^!]/) do |*args|
          events << ActiveSupport::Notifications::Event.new(*args)
        end
      end

      subject { get '/api/nested/v1/stuff'; events.last}

      it 'delivers a payload consistent with the API call.' do
        expect(subject.payload ).to eq(
          { method: "GET" , path: "api/nested/:version/stuff", action: "Grape(v1)(api/nested)::GET/api/nested/v1/stuff", class: "API"}
        )
      end

      it "names the payload consistent with the API call." do
        expect(subject.name ).to eq("process_action.grape.GET.api.nested.version.stuff")
      end
    end
  end
end
