class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  protect_from_forgery with: :null_session

  def github
    @user = User.from_omniauth(request.env['omniauth.auth'])

    sign_in_and_redirect @user, event: :authentication
    set_flash_message :notice,
                      :success,
                      kind: 'Github' if is_navigational_format?
  end
end
