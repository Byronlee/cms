require 'spec_helper'

describe ErrorsController do
  describe "GET 'render_404'" do
    it 'returns render 404' do
      get :render_404
      expect(response).to render_template('404')
    end
  end

  describe "GET 'render_500'" do
    it 'returns http success' do
      get :render_500
      expect(response).to render_template('500')
    end
  end
end
