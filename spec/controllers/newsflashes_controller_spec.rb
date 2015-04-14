require 'spec_helper'

describe NewsflashesController do

  describe "GET 'index'" do
    context 'should return success' do
      let (:newsflash) { create(:newsflash) }
      before { get 'index', year: newsflash.created_at.year, month: newsflash.created_at.month, day: newsflash.created_at.day }
      it {
        should respond_with(:success)
        should render_template(:index)

        newsflashes = assigns(:newsflashes)
        expect(newsflashes).to include(newsflash)
      }
    end
  end

  describe "GET 'show'" do
    context 'should return success' do
      let (:newsflash) { create(:newsflash) }
      before { get 'show', id: newsflash }
      it {
        date = newsflash.created_at
        should respond_with(302)
        expect(response).to redirect_to(newsflashes_of_day_path(year: date.year, month: date.month, day: date.day, anchor: newsflash.id))
      }
    end
  end

end
