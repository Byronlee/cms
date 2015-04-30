require 'spec_helper'

describe Asynces::FavoritesController do
  include Rails.application.routes.url_helpers
  login_admin_user

  describe "POST 'create'" do
    let(:post_obj) { create(:post, :published) }

    context 'json' do
      before do
        post 'create', url_code: post_obj.url_code
      end

      it 'when not like it return like it' do
        expect(assigns(:current_user).like? post_obj).to be true
        expect(post_obj.reload.favoriter_sso_ids).to eq [assigns(:current_user).krypton_authentication.uid.to_i]
      end

      it 'when like it retuen not like it' do
        post 'create', url_code: post_obj.url_code
        expect(assigns(:current_user).like? post_obj).to be false
        expect(post_obj.reload.favoriter_sso_ids).to eq []
      end
    end
  end
end
