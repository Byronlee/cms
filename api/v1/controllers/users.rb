module V1
  module Controllers
    class Users < ::V1::Base
      KEYS = [:email, :phone]

      desc 'User Feature'
      resource :users do
        desc 'Get user detail'
        get ':id' do
          @user = User.find(params[:id])
          present @user, with: Entities::User
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

      end
    end
  end
end
