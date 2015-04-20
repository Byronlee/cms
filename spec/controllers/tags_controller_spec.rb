require 'spec_helper'

describe TagsController do
  describe "GET 'show'" do
    let(:post) { create :post, :published }

    before do
      post.tag_list = 'fuck'
      post.save
    end

    it 'returns http success' do
      get 'show', tag: 'fuck'
      response.should be_success
      expect(assigns(:posts)).to eq [post]
    end

    context 'tag not found' do
      it 'raise ActiveRecord::RecordNotFound' do
        expect do
          get 'show', tag: 'oo-xx'
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
