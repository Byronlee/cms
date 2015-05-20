jQuery ->
  return unless $('table.post-columns').length

  $('form.column-selection').find(":radio").change ->
    console.log 'changed'
    $(this).closest('form').trigger('submit.rails')
  .end()
  .on "ajax:success", ->
    ;# $(this).fadeOut()
  .on "ajax:error", ->
    debugger