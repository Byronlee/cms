//= require polymer/webcomponents
//= require jquery
//= require jquery_ujs
//= require_tree ./application

function imgError(image) {
  image.onerror = "";
  image.src = "/assets/img/girl.jpg";
  return true;
}

function toggleCommentForm(){
  var form = $("#commentForm");
  var v = form.css('display');
  if(!v || v == "none"){
    form.fadeIn();
    $("#toggleFormIcon").addClass("dropup");
  }
  else{
    form.fadeOut();
    $("#toggleFormIcon").removeClass("dropup")
  }
}

function getNormalList(obj, commentable_type, commentable_id){
  $.get("/"+ commentable_type +"/"+ commentable_id +"/comments/normal_list.js", function(data, status){
    if(status == "success"){
      $(obj).attr("onclick","toggleNormalComments()");
      toggleNormalComments();
    }
  });
}

function toggleNormalComments(){
  var normal_list = $("#comments-normal");
  var v = normal_list.css('display');
  if(!v || v == "none"){
    normal_list.fadeIn(function(){
      $("#toggleNormalComments").text($("#toggleNormalComments").text().replace("Expand", "Collapse"));
    });
  }
  else{
    normal_list.fadeOut(function(){
      $('#toggleNormalComments').text($("#toggleNormalComments").text().replace("Collapse", "Expand"));
    });
  }
}