//= require jquery
//= require jquery_ujs

function goSearch(formname)
{
  var url = "http://www.baidu.com/baidu";
  formname.method = "get";
  document.search_baidu.word.value = document.search_baidu.word_display.value + " site:36kr.com";
  formname.action = url;
  return true;
}