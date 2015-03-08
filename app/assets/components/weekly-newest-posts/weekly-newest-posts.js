//= require application/kr_storage

$.get('/components/posts/weekly_hot', {}, function(posts){
  Polymer('weekly-newest-posts', {
    ready: function(){
      this.posts = posts;
     }
  });
});
