require 'spec_helper'

describe 'Routing' do
	include Rails.application.routes.url_helpers

  describe 'Welcome Controller', :type => :routing do
  	context '#changes' do
  		it { expect(:get => '/changes').to route_to(controller: 'welcome', action: 'changes') }
  	end

  	context '#archive' do
  		it { expect(:get => '/2015').to route_to(controller: 'welcome', action: 'archives', year: '2015') }
  		it { expect(:get => '/2015/04').to route_to(controller: 'welcome', action: 'archives', year: '2015', month: '04') }
  		it { expect(:get => '/2015/04/20').to route_to(controller: 'welcome', action: 'archives', year: '2015', month: '04', day: '20') }
  	end
  end
  
end