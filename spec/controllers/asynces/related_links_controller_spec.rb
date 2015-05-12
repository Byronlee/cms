require 'spec_helper'

describe Asynces::RelatedLinksController do
  include Rails.application.routes.url_helpers
  login_user

  describe "GET 'get_metas_info'" do
    context "url is not valid" do
      it do
        get :get_metas_info, url: ''
        expect(response).to be_success
        expect(response.headers['content-type']).to eq 'application/json'

        response_data = JSON.parse response.body
        expect(response_data['result']).to eq false
        expect(response_data['msg']).to match(/不可为空/)
        expect(response_data['metas'].blank?).to eq true
      end

      it do
        get :get_metas_info, url: 'baidu.com'
        expect(response).to be_success
        expect(response.headers['content-type']).to eq 'application/json'

        response_data = JSON.parse response.body
        expect(response_data['result']).to eq false
        expect(response_data['metas'].blank?).to eq true
      end
    end

    context "url is valid" do
      before do
        response = double(body: File.read(File.expand_path('../../../factories/og.html', __FILE__)))
        RedirectFollower.stub(:new) { double(resolve: response) }
        get :get_metas_info, url: 'http://tv.36kr.com/playing/XOTM4NTQzMzEy'
      end
      it do
        expect(response).to be_success
        expect(response.headers['content-type']).to eq 'application/json'

        response_data = JSON.parse response.body
        expect(response_data['result']).to eq true
        expect(response_data['msg'].blank?).to eq true
        expect(response_data['metas'].present?).to eq true
        expect(response_data['metas']['title']).to eq '装进背包里的智能吉他：Jamstik+'
        expect(response_data['metas']['type']).to eq 'video.movie'
        expect(response_data['metas']['description']).to eq '优酷播放地址关于Jamstik+的更多信息，点击进入查看。欢迎关注氪 TV 的微信号“krvideo”，以及优酷频道，第一时间收看更多有趣的科技视频。'
        expect(response_data['metas']['image']).to eq 'http://a.36krcnd.com/nil_class/fb580571-f578-4f54-8417-5ff6bfdc8b6a/800.jpg'
        expect(response_data['metas']['video']).to eq 'http://krtv.qiniudn.com/150506_zhuchao.mp4'
        expect(response_data['metas']['video_duration'].to_i).to eq 59
      end
    end
  end
end
