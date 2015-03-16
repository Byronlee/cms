# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( admin.css admin.js )
Rails.application.config.assets.precompile += %w( matrix_admin/matrix_admin.css matrix_admin/matrix_admin.js
                                                  ScrollToFixed/jquery-scrolltofixed-min.js
                                                  respond/dest/respond.min.js
                                                  lazyloadxt/dist/jquery.lazyloadxt.min.js
                                                  opensans/OpenSansLight.woff
                                                  opensans/OpenSans.woff
                                                  opensans/OpenSansBold.woff
                                                  36kr/36kr.eot
                                                  36kr/36kr.svg
                                                  36kr/36kr.ttf
                                                  36kr/36kr.woff
                                                  ladda/dist/ladda.min.js
                                                  ladda/dist/spin.min.js
                                                  magnific-popup/dist/jquery.magnific-popup.min.js
                                                  app.js )
