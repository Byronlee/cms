require 'spec_helper'

describe ApplicationController do
  include Rails.application.routes.url_helpers
  login_user

  describe '#redirect_to_no_subdomain', :type => :request do
    describe 'www request not include api or feed, redirect_to a domain not include www' do
      it 'www' do
        get 'http://www.36kr.com'
        expect(response).to redirect_to('http://36kr.com/')
        expect(response.status).to be(301)
      end
    end
  end

  describe '#match_krid_online_status', :type => :request do
    context 'cookies not present' do
      before do
        cookies[Settings.oauth.krypton.cookie.name] = nil
      end

      it 'should redirect_to sign_out path' do
        get 'http://kid.36kr.com'
        # expect(response).to redirect_to(sign_out(assigns(:current_user)))
        expect(response).to be_success
      end
    end
  end

  describe 'handling AccessDenied exceptions' do
    controller do
      def index
        raise CanCan::AccessDenied
      end
    end

    it 'redirects to the errors#forbidden page' do
      get :index
      expect(response).to render_template('errors/forbidden')
    end

    it 'redirects to the /401.html page if not sigin' do
      sign_out(session_user)
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
