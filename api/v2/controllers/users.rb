module V2
  module Controllers
    class Users < ::V2::Base
      KEYS = [:name, :phone, :email, :bio, :tagline, :avatar_url]

      desc 'User Feature'
      resource :users do

        desc 'use sso access token exchange authentication token'
        params do
          optional :sso_token, type: String, desc: 'sso_token'
        end
        get 'token' do
          present current_user, with: Entities::User
        end

        desc 'Get user name list'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        post 'fixname' do
          @user = User.where.not(sso_id: nil).order('created_at desc').page(params[:page]).per(params[:per_page])
          names= []
           @user.each do |user|
            names << { sso_id: user.sso_id, fix_name: user.name } #, token: user.krypton_authentication.raw[:credentials][:token] }
           end
           names
        end

        desc 'Get user detail for id'
        get ':id' do
          @user = User.where(id: params[:id]).first
          not_found! if @user.blank?
          #cache(key: "api:v2:users:#{params[:id]}", etag: @user.updated_at, expires_in: Settings.api.expires_in) do
            present @user, with: Entities::User
          #end
        end

        desc 'Get user detail for sso_id'
        get 'sso/:id' do
          @user = User.where(sso_id: params[:id]).first
          not_found! if @user.blank?
          #cache(key: "api:v2:users:#{params[:id]}", etag: @user.updated_at, expires_in: Settings.api.expires_in) do
            present @user, with: Entities::UserDetail
          #end
        end

        desc 'Get admin user list'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        post 'editor' do
          roles = Settings.editable_roles.map(&:to_s) << 'contributor'
          @users = User.where(role: roles).includes(:krypton_authentication)
          .order('created_at desc').page(params[:page]).per(params[:per_page])
          #cache(key: "api:v2:users:editor", etag: Time.now, expires_in: Settings.api.expires_in) do
            present @users, with: Entities::UserDetail
          #end
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

=begin
        desc 'update a user'
        params do
          requires :sso_id,                   desc: 'sso_id'
          requires :name,     type: String,   desc: '用户名'
          requires :phone,    type: String,   desc: '电话'
          requires :bio,      type: String,   desc: '三观'
          requires :tagline,  type: String,   desc: '自述'
        end
        post 'sso' do
          user_params = params.slice(*KEYS)
          @user = User.where(sso_id: params[:sso_id]).first
          unless @user.blank?
            @user.update_attributes user_params
            @user.errors.messages.blank? ? { date: true } : { date: false }
          else
            { date: false }
          end
        end
=end
      end
    end
  end
end
