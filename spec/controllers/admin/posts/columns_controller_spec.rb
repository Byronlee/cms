require "spec_helper"

describe Admin::Posts::ColumnsController do
  login_admin_user

  describe "GET 'index'" do
    before { create :post }
    let(:columns) { create_list :column, 5 }
    before { get :index, ids: columns.map(&:id) }
    it { should respond_with(:success) }
  end

  describe "POST 'create'" do
    let(:column) { create :column }
    let(:kpost) { create :post, column: nil }
    context "valid" do
      before { xhr :post, :create, id: column.id, post_id: kpost.id, format: :json }
      it { should respond_with(:success) }
    end
    # context "invalid" do
    #   context "invalid column id" do
    #     before { xhr :post, :create, id: nil, post_id: kpost.id, format: :json }
    #     it { should respond_with(:not_found) }
    #   end
    #   context "invalid post id" do
    #     before { xhr :post, :create, id: column.id, post_id: -1, format: :json }
    #     it { should respond_with(:not_found) }
    #   end
    # end
  end
end