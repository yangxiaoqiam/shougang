/* ========================================================================
 * 万户补充类脚本: scroll-top.js
 * 用返回顶部
 * ========================================================================
 * Author: Shion.Phan
 * Site: http://www.joomla178.com
 * Github: https://github.com/shionphan
 * ======================================================================== */
+function($){
  'use strict';
  $.fn.scrollTotop = function (options,obj) {
    var defualts = {
      offsetFixed:300, /*滚动条距离顶部300时触发 show-fixed*/
      offsetTop:200, /*滚动条距离顶部200时触发 show-top*/
      duration:700 /*动画过程*/
    };
    var opts = $.extend({}, defualts, options);  
    var $element = $(this);

    $element.children('.btn-go-top').on('click', function(event){
      event.preventDefault();
      $('body,html').animate({
          scrollTop: 0 ,
        }, opts.duration
      );
    });

    $(window).scroll(function(){
      ($(this).scrollTop() > opts.offsetFixed ) ? $element.addClass('show-fixed') : $element.removeClass('show-fixed show-top');
      if( $(this).scrollTop() > opts.offsetTop ) {
        $element.addClass('show-top');
      }
    });
  }
}(jQuery);