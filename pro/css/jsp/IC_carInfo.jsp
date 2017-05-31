<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/public/include/init.jsp"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="zh-cn" class="theme-blue theme-blue-pure size-big">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <base url="defaultroot">
    <title>信息详情页</title>
    <link rel="stylesheet" href="template/css/template_system/template.fa.min.css" />
    <link rel="stylesheet" href="template/css/template_system/template.reset.min.css" />
    <link rel="stylesheet" href="template/css/template.bootstrap.min.css" />
    <link rel="stylesheet" href="template/css/template_default/template.media.min.css" />
    <link rel="stylesheet" href="template/css/template_default/themes/2016/template.theme.media.min.css" />
    <script type="text/javascript" src="scripts/plugins/jquery/jquery.min.js"></script>
    <script type="text/javascript" src="scripts/static/template.js"></script>
    <script type="text/javascript" src="scripts/static/template.custom.js"></script>
    <script type="text/javascript" src="scripts/static/template.extend.js"></script>
    <script type="text/javascript" src="scripts/plugins/zTree_v3/jquery.ztree.core-3.5.js"></script>
    <script type="text/javascript" src="scripts/pagejs/view-frame.js?v=20160307"></script>
    <!--add  css  -->
    <link rel="stylesheet" type="text/css" href="pro/css/onecard.css">
</head>
<%
String nowDay=request.getAttribute("nowDay")==null?"":request.getAttribute("nowDay").toString();
String previousDay = request.getAttribute("previousDay")==null?"":request.getAttribute("previousDay").toString();
String nextDay = request.getAttribute("nextDay")==null?"":request.getAttribute("nextDay").toString();
%>
<body>
 <form name="dataForm" id="dataForm" action="/defaultroot/ICCardAction!getCarInfo.action" method="post" >
