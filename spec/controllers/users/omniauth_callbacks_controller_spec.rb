require 'rails_helper'

describe Users::OmniauthCallbacksController do
  before do
    request.env['devise.mapping'] = Devise.mappings[:user]

    request.env['omniauth.auth'] = OmniAuth::AuthHash.new({
      provider: 'github',
      uid: 1234,
      info: { email: 'name@example.com' },
      credentials: { token: 'foo' }
    })
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
  #
  # describe "#logged in user" do
  #   context "when user don't have facebook authentication" do
  #     before(:each) do
  #       stub_env_for_omniauth
  #
  #       user = User.create!(:email => "user@example.com", :password => "my_secret")
  #       sign_in user
  #
  #       get :facebook
  #     end
  #
  #     it "should add facebook authentication to current user" do
  #       user = User.where(:email => "user@example.com").first
  #       user.should_not be_nil
  #       fb_authentication = user.authentications.where(:provider => "facebook").first
  #       fb_authentication.should_not be_nil
  #       fb_authentication.uid.should == "1234"
  #     end
  #
  #     it { should be_user_signed_in }
  #
  #     it { response.should redirect_to authentications_path }
  #
  #     it { flash[:notice].should == "Facebook is connected with your account."}
  #   end
  #
  #   context "when user already connect with facebook" do
  #     before(:each) do
  #       stub_env_for_omniauth
  #
  #       user = User.create!(:email => "ghost@nobody.com", :password => "my_secret")
  #       user.authentications.create!(:provider => "facebook", :uid => "1234")
  #       sign_in user
  #
  #       get :facebook
  #     end
  #
  #     it "should not add new facebook authentication" do
  #       user = User.where(:email => "ghost@nobody.com").first
  #       user.should_not be_nil
  #       fb_authentications = user.authentications.where(:provider => "facebook")
  #       fb_authentications.count.should == 1
  #     end
  #
  #     it { should be_user_signed_in }
  #
  #     it { flash[:notice].should == "Signed in successfully." }
  #
  #     it { response.should redirect_to tasks_path }
  #
  #   end
  # end

end
