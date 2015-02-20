require 'rails_helper'

describe Users::OmniauthCallbacksController do
  before do
    request.env['devise.mapping'] = Devise.mappings[:user]

    request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: 1234,
      info: { email: 'name@example.com' },
      credentials: { token: 'foo' }
    )
  end

  describe '#annonymous user' do
    context "when github email doesn't exist in the system" do
      it 'creates a new user' do
        expect { get :github }.to change { User.count }.by 1
      end

      it 'redirects to ...' do
        get :github
        expect(response).to have_http_status :redirect
      end
    end
  end
end
