var timer = 0;
$(window).on('scroll', function() {
  if(timer) {
    clearTimeout(timer);
    timer = 0;
  }
  var $scrollBtn =$('#J_gotop');

  timer = setTimeout(function() {
    if(window.scrollY < 100) {
      $scrollBtn.hide();
    }else{
      $scrollBtn.show();
    }
  }, 300);
});

$(function() {

 $(".pro-list1 ul li:last").addClass("noborder");
 $(".pro-list2 ul li:last").addClass("noborder");
 $(".pro-list3 ul li:last").addClass("noborder");




 //登录弹出框

  var  width1 = screen.width;
  var  height1 = screen.height;
  $(".tan-loginbox").css({"width":width1,"height":height1});



  $(".header-search button").click(function(){

    if($(".tan-loginbox").hasClass("open")){
         $(".tan-loginbox").removeClass("open");
      }
      else{
         $(".tan-loginbox").addClass("open");
      }
  })


//日历

    $(".tan-thismonth-box").css({"width":width1,"height":height1});

//值班日历弃用-2017-2-22
  /*$(".pro-cr .pro-duty .duty-info .more").click(function(){

    if($(".tan-thismonth-box").hasClass("open")){
         $(".tan-thismonth-box").removeClass("open");
      }
      else{
         $(".tan-thismonth-box").addClass("open");
      }
  })*/

$(".thismonth-close").click(function(){
   $(".tan-thismonth-box").removeClass("open");
})



//信息弹出页

/*$(".detailbox").css({"width":width1,"height":height1});*/

/*$(".gf-detail").css({"height":height1});
var height3 = $(".detail-contact .detail-title").height()+$(".detail-contact .time").height()+$(".detail-contact .juti").height()+1000;
$(".detail-contact").css({"height":height3});
*/

//二级导航


 //幻灯片元素与类“menu_body”段与类“menu_head”时点击
        /*$(".side-nav .nav-li").hover(function() {
            $(this).children(".side-dropdown").slideToggle(300).siblings(".side-dropdown").slideUp("slow");
            $(this).addClass("current");
            $(this).siblings().next(".side-dropdown").slideUp("slow").find(".side-dropdown-three").slideUp("slow");
            $(this).siblings().removeClass("current");
        
        });

        $(".side-nav dl dd").hover(function() {
            $(this).addClass("current").next(".side-dropdown-three").slideToggle(300);
            $(this).siblings("dd").next(".side-dropdown-three").slideUp("slow");
            $(this).siblings().removeClass("current");
             $(this).parent().siblings(".side-dropdown").slideUp("slow");


        });*/
         $(".side-dropdown-three li").hover(function() {
            $(this).addClass("current").siblings().removeClass("current");

        });




  

  $(".flexslider").flexslider({
    animation: "slide",
    directionNav: false,
    controlNav: true,
  });

  $(".flexslider1").flexslider({
    animation: "slide",
    directionNav: false,
    controlNav: true,
    slideshow:false,

  });

  $(".flexslider2").flexslider({
    animation: "slide",
    slideshow: false,
    directionNav: true,
    controlNav: false,

  });

  $(".flexslider4").flexslider({
    animation: "slide",
    directionNav: false,
    controlNav: true,
    slideshow:false,
  });

  $(".flexslider5").flexslider({
    animation: "slide",
    slideshow: false,
    directionNav: true,
    controlNav: false,
    itemWidth: 100,
    itemMargin: 0, 
    maxItems: 3

  });

  //change to sole
  $(".flex-btn a").click(function() {
    var index = $(this).index();
    $(this).addClass("current").siblings().removeClass("current");
    $(".pro-meeting-container .isf").hide().eq(index).show();
    $(".flexslider3").flexslider({
      animation: "slide",
      slideshow: false,
      directionNav: true,
      controlNav: false,
    });
  });
  // direction
  var $scrollBtnWap =  $('#J_duty-scroll');
  var $scrollWin= $scrollBtnWap.siblings('.wrap');
  var scrollWinH = $scrollWin.height();
  var $scrollElem = $scrollWin.children('ul');
  var scrollElemH = $scrollElem.height();

  $('#J_duty-scroll').on('click', function(e) {
    var $target = $(e.target);
    if(!($target.is('a'))|| $target.hasClass('disable')){
      return;
    }

    var direction = parseInt($target.attr('direction'));
    /^(-?\d*)px/i.exec($scrollElem.css('top') || '0px');
    var curTop = parseInt(RegExp.$1);
    var nextTop =direction * scrollWinH + curTop ;
    var $children = $(this).children();
     if(nextTop === 0) {
      $children.first().addClass('disable');
     } else{
       $children.first().removeClass('disable');
     }
     if(Math.abs(nextTop) + scrollWinH >= scrollElemH) {
      $children.last().addClass('disable');
     } else {
      $children.last().removeClass('disable');
     }
     $scrollElem.css('top', nextTop + 'px');
  });

  $('#J_qrcode').on('click', function() {
    $(this).siblings('div').toggle();
  });

//登录弹出框点击关闭
$(".login-box .close").click(function(){
  $(".tan-loginbox").removeClass("open");
});


//登录语言下拉
 $(".lang-default").click(function(){
            $(this).toggleClass("lang-select");
            $("ul.lang-list ").toggle();
            $("ul.lang-list li ").click(function(){
  
                $(".lang-default ").html($(this).text());
  
                $("ul.lang-list ").hide();
            })
        })

 //隐藏公告信息的底边框







  
//扫描二维码
/*$(".pro-header-tips .t1").hover(function(){
         $(this).children(".weixin-tan").slideToggle("slow");
    });
*/


    /*   $(".pro-header-tips .t4").hover(function(){
         $(this).children(".system-tanbox").slideToggle("slow");
    });

  
    $(".fixed-sys .t4").hover(function(){
         $(this).children(".system-tanbox").slideToggle("slow");
    });


    $(".pro-header-tips .t3").hover(function(){
         $(".pro-header-tips .link").slideToggle("slow");
        });
*/
});



    

    
 
    
 function ddd(){
 
    var body_scroll= document.documentElement.scrollTop || window.pageYOffset || document.body.scrollTop;


     if(body_scroll > 177){
     
         $(".pro-header ").addClass("pro-header-fixed ");
    } else{
      $(".pro-header ").removeClass("pro-header-fixed ");
    }
  }

  $(window).scroll(function(event){
      
            ddd();

        });


    