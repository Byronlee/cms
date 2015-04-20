require 'spec_helper'

describe UsersController do
  describe "GET 'messages'" do
    it 'returns http success' do
      get 'messages', data: { code: 0, data: { total: 2 } }
      response.should be_success
      expect(response).to render_template('users/_messages')
    end
  end
end
