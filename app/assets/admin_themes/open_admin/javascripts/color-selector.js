function changeForInput(input_id, selector_id){
  document.getElementById(selector_id).value = document.getElementById(input_id).value;
}

function changeForSelector(selector_id, input_id){
  document.getElementById(input_id).value = document.getElementById(selector_id).value;
}
