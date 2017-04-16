require 'spec_helper'

describe Appsignal::Grape::Middleware do

  class SimpleAPI < Grape::API
    use Appsignal::Grape::Middleware

    resource :hello do
      route_param :id do
        get do
          "hello #{params['id']}"
        end
      end
    end
  end

  context "with a simple API" do
    let(:events){ [] }
    let(:app){ SimpleAPI }
    before do
      ActiveSupport::Notifications.subscribe('process_action.grape') do |*args|
        events << ActiveSupport::Notifications::Event.new(*args)
      end
    end

    subject { get "/hello/1337"; events.last}

    it "delivers a payload consistent with the API call."do
      expect(subject.payload ).to eq(
        {
          params: {
            'id' => '1337'
          },
          session: {},
          method: 'GET',
          path: '/hello/1337',
          action: 'GET /hello/:id(.:format)'
        }
      )
    end

    it "names the payload consistent with the API call."do
      expect(subject.name ).to eq("process_action.grape")
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
    let!(:app){ ComplexAPI::Root }
    before do
      ActiveSupport::Notifications.subscribe('process_action.grape') do |*args|
        events << ActiveSupport::Notifications::Event.new(*args)
      end
    end

    subject { get '/api/v1/hello/name/mark'; events.last}

    it "delivers a payload consistent with the API call."do
      expect(subject.payload ).to eq(
        {
          params: {
            'name' => 'mark'
          },
          session: {},
          method: 'GET',
          path: '/api/v1/hello/name/mark',
          action: 'GET /api/:version/hello(.:format)'
        }
      )
    end

    it "names the payload consistent with the API call."do
      expect(subject.name).to eq("process_action.grape")
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
        ActiveSupport::Notifications.subscribe('process_action.grape') do |*args|
          events << ActiveSupport::Notifications::Event.new(*args)
        end
      end

      subject { get "/api/v1/hello/goodbye/"; events.last}

      it "delivers a payload consistent with the API call."do
        expect(subject.payload ).to eq(
          {
            params: {},
            session: {},
            method: 'GET',
            path: '/api/v1/hello/goodbye',
            action: 'GET /api/:version/hello(.:format)'
          }
        )
      end

      it "names the payload consistent with the API call."do
        expect(subject.name ).to eq("process_action.grape")
      end
    end

    context 'with a complex nested API' do
      let(:events){ [] }
      let(:app){ ComplexAPI::Root }
      before do
        ActiveSupport::Notifications.subscribe('process_action.grape') do |*args|
          events << ActiveSupport::Notifications::Event.new(*args)
        end
      end

      subject { get '/api/nested/v1/stuff'; events.last}

      it 'delivers a payload consistent with the API call.' do
        expect(subject.payload ).to eq(
          {
            params: {},
            session: {},
            method: 'GET',
            path: '/api/nested/v1/stuff',
            action: 'GET /api/nested/:version/stuff(.:format)'
          }
        )
      end

      it "names the payload consistent with the API call." do
        expect(subject.name ).to eq("process_action.grape")
      end
    end
  end
end
