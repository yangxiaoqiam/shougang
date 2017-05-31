<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/public/include/init.jsp"%>
<%@ page import="com.whir.ezoffice.portal.po.*"%>
<%@ page import="com.whir.ezoffice.portal.bd.*"%>
<%@ page import="com.whir.org.bd.organizationmanager.OrganizationBD"%>
<%
if(session==null || session.getAttribute("userId")==null){
%>
	<SCRIPT LANGUAGE="JavaScript">
		parent.window.location.href="<%=rootPath%>/login.jsp";
	</SCRIPT>
<%
}else{
    String ismain = request.getParameter("ismain");
	String skin = session.getAttribute("skin").toString();
	String domainId = session.getAttribute("domainId").toString();
	String layoutId = request.getParameter("id");
	String orgId = request.getParameter("orgId")!=null?request.getParameter("orgId"):"";
	//20160412 -by jqq 安全性漏洞改造
	orgId = com.whir.component.security.crypto.EncryptUtil.replaceHtmlcode(orgId);
	layoutId = com.whir.component.security.crypto.EncryptUtil.replaceHtmlcode(request,"id");
	if(orgId != null && !"".equals(orgId) && !"null".equals(orgId)){
		OrganizationBD orgbd = new OrganizationBD();
		String style = (orgbd.getOrgStyle(orgId)!=null && !"".equals(orgbd.getOrgStyle(orgId)))?orgbd.getOrgStyle(orgId):"default/blue";
		whir_skin = "themes/department/"+style;
	}

	if(layoutId!=null&&!"".equals(layoutId)&&!"null".equals(layoutId)&&!"undefined".equals(layoutId)){
        PortalLayoutBD bd = new PortalLayoutBD();
        String title = "";//标题
        String[][] layoutPO = bd.loadLayout(layoutId+"");
        String templateId = layoutPO[0][4];
        title += layoutPO[0][1];
        PortalTemplatePO templatePO = new PortalTemplateBD().load(new Long(templateId));
				//20161012 -by jqq 新增扩展样式文件引入
				String cssFile = bd.getPortalCssFile(layoutId);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="zh-cn" class="wh-gray-bg <%=whir_2016_skin_color%> <%=whir_2016_skin_styleColor%> <%=whir_pageFontSize_css%>">
<head>
<title><%=title%></title>
<%
    whir_custom_str = "lhgdialog";
%>
<%@ include file="/public/include/portal_base113.jsp"%>
<script language="JavaScript">
var _def_isDesignPage_ = false;
if(parent.leftFrame==undefined){
    //location.href="about:blank";
}
</script>

<SCRIPT LANGUAGE="JavaScript">
<!--
var PORTAL_SKIN = "<%=whir_skin%>";
var EXCHANGE_SERVER = "";
<%
//Exchange服务地址
String exchangeServer = "";
try{
    exchangeServer = new com.whir.component.config.ConfigXMLReader().getAttribute("ExchangeWebService", "server1");
}catch(Exception e){}
%>
EXCHANGE_SERVER = "<%=exchangeServer%>";
//-->
</SCRIPT>
<script type="text/javascript" src="<%=rootPath%>/scripts/main/whir.validation.js"></script>
<script type="text/javascript" src="<%=rootPath%>/scripts/main/whir.application.js"></script>
<!--
<script type="text/javascript" src="<%=rootPath%>/platform/portal/js/common.js"></script>
<script type="text/javascript" src="<%=rootPath%>/platform/portal/js/jquery.jfeed.pack.js"></script>
<script type="text/javascript" src="<%=rootPath%>/platform/portal/js/jquery.slideshow.lite-0.5.3.js"></script>
-->
<script type="text/javascript" src="<%=rootPath%>/platform/portal/js/portlet_ftl.js"></script>
</head>
<!-- style="background-color:transparent;" -->
<body <%if("1".equals(ismain)){%>class="wh-gray-bg"<%}%>>
<div class="wh-container wh-portaler">

<div id="startMsg" style="text-align:center;margin-top:200px;"><img src="<%=rootPath%>/images/load.gif"></div>
<%
    String module = request.getParameter("module")!=null?request.getParameter("module"):"";
    if(module.equals("know")){//知道模块首页上方显示提问搜索框
%>
    <jsp:include page="/modules/kms/zhidao/zhidao_index.jsp" flush="true"></jsp:include>
<%
    }
%>
<div id="iframeDiv" class="portalBox">
    <div id="mainLayout">
        <div id="portalMainDiv" style="display:none;">
            <%out.print(new com.whir.ezoffice.portal.freemarker.PortletFreeMarker().processPortlet(layoutId, templatePO.getContent(), whir_skin, rootPath, request, pageContext));%>
        </div>
        <SCRIPT LANGUAGE="JavaScript">
        <!--
            showPortlet();
        //-->
        </SCRIPT>
    </div>
</div>

</div>
</body>
</html>
<script language="JavaScript">
//-------------------------------自定义模块 portal所需函数方法  start---------------------------//
//链接字段查看表单数据方法
function view(recordId,portletSettingId,hasNewForm,formId,menuId) {
	if(hasNewForm=="true"){
       viewnewform(recordId,portletSettingId,formId,menuId);
	}else{
		var flag = '1';
		var url = whirRootPath+"/CustomMantence!loadCustomMantenceV.action?flag=" + flag + "&formId=" + formId + "&recordId=" + recordId + "&menuId="+menuId+"&moduleType=customizeModi";
		//console.log('oldForm'+portletSettingId+'_'+recordId);
		openWin({url:url,isFull:'true',winName: 'oldForm'+portletSettingId+'_'+recordId });
	}
}
//新表单
function viewnewform(recordId,portletSettingId,formId,menuId) {
    var flag = '0';
	if(formId.indexOf("new$")!=-1)
        formId = formId.replace("new$","");

	var url = whirRootPath+"/EzFormMantence!loadCustomMantenceV.action?flag=" + flag + "&menuId="+menuId+"&formId="+formId+"&recordId="+recordId+"&moduleType=customizeModi";
	//console.log('oldForm'+portletSettingId+'_'+recordId);
	openWin({url:url,isFull:'true',winName: 'newForm'+portletSettingId+'_'+recordId });
}
//-------------------------------自定义模块 portal所需函数方法   end---------------------------//
</script>
<%}%>
<%}%>