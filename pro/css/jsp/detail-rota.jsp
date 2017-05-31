<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<%@ include file="/public/include/init.jsp"%>
<%@ page import="com.whir.rd.sggf.webindex.bd.*"%>
<%@ page import="com.whir.common.db.Dbutil"%>
<%@ page import="com.whir.common.util.UploadFile"%>
<%@ page import="com.whir.org.common.util.SysSetupReader"%>
<%
SysSetupReader sysRed = SysSetupReader.getInstance();
String skin = sysRed.getBeforeLoginSkin("0");
String logoName="logo.png";
if("red".equals(skin)){
logoName="red-logo.png";
%>
<html lang="zh-cn"  class="theme-red">
<%}else{%>
<html lang="zh-cn" >
<%}%>
<%
String nowMonth=request.getAttribute("nowMonth")==null?"":request.getAttribute("nowMonth").toString();
String previousMonth = request.getAttribute("previousMonth")==null?"":request.getAttribute("previousMonth").toString();
String nextMonth = request.getAttribute("nextMonth")==null?"":request.getAttribute("nextMonth").toString();
String title="";
title = nowMonth.replace("-","年");
title = "股份公司"+title+"月值班表";


%>

<head>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
    <link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/reset.css" />
    <link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/flexslider.css" />
    <link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/tan.css" />
    <link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/pro-style.css" />
	<link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/red.css" />
	<%if("grey".equals(skin)){%>
	<link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/gray.css" />
	<%}%>
    <script src="<%=rootPath%>/scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <script src="<%=rootPath%>/scripts/main/whir.application.js" type="text/javascript"></script>

</head>

<body>
	<form name="queryForm" id="queryForm" action="/defaultroot/RotaAction!detailRota.action" method="post" >
	<input name="nowMonth" id="nowMonth" type="hidden" value="<%=nowMonth%>"/>
	<input name="previousMonth" id="previousMonth" type="hidden" value="<%=previousMonth%>"/>
	<input name="nextMonth" id="nextMonth" type="hidden" value="<%=nextMonth%>"/>
        <div class="detail-contact gf-meetingbox" id="rotaDetailDiv" style="overflow: inherit;padding:0;padding-bottom:20px;width:auto">
            <div class="gf-meeting" align="center">
              <div class="zb-top" style="background:url(/defaultroot/rd/rota/images/zb-bg.png) center top no-repeat;padding-top:20px;padding-bottom:10px;">
                  <p class="detail-title" style="background:none;" ><span><img id="left" src="/defaultroot/rd/rota/images/arrow_left.png" onclick="previousMonthData();">
						&nbsp;&nbsp;</span><span id="rotaTitle" style="background:none;color:#fff;" ><%=title %></span><span>&nbsp;&nbsp;<img id="right" src="/defaultroot/rd/rota/images/arrow_right.png" onclick="nextMonthData();"></span></p>
                  <p class="time" style="background:none;color:#fff;"><span id="rotaAcc"><img  src="/defaultroot/rd/rota/images/fujian.png">&nbsp;&nbsp; <a href="#" onclick="exportExcel();" style="color:#fff;"><%=title %></a></span></p>
                </div>

           <div class="zb-top red-zb-top" style="background:url(/defaultroot/rd/rota/images/zb-bg_red.png) center top no-repeat;padding-top:20px;padding-bottom:10px;">
                  <p class="detail-title" style="background:none;" ><span><img id="left" src="/defaultroot/rd/rota/images/arrow_left_red.png" onclick="previousMonthData();">
						&nbsp;&nbsp;</span><span id="rotaTitle" style="background:none;color:#fff;" ><%=title %></span><span>&nbsp;&nbsp;<img id="right" src="/defaultroot/rd/rota/images/arrow_right_red.png" onclick="nextMonthData();"></span></p>
                  <p class="time" style="background:none;color:#fff;"><span id="rotaAcc"><img  src="/defaultroot/rd/rota/images/fujian_red.png">&nbsp;&nbsp; <a href="#" onclick="exportExcel();" style="color:#fff;"><%=title %></a></span></p>
                </div>

                 <div id="rotaDiv">
                  <table class="meeting-table" id="rotaTable" >
			          <tr align="center" id="dwmc">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" rowspan="2" colspan="1">
			                	单位
			            </td>
			        </tr>
			        <tr align="center" id="week">
			        	
			        </tr>
			        <tr align="center" id="gsld">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			                公司领导
			            </td>
			        </tr>
			        <tr align="center" id="bgs">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			                办公室
			            </td>
			        </tr>
			        <tr align="center" id="zzb">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			                制造部
			            </td>
			        </tr>
			        <tr align="center" id="aqb">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			               安全部
			            </td>
			        </tr>
			        <tr align="center" id="sbb">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			               设备部
			            </td>
			        </tr>
			        <tr align="center" id="nyhbb">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			              能源环保部
			            </td>
			        </tr>
			        <tr align="center" id="znhyyb">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			              智能化应用部
			            </td>
			        </tr>
			        <tr align="center" id="yyghb">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			                运营规划部
			            </td>
			        </tr>
			        <tr align="center" id="bwwzb">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			                保卫武装部
			            </td>
			        </tr>
			        <tr align="center" id="dqgzb">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			                党群工作部
			            </td>
			        </tr>
			        <tr align="center" id="rlzyb">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			                人力资源部
			            </td>
			        </tr>
			        <tr align="center" id="jcb">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			               计财部
			            </td>
			        </tr>
			        <tr align="center" id="jggcb">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			               技改工程部
			            </td>
			        </tr>
			        <tr align="center" id="ltzyb">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			               炼铁作业部
			            </td>
			        </tr>
			        <tr align="center" id="lgzyb">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			              炼钢作业部
			            </td>
			        </tr>
			        <tr align="center" id="rzzyb">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			               热轧作业部
			            </td>
			        </tr>
			        <tr align="center" id="ggsyb">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			               硅钢事业部
			            </td>
			        </tr>
			        <tr align="center" id="zjz">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			               质量检验部
			            </td>
			        </tr>
			        <tr align="center" id="cykfzx">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			              创业开发中心
			            </td>
			        </tr>
			        <tr align="center" id="wzgygs">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			              物资供应公司
			            </td>
			        </tr>
			        <tr align="center" id="xsgszpz">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			            <nobr> 销售公司派驻站</nobr>
			            </td>
			        </tr>
			        <tr align="center" id="lzgs">
			            <td style="padding: 10px; border: 1px solid rgb(0, 0, 0); " valign="middle">
			            首钢冷轧公司
			            </td>
			        </tr>
                  </table>
                  </div>
            </div>
       </div>
