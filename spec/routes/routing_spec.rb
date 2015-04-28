require 'spec_helper'

describe 'Routing' do
  include Rails.application.routes.url_helpers

  describe 'Welcome Controller', :type => :routing do
    context '#changes' do
      it { expect(get: '/changes').to route_to(controller: 'welcome', action: 'changes') }
    end

    context '#archive' do
      it { expect(get: '/2015').to route_to(controller: 'welcome', action: 'archives', year: '2015') }
      it { expect(get: '/2015/04').to route_to(controller: 'welcome', action: 'archives', year: '2015', month: '04') }
      it { expect(get: '/2015/04/20').to route_to(controller: 'welcome', action: 'archives', year: '2015', month: '04', day: '20') }
    end

    context '#site_map' do
      it{ expect(get: 'api/site_map.xml').to route_to(controller: 'welcome', action: 'site_map', format: 'xml') }
    end
  end

  describe 'Newsflashes Controller', :type => :routing do
    context '#index' do
      it { expect(get: '/clipped/2015/04/20').to route_to(controller: 'newsflashes', action: 'index', year: '2015', month: '04', day: '20') }
      it { expect(get: '/clipped/1234').to route_to(controller: 'newsflashes', action: 'show', id: '1234') }
    end
  end

  describe 'Posts Controller', :type => :routing do
    context '#bdnews' do
      it { expect(get: '/baidu/1234').to route_to(controller: 'posts', action: 'bdnews', url_code: '1234') }
    end
  end
  
end