require 'spec_helper'

describe Admin::HeadLinesController do

  describe "GET 'index'" do
  	let!(:head_line){ create(:head_line) }

    it "returns http success" do
      get 'index'
      response.should be_success
      expect(response).to render_template(:admin)
      expect(assigns(:head_lines)).to eq([head_line])
    end
  end


  describe "PATCH 'update'" do
  	context "when params is valid" do
	  	let!(:head_line){ create(:head_line) }
	  	let(:url){"http://localhost:3000/admin/posts/2"}

	  	it "returns http rediect" do
	      patch :update, id:head_line, head_line: {:url => url}
	      expect(response.status).to eq(302)
	      head_line.reload.url.should == url
	      expect(response).to redirect_to(admin_head_lines_path)
	    end
    end

    context "when params is invalid" do
    	let!(:head_line){ create(:head_line) }
	  	let(:url){"http://localhost:3000/admin/posts/2"}

	     it "returns back for url being necessary" do
	      patch :update, id:head_line, head_line: {:url => nil}
	      assigns(:head_line).errors.empty?.should_not be_true
	      assigns(:head_line).errors[:url].empty?.should_not be_true
	      assigns(:head_line).errors[:order_num].empty?.should be_true

	      assigns(:head_line).errors[:url].first.should match(/不能为空字符/)
	    end

	    it "returns back for url being uniquee" do
	    	create :head_line2
	      patch :update, id:head_line, head_line: {:url => attributes_for(:head_line2)[:url] }
	      assigns(:head_line).errors.empty?.should_not be_true
	      assigns(:head_line).errors[:url].empty?.should_not be_true
	      assigns(:head_line).errors[:introduce].empty?.should be_true

	      assigns(:head_line).errors[:url].first.should match(/已经被使/)
      end
    end
   end

   describe "POST 'create'" do
 		 context "when params is valid" do
	  	 it "returns http rediect" do
	       post 'create', :head_line => attributes_for(:head_line2)
	       expect(response.status).to eq(302)
	       expect(response).to redirect_to(admin_head_lines_path)
	     end
     end

     context "when params is invalid" do
	     it "returns back for url being necessary" do
	       post 'create', :head_line => {:url => nil, :order_num => nil}
	       assigns(:head_line).errors.empty?.should_not be_true
	       assigns(:head_line).errors[:url].empty?.should_not be_true
	       assigns(:head_line).errors[:order_num].empty?.should be_true

	       assigns(:head_line).errors[:url].first.should match(/不能为空字符/)
	     end

	     it "returns back for url being uniquee" do
	     	 create :head_line2
	       post 'create', :head_line => attributes_for(:head_line2)
	       assigns(:head_line).errors.empty?.should_not be_true
	       assigns(:head_line).errors[:url].empty?.should_not be_true
	       assigns(:head_line).errors[:order_num].empty?.should be_true

	       assigns(:head_line).errors[:url].first.should match(/已经被使用/)
	     end
     end
  end

   describe "DELETE 'destroy'" do
   	before{  @head_line = create :head_line }
  	it "returns http rediect" do
  	  request.env["HTTP_REFERER"] = admin_head_lines_path # for redicect :back
      expect{
        delete :destroy, :id => @head_line
      }.to change(HeadLine, :count).by(-1)
      expect(response).to redirect_to(admin_head_lines_path)
    end
  end
end
