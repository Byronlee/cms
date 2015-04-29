require 'spec_helper'

describe API::API do
  include ApiHelpers

  describe 'POST /api/v2/posts/new.json' do

    context 'invalide params' do
      it 'post_type invalide should return msg: 所传参数不合法' do
        post_params = attributes_for(:post)
        post_params = post_params.merge(post_type: 'xxoo', uid: 478, column_id: 1)
        post '/api/v2/posts/new.json?api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je', post_params
        expect(JSON.parse(response.body)['msg']).to eq('所传参数不合法!')
      end

      it 'user_id invalide should return msg: 用户无效,请登录网站激活用户 ' do
        post_params = attributes_for(:post)
        post_params = post_params.merge(post_type: 'draft', uid: 478, column_id: 1)
        post '/api/v2/posts/new.json?api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je', post_params
        expect(JSON.parse(response.body)['msg']).to eq('用户无效,请登录网站激活用户 !')
      end
    end

    context 'with post_type is draft' do
      it 'with post_type is draft should return a post with state is draft' do
        post_params = attributes_for(:post)
        auth = create :authentication
        post_params = post_params.merge(post_type: 'draft', uid: auth.uid, column_id: 1)
        post '/api/v2/posts/new.json?api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je', post_params
        expect(JSON.parse(response.body)['status']).to be_true
        expect(JSON.parse(response.body)['data']['state']).to eql('drafted')
      end
    end

    context 'with post_type is post' do

      context 'when user can pubish' do
        it 'should return a post with state is publish' do
          post_params = attributes_for(:post)
          auth = create :authentication
          auth.user.update(role: 'admin')
          post_params = post_params.merge(post_type: 'post', uid: auth.uid, column_id: 1)
          post '/api/v2/posts/new.json?api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je', post_params
          expect(JSON.parse(response.body)['status']).to be_true
          expect(JSON.parse(response.body)['data']['state']).to eql('published')
        end
      end

      context 'when user can not publish' do
        it 'should return a post with state is reviewing' do
          post_params = attributes_for(:post)
          auth = create :authentication
          auth.user.update(role: 'reader')
          post_params = post_params.merge(post_type: 'post', uid: auth.uid, column_id: 1)
          post '/api/v2/posts/new.json?api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je', post_params
          expect(JSON.parse(response.body)['status']).to be_true
          expect(JSON.parse(response.body)['data']['state']).to eql('reviewing')
        end
      end
    end
  end

  describe 'PATCH /api/v2/posts/id.json' do

    context 'invalide params' do
      it 'param`s post_type invalide should return msg: 所传参数不合法' do
      end
    end

    context 'update post with state is draft' do
      before(:each) do
        auth = create :authentication
        @post = create :post, user_id: auth.user.id
      end

      it 'and param`s post_type is draft should return the post with state is draft' do
        post_params = attributes_for(:post)
        post_params = post_params.merge(post_type: 'draft', column_id: 1)
        patch "/api/v2/posts/#{@post.id}.json?api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je", post_params
        expect(JSON.parse(response.body)['status']).to be_true
        expect(JSON.parse(response.body)['data']['state']).to eql('drafted')
      end

      context 'and with param`s post_type is post' do
        it 'when use can pubish should return the post with state is publish' do
          post_params = attributes_for(:post)
          post_params = post_params.merge(post_type: 'post', column_id: 1)
          @post.author.update_attributes(role: 'admin')
          patch "/api/v2/posts/#{@post.id}.json?api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je", post_params
          expect(JSON.parse(response.body)['status']).to be_true
          expect(JSON.parse(response.body)['data']['state']).to eql('published')
        end

        it 'when use cannot pubish should return the post with state is reviewing' do
          post_params = attributes_for(:post)
          post_params = post_params.merge(post_type: 'post', column_id: 1)
          @post.author.update_attributes(role: 'reader')
          patch "/api/v2/posts/#{@post.id}.json?api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je", post_params
          expect(JSON.parse(response.body)['status']).to be_true
          expect(JSON.parse(response.body)['data']['state']).to eql('reviewing')
        end
      end
    end

    context 'update post' do
      before(:each) do
        @auth = create :authentication
      end

      context 'with state is reviewing' do
        it 'param`s post_type must is post' do
        end

        it 'should return the post state is reviewing' do
          @post = create :post, user_id: @auth.user.id, state: 'reviewing'
          post_params = attributes_for(:post)
          post_params = post_params.merge(post_type: 'post', column_id: 1)
          patch "/api/v2/posts/#{@post.id}.json?api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je", post_params
          expect(JSON.parse(response.body)['status']).to be_true
          expect(JSON.parse(response.body)['data']['state']).to eql('reviewing')
        end
      end

      context 'with state is publish' do
        it 'param`s post_type must is post' do
        end

        it 'should return the post state is pubish' do
          @post = create :post, user_id: @auth.user.id, state: 'published', published_at: Time.now
          post_params = attributes_for(:post)
          post_params = post_params.merge(post_type: 'post', column_id: 1)
          patch "/api/v2/posts/#{@post.id}.json?api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je", post_params
          expect(JSON.parse(response.body)['status']).to be_true
          expect(JSON.parse(response.body)['data']['state']).to eql('published')
        end
      end
    end
  end

  describe "Test access token" do
    it "return 401" do
      get "/api/v2/posts/index.json?api_key=xxoo"
      response.status.should == 401
    end
  end

  describe "GET /api/v2/posts/index.json" do
    it "should return an array of posts" do
      get "/api/v2/posts/index.json?api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je"
      response.status.should == 200
      json_response.should be_an Array
    end
  end

  describe "GET /api/v2/posts/:id" do
      it "should return array size 30" do
        post = create :post, url_code: 1 ,user_id: 1, state: 'published', published_at: Time.now
        get "/api/v2/posts/#{post.url_code}.json?api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je"
        response.status.should == 200
      end
  end


end
