 Polymer('post-body', {
   ready: function(){
      _this = this;
     $.get('/components/posts/show', {id: this.post_id}, function(result){
         _this.post_body = result.content
     });
   }
});