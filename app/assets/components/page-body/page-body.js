 Polymer('page-body', {
   ready: function(){
      _this = this;
     $.get('/components/pages/show', {id: this.page_id}, function(result){
         _this.page_body = result.body
     });
   }
});