<input name="nowDay" id="nowDay" type="hidden" value="<%=nowDay%>"/>
<input name="previousDay" id="previousDay" type="hidden" value="<%=previousDay%>"/>
<input name="nextDay" id="nextDay" type="hidden" value="<%=nextDay%>"/>
    
    <div class="car-tan car-a" id="hascar">
		
        <div class="tab-title">
            <a class="title-a" onclick="changeDay('-1')" ><i class="fa fa-angle-left"></i>前一天</a>
            <a class="title-b" onclick="changeDay('1')" ><i class="fa fa-angle-right"></i>后一天</a>
        </div>
        <div class="tab-box" >
            <div class="week"><span id="nowDay2"></span><span id="week1"></span>&nbsp;&nbsp;&nbsp;&nbsp;<span id="lunar1"></span></div>
            <div class="part part-bluebg">
                <strong>回京：</strong>
                <p id="hj"></p>
            </div>
            <div class="part">
                <strong><span>迁安</span><img src="images/ver113/shougang/jiantou.png"><span> 莲花桥</span><img src="images/ver113/shougang/jiantou.png"><span>古城</span><img src="images/ver113/shougang/jiantou.png"><span>厂东门</span> </strong>
                <p>四班：迁钢小区西门 &nbsp; 10:00</p>
				<p>常白班：办公中心 &nbsp; 12:45</p>
            </div>
            <div class="part">
                <strong class="red">B车</strong>
                <strong><span>迁安</span><img src="images/ver113/shougang/jiantou.png"><span> 狼垡</span><img src="images/ver113/shougang/jiantou.png"><span>王四营(盛华宏林粮油批发市场)</span><img src="images/ver113/shougang/jiantou.png"><span>厂东门</span> </strong>
               <p>四班：迁钢小区西门 &nbsp; 10:00</p>
			   <p>常白班：办公中心 &nbsp; 12:45</p>
            </div>
            <div class="part">
               <strong><span>迁安</span><img src="images/ver113/shougang/jiantou.png"><span> 六元桥下(西杜兰庄)</span><img src="images/ver113/shougang/jiantou.png"><span>门头沟龙泉花园</span> </strong>
               <p>四班：迁钢小区西门 &nbsp; 10:00</p>
            </div>
            <div class="part">
                <strong class="red">第一，第二批次E车;第三批次D车</strong>
                <strong><span>迁安</span><img src="images/ver113/shougang/jiantou.png"><span> 六元桥下(西杜兰庄)</span><img src="images/ver113/shougang/jiantou.png"><span>一线材厂门口</span></strong>
                 <p>四班：迁钢小区西门 &nbsp; 10:00</p>
			   <p>常白班：合力楼/办公中心 &nbsp; 12:20</p>
            </div>
			<div class="part part-bluebg">
                <strong>返迁：</strong>
                <p id="hq"></p>
            </div>
			 <div class="part">
                <strong><span>厂东门</span><img src="images/ver113/shougang/jiantou.png"><span>迁钢小区</span></strong>
                 <p>四班:&nbsp; 15:00</p>
			     <p>常白班: &nbsp; 15:30</p>
            </div>
            <div class="part">
                <strong class="red">B车</strong>
                <strong><span>狼垡</span><img src="images/ver113/shougang/jiantou.png"><span> 王四营(盛华宏林粮油批发市场)</span><img src="images/ver113/shougang/jiantou.png"><span>迁钢小区</span> </strong>
                  <p>四班:狼垡(15:20);王四营(15:50)</p>
			      <p>常白班:狼垡(16:40);王四营(17:20)</p>
            </div>
			 <div class="part">
                <strong><span>门头沟龙泉花园</span><img src="images/ver113/shougang/jiantou.png"><span>六元桥下(西杜兰庄)</span><img src="images/ver113/shougang/jiantou.png"><span>迁钢小区</span></strong>
                 <p>四班:&nbsp; 门头沟龙泉花园(14:30);六元桥下(西杜兰庄)(15:30)</p>
			 
            </div>
			 <div class="part">
                <strong><span>一线材厂门口</span><img src="images/ver113/shougang/jiantou.png"><span>六元桥下(西杜兰庄)</span><img src="images/ver113/shougang/jiantou.png"><span>迁钢小区</span></strong>
			     <p>常白班: &nbsp; 一线材厂(15:00);六元桥下(西杜兰庄)(15:30)</p>
            </div>
        </div>
    </div>
      <div class="car-tan car-a" id="nocar" style="display:none;">
        <div class="tab-title">
            <a class="title-a" onclick="changeDay('-1')" ><i class="fa fa-angle-left"></i>前一天</a>
            <a class="title-b" onclick="changeDay('1')" ><i class="fa fa-angle-right"></i>后一天</a>
        </div>
        <div class="tab-box">
            <div class="week"><span id="nowDay2"></span><span id="week2"></span>&nbsp;&nbsp;&nbsp;&nbsp;<span id="lunar2">初十</span></div>
            <div class="part part-bluebg">
                <strong>回京：</strong>
                <p>无回京班车</p>
            </div>
            <div class="part part-bluebg">
                <strong>返迁：</strong>
                <p>无返迁班车</p>
            </div>
        </div>
    </div>
</form>
   
</body>
<script type="text/javascript">
$(document).ready(function(){
			var url = "/defaultroot/ICCardAction!getCarInfoData.action?randomid=" + (new Date()).getTime();
			 var jsonData = {
						nowDay:$("#nowDay").val()
					};
					$.ajax({
						url: url,
						type: "post",
						async: false,
						data:jsonData,
						success: function (data) {
						data = data.replace(/(^\s*)|(\s*$)/g, '');
						if(data != ''){
							data = eval('('+data+')');
							var json = data.data;
							if(json.hj != '' ){
								$("#hj").html(json.hj);
								$("#hq").html(json.hq);
								$("#nowDay2").html(json.nowDay);
								$("#week1").html(json.week);
								$("#lunar1").html(json.lunar);
							}else{
								$("#nocar").css("display","");
								$("#hascar").css("display","none");
								$("#nowDay2").html(json.nowDay);
								$("#week2").html(json.week);
								$("#lunar2").html(json.lunar);
							}
						}
						},
						error: function (XMLHttpRequest, textStatus, errorThrown) {
							alert(XMLHttpRequest);
							alert(textStatus);
							alert(errorThrown);
						}
					});

});

function changeDay(type){
	if(type == '-1'){
		$('#nowDay').val($('#previousDay').val());
	}else if(type == '0'){
		$('#nowDay').val('');
	}else if(type == '1'){
		$('#nowDay').val($('#nextDay').val());
	}
	$('#dataForm').submit();
}

</script>

</html>
