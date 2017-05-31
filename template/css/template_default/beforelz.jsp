<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="/public/include/init.jsp"%>
<%@ page import="com.whir.rd.sggf.webindex.index.*"%>
<%@ page import="com.whir.rd.sggf.webindex.bd.*"%>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.whir.org.basedata.bd.UnitSetBD" %>
<%@ page import="com.whir.org.basedata.po.UnitInfoPO" %>
<%@ page import="com.whir.i18n.Resource" %>
<%@ page import="com.whir.component.util.LocaleUtils" %>
<%@ page import="com.whir.component.util.CookieParser" %>
<%@ page import="com.whir.ezoffice.personalwork.setup.bd.MyInfoBD" %>
<%@ page import="com.whir.ezoffice.personalwork.setup.po.MyInfoPO" %>
<%@ page import="com.whir.common.util.CommonUtils" %>
<%@ page import="com.whir.org.common.util.SysSetupReader" %>
<%@ page import="com.whir.ezoffice.logon.bd.ResetPasswordBD" %>
<%@ page import="java.security.SecureRandom" %>



<%
String localeCode=request.getParameter("localeCode")==null?"":com.whir.component.security.crypto.EncryptUtil.replaceHtmlcode(request.getParameter("localeCode"));
if(localeCode!=null){
    com.whir.component.util.LocaleUtils.setLocale(localeCode, request);
}
%>

<%


response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache");
response.setDateHeader ("Expires", 0);

session = request.getSession(true); 
String fileServer = com.whir.component.config.ConfigReader.getFileServer(request.getRemoteAddr());
//log图片默认不显示
//String logopicacc = rootPath+"/images/logo.png";
String logopicacc  = "";
String ewmpicacc = rootPath+"/images/ewm.jpg";
String logobroadpicacc = rootPath+"/images/bg1.jpg";
String userPhoto = rootPath+"/images/ver113/login/user.jpg";
String preview =request.getParameter("preview")!=null?com.whir.component.security.crypto.EncryptUtil.replaceHtmlcode(request.getParameter("preview")):"";
String[] ewmArr = null;
String[] ewmNameArr = null;
String logobgSaveNameArr[] = new String[3];
String logobgpath = "";
String bqxx = "";
String qrcodeStatus = "0";//是否开启二维码，默认不开启
if(!preview.equals("") && preview.equals("true")){
    /*String logo = request.getParameter("logopicacc")!=null?com.whir.component.security.crypto.EncryptUtil.replaceHtmlcode(request.getParameter("logopicacc")):"";
    if(!logo.equals("")){
	    logopicacc = fileServer+"/upload/loginpage/"+logo.substring(0,6)+"/"+logo;
    }*/
    String ewm = com.whir.component.security.crypto.EncryptUtil.replaceHtmlcode(request.getParameter("logoindexpicacc"));
    String ewmName = com.whir.component.security.crypto.EncryptUtil.replaceHtmlcode(request.getParameter("logoindexpicaccName"));
    ewmArr = !"".equals(ewm)?ewm.split("\\|"):null;
    ewmNameArr = !"".equals(ewmName)?ewmName.split("\\|"):null;
	String broad = request.getParameter("logobroadpicacc")!=null?com.whir.component.security.crypto.EncryptUtil.replaceHtmlcode(request.getParameter("logobroadpicacc")):"";
    //logobgSaveNameArr = !broad.equals("")?broad.split("\\|"):null; 
    if(!broad.equals("")){
        logobroadpicacc = fileServer+"/upload/loginpage/"+broad.substring(0,6)+"/"+broad;
        logobgpath = fileServer+"/upload/loginpage/"+broad.substring(0,6)+"/";
        logobgSaveNameArr = broad.split("\\|");
    }else{
    	logobgpath = rootPath+"/images/";
    	logobgSaveNameArr[0] = "bg1.jpg";
    }
    qrcodeStatus = request.getParameter("isOpenewm")!= null ?com.whir.component.security.crypto.EncryptUtil.replaceHtmlcode(request.getParameter("isOpenewm")):"0";
}else{
	com.whir.org.basedata.bd.LoginPageSetBD loginPageSetBD = new com.whir.org.basedata.bd.LoginPageSetBD();
	String[][] pageset = loginPageSetBD.getLoginPageSet((String)request.getAttribute("previewId"));
	if(pageset!=null && pageset.length>0){
		 if(pageset[0][0]!=null&&!"null".equals(pageset[0][0])&&!"".equals(pageset[0][0])){
			 //String saveName = pageset[0][0];
			 logobgSaveNameArr = !pageset[0][0].equals("")?pageset[0][0].split("\\|"):null; 
			logopicacc = fileServer+"/upload/loginpage/"+pageset[0][0].substring(0,6)+"/"+pageset[0][0];
			logobgpath = fileServer+"/upload/loginpage/"+pageset[0][0].substring(0,6)+"/";
		 }
		 if(pageset[0][2]!=null&&!"null".equals(pageset[0][2])&&!"".equals(pageset[0][2])){
			//ewmpicacc = fileServer+"/upload/loginpage/"+pageset[0][2].substring(0,6)+"/"+pageset[0][2];
            ewmArr = pageset[0][2].split("\\|");
            ewmNameArr = pageset[0][3].split("\\|");
		 }
		 if(pageset[0][4]!=null&&!"null".equals(pageset[0][4])&&!"".equals(pageset[0][4])){
			logobgSaveNameArr = !pageset[0][4].equals("")?pageset[0][4].split("\\|"):null; 
			logobroadpicacc = fileServer+"/upload/loginpage/"+pageset[0][4].substring(0,6)+"/"+pageset[0][4];
			logobgpath = fileServer+"/upload/loginpage/"+pageset[0][4].substring(0,6)+"/";
		 }
		 if(pageset[0][6]!=null&&!"null".equals(pageset[0][6])&&!"".equals(pageset[0][6])){
			 qrcodeStatus = pageset[0][6]; 
		 }
	}
}
//获取版权信息
    UnitSetBD unitSetBD = new UnitSetBD();
//域标识 默认 为0    
	UnitInfoPO unitInfoPO = unitSetBD.getUnitInfo("0");
	if(unitInfoPO != null){
		if(StringUtils.isNotBlank(unitInfoPO.getCopyRights())){
			bqxx = unitInfoPO.getCopyRights();
		}
	}
//输入错误次数,用于显示验证码（>=2）
int inputErrorNum = Integer.parseInt(session!=null&&session.getAttribute("inputErrorNum")!=null?session.getAttribute("inputErrorNum").toString():"0");
String isDiglossia = "1" ; //是否双语,0:非双语,1：双语
if(localeCode==null){
   localeCode="zh_CN";
}
//以下语句防止日文系统ja或者zh_CN
localeCode = LocaleUtils.getLocale(localeCode);
String validate=request.getParameter("validate")==null?"":com.whir.component.security.crypto.EncryptUtil.replaceHtmlcode(request.getParameter("validate"));

