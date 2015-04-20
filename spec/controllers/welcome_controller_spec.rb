require 'spec_helper'

describe WelcomeController do
  describe "GET 'index'" do
    before { get :index }
    it { should respond_with(:success) }
  end

  describe "GET 'changes'" do
    before { get :changes}
    it { should respond_with(:success) }
  end
end
