require 'spec_helper'

describe Admin::ColumnsController do

  describe "GET 'index'" do
    it "returns http success" do
      column = Column.create({:name => 'test', :introduce => 'hello, this is just for test.'})
      get 'index'
      response.should be_success
      expect(response).to render_template(:admin)
      expect(assigns(:columns)).to eq([column])
    end
  end

  describe "PATCH 'update'" do
  	before(:each) do
  	  @column = Column.create({:name => 'test', :introduce => 'hello, this is just for test.'})
  	end
  	
  	it "returns http rediect" do
      patch :update, id:@column, column: {:name => "test2"}
      expect(response.status).to eq(302)
      @column.reload.name.should == 'test2'
      expect(response).to redirect_to(admin_columns_path)
    end

     it "returns back for name and introduce being necessary" do
      patch :update, id:@column, column: {:name => nil, :introduce => nil}
      assigns(:column).errors.empty?.should_not be_true
      assigns(:column).errors[:name].empty?.should_not be_true
      assigns(:column).errors[:introduce].empty?.should_not be_true
    
      assigns(:column).errors[:name].first.should match(/不能为空字符/)
      assigns(:column).errors[:introduce].first.should match(/不能为空字符/)
    end

    it "returns back for name and introduce being to long" do
      patch :update, id:@column, column: {:name => 'a' * 11, :introduce => 'a' * 141}
      assigns(:column).errors.empty?.should_not be_true
      assigns(:column).errors[:name].empty?.should_not be_true
      assigns(:column).errors[:introduce].empty?.should_not be_true
    
      assigns(:column).errors[:name].first.should match(/过长/)
      assigns(:column).errors[:introduce].first.should match(/过长/)
    end
  end

   describe "POST 'create'" do
  	it "returns http rediect" do
      post 'create', :column => {:name => 'test', :introduce => 'hello, this is just for test.'}
      expect(response.status).to eq(302)
      expect(response).to redirect_to(admin_columns_path)
    end

    it "returns back for name and introduce being necessary" do
      post 'create', :column => {:name => nil, :introduce => nil}
      assigns(:column).errors.empty?.should_not be_true
      assigns(:column).errors[:name].empty?.should_not be_true
      assigns(:column).errors[:introduce].empty?.should_not be_true
    
      assigns(:column).errors[:name].first.should match(/不能为空字符/)
      assigns(:column).errors[:introduce].first.should match(/不能为空字符/)
    end

    it "returns back for name and introduce being to long" do
      post 'create', :column => {:name => 'a' * 11, :introduce => 'a' * 141}
      assigns(:column).errors.empty?.should_not be_true
      assigns(:column).errors[:name].empty?.should_not be_true
      assigns(:column).errors[:introduce].empty?.should_not be_true
    
      assigns(:column).errors[:name].first.should match(/过长/)
      assigns(:column).errors[:introduce].first.should match(/过长/)
    end
  end

  describe "DELETE 'destroy'" do
  	it "returns http rediect" do
  	  request.env["HTTP_REFERER"] = admin_columns_path # for redicect :back
	  @column = Column.create({:name => 'test', :introduce => 'hello, this is just for test.'})
      expect{ 
        delete :destroy, :id => @column
      }.to change(Column, :count).by(-1)
      expect(response).to redirect_to(admin_columns_path)
    end
  end

end