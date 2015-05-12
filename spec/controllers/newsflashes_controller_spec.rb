require 'spec_helper'

describe NewsflashesController do

  describe "GET 'index'" do
    context 'should return success' do
      let(:newsflash) { create(:newsflash) }
      before { get 'index', year: newsflash.created_at.year, month: newsflash.created_at.month, day: newsflash.created_at.day }
      it do
        should respond_with(:success)
        should render_template(:index)

        nf = assigns(:newsflashes).first
        expect(nf).to eq newsflash

        expect(nf.cache_views_count - nf.views_count).to eq(1)
        expect(nf.persist_views_count).to eq([nf.cache_views_count, nf.views_count].max)
        expect(nf.cache_views_count - nf.views_count).to eq(0)
      end
    end

    context 'should render tips with no newsflash' do
      before { get 'index', year: 2015, month: 03, day: 01 }
      it do
        should respond_with(:success)
        should render_template(:index)

        newsflashes = assigns(:newsflashes)
        expect(newsflashes).to eq([])
      end
    end
  end

  describe "GET 'show'" do
    context 'should return success' do
      let(:newsflash) { create(:newsflash) }
      before { get 'show', id: newsflash }
      it do
        date = newsflash.created_at
        should respond_with(302)
        expect(response).to redirect_to(newsflashes_of_day_path(year: date.year, month: date.month, day: date.day, anchor: newsflash.id))
      end
    end
  end
end
