require 'spec_helper'

describe UsersController do
  describe "GET 'messages'" do
    it 'returns http success' do
      get 'messages', data: { code: 0 }
      response.should be_success
      expect(response).to render_template('_messsage')
    end
  end
end
