//= require application/kr_storage

$.get('/components/posts/hot_posts', {}, function(posts){
  Polymer('hot-posts', {
    ready: function(){
      this.posts = posts;
     }
  });
});