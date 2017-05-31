<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/public/include/init.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="com.whir.rd.sggf.before.bd.BeforeInfoBD" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>一卡通</title>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    <%@ include file="/public/include/meta_base.jsp"%>
    <%@ include file="/public/include/meta_detail.jsp"%>
    <%@ include file="/public/include/form_detail.jsp"%>
    <!--这里可以追加导入模块内私有的js文件或css文件-->
    <script src="<%=rootPath%>/platform/custom/custom_database/js/common.js" type="text/javascript"></script>
    <script src="/defaultroot/scripts/plugins/powerFloat/jquery-powerFloat.js" type="text/javascript"></script>
<link href="/defaultroot/scripts/plugins/powerFloat/powerFloat.css" rel="stylesheet" type="text/css"/>
<link href="/defaultroot/scripts/plugins/tagit/css/jquery-ui-simple.css" rel="stylesheet" type="text/css"/>
<link href="/defaultroot/scripts/plugins/tagit/css/tagit-simple-grey.css" rel="stylesheet" type="text/css"/>
<script src="/defaultroot/scripts/plugins/jquery_ui/jquery-ui.min.js"></script>
<script src="/defaultroot/scripts/plugins/poshytip/jquery.poshytip.js" type="text/javascript"></script>
<link href="/defaultroot/scripts/plugins/poshytip/tip-yellowsimple/tip-yellowsimple.css" rel="stylesheet" type="text/css"/>
<script src="<%=rootPath%>/scripts/plugins/tagit/tagit.js"></script>
<script src="<%=rootPath%>/scripts/plugins/tagit/tagit.utils.js"></script>
<link rel="stylesheet" href="/defaultroot/template/css/template_system/template.reset.min.css">
<link rel="stylesheet" href="/defaultroot/template/css/template_system/template.fa.min.css">
 <link rel="stylesheet" type="text/css" href="/defaultroot/pro/css/onecard.css">
   
</head>

<body class="Pupwin">
    <div class="BodyMargin_10">
        <div class="_docBoxNoPanel" style="padding:5px">
			 <ul class="wh-quick-entry-list">
             <li><a title="考勤" href="javascript:void(0)" onclick="javascript:openWin({url:'/defaultroot/ICCardAction!getICCardAttendanceSummary.action',width:810,height:640,winName:'ICCard'});"><i class="fa fa-clock-o"></i><span>考勤</span></a> </li>
				 <li><a title="排班表" href="javascript:void(0)" onclick="javascript:openWin({url:'/defaultroot/ICCardAction!getICCardMonthAssign.action',width:810,height:640,winName:'assign'});"><i class="fa fa-list-alt"></i><span>排班表</span></a> </li>
				 <li><a class="no-border" title="乘车" href="javascript:void(0)" onclick="javascript:"><i class="fa fa-car"></i><span>乘车</span></a> </li>
				 <li><a class="no-border" title="消费" href="javascript:void(0)" onclick="javascript:openWin({url:'/defaultroot/ICCardAction!getConsumption.action',width:810,height:640,winName:'ICCard'});"><i class="fa fa-jpy"></i><span>消费</span></a> </li>
			</ul>
        </div>
    </div>
</body>

<script type="text/javascript">  






</script>

</html>