//此处进行个人图片的验证
String userId = session.getAttribute("userId")==null?"":session.getAttribute("userId").toString();
MyInfoBD bd = new MyInfoBD();
if(StringUtils.isNotBlank(userId)){
	MyInfoPO  myInfo = bd.load(userId);
	if(myInfo != null&&myInfo.getEmpLivingPhoto()!=null){
		
		java.io.File file = new java.io.File(myInfo.getEmpLivingPhoto());
		if(file.exists()){userPhoto = myInfo.getEmpLivingPhoto();}
	}
}
if("no".equals(validate)){
	if(session.getAttribute("org.apache.struts.action.LOCALE")!=null && !"".equals(session.getAttribute("org.apache.struts.action.LOCALE"))){
        localeCode = session.getAttribute("org.apache.struts.action.LOCALE").toString();
  		//以下语句防止日文系统ja或者zh_CN
        localeCode = LocaleUtils.getLocale(localeCode);
	}
	//注销时，清除工作流当前用户的锁
	String userAccount = session.getAttribute("userAccount")==null?"":com.whir.component.security.crypto.EncryptUtil.replaceHtmlcode(session.getAttribute("userAccount").toString());
	if(!"".equals(userAccount)){
		com.whir.ezoffice.workflow.newBD.WorkFlowButtonBD wfbd = new com.whir.ezoffice.workflow.newBD.WorkFlowButtonBD();
		wfbd.logoutWFOnlineUser(userAccount);
	}
	
    //session.invalidate();
    if("1".equals(isDiglossia)){
        response.sendRedirect("login.jsp?localeCode="+localeCode);
    }else{
        response.sendRedirect("login.jsp");
    }
}else{
    //以下语句防止日文系统ja或者zh_CN
    localeCode = LocaleUtils.getLocale(localeCode);
    LocaleUtils.setLocale(localeCode, request);
}
CookieParser cookieparser = new CookieParser();
cookieparser.addCookie(response, "LocLan", localeCode, 365*24*60*60, null, "/", false);
String domainAccount=com.whir.org.common.util.SysSetupReader.getInstance().isMultiDomain();
String logoFile = rootPath+"/images/"+localeCode+"/bg.jpg";
int inputPwdErrorNum = Integer.parseInt(request.getAttribute("inputPwdErrorNum")!=null?(String)request.getAttribute("inputPwdErrorNum"):"0");
int inputPwdErrorNumMax = Integer.parseInt(request.getAttribute("inputPwdErrorNumMax")!=null?(String)request.getAttribute("inputPwdErrorNumMax"):"6");
String useCaptcha = com.whir.org.common.util.SysSetupReader.getInstance().getSysValueByName("captcha", "0");
String userAccount = request.getAttribute("userAccount")==null?"":com.whir.component.security.crypto.EncryptUtil.replaceHtmlcode(request.getAttribute("userAccount").toString());
String userPassword = request.getAttribute("userPassword")==null?"":request.getAttribute("userPassword").toString();

//获取找回密码配置----开始
 String domainId1 = request.getAttribute("domainId")==null?"0":request.getAttribute("domainId").toString();
 com.whir.ezoffice.logon.bd.ResetPasswordBD rpbd = new com.whir.ezoffice.logon.bd.ResetPasswordBD();
 String resetPassword = rpbd.getResetPassword(domainId1);

 //获取找回密码配置----结束
 
 //登陆设置预览
 String previewId = request.getAttribute("previewId")==null?"":com.whir.component.security.crypto.EncryptUtil.replaceHtmlcode(request.getAttribute("previewId")+"");
 
SecureRandom random1=SecureRandom.getInstance("SHA1PRNG");
long seq=random1.nextLong();
String random=""+seq;
session.setAttribute("random_session",random);
%>


<%
String orgId="12867";
String path = "information";

%>

<script type="text/javascript">
	var whirRootPath = "<%=rootPath%>";
	var preUrl = "<%=preUrl%>"; 
	var whir_browser = "<%=whir_browser%>"; 
	var whir_agent = "<%=com.whir.component.security.crypto.EncryptUtil.htmlcode(whir_agent)%>"; 
	var whir_locale = "<%=whir_locale.toLowerCase()%>"; 
</script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<title>北京首钢冷轧薄板有限公司</title>
    <meta charset="utf-8">
    <!-- <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"> -->
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <base url="defaultroot">
    <link rel="stylesheet" href="template/css/template_system/template.reset.min.css" />
    <link rel="stylesheet" href="template/css/template_system/template.fa.min.css" />
    <link rel="stylesheet" href="template/css/template_default/template.media.min.css" />
    <link rel="stylesheet" href="template/css/template_default/template.style.min.css" />
    <link rel="stylesheet" href="template/css/template_default/template.portal.min.css" />
    <link rel="stylesheet" href="template/css/template_default/themes/2016/template.theme.before.min.css" />
    <link rel="stylesheet" href="template/css/template_default/themes/2016/template.theme.after.min.css" />
    <link rel="stylesheet" href="template/css/template_default/themes/2016/template.theme.line.min.css" />
    <link rel="stylesheet" href="template/css/template_default/themes/2016/template.theme.media.min.css" />
    <link rel="stylesheet" href="template/css/template_default/template.style.size.min.css" />
    <link rel="stylesheet" href="template/css/template_default/template.syly-before.css" />
	<link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/layer.css" />
    <script type="text/javascript" src="scripts/plugins/jquery/jquery.min.js"></script>
    <script type="text/javascript" src="scripts/plugins/superslide/jquery.SuperSlide.2.1.1.js"></script>
	<script src="<%=rootPath%>/scripts/i18n/<%=whir_locale%>/CommonResource.js" type="text/javascript"></script>
	<script src="<%=rootPath%>/scripts/plugins/lhgdialog/lhgdialog.js?skin=idialog" type="text/javascript"></script>
	<script type="text/javascript" src="<%=rootPath%>/rd/js/util/loginbf.js"></script>
	<script src="<%=rootPath%>/scripts/main/whir.validation.js" type="text/javascript"></script>
	 <script src="<%=rootPath%>/scripts/main/whir.application.js" type="text/javascript"></script>
	<script src="<%=rootPath%>/scripts/main/whir.util.js" type="text/javascript"></script>
	<script src="<%=rootPath%>/scripts/util/cookie.js" type="text/javascript"></script>
	 <script type="text/javascript" src="<%=rootPath%>/scripts/plugins/security/security.js"></script>
	 <script type="text/javascript" src="<%=rootPath%>/pro/js/layer.js"></script>
</head>

