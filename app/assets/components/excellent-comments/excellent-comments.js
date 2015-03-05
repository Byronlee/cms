//= require application/kr_storage

$.get('/components/comments', {}, function(comments){
  Polymer('excellent-comments', {
    ready: function(){
      this.comments = comments;
     }
  });
});