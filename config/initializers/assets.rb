# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( admin.js
                                                  admin.css
                                                  footer.js
                                                  sass/style.scss
                                                  krx/index.css
                                                  krx/search-result.css
                                                  krx/article.css
                                                  krx/format.css
                                                  krx/fast-section-detail.css
                                                  krx/pages.css)

Rails.application.config.assets.precompile += %w( vender/html5shiv/dist/html5shiv.js
                                                  vender/ScrollToFixed/jquery-scrolltofixed-min.js
                                                  vender/tabulous/tabulous.min.js
                                                  vender/respond/dest/respond.min.js
                                                  vender/lazyloadxt/dist/jquery.lazyloadxt.min.js
                                                  vender/ladda/dist/spin.min.js
                                                  vender/ladda/dist/ladda.min.js
                                                  vender/magnific-popup/dist/jquery.magnific-popup.min.js
                                                  vender/widearea/minified/widearea.min.js
                                                  js/app.js
                                                  krx/index.js
                                                  krx/article.js
                                                  krx/search-result.js
                                                  krx/fast-section-detail.js)