<body>
    <!--- top  -->
    <div class="before-top clearfix w1280">
        <a class="before-logo fl"><img src="../defaultroot/images/ver113/shougang/logo.png"></a>
        <div class="before-nav fl">
            <ul class="clearfix">
                <li>
                    <a href="#">首页</a>
                </li>      
                <li>
                    <a href="javascript:void(0);">公司链接</a>
                    <dl>
						<dd><a target="_blank" href="http://oa.shougang.com.cn">首钢集团</a></dd>
                        <dd><a target="_blank" href="/defaultroot/index_pre.jsp">股份公司</a></dd>
                        <dd><a target="_blank" href="/defaultroot/beforesale.jsp">营销管理部</a></dd>
                    </dl>
                </li>
                <li><a href="#">通讯录</a></li>
            </ul>
        </div>
        <div class="before-logo-ri fr clearfix">
            <div class="header-buttom-fr fr">
                <input type="text" id="search" name="search" value="请输入文字" onfocus="this.value=''" />
                <a href="javascript:void(0);" onclick="SearchInformation();" class="before-btn"><i class="fa fa-search fa-color"></i></a>
            </div>
            <div class="ri_1 fr">
                <a target="_blank" href="http://mail.sg-crm.com.cn/">邮箱</a>
            </div>
        </div>
    </div>
    <!--- top  end -->
	<script type="text/javascript">
	//页面搜索字符
	function SearchInformation(){
		var infokey = $("#search").val();
		openWin({url:whirRootPath+"/BeforeInfoAction!infolist.action?infokey2=" + encodeURIComponent(infokey)+"&orgId=<%=orgId%>"+"&channelIds=21461,22389,22315,22479,21477,21510,42928,22058,22452,22462,22285,22287,22289,43464,22471",isFull:'true',winName: 'searchInfo'});
	}
	</script>
    <!--- banner  -->
    <div class="banner">
        <div id="slideBox" class="slideBox">
            <div class="hd">
                <ul>
                    <li></li>
                    <li></li>
                    <li></li>
                    <li></li>
                </ul>
            </div>
            <div class="bd">
                <ul>
                    <li style="background:url(images/ver113/shougang/banner1.png) center no-repeat; height:270px;">
                        <a href="#"></a>
                    </li>
                    <li style="background:url(images/ver113/shougang/banner1.png) center no-repeat; height:270px;">
                        <a href="#"></a>
                    </li>
                    <li style="background:url(images/ver113/shougang/banner1.png) center no-repeat; height:270px;">
                        <a href="#"></a>
                    </li>
                </ul>
            </div>
            <!-- 下面是前/后按钮代码，如果不需要删除即可 -->
            <a class="prev" href="javascript:void(0)"></a>
            <a class="next" href="javascript:void(0)"></a>
        </div>
    </div>
    <!--- banner end -->
    <div id="mainLayout" style="height:100%;" class="wh-container wh-portaler">
        <!-- banner关闭按钮 -->
        <div class="close_banner"><span></span></div>
        <table class="w1280" id="portalMain" cellpadding="0" cellspacing="0" border="0" width="100%" align="center" style="table-layout: fixed;">
            <tbody>
                <tr>
                    <td width="29%" class="portal-column-td" zone="A">
                        <!--通知公告-->
						<%
						List txtg=new ArrayList();
						//获取通知通告
						GetPortalInfo gpInfo=new GetPortalInfo();
						txtg=gpInfo.getInfo("21461",orgId,6);
						%>
                        <div class="wh-portal-info-box height-1">
                            <div class="wh-portal-tools">
                                <i class="fa fa-more-a">
								<a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21461&startPage=1&pageSize=12&orgId=<%=orgId%>" target="_blank">MORE >></a></i>
                            </div>
                            <div class="wh-portal-info">
                                <div class="wh-portal-i-title clearfix">
                                    <ul class="wh-portal-i-title-left clearfix">
                                        <li class="wh-portal-title-li  on"><a href="javascript:void(0);" >通知公告</a></li>
                                    </ul>
                                </div>
                                <div class="wh-portal-i-content">
                                    <div class="wh-portal-info-content"> 
									<%
									if(txtg!=null&&txtg.size()>0){
										for(int i=0;i<txtg.size();i++){
											String [] arr=(String [])txtg.get(i);
										%>
                                        <div class="wh-portal-i-item clearfix">
                                            <a href="javascript:void(0)">
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
                                                <span class="wh-pending-time" style="align:right"><%=arr[2]%></span>
                                            </a>
                                        </div>
									<%}}%>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- 规章制度 -->
                        <div class="wh-portal-info-box height-2">
                            <div class="wh-portal-tools">
                                <i class="fa fa-more-a">
								<a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21781&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">MORE >></a></i>
                            </div>
                            <div class="wh-portal-info">
                                <div class="wh-portal-i-title clearfix">
                                    <ul class="wh-portal-i-title-left clearfix">
                                        <li class="wh-portal-title-li on"><a href="javascript:void(0);">规章制度</a></li>
                                    </ul>
                                </div>
                                <div class="wh-portal-i-content">
                                    <div class="wh-portal-info-content wh-protal-overflow">
                                        <div class="gzzd">
                                            <ul class="clearfix">
                                                <li><a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21781&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});" >现行制度目录</a></li>
                                                <li><a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21816&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});" >废止制度目录</a></li>
                                                <li><a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21852&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});" >生产安全</a></li>
                                                <li><a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21879&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});" >设备管理</a></li>
                                                <li><a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21915&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});" >技术质量</a></li>
                                                <li><a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21935&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});" >能源环保</a></li>
                                                <li><a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21937&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});" >劳务人事</a></li>
                                                <li><a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21939&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});" >武装保卫</a></li>
                                                <li><a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21943&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});" >财务管理</a></li>
                                                <li><a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21949&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});" >行政生活</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--党员学习园地 -->
						<%
						List xxyd=new ArrayList();
						List dwgk=new ArrayList();
						//获取党员学习园地
						xxyd=gpInfo.getInfo("22389",orgId,6);
						dwgk=gpInfo.getInfo("22315",orgId,6);
						%>
                        <div class="wh-portal-info-box height-3">
                            <div class="wh-portal-tools">
                                <i class="fa fa-more-a">
								<a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=22389&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">MORE >></a></i>
                            </div>
                            <div class="wh-portal-info">
                                <div class="wh-portal-i-title clearfix">
                                    <ul class="wh-portal-i-title-left wh-portal-title-slide01 clearfix">
                                        <li class="wh-portal-title-li on"><a href="javascript:void(0);">党员学习园地</a></li>
                                        <li class="wh-portal-title-li"><a href="javascript:void(0);">党务公开</a></li>
                                    </ul>
                                </div>
                                <div class="wh-portal-i-content">
                                    <div class="wh-portal-info-content">
                                        <div class="wh-portal-slide01">
                                            <ul class="clearfix">
                                                <li>
													<%
													if(xxyd!=null&&xxyd.size()>0){
														for(int i=0;i<xxyd.size();i++){
															String [] arr=(String [])xxyd.get(i);
														%>
                                                    <div class="wh-portal-i-item clearfix">
                                                        <a href="javascript:void(0)" >
                                                            <i class="fa fa-file-o"></i>
                                                            <span class="title-aa" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
                                                            <span class="wh-pending-time"><%=arr[2]%></span>
                                                        </a>
                                                    </div>
													<%}}%>  
                                                </li>
												  <li class="wh-portal-hidden" style="display:none;">
													<%
													if(dwgk!=null&&dwgk.size()>0){
														for(int i=0;i<dwgk.size();i++){
															String [] arr=(String [])dwgk.get(i);
														%>
                                                    <div class="wh-portal-i-item clearfix">
                                                        <a href="javascript:void(0)" >
                                                            <i class="fa fa-file-o"></i>
                                                            <span class="title-aa" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
                                                            <span class="wh-pending-time"><%=arr[2]%></span>
                                                        </a>
                                                    </div>
													<%}}%>  
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- TPM园地 -->
						
						 <!-- 安全文化 start-->
						 <%
						List aqwh=new ArrayList();
						//获取安全文化
						aqwh=gpInfo.getInfo("23094",orgId,6);
						%>
						  <div class="wh-portal-info-box height-4">
                            <div class="wh-portal-tools">
                                <i class="fa fa-more-a">
								<a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=23094&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">MORE >></a></i>
                            </div>
                            <div class="wh-portal-info">
                                <div class="wh-portal-i-title clearfix">
                                    <ul class="wh-portal-i-title-left clearfix">
                                        <li class="wh-portal-title-li  on"><a href="javascript:void(0);">安全文化</a></li>
                                    </ul>
                                </div>
                                <div class="wh-portal-i-content">
                                    <div class="wh-portal-info-content">
									<%
									if(aqwh!=null&&aqwh.size()>0){
										for(int i=0;i<aqwh.size();i++){
											String [] arr=(String [])aqwh.get(i);
									%>
                                        <div class="wh-portal-i-item clearfix">
                                            <a href="javascript:void(0)" >
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
												 <span class="wh-pending-time"><%=arr[2]%></span>
                                            </a>
                                        </div>
                                        <%}}%>  
                                    </div>
                                </div>
                            </div>
                        </div>
						  <!-- 安全文化 end-->
						<%
						List tpmyd=new ArrayList();
						//获取TPM园地园地
						tpmyd=gpInfo.getInfo("22479",orgId,8);
						%>
                        <div class="wh-portal-info-box height-4">
                            <div class="wh-portal-tools">
                                <i class="fa fa-more-a">
								<a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=22479&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">MORE >></a></i>
                            </div>
                            <div class="wh-portal-info">
                                <div class="wh-portal-i-title clearfix">
                                    <ul class="wh-portal-i-title-left clearfix">
                                        <li class="wh-portal-title-li  on"><a href="javascript:void(0);">TPM园地</a></li>
                                    </ul>
                                </div>
                                <div class="wh-portal-i-content">
                                    <div class="wh-portal-info-content">
									<%
									if(tpmyd!=null&&tpmyd.size()>0){
										for(int i=0;i<tpmyd.size();i++){
											String [] arr=(String [])tpmyd.get(i);
									%>
                                        <div class="wh-portal-i-item clearfix">
                                            <a href="javascript:void(0)" >
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
												 <span class="wh-pending-time"><%=arr[2]%></span>
                                            </a>
                                        </div>
                                        <%}}%>  
                                    </div>
                                </div>
                            </div>
                        </div>
                    </td>
                    <td width="42%" class="portal-column-td" zone="B">
                        <!-- 冷轧公司会议通知  -->
						<%
						List hytzlz=new ArrayList();
						WebIndexSggfBD webIndexSggfBD=new WebIndexSggfBD();
						List hytzgf=new ArrayList();
						//获取会议通知
						hytzlz=gpInfo.getInfo("21477",orgId,6);
						hytzgf=webIndexSggfBD.getInfoHytz(6);
						%>
                        <div class="wh-portal-info-box height-1">
                            <div class="wh-portal-tools">
                                <i class="fa fa-more-a">
								<a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21477&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">MORE >></a></i>
                            </div>
                            <div class="wh-portal-info">
                                <div class="wh-portal-i-title clearfix">
                                    <ul class="wh-portal-i-title-left wh-portal-title-slide02 clearfix">
                                        <li class="wh-portal-title-li on"><a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21477&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">冷轧公司会议通知</a></li>
                                        <li class="wh-portal-title-li"><a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/WebIndexSggfBD!getInfoListHytz.action?type=sylz&channelId=21510&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">股份公司会议通知</a></li>
                                    </ul>
                                </div>
                                <div class="wh-portal-i-content">
                                    <div class="wh-portal-info-content">
                                        <div class="wh-portal-slide02">
                                            <ul class="clearfix">
                                                <li>
													<%
													if(hytzlz!=null&&hytzlz.size()>0){
														for(int i=0;i<hytzlz.size();i++){
															String [] arr=(String [])hytzlz.get(i);
														%>
                                                    <div class="wh-portal-i-item clearfix">
                                                        <a href="javascript:void(0)" >
                                                            <i class="fa fa-file-o"></i>
                                                            <span class="title-aa" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
                                                            <span class="wh-pending-time"><%=arr[2]%></span>
                                                        </a>
                                                    </div>    
													<%}}%>													
                                                </li>
                                                <li class="wh-portal-hidden" style="display:none;">
													<%
													if(hytzgf!=null&&hytzgf.size()>0){
														for(int i=0;i<hytzgf.size()&&i<6;i++){
															String [] arr=(String [])hytzgf.get(i);
														%>
                                                    <div class="wh-portal-i-item clearfix">
                                                        <a href="javascript:void(0)" >
                                                            <i class="fa fa-file-o"></i>
                                                            <span class="title-aa" title='<%=arr[12]%><%=arr[1]%>' onclick="meetDetailView('<%=arr[0]%>');"><%=arr[12]%></span>
                                                            <span class="wh-pending-time"><%=arr[1]%></span>
                                                        </a>
                                                    </div>
													<%}}%>  
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>


                      

                        <!-- 公文公告 -->
						<%
						List gwgg=new ArrayList();
						List hyjy=new ArrayList();
						List db=new ArrayList();
						List zbb=new ArrayList();
						//获取公文公告
						gwgg=gpInfo.getInfo("42928",orgId,6);
						hyjy=gpInfo.getInfo("22058",orgId,6);
						db=gpInfo.getInfo("22125",orgId,6);
						zbb=gpInfo.getInfo("22148",orgId,6);
						%>
                        <div class="wh-portal-info-box height-2">
                            <div class="wh-portal-tools">
                                <i class="fa fa-more-a">
								<a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=42928&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">MORE >></a></i>
                            </div>
                            <div class="wh-portal-info">
                                <div class="wh-portal-i-title clearfix">
                                    <ul class="wh-portal-i-title-left wh-portal-title-slide03 clearfix">
                                        <li class="wh-portal-title-li on"><a href="javascript:void(0);">公文公告</a></li>
                                        <li class="wh-portal-title-li"><a href="javascript:void(0);">会议纪要</a></li>
                                        <li class="wh-portal-title-li"><a href="javascript:void(0);">督办</a></li>
                                        <li class="wh-portal-title-li"><a href="javascript:void(0);">值班表/通讯录</a></li>
                                    </ul>
                                </div>
                                <div class="wh-portal-i-content">
                                    <div class="wh-portal-info-content">
                                        <div class="wh-portal-slide03">
                                            <ul class="clearfix">
                                                <li>
												<%
													if(gwgg!=null&&gwgg.size()>0){
														for(int i=0;i<gwgg.size();i++){
															String [] arr=(String [])gwgg.get(i);
														%>
                                                    <div class="wh-portal-i-item clearfix">
                                                        <a href="javascript:void(0)" >
                                                            <i class="fa fa-file-o"></i>
                                                            <font>[<%=arr[7]%>]</font>
                                                            <span class="title-aa" style="width:53%" title='[<%=arr[7]%>]<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
                                                            <span class="wh-pending-time"><%=arr[2]%></span>
                                                        </a>
                                                    </div>
                                                    <%}}%>  
                                                </li>
                                                <li class="wh-portal-hidden" style="display: none;">
												<%
													if(hyjy!=null&&hyjy.size()>0){
														for(int i=0;i<hyjy.size();i++){
															String [] arr=(String [])hyjy.get(i);
														%>
                                                    <div class="wh-portal-i-item clearfix">
                                                        <a href="javascript:void(0)" >
                                                            <i class="fa fa-file-o"></i>
                                                            <font>[<%=arr[7]%>]</font>
                                                            <span class="title-aa" style="width:53%" title='[<%=arr[7]%>]<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
                                                            <span class="wh-pending-time"><%=arr[2]%></span>
                                                        </a>
                                                    </div>
                                                   <%}}%>  
                                                </li>
                                                <li class="wh-portal-hidden" style="display: none;">
												<%
													if(db!=null&&db.size()>0){
														for(int i=0;i<db.size();i++){
															String [] arr=(String [])db.get(i);
														%>
                                                    <div class="wh-portal-i-item clearfix">
                                                        <a href="javascript:void(0)" >
                                                            <i class="fa fa-file-o"></i>
                                                            <font>[<%=arr[7]%>]</font>
                                                            <span class="title-aa" style="width:53%" title='[<%=arr[7]%>]<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
                                                            <span class="wh-pending-time"><%=arr[2]%></span>
                                                        </a>
                                                    </div>
                                                   <%}}%>  
                                                </li>
                                                <li class="wh-portal-hidden" style="display: none;">
												<%
													if(zbb!=null&&zbb.size()>0){
														for(int i=0;i<zbb.size();i++){
															String [] arr=(String [])zbb.get(i);
														%>
                                                    <div class="wh-portal-i-item clearfix">
                                                        <a href="javascript:void(0)" >
                                                            <i class="fa fa-file-o"></i>
                                                            <font>[<%=arr[7]%>]</font>
                                                            <span class="title-aa" style="width:53%" title='[<%=arr[7]%>]<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
                                                            <span class="wh-pending-time"><%=arr[2]%></span>
                                                        </a>
                                                    </div>
                                                     <%}}%>  
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
						<!--公文公告-->
						<!--生产日计划 start -->
						<%
						List scrjh=new ArrayList();
						//获取生产日计划
						scrjh=gpInfo.getInfo("23713",orgId,6);
						%>
                        <div class="wh-portal-info-box height-2">
                            <div class="wh-portal-tools">
                                <i class="fa fa-more-a">
								<a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=23713&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">MORE >></a></i>
                            </div>
                            <div class="wh-portal-info">
                                <div class="wh-portal-i-title clearfix">
                                    <ul class="wh-portal-i-title-left clearfix">
                                        <li class="wh-portal-title-li  on"><a href="javascript:void(0);">生产日计划</a></li>
                                    </ul>
                                </div>
                                <div class="wh-portal-i-content">
                                    <div class="wh-portal-info-content">
									<%
									if(scrjh!=null&&scrjh.size()>0){
										for(int i=0;i<scrjh.size();i++){
											String [] arr=(String [])scrjh.get(i);
									%>
                                        <div class="wh-portal-i-item clearfix">
                                            <a href="javascript:void(0)" >
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
												 <span class="wh-pending-time"><%=arr[2]%></span>
                                            </a>
                                        </div>
                                        <%}}%>  
                                    </div>
                                </div>
                            </div>
                        </div>
						<!--生产日计划 end -->
						  <!-- 冷轧新闻 -->
						<%
						List lzxw=new ArrayList();
						List gfxw=new ArrayList();
						List lzxwp=new ArrayList();
						List gfxwp=new ArrayList();
						//冷轧新闻
						lzxw=gpInfo.getInfo("22452",orgId,9);
						//gfxw=gpInfo.getInfo("22462",orgId,9);
						gfxw=gpInfo.getInfo("23683",orgId,9);
						lzxwp=gpInfo.getNewsPH("22452",orgId,3);
						gfxwp=gpInfo.getNewsPH("23683",orgId,3);
						%>
                        <div class="wh-portal-info-box height-5">
						 <div class="wh-portal-tools">
                                <i class="fa fa-more-a">
								<a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=22452&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">MORE >></a></i>
                            </div>
                            <div class="wh-portal-info">
                                <div class="wh-portal-i-title clearfix">
                                    <ul class="wh-portal-i-title-left wh-portal-title-slide04 clearfix">
                                        <li class="wh-portal-title-li"><a href="javascript:void(0);">冷轧新闻</a></li>
                                        <li class="wh-portal-title-li on"><a href="javascript:void(0);">股份新闻</a></li>
                                    </ul>
                                </div>
                                <div class="wh-portal-i-content">
                                    <div class="wh-portal-info-content">
                                        <div class="wh-portal-slide04">
                                            <ul class="clearfix">
                                                <li>
                                                    <div class="wh-portal-info-content">
                                                        <div class="slideBox_a" id="slideBox_2">
                                                            <div class="hd">
                                                                <ul>
																<%
																if(lzxwp!=null&&lzxwp.size()>0){
																	for(int i=1;i<lzxwp.size()+1;i++){
																	%>
                                                                    <li <%if(i==1){%>class="on"<%}else{%>class=""<%}%>><%=i%></li>
																	<%}}%>  
                                                                    
                                                                </ul>
                                                            </div>
                                                            <div class="bd">
                                                                <ul>
																<%
																if(lzxwp!=null&&lzxwp.size()>0){
																	for(int i=0;i<lzxwp.size();i++){
																		String [] arr=(String [])lzxwp.get(i);
																		String infoPicSaveName =arr[8]==null?"":arr[8];
																		if(!"".equals(infoPicSaveName)){
																			String[] imgs = infoPicSaveName.split("\\|");
																			String img2 =imgs[0];
																			String realSrcUrl = preUrl+"/upload/"+path+"/"+img2;
																			String smallName = img2.substring(0,img2.lastIndexOf("."))+"_small"+img2.substring(img2.indexOf("."),img2.length());
																			String smallSrcUrl = preUrl+"/upload/"+path+"/"+smallName;
																			java.io.File file2 = new java.io.File(realSrcUrl);
																			if(!file2.exists()){
																				realSrcUrl = preUrl+"/upload/"+path+"/"+img2.substring(0,6)+"/"+img2;
																				smallSrcUrl = preUrl+"/upload/"+path+"/"+img2.substring(0,6)+"/"+smallName;
																			}
																		
																	%>
                                                                    <li <%if(i==0){%>style="display: list-item;"<%}else{%>style="display: none;"<%}%>>
                                                                        <a href="javascript:void(0)" title='<%=arr[1]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});">
                                                                            <img src="<%=smallSrcUrl%>">
                                                                            <p><%=arr[1]%></p>
                                                                        </a>
                                                                    </li>
															<%}}}%>  
                                                                
                                                                </ul>
                                                            </div>
                                                            <!-- 下面是前/后按钮代码，如果不需要删除即可 -->
                                                            <a class="prev" href="javascript:void(0)"></a>
                                                            <a class="next" href="javascript:void(0)"></a>
                                                        </div>
                                                        <div class="newsbox">
                                                           <%
													if(lzxw!=null&&lzxw.size()>0){
														for(int i=0;i<lzxw.size();i++){
															String [] arr=(String [])lzxw.get(i);
														%>
                                                            <div class="wh-portal-i-item clearfix">
                                                                <a href="javascript:void(0)">
                                                                    <i class="fa fa-file-o"></i>
                                                                    <span class="title-aa" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
                                                                    <span class="wh-pending-time"><%=arr[2]%></span>
                                                                </a>
                                                            </div>
															 <%}}%>  
                                                        </div>
                                                    </div>
                                                </li>
                                                <li class="wh-portal-hidden" style="display:none;">
                                                    <div class="wh-portal-info-content">
                                                        <div class="slideBox_a" id="slideBox_1">
                                                            <div class="hd">
                                                                <ul>
                                                                  <%
																if(gfxwp!=null&&gfxwp.size()>0){
																	for(int i=1;i<gfxwp.size()+1;i++){
																	%>
                                                                    <li <%if(i==1){%>class="on"<%}else{%>class=""<%}%>><%=i%></li>
																	<%}}%> 
                                                                </ul>
                                                            </div>
                                                            <div class="bd">
                                                                <ul>
                                                                   <%
																if(gfxwp!=null&&gfxwp.size()>0){
																	for(int i=0;i<gfxwp.size();i++){
																		String [] arr=(String [])gfxwp.get(i);
																		String infoPicSaveName =arr[8]==null?"":arr[8];
																		if(!"".equals(infoPicSaveName)){
																			String[] imgs = infoPicSaveName.split("\\|");
																			String img2 =imgs[0];
																			String realSrcUrl = preUrl+"/upload/"+path+"/"+img2;
																			String smallName = img2.substring(0,img2.lastIndexOf("."))+"_small"+img2.substring(img2.indexOf("."),img2.length());
																			String smallSrcUrl = preUrl+"/upload/"+path+"/"+smallName;
																			java.io.File file2 = new java.io.File(realSrcUrl);
																			if(!file2.exists()){
																				realSrcUrl = preUrl+"/upload/"+path+"/"+img2.substring(0,6)+"/"+img2;
																				smallSrcUrl = preUrl+"/upload/"+path+"/"+img2.substring(0,6)+"/"+smallName;
																			}
																		
																	%>
                                                                    <li <%if(i==0){%>style="display: list-item;"<%}else{%>style="display: none;"<%}%>>
                                                                        <a href="javascript:void(0)" title='<%=arr[1]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});">
                                                                            <img src="<%=smallSrcUrl%>">
                                                                            <p><%=arr[1]%></p>
                                                                        </a>
                                                                    </li>
															<%}}}%>  
                                                                </ul>
                                                            </div>
                                                            <!-- 下面是前/后按钮代码，如果不需要删除即可 -->
                                                            <a class="prev" href="javascript:void(0)"></a>
                                                            <a class="next" href="javascript:void(0)"></a>
                                                        </div>
                                                        <div class="newsbox">
														<%
													if(gfxw!=null&&gfxw.size()>0){
														for(int i=0;i<gfxw.size();i++){
															String [] arr=(String [])gfxw.get(i);
														%>
                                                            <div class="wh-portal-i-item clearfix">
                                                                <a href="javascript:void(0)">
                                                                    <i class="fa fa-file-o"></i>
                                                                    <span class="title-aa" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
                                                                    <span class="wh-pending-time"><%=arr[2]%></span>
                                                                </a>
                                                            </div>
                                                            <%}}%>  
                                                           
                                                        </div>
                                                    </div>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
						<!-- 新闻 -->
						
                    </td>
                    <td width="29%" class="portal-column-td" zone="C">
                        <!-- 登录 -->
                        <div class="wh-portal-info-box height-1">
                            <div class="wh-portal-info">
                                <div class="wh-portal-i-title clearfix">
                                    <ul class="wh-portal-i-title-left clearfix">
                                        <li class="wh-portal-title-li on"><a  style="font-weight: bold;">用户登录</a></li>
                                    </ul>
                                </div>
                                <div class="wh-portal-i-content" id="loginDiv" style="display: block;">
                                    <div class="login-box">
                                        <div class="login-contact">
										 <form action="LogonActionBF!logon.action" method="post" name=LogonForm target="_parent">
											<input type="hidden" name="random_form" value=<%=random%>></input>
											<input type="hidden" name="type" value="sylz" />
											<p class="before-username clearfix" style="DISPLAY: none">
												<INPUT type="text" id="domainAccount" value="whir" name="domainAccount" class="textstyle" />
											</p>
                                            <p class="before-username clearfix">
                                                <label class="fl"><img src="../defaultroot/images/ver113/shougang/icon06.png"></label>
                                                <input type="text" name="userAccount" id="userAccount" class="fr" />
                                            </p>
                                            <p class="before-password clearfix">
                                                <label class="fl"><img src="../defaultroot/images/ver113/shougang/icon07.png"></label>
                                                <input type="password" name="userPassword" id="userPassword" class="fr" autocomplete="off" />
												 <input type="hidden" id="userPasswordTemp" name="userPasswordTemp"/>
												 <input type="hidden" id="time" name="time"/>
                                            </p>
											 <%if("1".equals(useCaptcha)||(inputPwdErrorNum>2 && "2".equals(useCaptcha))){%>
												 <p class="before-password clearfix">
													<input type="text" name="captchaAnswer" id="captchaAnswer" class="image" style="width:60%;" value=""/>
													<img id="yzm" src="<%=rootPath%>/captcha.png" onclick="document.getElementById('yzm').src='<%=rootPath%>/captcha.png?'+new Date().getTime();">
												</p>
											<%}%>
                                            <p class="remember">
												<em class="rebp fl" id="isRememberEm" name="isRememberEm" value="1" onclick="javascript:mychecked();">
													<span></span>记住密码</em>
											   <input type="hidden" id="isRemember" name="isRemember" value="0">
											   <input type="button" class="dl fr" value="登录" onclick="javascript:submitForm();">
                                            </p>
											</form>
                                        </div>
										
                                    </div>
                                    <ul class="others clearfix">
                                        <li><a onclick="javascript:change(0);">扫描二维码</a></li>
                                        <li><a target="_blank" href="/defaultroot/public/edit/logindownload/Logindownload.jsp?fileName=activex.msi">控件安装</a></li>
                                        <li><a target="_blank" href="/defaultroot/help/help_set.html">设置帮助</a></li>
                                    </ul>
                                </div>
								 <div class="wh-portal-i-content" id="ewmDiv"  style="display: none;">
									<div>
									<i><a href="javascript:void(0);" onclick="javascript:change(1);" style="color:red">&lt;&lt;返回</a></i></div>
									<div>
										<!-- 遍历二维码 -->
											<%
											if(ewmArr!=null && ewmNameArr != null){
												int ewmSize = ewmArr.length;
												int ewmNameSize = ewmNameArr.length;
												int picsize = 0;
												if(ewmSize >= ewmNameSize){
													picsize = ewmNameSize;
												}else{
													picsize = ewmSize;
												}
												//for(int i=0;i< picsize ;i++){
											%>
												<img src="<%=fileServer+"/upload/loginpage/"+ewmArr[0].substring(0,6)+"/"+ewmArr[0]%>" style="" />
												 <p align="center"><%=ewmNameArr[0] %></p>										
												
											<%  //}
											}else{
											%>
												
											<%}%>
										</ul>
									</div>
								</div>
                                <script type="text/javascript">
								document.onkeydown=function(e){ 
									var theEvent = window.event || e; 
									var code = theEvent.keyCode || theEvent.which; 
									if (code == 13) { 
										submitForm();
									} 
								} 
								
								function load(){
									//去除原来下拉框的设置
									
									loadCookie();
									
									//	document.LogonForm.userPassword.focus();
									
								}
								
								window.onload = function (e) {
									load();

									checkBrowser();
								}
								
								function change(i){
									if(i==0){
										$("#loginDiv").attr("style","display: none;");
                                        document.getElementById("isRememberEm").style.display="none";
                                       //$("#isRememberEm").attr("style","display: none;");
										$("#ewmDiv").attr("style","display: block;");
                                        
									}else{
										$("#ewmDiv").attr("style","display: none;");
										$("#loginDiv").attr("style","display: block;");
                                        //$("#isRememberEm").attr("style","display: block;");
                                         document.getElementById("isRememberEm").style.display="block";
									}
								}
								
								function mychecked(obj){
									var classem=$("#isRememberEm").attr("class");
									if(classem=="rebp fl open"){
										document.getElementById("isRemember").value= "0";
									}else{
										document.getElementById("isRemember").value= "1";
									}
								}
															
								function checkForm(){
								  //需要对隐藏域重新赋值
								  $("#localeCode").val("<%=localeCode%>");	
								 if(document.LogonForm.userAccount.value==""){
									whir_alert("<%=Resource.getValue(localeCode,"common","comm.loginremind4")%>", function(){
										document.LogonForm.userAccount.focus();
										return false;
									});

									document.LogonForm.userAccount.focus();
									
									return false;
								}else if( document.LogonForm.userPassword.value==""){
									whir_alert("<%=Resource.getValue(localeCode,"common","comm.loginremind5")%>", function(){
										document.LogonForm.userPassword.focus();
										return false;
									});

									document.LogonForm.userPassword.focus();
									
									return false;
								}
								 var captchaAnswer = $('#captchaAnswer').val();
								 if(captchaAnswer==""){
									 whir_alert("<%=Resource.getValue(localeCode,"common","comm.captchawrongNull")%>", function(){
										document.LogonForm.captchaAnswer.focus();
										return false;
									});
									  document.LogonForm.captchaAnswer.focus();
										return false;
								 }
								
								return true;
							}
                                </script>
                            </div>
                        </div>
                        <!-- 安全动态 -->
						<%
						List aqdt=new ArrayList();
						List rlzy=new ArrayList();
						List xzhq=new ArrayList();
						//获取公文公告
						aqdt=gpInfo.getInfo("22285",orgId,6);
						rlzy=gpInfo.getInfo("22287",orgId,6);
						xzhq=gpInfo.getInfo("22289",orgId,6);
						%>
                        <div class="wh-portal-info-box height-2">
                            <div class="wh-portal-tools">
                                <i class="fa fa-more-a">
								<a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=22285&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">MORE >></a></i>
                            </div>
                            <div class="wh-portal-info">
                                <div class="wh-portal-i-title clearfix">
                                    <ul class="wh-portal-i-title-left wh-portal-title-slide05 clearfix">
                                        <li class="wh-portal-title-li on"><a href="javascript:void(0);">安全动态</a></li>
                                        <li class="wh-portal-title-li"><a href="javascript:void(0);">人力资源</a></li>
                                        <li class="wh-portal-title-li"><a href="javascript:void(0);">行政后勤</a></li>
                                    </ul>
                                </div>
                                <div class="wh-portal-i-content">
                                    <div class="wh-portal-info-content">
                                        <div class="wh-portal-slide05">
                                            <ul class="clearfix">
                                                <li style="display: list-item;">
												<%
													if(aqdt!=null&&aqdt.size()>0){
														for(int i=0;i<aqdt.size();i++){
															String [] arr=(String [])aqdt.get(i);
														%>
                                                    <div class="wh-portal-i-item clearfix">
                                                        <a href="javascript:void(0)"> 
                                                            <i class="fa fa-file-o"></i>
                                                            <span class="title-aa"  title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
                                                            <span class="wh-pending-time"><%=arr[2]%></span>
                                                        </a>
                                                    </div>
													<%}}%>
                                                </li>
												
                                                <li class="wh-portal-hidden" style="display: none;">
													<%
													if(rlzy!=null&&rlzy.size()>0){
														for(int i=0;i<rlzy.size();i++){
															String [] arr=(String [])rlzy.get(i);
														%>
                                                    <div class="wh-portal-i-item clearfix">
                                                        <a href="javascript:void(0)">
                                                            <i class="fa fa-file-o"></i>
                                                            <span class="title-aa" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
                                                            <span class="wh-pending-time"><%=arr[2]%></span>
                                                        </a>
                                                    </div>
                                                   <%}}%>
                                                </li>
												<li class="wh-portal-hidden" style="display:  none;">
												<%
													if(xzhq!=null&&xzhq.size()>0){
														for(int i=0;i<xzhq.size();i++){
															String [] arr=(String [])xzhq.get(i);
														%>
                                                    <div class="wh-portal-i-item clearfix">
                                                        <a href="javascript:void(0)">
                                                            <i class="fa fa-file-o"></i>
                                                            <span class="title-aa" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
                                                            <span class="wh-pending-time"><%=arr[2]%></span>
                                                        </a>
                                                    </div>
                                                   <%}}%>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- 质量异议及抱怨 -->
						<%
						List zlyy=new ArrayList();	
						List rqrj=new ArrayList();
						//获取质量异议及抱怨
						zlyy=gpInfo.getInfo("43464",orgId,6);
						rqrj=gpInfo.getInfo("364064",orgId,6);
						%>
                        <div class="wh-portal-info-box line-height-1 height-6" >
                            <div class="wh-portal-tools">
                                <i class="fa fa-more-a">
								<a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=43464&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">MORE &gt;&gt;</a></i>
                            </div>
                            <div class="wh-portal-info">
                                <div class="wh-portal-i-title clearfix">
									<ul class="wh-portal-i-title-left wh-portal-title-slide05 clearfix">
                                        <li class="wh-portal-title-li on"><a href="javascript:void(0);">质量异议及抱怨</a></li>
                                        <li class="wh-portal-title-li"><a href="javascript:void(0);">质量日清日结</a></li>
                                    </ul>                                   
                                </div>
                                <div class="wh-portal-i-content">                            
                                    <div class="wh-portal-info-content">
                                        <div class="wh-portal-slide05">
                                            <ul class="clearfix">
                                                <li style="display: list-item;">
												<%
													if(zlyy!=null&&zlyy.size()>0){
														for(int i=0;i<zlyy.size();i++){
															String [] arr=(String [])zlyy.get(i);
													%>
                                                    <div class="wh-portal-i-item clearfix">
                                                        <a href="javascript:void(0)"> 
                                                            <i class="fa fa-file-o"></i>
                                                            <span class="title-aa"  title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
                                                            <span class="wh-pending-time"><%=arr[2]%></span>
                                                        </a>
                                                    </div>
													<%}}%>
                                                </li>
												
                                                <li class="wh-portal-hidden" style="display: none;">
													<%
													if(rqrj!=null&&rqrj.size()>0){
														for(int i=0;i<rqrj.size();i++){
															String [] arr=(String [])rqrj.get(i);
														%>
                                                    <div class="wh-portal-i-item clearfix">
                                                        <a href="javascript:void(0)">
                                                            <i class="fa fa-file-o"></i>
                                                            <span class="title-aa" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
                                                            <span class="wh-pending-time"><%=arr[2]%></span>
                                                        </a>
                                                    </div>
                                                   <%}}%>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- 事故通报  -->
						<%
						List sgtb=new ArrayList();	
						//获取事故通报
						sgtb=gpInfo.getInfo("22471",orgId,6);
						%>
                        <div class="wh-portal-info-box line-height-1 height-7">
                            <div class="wh-portal-tools">
                                <i class="fa fa-more-a">
								<a href="javascript:void(0);" onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=22471&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">MORE &gt;&gt;</a></i>
                            </div>
                            <div class="wh-portal-info">
                                <div class="wh-portal-i-title clearfix">
                                    <ul class="wh-portal-i-title-left clearfix">
                                        <li class="wh-portal-title-li  on"><a href="javascript:void(0);">事故通报</a></li>
                                    </ul>
                                </div>
                                <div class="wh-portal-i-content">
                                    <div class="wh-portal-info-content">
									<%
										if(sgtb!=null&&sgtb.size()>0){
											for(int i=0;i<sgtb.size();i++){
												String [] arr=(String [])sgtb.get(i);
										%>
                                        <div class="wh-portal-i-item clearfix">
                                            <a href="javascript:void(0)">
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});"><%=arr[1]%></span>
                                                <span class="wh-pending-time"><%=arr[2]%></span>
                                            </a>
                                        </div>
                                          <%}}%>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- 常用链接  -->
                        <div class="wh-portal-info-box ">              
							 <div class="wh-portal-tools">
                                <i class="fa fa-more-a">
								<a href="javascript:void(0);" onclick="checklink();">MORE &gt;&gt;</a></i>
                            </div>
                            <div class="wh-portal-info">
                                <div class="wh-portal-i-title clearfix">
                                    <ul class="wh-portal-i-title-left clearfix">
                                        <li class="wh-portal-title-li on"><a href="javascript:void(0);">常用链接</a></li>
                                    </ul>
                                </div>
								<input type="hidden" id="linkin" value="0" />
                                <div class="wh-portal-i-content" style="display;block;" id="link1">
                                    <div class="wh-portal-info-content">
                                        <div class="before-link">
                                            <ul>
                                                <li>
                                                    <a href="http://192.168.139.38/coremail/" target="_blank"><img src="../defaultroot/images/ver113/shougang/icon02.png"><em>邮件系统</em></a>
                                                </li>
                                                <li>
                                                    <a href="http://10.4.55.80:7001/mes-wtm-app/" target="_blank"><img src="../defaultroot/images/ver113/shougang/icon03.png"><em>新仓储系统</em></a>
                                                </li>
                                                <li>
                                                    <a href="http://192.168.100.10:8080/webmanage" target="_blank"><img src="../defaultroot/images/ver113/shougang/icon04.png"><em>安全生产预警系统</em></a>
                                                </li>
                                                <li>
                                                    <a href="http://10.4.56.34/pes/" target="_blank"><img src="../defaultroot/images/ver113/shougang/icon05.png"><em>三级系统</em></a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
								 <div class="wh-portal-i-content" style="display;none;" id="link2" style="overflow:auto">
                                    <div class="wh-portal-info-content">
									 <div class="wh-portal-i-item clearfix">
                                            <a href="http://192.168.139.38/coremail/" target="_blank" >
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='邮件系统' >邮件系统</span>
                                            </a>
                                        </div>
										 <div class="wh-portal-i-item clearfix">
                                            <a href="http://10.4.55.80:7001/mes-wtm-app/" target="_blank" >
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='新仓储系统' >新仓储系统</span>
                                            </a>
                                        </div>
										 <div class="wh-portal-i-item clearfix">
                                            <a href="http://192.168.100.10:8080/webmanage" target="_blank" >
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='安全生产预警系统' >安全生产预警系统</span>
                                            </a>
                                        </div>
										 <div class="wh-portal-i-item clearfix">
                                            <a href="http://10.4.56.34/pes/" target="_blank" >
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='三级系统' >三级系统</span>
                                            </a>
                                        </div>
                                        <div class="wh-portal-i-item clearfix">
                                            <a href="http://10.4.56.38:8080/shunyi-oqs-app/" target="_blank" >
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='在线质量判定查询系统' >在线质量判定查询系统</span>
                                            </a>
                                        </div>
										 <div class="wh-portal-i-item clearfix">
                                            <a href="http://10.4.31.14:100/word/Admin/Admin_Login.aspx" target="_blank" >
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='控制计划系统' >控制计划系统</span>
                                            </a>
											 <a href="http://10.4.55.68:7001/mes-report-app/"  target="_blank">
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='报表平台' >报表平台</span>
                                            </a>
                                        </div>
										 <div class="wh-portal-i-item clearfix">
                                            <a href="javascript:void(0)http://10.3.247.152:7003/mes-dtm-app/" target="_blank">
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='交货期系统' >交货期系统</span>
                                            </a>
                                        </div>
										
										 <div class="wh-portal-i-item clearfix">
                                            <a href="http://10.4.55.66:8080/lims/auth/login.jsp" target="_blank">
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='LIMS检化验系统' >LIMS检化验系统</span>
                                            </a>
                                        </div> <div class="wh-portal-i-item clearfix">
                                            <a href="http://10.4.56.19/sgwm/sgwm.html"  target="_blank">
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='仓储系统' onclick="">仓储系统</span>
                                            </a>
                                        </div> <div class="wh-portal-i-item clearfix">
                                            <a href="http://jk.shougang.com.cn/"  target="_blank">
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='首钢健康管理信息网' onclick="">首钢健康管理信息网</span>
                                            </a>
                                        </div> <div class="wh-portal-i-item clearfix">
                                            <a href="http://yikatong.sg-crm.com.cn/login.jsp"  target="_blank">
                                                <i class="fa fa-file-o"></i>
                                                <span class="title-aa" title='冷轧一卡通系统' onclick="">冷轧一卡通系统</span>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <!-- footer  -->
    <div class="before-footer clearfix">
        <span>中国.首钢集团</span>Copyright © 2003 shougang.com.cn, All Rights Reserved
    </div>
    <!-- footer end  -->
    <script type="text/javascript">
    $(function() {
        //banner图切换
        $("#slideBox").slide({
            mainCell: ".bd ul",
            autoPlay: true
        });

        $("#slideBox_1").slide({
            mainCell: ".bd ul",
            autoPlay: true
        });

         $("#slideBox_2").slide({
            mainCell: ".bd ul",
            autoPlay: true
        });


        //党员学习园地  党务公开
        var $tab_li_1 = $('.wh-portal-title-slide01 li');
        $tab_li_1.hover(function() {
            $(this).addClass('on').siblings().removeClass('on');
            var index = $tab_li_1.index(this);
            $('.wh-portal-slide01 > ul > li').eq(index).show().siblings().hide();
        });


        //冷轧公司会议通知  股份公司会议通知
        var $tab_li_2 = $('.wh-portal-title-slide02 li');
        $tab_li_2.hover(function() {
            $(this).addClass('on').siblings().removeClass('on');
            var index = $tab_li_2.index(this);
            $('.wh-portal-slide02 > ul > li').eq(index).show().siblings().hide();
        });


        //冷轧公司会议通知  股份公司会议通知
        var $tab_li_3 = $('.wh-portal-title-slide03 li');
        $tab_li_3.hover(function() {
            $(this).addClass('on').siblings().removeClass('on');
            var index = $tab_li_3.index(this);
            $('.wh-portal-slide03 > ul > li').eq(index).show().siblings().hide();
        });


        //冷轧公司会议通知  股份公司会议通知
        var $tab_li_4 = $('.wh-portal-title-slide04 li');
        $tab_li_4.hover(function() {
            $(this).addClass('on').siblings().removeClass('on');
            var index = $tab_li_4.index(this);
            $('.wh-portal-slide04 > ul > li').eq(index).show().siblings().hide();
        });


        //冷轧公司会议通知  股份公司会议通知
        var $tab_li_5 = $('.wh-portal-title-slide05 li');
        $tab_li_5.hover(function() {
            $(this).addClass('on').siblings().removeClass('on');
            var index = $tab_li_5.index(this);
            $('.wh-portal-slide05 > ul > li').eq(index).show().siblings().hide();
        });




        //点击隐藏banner
        $(".close_banner span").click(function() {
            if ($(".banner").hasClass("close")) {
                $(".banner").removeClass("close");
            } else {
                $(".banner").addClass("close");
            }

            if ($(this).parent().hasClass("close")) {
                $(this).parent().removeClass("close");
            } else {
                 $(this).parent().addClass("close");
            }

        });


        //登录

        $(".login-box  .remember .rebp").click(function() {
            if ($(this).hasClass("open")) {
                $(this).removeClass("open");
            } else {
                $(this).addClass("open");
            }

        });

        $(".login-box").parent().siblings(".wh-portal-i-title").find(".wh-portal-title-li a").css({
            "font-weight": "bold"
        });
		
		//常用链接
		$("#link2").attr("style","display:none");
		$("#link1").attr("style","display:block");
    });
	
	function checklink(){
		var link=$("#linkin").val();
		if(link=="0"){
			$("#linkin").val("1");
			$("#link1").attr("style","display:none");
			$("#link2").attr("style","display:block");
		}else{
			$("#linkin").val("0");
			$("#link2").attr("style","display:none");
			$("#link1").attr("style","display:block");
		}
	}

	function  meetDetailView(id){
	layer.open({
		type: 2,
		title: '会议详情',
		shadeClose: false,
		shade: 0.8,
		area: ['1000px', '600px'],
		scrollbar: false,
		content: '/defaultroot/WebIndexSggfBD!detailMeeting.action?id='+id
	});
}

