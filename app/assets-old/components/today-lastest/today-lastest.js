//= require application/kr_storage

$.get('/components/posts/today_lastest', {}, function(result){
  Polymer('today-lastest', {
    ready: function(){
      if(result){
        this.posts = result[0].posts;
        this.posts_count = result[0].posts_count;
      }
      else{
        this.posts = [];
        this.posts_count = 0;
      }
     }
  });
});

