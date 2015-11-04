module Admin::PostsHelper
  def display_state(state)
    case state
    when 'reviewing'
      raw "<span title='待审查' style='padding-right: 0;'><i class='fa fa-question'></i></span>"
    when 'published'
      raw "<span title='已发布'  style='padding-right: 0;'><i class='fa fa-check'></i></span>"
    else
      raw "<span title='错误状态'  style='padding-right: 0;'><i class='fa fa-remove'></i></span>"
    end
  end

  def personal_post_manage_path(current_user)
    return current_user.admin_post_manage_session_path if current_user.admin_post_manage_session_path.present?
    case current_user.role
    when 'reader'
      admin_favorites_path
    when 'operator'
      admin_posts_path
    when 'writer'
      myown_admin_posts_path
    when 'editor'
      admin_posts_path
    when 'admin'
      admin_posts_path
    when 'contributor'
      draft_admin_posts_path
    when 'investor'
      myown_admin_posts_path
    when 'investment'
      myown_admin_posts_path
    when 'entrepreneur'
      myown_admin_posts_path
    else
      admin_favorites_path
    end
  end
end
