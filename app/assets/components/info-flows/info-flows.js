//= require application/kr_storage

$.get('/components/info_flows', {}, function(info_flows){
  Polymer('info-flows', {
    ready: function(){
      this.posts_with_ads = info_flows['posts_with_ads'];
      this.totle_count = info_flows['totle_count'];
     }
  });
});
