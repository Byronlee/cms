module V1
  module Controllers
    class Users < ::V1::Base
      KEYS = [:name, :phone, :email, :bio, :tagline, :avatar_url]

      desc 'User Feature'
      resource :users do

        desc 'use sso access token exchange authentication token'
        params do
          optional :sso_token, type: String, desc: 'sso_token'
        end
        get 'token' do
          users = init_and_exchange_token
          present users[0], with: Entities::User
        end

        desc 'Get user detail'
        get ':id' do
          @user = User.where(id: params[:id]).first
          not_found! if @user.blank?
          cache(key: "api:v1:users:#{@user.id}", etag: @user.updated_at, expires_in: Settings.api.expires_in) do
            present @user, with: Entities::User
          end
        end

        desc 'Get admin user list'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        post 'editor' do
          roles = Settings.editable_roles.map(&:to_s) << 'contributor'
          @user = User.where(role: roles)
          .order('created_at desc').page(params[:page]).per(params[:per_page])
          present @user, with: Entities::User
        end

        desc 'Create a new user'
        params do
          optional :name, type: String, desc: '姓名'
          optional :email, type: String, desc: '邮箱'
          optional :bio, type: String, desc: '自我介绍'
          optional :tagline, type: String, desc: '座右铭'
          optional :avatar_url, type: String, desc: '头像url'
        end
        post 'new' do
          user_params = params.slice(*KEYS)
          @user = User.new user_params.merge!({password: 'VEX60gCF'})
          if @user.save
            present @user, with: Entities::User
          else
            error!({ error: @user.errors.full_messages }, 400)
          end
        end

      end
    end
  end
end
