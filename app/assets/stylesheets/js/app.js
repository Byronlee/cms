(function($) {

	//remove sticky fixed when screen size < 768
	var $window = $(window);

	function resize() {
	  if ($window.width() < 934) {
	      return $('.aside-social').removeClass('aside-fixed');
	  }
	  $('.aside-social').addClass('aside-fixed');
	 }
	 $window
	     .resize(resize)
	     .trigger('resize');

	//topbar scroll event
	$(document).on('scroll', function() {
	    if ($(this).scrollTop() > 40) {
	        $('.header-normal').addClass('scrolled');
	    }
	    else {
	        $('.header-normal').removeClass('scrolled');
	    }
	});

	//main nav dropdown menu
  if(window.matchMedia('(min-width: 768px)').matches) {
  	$('.drop').on('click', function(e) {
  		e.stopPropagation();
  		e.preventDefault();
  		$('.drop.active').not(this).removeClass('active');
    	$(this).toggleClass('active');
  	});
  }

  //main nav dropdown menu when screen size < 768
  $('.toggle__main').on('click', function(e) {
  	e.stopPropagation();
    $('.main-nav').toggleClass('active').siblings().removeClass('active');
  });

  $('.toggle__search').on('click', function(e) {
  	e.stopPropagation();
    $('.search').toggleClass('active').siblings().removeClass('active');
  });

  //social share actions
  $('.share-btn').on('click', function(e) {
  	e.stopPropagation();
    $('.single-post-social__popup').toggleClass('active').siblings().removeClass('active');
  });

  //sticky, offset = header height - 1
  $('.aside-fixed').scrollToFixed({
  	marginTop: $('.header').outerHeight() - 1,
  	dontCheckForPositionFixedSupport: true
  });


  //tabs
  $('.sidebar-tab').tabulous();

  //remove added class when scroll or chick everywhere else
  $('.dropdown__list, .panel').on('click', function(e) {
  	e.stopPropagation();
  });
  $(document).on('click', function() {
    deactivate();
  });
  $(document).on('keyup', function() {
    if( event.keyCode === 27 ) {
    	deactivate();
    }
  });
  $(document).on('scroll', function() {
  	$('.drop').removeClass('active');
  });

  function deactivate() {
  	$('.drop, .overlay, .single-post-social__popup').removeClass('active');
  	setTimeout(function() {
  		$('.login-section, .register-section').removeClass('fadeOut');
  		$('.login-section').removeClass('fadeInDown');
  		$('.register-section').removeClass('fadeInUp');
  	},300);
  }

  //open outside links in new window
  $("a[href*='http://']:not([href*='"+location.hostname+"']), [href*='https://']:not([href*='"+location.hostname+"'])")
  .addClass("external")
  .attr("target","_blank");

  //login popup window
  $('.overlay').magnificPopup({
  	mainClass: 'pop-in',
    removalDelay: 400,
    preloader: false,
    showCloseBtn: false,
    midClick: true
  });

  //login/regitser switch
  $('.login__register-btn').on('click', function() {
  	$('.login-section').removeClass('fadeInDown').addClass('fadeOut');
    setTimeout(function() {
    	$('.register-section').removeClass('fadeOut').addClass('fadeInUp');
    },200);
  });

  $('.register__login-btn').on('click', function() {
  	$('.register-section').removeClass('fadeInUp').addClass('fadeOut');
    setTimeout(function() {
    	$('.login-section').removeClass('fadeOut').addClass('fadeInDown');
    },200);
  });

  //like and fav actions
  $('.icon-heart, .icon-star').on('click', function() {
    $(this).addClass('active');
  });

  //Off focus page title change
  var title = document.title;
  var alttitle = "(·—·) | 36氪";
  window.onblur = function () { document.title = alttitle; };
  window.onfocus = function () { document.title = title; };

})(jQuery);
