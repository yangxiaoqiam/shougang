<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/public/include/init.jsp"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html >
<html lang="zh-cn">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
	<%@ include file="/public/include/meta_base.jsp"%>
    <%@ include file="/public/include/meta_detail.jsp"%>
	<base url="defaultroot">
    <title>信息详情页</title>
    <link rel="stylesheet" type="text/css" href="<%=rootPath%>/rd/rota/css/reset.css" />
    <link rel="stylesheet" type="text/css" href="<%=rootPath%>/rd/rota/css/pro-style.css" />
	<script src="<%=rootPath%>/scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <script type="text/javascript " src="<%=rootPath%>/rd/rota/js/jquery.min.js "></script>
    <script type="text/javascript " src="<%=rootPath%>/rd/rota/js/bootstrap-datetimepicker.js "></script>
    <script type="text/javascript" src="<%=rootPath%>/rd/rota/js/jquery.flexslider.js"></script>
	<script type="text/javascript" src="<%=rootPath%>/rd/rota/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="<%=rootPath%>/rd/rota/js/layer.js"></script>
	<script type="text/javascript" src="<%=rootPath%>/rd/rota/js/index.js"></script>
	<link rel="stylesheet" href="/defaultroot/template/css/template_system/template.reset.min.css">
<link rel="stylesheet" href="/defaultroot/template/css/template_system/template.fa.min.css">
 <link rel="stylesheet" type="text/css" href="/defaultroot/pro/css/onecard.css">
</head>
<%
String nowMonth=request.getAttribute("nowMonth")==null?"":request.getAttribute("nowMonth").toString();
String previousMonth = request.getAttribute("previousMonth")==null?"":request.getAttribute("previousMonth").toString();
String nextMonth = request.getAttribute("nextMonth")==null?"":request.getAttribute("nextMonth").toString();
String monthStart = request.getAttribute("monthStart")==null?"":request.getAttribute("monthStart").toString();
String monthEnd = request.getAttribute("monthEnd")==null?"":request.getAttribute("monthEnd").toString();
String workCode = request.getAttribute("workCode")==null?"":request.getAttribute("workCode").toString();
String workName = request.getAttribute("workName")==null?"":request.getAttribute("workName").toString();

String title="";
title = nowMonth.replace("-","年");
title = title+"月排班表";
%>

<body>
<style type="text/css">
	  .tan-thismonth{
	  	 paddding:0;
	  }
</style>
 <form name="dataForm" id="dataForm" action="/defaultroot/ICCardAction!getICCardMonthAssign.action" method="post" >
<input name="nowMonth" id="nowMonth" type="hidden" value="<%=nowMonth%>"/>
<input name="previousMonth" id="previousMonth" type="hidden" value="<%=previousMonth%>"/>
<input name="nextMonth" id="nextMonth" type="hidden" value="<%=nextMonth%>"/>
<input name="monthStart" id="monthStart" type="hidden" value="<%=monthStart%>"/>
<input name="monthEnd" id="monthEnd" type="hidden" value="<%=monthEnd%>"/>
<input name="workCode" id="workCode" type="hidden" value="<%=workCode%>"/>
<input name="workName" id="workName" type="hidden" value="<%=workName%>"/>
  <div class="tan-thismonth-box card-rili" class="open">
        <div class="tan-thismonth" style="padding:0">
            <div class="data-a">
            <div class="thismonth-close"></div>
                <div class="pro-sche">
                    <!-- <div class="sche-title"><a href="javascript:void(0);" onclick="javascript:openWin({url:'/defaultroot/ICCardAction!getAllAssign.action',width:810,height:490,winName:'allAssign'});">常白班</a></div>
                    					 <div class="meeting-btn">
                    						 <a href="javascript:void(0)" onclick="changeMonth('-1');">上一月</a>
                    						<h3 align="cneter" ><%=title%></h3>
                    						 <a href="javascript:void(0)" onclick="changeMonth('1');">下一月</a>
                    					</div> -->
                     <div class="kq-list">
		               	   	  
		               	   	  <div class="tab">  	  
				               	   	  <div>
				               	   	  <i class="fa fa-angle-left" onclick="changeMonth('-1')"></i>  <span> <%=title%> </span> <i class="fa fa-angle-right" onclick="changeMonth('1');"></i>
				               	   	  <span></span>
				               	   	  <h3><a href="javascript:void(0);" onclick="javascript:openWin({url:'/defaultroot/ICCardAction!getAllAssign.action',width:810,height:490,winName:'allAssign'});"><span id="assignName">常白班</span></a></h3>
				               	      </div>
		               	   	  </div>
		             </div> 
		         </div>
                 <div id="datetimepicker"></div>
                </div>
			</div>
		</div>
	</div>

</form>
<script type="text/javascript">
    
$.fn.datetimepicker.dates['zh'] = {
    days: ["星期日 ", "星期一 ", "星期二 ", "星期三 ", "星期四 ", "星期五 ", "星期六 ", "星期日 "],
    daysShort: ["周日 ", "周一 ", "周二 ", "周三 ", "周四 ", "周五 ", "周六 ", "周日 "],
    daysMin: ["周日 ", "周一 ", "周二 ", "周三 ", "周四 ", "周五 ", "周六 ", "周日 "],
    months: ["一月 ", "二月 ", "三月 ", "四月 ", "五月 ", "六月 ", "七月 ", "八月 ", "九月 ", "十月 ", "十一月 ", "十二月 "],
    monthsShort: ["一月 ", "二月 ", "三月 ", "四月 ", "五月 ", "六月 ", "七月 ", "八月 ", "九月 ", "十月 ", "十一月 ", "十二月 "],
    today: "今天 ",
    suffix: [],
    meridiem: ["上午 ", "下午 "]
};
$('#datetimepicker').datetimepicker({
    language: 'zh',
    maxView: '0',
    todayHighlight: '1',
	startDate:'<%=monthStart%>',
	endDate:'<%=monthEnd%>'
});

$(document).ready(function(){

if($("#workName").val() != ''){
	var workName =  $("#workName").val();
	$("#assignName").html(workName);
}

var url = "/defaultroot/ICCardAction!getICCardMonthAssignData.action?randomid=" + (new Date()).getTime();
			var lskHtml = '' ;
			 var jsonData = {
						nowMonth:$("#nowMonth").val(),
						workCode:$("#workCode").val()
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
						var jsonData = data.data;
						if(jsonData.length > 0 && jsonData.length >0){
							for(var i=0;i<jsonData.length;i++){
									$("td[name='dateTd']").each(function(){
										if($(this).attr("id") == jsonData[i].date){
												$(this).append('<br>'+jsonData[i].lunar+'<br>'+jsonData[i].work);
												if(jsonData[i].hasCar != '' ){
													$(this).append('<br>京-迁');
												}
										}
									});

								}
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

function changeMonth(type){
	if(type == '-1'){
		$('#nowMonth').val($('#previousMonth').val());
	}else if(type == '0'){
		$('#nowMonth').val('');
	}else if(type == '1'){
		$('#nowMonth').val($('#nextMonth').val());
	}
	$('#dataForm').submit();
}

function viewCarInfo(dateStr){
	openWin({url:'/defaultroot/ICCardAction!getCarInfo.action?nowDay='+dateStr,width:710,height:540,winName:'ICCard'});
	 
}


</script> 

   
  
</body>

</html>
