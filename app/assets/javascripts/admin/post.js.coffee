jQuery ->
  $('#post_source_type').change ->
    $('#post_source_urls').toggleClass('hide', $(this).val() == "original")
