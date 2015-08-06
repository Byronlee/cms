module V2
  module Controllers
    class Subsites < ::V2::Base
      KEYS = [:id, :title, :created_at, :updated_at, :summary, :content,:title_link,
        :must_read, :slug, :state, :draft_key, :cover, :user_id, :source,
        :column_id, :remark, :tag_list, :published_at]

      desc 'Subsites Feature'
      resource :subsites do

      	# Create a new post
        desc 'create a new post'
        params do
          requires :title,     type: String,   desc: '标题'
          requires :content,   type: String,   desc: '内容'
          requires :uid,       type: Integer,  desc: '用户SSO_ID'
          requires :column_id, type: Integer,  desc: '专栏id'
          optional :cover,     type: String,   desc: '图片封面url'
          optional :remark,    type: String,   desc: '备注'
          optional :state,     type: String,   default: 'published', desc: '文章状态'
          optional :published_at, type:Date,   default:Time.now
        end
        post 'krspace/new' do
          post_params = params.slice(*KEYS)
          site  = Site.find_by_name('氪空间')
          auth = Authentication.where(uid: params[:uid].to_s).first
          if auth.blank?
          	return { status: false, msg: '用户无效,请登录网站激活用户 !' }
          elsif auth.user.role.eql?('admin') or site.admin.krypton_authentication.uid == params[:uid]
            post_params.merge!(user_id: auth.user.id)
          else
          	return { status: false, msg: '你没权限写文章!' }
          end
          @post = Post.new post_params
          return { status: false, msg: @post.errors.full_messages }  unless @post.save
          return { status: true,
            data: { key: @post.key, published_id: @post.url_code, state: @post.state },
            review_url: "#{Settings.subsite}/blog/#{@post.url_code}.html",
            admin_edit_post_url: admin_edit_post_url(@post, auth) }
        end

        # Update a post
        desc 'update a post'
        params do
          requires :id, desc: '编号'
          requires :title,     type: String,   desc: '标题'
          requires :content,   type: String,   desc: '内容'
          requires :uid,       type: Integer,  desc: '用户SSO_ID'
          requires :column_id, type: Integer,  desc: '专栏id'
          optional :cover,     type: String,   desc: '图片封面url'
          optional :remark,    type: String,   desc: '备注'
          optional :state,     type: String,   default: 'published', desc: '文章状态'
          optional :published_at, type:Date,   default:Time.now
        end
        patch 'krspace/:id' do
          post_params = params.slice(*KEYS)
          @post = Post.find(params[:id])
          auth = Authentication.where(uid: params[:uid].to_s).first
          if auth.blank?
          	return { status: false, msg: '用户无效,请登录网站激活用户 !' }
          elsif auth.user.role.eql?('admin') or site.admin.krypton_authentication.uid == params[:uid]
            post_params.merge!(user_id: auth.user.id)
          else
          	return { status: false, msg: '你没权限写文章!' }
          end
          @post.assign_attributes(post_params)
          return { status: false, msg: @post.errors.full_messages }  unless @post.save
          return { status: true,
            data: { key: @post.key, published_id: @post.url_code, state: @post.state },
            review_url: "#{Settings.subsite}/blog/#{@post.url_code}.html",
            admin_edit_post_url: admin_edit_post_url(@post, auth) }
        end

      end

    end
  end
end