settings.oauth = {
  krypton: {
      app_id: "5b4d197b305ed7740e8f898505cd7c83f3fc85b21282d101b75eea772be92d62",
      secret: "31164e33cfba6d1fbef18e91728c592f455864967a8673b1f368b443d01a956c",
      host: "http://auth.36kr.com",
      cookie: {
          name: "krid_user_version",
          domain: "36kr.com"
      }
  }
}

settings.next = {
    host: "https://next.36kr.com/oauth/token",
    token_params: {grant_type: "client_credentials",
                   client_id: "32b4474696ff04185b62f78f1d9f6c1ecccd26551111eeb195864c2cf2b737aa",
                   client_secret: "e38e3ed327e7815c22ac49ffcd016209f2dc60e671d08f1e7e810d049e851130"
                  },
    collection_api: "https://next.36kr.com/api/v1/posts/collections"
}

# 读者, 运营, 作者, 编辑, 管理员, 投稿
settings.roles =  [:reader, :operator, :writer, :editor, :admin, :contributor]

settings.cookie = {
  domain: ".36kr.com"
}

settings.users = {
  invitation: {
    subject: "36氪：羊年 Duang 一下，我们给你准备好了更好的账号登录体验(需要您确认)",
    body: File.read(Rails.root.join("doc/mails/invitation.md"))
  }
}