//= require application/kr_storage

$.get('/components/head_lines', {}, function(head_lines){
  Polymer('head-lines', {
    ready: function(){
      this.head_lines = head_lines;
      this.first_head_line = head_lines[0];
      this.rest_head_lines = head_lines.slice(1,5);
      for(var i = this.rest_head_lines.length; i < 4; i++){
        this.rest_head_lines.push({});
      }
     }
  });
});
