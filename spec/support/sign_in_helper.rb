module SignInHelper
  def login_user(*args)
    let(:session_user) { create :user, *args }

    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in(session_user)
    end
  end

  def login_admin_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = create(:user, :admin)
      sign_in(user)
    end
  end
end

RSpec.configure do |config|
  config.extend SignInHelper, type: :controller
end
