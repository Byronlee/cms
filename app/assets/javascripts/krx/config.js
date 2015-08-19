window.KR_CONFIG_OBJECT = {
    fetchFeed: 'https://rong.36kr.com/api/hostsite/fetchFeeds',
    trackClipPage: function(id){
      $.post('/clipped/'+ id +'/touch_view', {
        'authenticity_token': window._token
      });
    },
    fetchNext: 'http://next.36kr.com/posts/latest.json',
    nextPageSize: 20
};