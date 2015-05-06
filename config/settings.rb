settings.site = 'http://36kr.com'
settings.writer = {
  host: 'http://writer.36kr.com/posts/new'
}
settings.url_code_begin = 33_000

settings.redis_servers = {
  cache: 'redis://127.0.0.1:6379/1',
  session: 'redis://127.0.0.1:6379/2'
}

settings.elasticsearch_server = 'http://staging.36kr.com:9200'

settings.api = {
  v1: {
    XToken: '501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je',
    token: '734dca654f1689f727cc:32710'
  },
  v2: {
    XToken: '501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je',
    api_key: '501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je'
  }
}

settings.oauth = {
  krypton: {
    app_id: '9767d4838b9664ca33a1630f6a7889d8b78a1dfd0bcf4b257a3c95122bf9ceaa',
    secret: 'e0df3c21ee500eaf85687357290f6c61878559f22eb0ce24c4ba3219c2666c07',
    host: 'https://passport.36kr.com',
    cookie: {
      name: 'krid_user_version',
      domain: '.36kr.com'
    }
  }
}

settings.next = {
  host: 'https://next.36kr.com/oauth/token',
  token_params: {
    grant_type: 'client_credentials',
    client_id: '32b4474696ff04185b62f78f1d9f6c1ecccd26551111eeb195864c2cf2b737aa',
    client_secret: 'e38e3ed327e7815c22ac49ffcd016209f2dc60e671d08f1e7e810d049e851130'
  },
  collection_api: 'https://next.36kr.com/api/v1/posts/collections'
}

# 读者, 运营, 作者, 编辑, 管理员, 投稿
settings.roles =  [:reader, :operator, :writer, :editor, :admin, :contributor]
settings.user_search_support = [['角色', 'role'], ['ID', 'id'], ['姓名', 'name'], ['电话', 'phone'], ['邮件', 'email'], ['sso_id', 'sso_id']]
settings.editable_roles =  [:operator, :writer, :editor, :admin]

settings.users = {
  invitation: {
    subject: '36氪：羊年 Duang 一下，我们给你准备好了更好的账号登录体验(需要您确认)',
    body: File.read(Rails.root.join('doc/mails/invitation.md'))
  }
}

settings.writer_update_role_api = 'http://writer.36kr.com/api/jHcDEyl/v1/users/update_role'

settings.writer_token = 'e625cf097bb338f1100b5453f68'

settings.writer_edit_path = ->(post) { "http://writer.36kr.com/posts/#{post.url_code}/#{post.key}/" }

settings.default_avatars = [
  'http://a.36krcnd.com/nil_class/48147b7f-5f11-4008-b09d-a3d22ee0a2cb/a-1.jpg.jpg',
  'http://a.36krcnd.com/nil_class/1897ffab-0a89-431e-9c80-81357507c321/a-2.jpg.jpg',
  'http://a.36krcnd.com/nil_class/77f40d6e-0834-47a6-b847-c7ff67160f27/h_main_KM3O_0fa60001f029111a.jpg'
]

settings.kr_messages_api = 'http://rong.36kr.com/api/message/count'

settings.post_views_count_cache = 100

settings.ga = {
  tracker: 'UA-1268479-12'
}

settings.fileupload = {
  url: 'http://writer.36kr.com/api/jHcDEyl/v1/images/create',
  token: 'e625cf097bb338f1100b5453f68',
  source: '36kr.com'
}

settings.favorite_beggin_time = '2015-03-28 23:59:59.000000'

settings.page_views = { persist: true }

settings.default_info_flow = '主站'

settings.site_map = { posts_count: 2000 }
