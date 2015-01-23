//= require application/kr_storage
$.get('/admin/headlines/top_items', {}, function(headlines){ 
   var head_infos = [];
   $.each(headlines, function( index, headline ) {
     $.get(headline.url, function(ret) {
     	metas = $(ret).filter('meta');

        head_infos.push({
       	"title": find_by_name(metas, 'og:title'),
       	"url": find_by_name(metas, 'og:url'),
       	"type": find_by_name(metas, 'og:type'),
       	"image": find_by_name(metas, 'og:image'),
       	"is_display_title": find_by_name(metas, 'og:image:is_display_title'),
       	"order_num": headline.order_num
       });

       if( index + 1 == headlines.length)

       	   Polymer('head-lines', {
            ready: function(){
               collections = head_infos.sort(function(a,b){
                  return (a.order_num < b.order_num) ? 1 : -1;
   	           });
               this.first_headline = collections[0];
               this.rest_headlines = collections.slice(1,4)
       	   }
       });
     });
   });
});

function find_by_name(items, name){ 
   var value = undefined;
   $.each(items, function( index, item ) {
      if(item && item.attributes["property"] && item.attributes["property"]["value"] == name){
      	   value =  item.attributes["content"]["value"].toString();
      }
   });
   return value;
}

