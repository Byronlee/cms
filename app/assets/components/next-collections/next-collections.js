// require application/kr_storage

 (function() {
    $.get('/components/next/collections', {}, function(result){

       Polymer('next-collections', {
         ready: function(){
           this.collections = result.slice(1, 13);
         }
      });

    })
})()
