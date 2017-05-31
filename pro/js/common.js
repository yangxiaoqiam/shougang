
//首页新闻切换
function a(x)
{
	for(var i=1; i<7; i++ )
	{
		$("#boa"+i).css("display", "none");//关闭
		$("#a"+i).removeClass("tit_1");//关闭
		$("#a"+i).addClass("tit_2");//打开
	}
	$("#boa"+x).css("display","block");//打开
	$("#a"+x).removeClass("tit_2");
	$("#a"+x).addClass("tit_1");
	}
	


$(document).ready(function(){
  $("#cc1").click(function(){
    $("#boa3").css("display","none");
  });
});




//产品中心
$(function(){
	jQuery(".course").slide({
		effect:"leftMarquee",
		/*effect:"leftMarquee",*/
		mainCell:".course_list ul",
		autoPlay:true,          
		interTime:50,   
		vis:4, prevCell:".prev",nextCell:".next",
		easing:"swing",
		trigger:'mouseover' 
		})
	})
	
	//产品中心
$(function(){
	jQuery(".books_a").slide({
		effect:"leftMarquee",
		/*effect:"leftMarquee",*/
		mainCell:".books_a_list ul",
		autoPlay:true,          
		interTime:50,   
		vis:4, prevCell:".prev",nextCell:".next",
		easing:"swing",
		trigger:'mouseover' 
		})
	})
	
	
	
//优秀学员
$(function(){
	jQuery(".std").slide({
		effect:"leftMarquee",
		/*effect:"leftMarquee",*/
		mainCell:".std_list ul",
		autoPlay:true,          
		interTime:50,   
		vis:4, prevCell:".prev",nextCell:".next",
		easing:"swing",
		trigger:'mouseover' 
		})
	})
	
	
	//名师风采
$(function(){
	jQuery(".tch").slide({
		effect:"leftLoop",
		/*effect:"leftMarquee",*/
		mainCell:".tch_list ul",
		autoPlay:true,          
		interTime:3000,   
		vis:5, prevCell:".prev",nextCell:".next",
		easing:"swing",
		trigger:'mouseover' 
		})
	})
	
	

//导航选中
function setParmsValue(parm, parmsValue) {  
       }    
    $(function(){  
       var spans= $(".nav ul li").click(function(){  
            $(this).addClass("on");  
            $(this).siblings().removeClass("on");           
        });  
    });  







$(function(){
	
	$("a").focus(function(){this.blur();});
	
	 
$(".search .icon").click(function(){
  $(".SearchBox").slideToggle();
});//search top

//
	var offset = 300,
		offset_opacity = 1200,
		scroll_top_duration = 700,
		$back_to_top = $('.cd-top');

	$(window).scroll(function(){
		( $(this).scrollTop() > offset ) ? $back_to_top.addClass('cd-is-visible') : $back_to_top.removeClass('cd-is-visible');
	});
	$back_to_top.on('click', function(event){
		event.preventDefault();
		$('body,html').animate({
			scrollTop: 0 ,
		 	}, scroll_top_duration
		);
	});//返回顶部
		
})





$(function(){$("a").focus(function(){this.blur();});});//去除链接虚线

function SetHome(obj,vrl){ 
try{ 
obj.style.behavior='url(#default#homepage)';obj.setHomePage(vrl); 
} 
catch(e){ 
if(window.netscape) { 
try { 
netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect"); 
} 
catch (e) { 
alert("此操作被浏览器拒绝！\n请在浏览器地址栏输入“about:config”并回车\n然后将 [signed.applets.codebase_principal_support]的值设置为'true',双击即可。"); 
} 
var prefs = Components.classes['@mozilla.org/preferences-service;1'].getService(Components.interfaces.nsIPrefBranch); 
prefs.setCharPref('browser.startup.homepage',vrl); 
}else{ 
alert("您的浏览器不支持，请按照下面步骤操作：1.打开浏览器设置。2.点击设置网页。3.输入："+vrl+"点击确定。"); 
} 
} 
} 
// 加入收藏 兼容360和IE6 
function shoucang(sTitle,sURL) 
{ 
try 
{ 
window.external.addFavorite(sURL, sTitle); 
} 
catch (e) 
{ 
try 
{ 
window.sidebar.addPanel(sTitle, sURL, ""); 
} 
catch (e) 
{ 
alert("加入收藏失败，请使用Ctrl+D进行添加"); 
} 
} 
} //e

//
var speed=50; 
var tab=document.getElementById("demo"); 
var tab1=document.getElementById("demo1"); 
var tab2=document.getElementById("demo2"); 
tab2.innerHTML=tab1.innerHTML; 
function Marquee(){ 
if(tab2.offsetWidth-tab.scrollLeft<=0) 
tab.scrollLeft-=tab1.offsetWidth 
else{ 
tab.scrollLeft++; 
} 
} 
var MyMar=setInterval(Marquee,speed); 
tab.onmouseover=function() {clearInterval(MyMar)}; 
tab.onmouseout=function() {MyMar=setInterval(Marquee,speed)}; 
//


//banner





