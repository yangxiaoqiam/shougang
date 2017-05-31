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
String nowMonth=request.getAttribute("nowMonth")==null?"":request.getAttribute("nowMonth").toString();
String previousMonth = request.getAttribute("previousMonth")==null?"":request.getAttribute("previousMonth").toString();
String nextMonth = request.getAttribute("nextMonth")==null?"":request.getAttribute("nextMonth").toString();
String allowSearch = request.getAttribute("allowSearch")==null?"":request.getAttribute("allowSearch").toString();
String title="";
title = nowMonth.replace("-","年");
title = title+"月考勤";
%>
<body>
 <form name="dataForm" id="dataForm" action="/defaultroot/ICCardAction!getICCardAttendanceSummary.action" method="post" >
	<input name="nowMonth" id="nowMonth" type="hidden" value="<%=nowMonth%>"/>
	<input name="previousMonth" id="previousMonth" type="hidden" value="<%=previousMonth%>"/>
	<input name="nextMonth" id="nextMonth" type="hidden" value="<%=nextMonth%>"/>
   <!-- 考勤信息表 -->
   <div class="kq-list">
      <h3>考勤信息表</h3>
      <div class="tab">       
      <div>
          <a href="javascript:void(0)" onclick="changeMonth('-1');"><i class="fa fa-angle-left" id="previous" ></i></a><span><%=nowMonth%></span> <a href="javascript:void(0)" onclick="changeMonth('1');"><i class="fa fa-angle-right" id="next"></i></a>
		  <a class="btn btn-wh-line" href="javascript:void(0)" onclick="changeMonth('0');">本月</a>
      </div>
      </div>
      <p class="month-title"><%=title%><i class="fa fa-angle-right fr"></i></p>
       <ul class="kg-detail fl" style="display: block;width:49%">
           <li class="clearfix">
                <span>上班</span>
                <em class="fr" id="sbNum" ></em>
           </li>
           <li class="clearfix" id="ysb" >
                <span>应上班</span>
                <em class="fr" id="ysbNum" ></em>
           </li>     
      </ul>
	   <div class="list-aa fr" style="width:49%" id="detailDiv">
           
        </div>
   </div>
 </div>
</form>
   
</body>
<script type="text/javascript">
$(document).ready(function(){
			var url = "/defaultroot/ICCardAction!ICCardAttendanceSummaryData.action?randomid=" + (new Date()).getTime();
			var lskHtml = '' ;
			var detailedHtml = '';
			 var jsonData = {
						nowMonth:$("#nowMonth").val()
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
						var jsonData = data.data.summaryJson;
						if(jsonData.length > 0 && jsonData.length >0){
							for(var i=0;i<jsonData.length;i++){
								if(jsonData[i].detailedType == '上班'){
									$("#sbNum").html(jsonData[i].numOrDate);
								}else if(jsonData[i].detailedType == '应上班'){
									$("#ysbNum").html(jsonData[i].numOrDate);
								}else if(jsonData[i].detailedType == '剩余班次'){
									$("#ysb").after('<li class="clearfix" id="sybc" ><span>剩余班次</span><em class="fr" id="sybcNum">'+jsonData[i].numOrDate+'</em></li>');
								}else{
									
										if(jsonData[i].detailedType.indexOf('△') == -1){
											detailedHtml += '<li class="clearfix" ><span>'+jsonData[i].detailedType+'</span><em class="fr" id="lskMun">'+jsonData[i].numOrDate+'</em></li>';
										}else{
											detailedHtml += '<li class="clearfix"><span>'+jsonData[i].detailedType+'</span> <em class="fr red">'+jsonData[i].numOrDate+'</em></li>'; 
										}
								}
							}

							}
							if($("#sybc").length > 0){ 
									$("#sybc").after(detailedHtml);
							}else{
									$("#ysb").after(detailedHtml);
							}

							var detailHtml="";
							var detailJson = data.data.detailJson;
							if(detailJson.length > 0 && detailJson.length >0){
								for(var i=0;i<detailJson.length;i++){
										detailHtml +='<div><p class="t-left">'+detailJson[i].skTime+'</p><p class="t-right">'+detailJson[i].skDetail+'</p></div>'
									}
								$("#detailDiv").html(detailHtml);
							}

							}
						},
						error: function (XMLHttpRequest, textStatus, errorThrown) {
							alert(XMLHttpRequest);
							alert(textStatus);
							alert(errorThrown);
						}
					});

			var allowSearch = '<%=allowSearch%>';
			var previousMonth = '<%=previousMonth%>';
			var nextMonth = '<%=nextMonth%>';
			if(allowSearch.indexOf(previousMonth) == -1){
				/*$("#previous").css("display","none");*/
			}
			if(allowSearch.indexOf(nextMonth) == -1){
				/*$("#next").css("display","none");*/
			}
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

</script>

</html>
