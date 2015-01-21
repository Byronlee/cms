## 36krx2015

36krx2015(2015年36kr主站).

### System dependencies

* Ruby 2.2.0-p0
* Postgres
* Rails 4.1.6
* Nginx + Unicorn
* Faye
* Linux or vagrant for mac
* Sidekiq
* Redis
* Grape

### Configuration
```
  $ cp config/database.example.yml config/database.yml
```

### How to run the test suite
```
  $ rspec spec
```

## 如何运行该项目，有两种方案

### 方案一：本地安装所有以上的依赖环境，然后运行以下相关命令

```shell
  $ bundle install 
  $ rake db:create 
  $ rake db:migrate 
  $ rake db:seed 
  $ rails s 
```

### 方案二：使用Vagrant

> 提供的Vagrant镜像包已经包含系统所有依赖的环境，只需本地加载这个镜像包，项目就可以启动运行了。
 目前镜像已经存在的用户有vagrant 和 deploy 密码同用户名

```shell
  $ mkdir -p ~/workspace/source && cd ~/workspace
  $ vagrant box add 36kr ubuntu_tls_ruby_mongo_postgre_memcached_redis_nginx_node_els_img_faye_sidekiq_36kr_v2.box
  $ vagrant init 36kr
  $ vagrant up
  $ vagrant ssh 或者 ssh -p2222 deploy@localhost
```

#### 打开vagrant与host的端口映射

 在Vagrantfile文件里添加
```shell
  $ config.vm.network "forwarded_port", guest: 3000, host: 3000
```

#### 开启目录映射

 在Vagrantfile文件里添加
```shell
  $ config.vm.synced_folder "~/workspace/source/36krx2015", "/vagrant_data"
```

### 在vagrant里启动项目
```shell
  $ vagrant reload
  $ vagrant ssh 或者 ssh -p2222 vagrant@localhost
  $ cd /vagrant_data
  $ bundle install
  $ rake db:create
  $ rake db:migrate
  $ rake db:seed
  $ rails s
```

## Deployment instructions

使用Capistrano3 进行

#### 如果是初次部署:

* 产品环境
```shell
  $ bundle exec cap production deploy:create_database
  $ bundle exec cap production deploy
  $ bundle exec cap production deploy:rake_seed
  $ bundle exec cap production run_faye
```
* 开发环境
```shell
  $ bundle exec cap development deploy:create_database
  $ bundle exec cap development deploy
  $ bundle exec cap development deploy:rake_seed
  $ bundle exec cap development run_faye
```
#### 如果不是第一次运行以下命令即可:

* 产品环境
```shell
  ruby bundle exec cap production deploy
```
* 开发环境
```shell
  ruby bundle exec cap development deploy
```
## 其他

### API 文档

在浏览器里打开
```shell
  http://localhost:3000/api/doc
```
### Sidekiq Web 监控

在本地项目根目录
```shell
  $ bundle exec sidekiq -c config/sidekiq.yml
```
然后在浏览器访问
```shell
  http://localhost:3000/sidekiq
```
### Redis Web 监控

在本地项目根目录
```shell
  $ redis-stat --server
  $ redis-stat --verbose --server=8080 5

  # redis-stat server can be daemonized
  $ redis-stat --server --daemon

  # Kill the daemon
  $ killall -9 redis-stat-daemon
```
然后在浏览器访问
```shell
  http://localhost:8080/sidekiq
```