//点击空白处关闭登陆，信息详情叶
	$("body").click(function(e){
		if($(e.target).attr('class')=="layui-layer-shade"){
			layer.closeAll();
		}else if($(e.target).attr('class')=="tan-loginbox open"){
			$(".close").click();
		}else if($(e.target).attr('class')=="tan-thismonth-box open"){
			$(".thismonth-close").click();
		}
	});
    </script>
	
</body>
<script language="JavaScript">
	
$(document).ready(function() {
	var userAccount = $('#userAccount');
	userAccount.focus();
});


<%
String errorType=(String)request.getAttribute("errorType");
System.out.println("errorType============"+errorType);
if("noDog".equals(errorType)){
%>
    whir_alert("<%=Resource.getValue(localeCode,"common","comm.noDog")%>",null);
<%}else if("active".equals(errorType)){%>
    whir_alert("<%=Resource.getValue(localeCode,"common","comm.active")%>",null);
<%}else if("sleep".equals(errorType)){%>
	whir_alert("<%=Resource.getValue(localeCode,"common","comm.userIsSleep")%>",null);
<%}else if("captchaWrong".equals(errorType)){%>
	whir_alert("<%=Resource.getValue(localeCode,"common","comm.captchawrong")%>",null);
<%}else if("captchaWrongNull".equals(errorType)){%>
	whir_alert("<%=Resource.getValue(localeCode,"common","comm.captchawrongNull")%>",null);
<%}else if("resetpassword".equals(errorType)){%>
	whir_alert("<%=Resource.getValue(localeCode,"common","comm.resetpassword")%>",null);
<%}else if("ip".equals(errorType)){
    String addr=request.getRemoteAddr();
    addr=addr==null?"":"("+addr+")";
%>
    whir_alert("<%=Resource.getValue(localeCode,"common","comm.loginremind1")%>",null);
<%}else if("password".equals(errorType)
//&&!("admin".equals(userAccount)||"security".equals(userAccount))
){%>
    whir_alert("输入密码错误！",function(){
        document.LogonForm.userPassword.select();
        document.LogonForm.userPassword.value="";
        document.LogonForm.userAccount.value='<%=com.whir.component.security.crypto.EncryptUtil.htmlcode(userAccount.replaceAll("\\+|>|<|\"|'|;|%|&|\\(|\\)",""))%>';
    });
	
    
<%}else if("password".equals(errorType)&&("admin".equals(userAccount)||"security".equals(userAccount))){%>
    whir_alert("<%=Resource.getValue(localeCode,"common","comm.loginremind3")%>",function(){
        document.LogonForm.userPassword.select();
        document.LogonForm.userPassword.value="";
        document.LogonForm.userAccount.value='<%=com.whir.component.security.crypto.EncryptUtil.htmlcode(userAccount.replaceAll("\\+|>|<|\"|'|;|%|&|\\(|\\)",""))%>';
    });
<%}else if("user".equals(errorType)){%>
    whir_alert("<%=Resource.getValue(localeCode,"common","comm.loginremind2")%>",function(){
        document.LogonForm.userAccount.select();
        document.LogonForm.userAccount.value='<%=com.whir.component.security.crypto.EncryptUtil.htmlcode(userAccount.replaceAll("\\+|>|<|\"|'|;|%|&|\\(|\\)",""))%>';
        document.LogonForm.userPassword.value="";
        
    });
<%}else if("online".equals(errorType)){%>
    whir_alert("<%=Resource.getValue(localeCode,"common","comm.online")%>",null);
<%}else if("domainError".equals(errorType)){%>
	whir_alert("<%=Resource.getValue(localeCode,"common","comm.domainerror")%>",null);
<%}else if("userNumError".equals(errorType)){%>
    whir_alert("<%=Resource.getValue(localeCode,"common","comm.usernumerror")%>",null);
<%}else if("forbidUser".equals(errorType)){%>
	whir_alert("<%=Resource.getValue(localeCode,"common","comm.active")%>",null);
<%}else if("zhuyun".equals(errorType)){
   
%>
    whir_alert("用户名或密码错误！"); 
<%}
errorType=request.getParameter("errorType")==null?"":com.whir.component.security.crypto.EncryptUtil.replaceHtmlcode(request.getParameter("errorType"));
if("overtime".equals(errorType)){%>
    whir_alert("<%=Resource.getValue(localeCode,"common","comm.overtime")%>",null);
<%}else if("nokey".equals(errorType)){
	session.invalidate();
%>
    whir_alert("<%=Resource.getValue(localeCode,"common","comm.nokey")%>",null);
<%}else if("keyErr".equals(errorType)){
	session.invalidate();
%>
    whir_alert("<%=Resource.getValue(localeCode,"common","comm.keyerror")%>",null);
<%}else if("domainError".equals(errorType)){%>
    whir_alert("<%=Resource.getValue(localeCode,"common","comm.domainiderror")%>",null);
<%}else if("userNumError".equals(errorType)){%>
    whir_alert("<%=Resource.getValue(localeCode,"common","comm.domainerror")%>",null);
<%}else if("kickout".equals(errorType)){
   
%>
    whir_alert("您的账号正在另一客户端登录！"); 
<%}%>

</script>
</html>