</form>
        <script type="text/javascript">
        $(document).ready(function(){
        	var jsonData = {
        			nowMonth:$("#nowMonth").val()
				};
				var url = "/defaultroot/RotaAction!getDetailRota.action?randomid=" + (new Date()).getTime();
				$.ajax({
					url: url,
					data: jsonData,
					type: "post",
					async: false,
					success: function (data) {
					data = data.replace(/(^\s*)|(\s*$)/g, '');
						data = eval('('+data+')');
						var dayAndWeek = data.data.dayAndWeek;
						var rotaJson = data.data.rotaJson;
						if(dayAndWeek.length > 0 && rotaJson.length >0){
							for(var i=0;i<dayAndWeek.length;i++){
								$("#dwmc").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle">'+dayAndWeek[i].day+'</td>');
								$("#week").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle">'+dayAndWeek[i].week+'</td>');
								$("#gsld").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#bgs").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#zzb").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#aqb").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#sbb").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#nyhbb").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#znhyyb").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#yyghb").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#bwwzb").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#rlzyb").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#jcb").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#jggcb").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#ltzyb").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#lgzyb").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#ggsyb").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#zjz").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#cykfzx").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#wzgygs").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#xsgszpz").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#lzgs").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#dqgzb").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								$("#rzzyb").append('<td style="padding: 10px; border: 1px solid rgb(0, 0, 0);" valign="middle" name="'+dayAndWeek[i].day+'"></td>');
								
								}
							for(var j=0;j<rotaJson.length;j++){
								if(rotaJson[j].dwmc == '公司领导'){
									$("#gsld").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '股份办公室'){
									$("#bgs").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '制造部'){
									$("#zzb").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '安全部'){
									$("#aqb").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '设备部'){
									$("#sbb").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '能源环保部'){
									$("#nyhbb").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '智能化应用部'){
									$("#znhyyb").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '运营规划部'){
									$("#yyghb").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '保卫武装部'){
									$("#bwwzb").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '党群工作部（工会）'){
									$("#dqgzb").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '人力资源部'){
									$("#rlzyb").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '计财部'){
									$("#jcb").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '技改工程部'){
									$("#jggcb").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '炼铁作业部'){
									$("#ltzyb").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '炼钢作业部'){
									$("#lgzyb").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '热轧作业部'){
									$("#rzzyb").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '硅钢事业部'){
									$("#ggsyb").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '质量检验部'){
									$("#zjz").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '职工创业开发中心'){
									$("#cykfzx").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '物资供应公司'){
									$("#wzgygs").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '营销管理部'){
									$("#xsgszpz").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}else if(rotaJson[j].dwmc == '首钢冷轧公司'){
									$("#lzgs").find($("[name='"+rotaJson[j].zbrq+"']")).append(rotaJson[j].zbry+"<br>"+rotaJson[j].lxdh+"<br>");
								}
							}
							//$("#rotaDetailDiv").css('width',$("#rotaTable").find("tr").width()+'px'); 
							/*var screenwidth = window.screen.width;*/

            var trwidth = $("#rotaTable").width();
             
            if(trwidth > screenwidth){
            	  $("#rotaDetailDiv").css('width',trwidth);
            }
            else{
            	   $("#rotaDetailDiv").css('width','auto');
			     }


						}else{
							$('#rotaTable').replaceWith('暂未设置该月值班信息，请联系管理员！');
							$('#rotaAcc').css('display','none');
						}
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
					}
				});
        });
              
           
             
           
		//上一月
        function previousMonthData(){
            $("#nowMonth").val($("#previousMonth").val());
            $("#queryForm").submit();
            }
      //下一月
        function nextMonthData(){
            $("#nowMonth").val($("#nextMonth").val());
            $("#queryForm").submit();
            }
        //导出excel文件
        function exportExcel(){
            var content = $('#rotaDiv').html();
            var title = $('#rotaTitle').html();
            _export2('RotaAction!exportExcel.action',content,title);
			
            }
        
        function _export2(url, content,title){
            var $form = createDynamicForm({id:'_postForm_',target:'_self', action:url, method:'post'});
            var textareaObj = $('<textarea name=content style="display:none"/>');
            textareaObj.val(content);
            textareaObj.appendTo($form);

        	 var textareaObj2 = $('<textarea name=accTitle style="display:none"/>'); 
        	   textareaObj2.val(title); 
        	    textareaObj2.appendTo($form);
         
            if($form) {
                $form.submit();
            }
        }
        


        
        </script>

</body>
</html>
