<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
com.whir.org.common.util.SysSetupReader sysRed = SysSetupReader.getInstance();
String skin = sysRed.getBeforeLoginSkin("0");
String logoName="logo.png";
if("red".equals(skin)){
logoName="red-logo.png";
%>
<html lang="zh-cn"  class="theme-red">
<%}else{%>
<html lang="zh-cn" >
<%}%>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<%@ include file="/public/include/init.jsp"%>
<%@ page import="com.whir.rd.sggf.webindex.index.*"%>
<%@ page import="com.whir.rd.sggf.webindex.bd.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.whir.i18n.Resource" %>

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
<%@ page import="com.whir.ezoffice.portal.bd.PortalBD" %>
<%@ page import="java.util.List" %>
<%@ page import="com.whir.common.util.UploadFile"%>
<%@ page import="com.whir.ezoffice.information.infomanager.bd.*"%>

<%
String localeCode=request.getParameter("localeCode")==null?"":com.whir.component.security.crypto.EncryptUtil.replaceHtmlcode(request.getParameter("localeCode"));
if(localeCode!=null){
    com.whir.component.util.LocaleUtils.setLocale(localeCode, request);
}
String flag = request.getParameter("flag") == null?"1":request.getParameter("flag").toString();

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

String channelName = request.getAttribute("channelName")!=null?request.getAttribute("channelName").toString():"";
String orgId=request.getAttribute("orgId")!=null?request.getAttribute("orgId").toString():"";
String orgName=request.getAttribute("orgName")!=null?request.getAttribute("orgName").toString():"";
String pageCount=request.getAttribute("pageCount")!=null?request.getAttribute("pageCount").toString():"0";
String recordCount=request.getAttribute("recordCount")!=null?request.getAttribute("recordCount").toString():"0";
String currentPage=request.getAttribute("currentPage")!=null?request.getAttribute("currentPage").toString():"0";
String pageSize=request.getAttribute("pageSize")!=null?request.getAttribute("pageSize").toString():"0";
List list=(List)request.getAttribute("list");
String channelId= request.getAttribute("channelId")!=null?request.getAttribute("channelId").toString():"";
String infokeyForgzzd =  request.getAttribute("infokeyForgzzd")!=null?request.getAttribute("infokeyForgzzd").toString():"";

int cpage=Integer.parseInt(currentPage);
int ppage=Integer.parseInt(pageCount);

java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");

List orgList = new ArrayList();
WebIndexSggfBD webIndexSggfBD = new WebIndexSggfBD();
orgList = webIndexSggfBD.getOrgList();
InformationAccessoryBD accBD = new InformationAccessoryBD();

%>
<head>
    
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
	<%@ include file="/public/include/meta_base.jsp"%>
	<%@ include file="/public/include/meta_list.jsp"%>
        <title>北京首钢股份有限公司</title>
    <link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/reset.css" />
    <link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/common.css" />
    <link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/flexslider.css" />
    <link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/pro-style.css" />
    <link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/layer.css">
	<link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/red.css" />
	<%if("grey".equals(skin)){%>
	<link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/gray.css" />
	<%}%>
	<script src="<%=rootPath%>/scripts/plugins/My97DatePicker/WdatePicker.js"></script>
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
	 <script src="<%=rootPath%>/scripts/plugins/My97DatePicker/WdatePicker.js"></script>
	 <script src="<%=rootPath%>/scripts/plugins/form/jquery.form.js" type="text/javascript"></script>
	 <script src="<%=rootPath%>/scripts/plugins/jPages/js/jPages.js" type="text/javascript"></script>
	 <script type="text/javascript" src="<%=rootPath%>/pro/js/jquery.SuperSlide.2.1.1.js"></script>
    <script type="text/javascript" src="<%=rootPath%>/pro/js/jquery.flexslider.js"></script>
    <script type="text/javascript" src="<%=rootPath%>/pro/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="<%=rootPath%>/pro/js/layer.js"></script>
    <script type="text/javascript" src="<%=rootPath%>/pro/js/index.js"></script>
</head>

<body>
<!--头部公共文件-->
   <%@ include file="index_pre_header.jsp"%>
    <div class="pro-banner">
    </div>
    <div class="pro-container clearfix">
        <!--  列表页  -->
        <div class="erji clearfix">
            <div class="siderbar fl">
                <div class="title home"><a href="/defaultroot/index_pre.jsp"><span>首页</span></a></div>
                <div class="side-nav">
                    <ul>
						<li class="nav-li li_4"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23683&startPage=1&pageSize=12&orgId=<%=orgId%>"> <em></em> 新闻动态</a></li>
							<li class="nav-li li_5"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=80245&startPage=1&pageSize=12&orgId=<%=orgId%>"> <em></em> 公告信息</a></li>
							<li class="nav-li li_6"><a href="/defaultroot/WebIndexSggfBD!getInfoListHytz.action?startPage=1&pageSize=12&orgId=<%=orgId%>"> <em></em> 会议通知</a></li>
							<li class="nav-li li_7"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23656&startPage=1&pageSize=12&orgId=<%=orgId%>"> <em></em> 会议纪要</a></li>
                            <li class="nav-li li_1"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=114132&startPage=1&pageSize=12&orgId=<%=orgId%>"><em></em>规章制度</a>
                               <dl class="side-dropdown" id="dl-gzzd">
									<dd id="dd-gszd"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=240672&startPage=1&pageSize=12&orgId=<%=orgId%>">股份公司级</a></dd>
									<dd id="dd-bmbf"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=240688&startPage=1&pageSize=12&orgId=<%=orgId%>">职能部门级</a></dd>
									<dd id="dd-zybj"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=398610&startPage=1&pageSize=12&orgId=<%=orgId%>">作业部级</a></dd>
                                </dl>
                           </li>
							<li class="nav-li li_8" ><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23784&startPage=1&pageSize=12&orgId=<%=orgId%>"><em></em>廉政建设</a>
                                <dl  id="dl-lzjs">
									<dd id="dd-gzdt" ><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23790&startPage=1&pageSize=12&orgId=<%=orgId%>">工作动态</a></dd>
									<dd id="dd-jzcm" ><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23792&startPage=1&pageSize=12&orgId=<%=orgId%>">警钟长鸣</a></dd>
									<dd id="dd-djfg" ><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23794&startPage=1&pageSize=12&orgId=<%=orgId%>">党纪法规</a></dd>
									<dd id="dd-lzzd" ><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23803&startPage=1&pageSize=12&orgId=<%=orgId%>">廉政制度</a></dd>
									<dd id="dd-ffzx" ><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23811&startPage=1&pageSize=12&orgId=<%=orgId%>">反腐在线</a></dd>
									<dd id="dd-ljwh" ><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23815&startPage=1&pageSize=12&orgId=<%=orgId%>">廉洁文化</a></dd>
									<dd id="dd-xyjl" ><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23848&startPage=1&pageSize=12&orgId=<%=orgId%>">学习交流</a></dd>
								 </dl>
                           </li>
						<!--
						href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23862&startPage=1&pageSize=12&orgId=<%=orgId%>"
						-->
                        <li class="nav-li li_2"><a href="#"> <em></em> 生活服务</a>
						<dl class="side-dropdown" id="dl-shfu">
								<dd id="dd-bcxx"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23864&startPage=1&pageSize=12&orgId=<%=orgId%>">班车信息</a></dd>
								<dd id="dd-cqxmb"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=349413&startPage=1&pageSize=12&orgId=<%=orgId%>">厂区小卖部</a></dd>
								<dd id="dd-gzcsp"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23868&startPage=1&pageSize=12&orgId=<%=orgId%>">工作餐食谱</a></dd>
								<dd id="dd-gxx"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23872&startPage=1&pageSize=12&orgId=<%=orgId%>">感谢信</a></dd>
								<dd id="dd-xwqs"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23876&startPage=1&pageSize=12&orgId=<%=orgId%>">寻物启事</a></dd>
								<dd id="dd-swzl"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23878&startPage=1&pageSize=12&orgId=<%=orgId%>">失物招领</a></dd>
								<dd id="dd-zbxx"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=305767&startPage=1&pageSize=12&orgId=<%=orgId%>" title="办公室生活服务单位值班信息">办公室生活服...</a></dd>

								
							</dl>
						</li>
						<!--
						href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=24119&startPage=1&pageSize=12&orgId=<%=orgId%>"
						-->
						<li class="nav-li li_3"><a href="#"> <em></em> 专题专栏</a>
						<dl class="side-dropdown" id="dl-ztzl">
								<dd id="dd-szbg"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=24198&startPage=1&pageSize=12&orgId=<%=orgId%>">述职报告</a></dd>
								<dd id="dd-lxyz"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=24127&startPage=1&pageSize=12&orgId=<%=orgId%>">两学一做</a></dd>
								<dd id="dd-ztzl"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=92337&startPage=1&pageSize=12&orgId=<%=orgId%>">人大代表选举</a></dd>
								<dd id="dd-ztzl"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=882271&startPage=1&pageSize=12&orgId=<%=orgId%>">首钢股份电视新闻</a></dd>
								<dd id="dd-lhrh"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=24202&startPage=1&pageSize=12&orgId=<%=orgId%>">两化融合 管理体系</a></dd>
								<dd id="dd-ldgb"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=24208&startPage=1&pageSize=12&orgId=<%=orgId%>">领导干部大讲坛</a></dd>
								<dd id="dd-ldgb"><a title="美铝安全管理经验推广" href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=930252&startPage=1&pageSize=12&orgId=<%=orgId%>">美铝安全管理...</a></dd>
								<dd id="dd-qysc"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23907&startPage=1&pageSize=12&orgId=<%=orgId%>">全员生产保全</a></dd>
							</dl>
						</li>
							
                        <!--<li class="nav-li li_3"><a href="# "> <em></em> 图片新闻</a></li>-->
                    </ul>
                </div>
            </div>
            <div class="erji-fr-box fr">
                <div class="erji-fr fr">
                    <div class="location clearfix">
                        <p>您当前的位置：<a href="/defaultroot/index_pre.jsp">首页</a><i>&gt;</i><%if("240672".equals(channelId)||"240688".equals(channelId) || "398610".equals(channelId) ){%>
						<a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=114132&startPage=1&pageSize=12&orgId=<%=orgId%>">规章制度</a>&nbsp;>&nbsp;
						<%}else if("23864".equals(channelId)||"23868".equals(channelId)||"23872".equals(channelId)||"23876".equals(channelId)||"23878".equals(channelId)||"305767".equals(channelId)||"349413".equals(channelId)||"783170".equals(channelId)||"783147".equals(channelId)){%>
						<a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23862&startPage=1&pageSize=12&orgId=<%=orgId%>">生活服务</a>&nbsp;>&nbsp;
						<%}else if("24127".equals(channelId)||"92337".equals(channelId)||"24198".equals(channelId)||"24202".equals(channelId)||"24208".equals(channelId)||"930252".equals(channelId)||"882271".equals(channelId)||"23907".equals(channelId)){%>
						<a href="#">专题专栏</a>&nbsp;>&nbsp;
						<%}else if("23790".equals(channelId)||"23792".equals(channelId)||"23794".equals(channelId)||"23803".equals(channelId)||"23811".equals(channelId)||"23815".equals(channelId)||"23848".equals(channelId)){%>
						<a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23784&startPage=1&pageSize=12&orgId=<%=orgId%>">廉政建设</a>&nbsp;>&nbsp;
						<%}%>
						<%if("783170".equals(channelId)||"783147".equals(channelId)){%>
						班车信息
						<%}else if("305767".equals(channelId)){%>
						<span title="办公室生活服务单位值班信息" style="font-size:16px;">办公室生活服务...</span>
						<%}else{%>
						<%=channelName%>
						<%}%>
						<%if("114132".equals(channelId)){%>
						<input type="textarea" class="search-text" id="infokeyForgzzd" name="infokeyForgzzd" value="请输入文字" onfocus="this.value=''" onblur="if(this.value==''){this.value='请输入文字'}">
						<%}%>
						</p>
						<%if("会议通知".equals(channelName)){%>
						 <div class="aa-fenlei" style="margin: -5px 0 10px 0;position:absolute;top:32px;right:12px;width:auto;">
                            <a href="javascript:void(0);"   onclick="searchInfo(1,1)" <%if("1".equals(flag)){%>class="on"<%}%> >按发布时间排序</a>
                            <a href="javascript:void(0);"   onclick="searchInfo(2,1)" <%if("2".equals(flag)){%>class="on"<%}%> >按开会时间排序</a>
                        </div>	
						<%}else{%>
						 <div class="aa-fenlei" style="margin: -5px 0 10px 0;position:absolute;top:32px;right:12px;width:auto;">
                            <a href="javascript:void(0);"   onclick="searchInfo(2,2)" <%if("2".equals(flag)){%>class="on"<%}%> >按发布时间正序</a>
                            <a href="javascript:void(0);"   onclick="searchInfo(1,2)" <%if("1".equals(flag)){%>class="on"<%}%> >按发布时间倒序</a>
                        </div>				
						<%}%>
						


                    </div>
					
                    <div class="news-list">
					<form name="queryForm" id="queryForm" action="/defaultroot/BeforeInfoAction!getInformationListBF.action" onkeydown="if(event.keyCode==13)return false;" method="post" >
						<input name="type" id="type" type="hidden" value="gfgs"/>
						<input name="channelId" id="channelId" type="hidden" value="<%=channelId%>"/>
						<input name="startPage" id="startPage" type="hidden" value="1"/>
						<input name="orgId" id="orgId" type="hidden" value="<%=orgId%>"/>
						<input name="pageSize" id="pageSize" type="hidden" value="<%=pageSize%>"/>
						<div class="whir_td_searchinput" style="margin-top: -45px;">
							<select id="orgName" name="orgName" value="" style="text-align: left;border-radius: 5px;height: 30px;list-style: 30px;padding: 3px 1px 5px 0;width: 134px;position: relative;left: 420px;top: -11px;">
								<option value="" selected="">---请选择部门---</option>
								<%if(orgList.size()>0){
								for(int i=0;i<orgList.size();i++){
									String [] arr = (String[])orgList.get(i);
								%>
								<option value="<%=arr[0]+";"+arr[1]%>" >&nbsp;<%=arr[1]%></option>
								<%}}%>
							</select>
					   </div>
					   <%if("23864".equals(channelId)||"783170".equals(channelId)||"783147".equals(channelId)){%>
					    <div class="aa-fenlei">
                            <a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=783170&startPage=1&pageSize=12&orgId=<%=orgId%>" <%if("783170".equals(channelId)){%>class="on"<%}%> >长途班车日乘车信息</a>
                            <a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=783147&startPage=1&pageSize=12&orgId=<%=orgId%>" <%if("783147".equals(channelId)){%>class="on"<%}%> >长途班车月运行顺序表</a>
                       </div>
					   <%}%>
					    <%if("24198".equals(channelId)||"960628".equals(channelId)||"960639".equals(channelId)){%>
					    <div class="aa-fenlei">
                            <a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=960628&startPage=1&pageSize=12&orgId=<%=orgId%>" <%if("960628".equals(channelId)){%>class="on"<%}%> >公司领导班子述职报告</a>
                            <a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=960639&startPage=1&pageSize=12&orgId=<%=orgId%>" <%if("960639".equals(channelId)){%>class="on"<%}%> >公司领导述职报告</a>
                       </div>
					   <%}%>
						<table border="0" align="center" cellpadding="0" cellspacing="0" style="width:100%;">
                            
						   <%if(list!=null&&list.size()>0){
						   if("114161".equals(channelId)||"114168".equals(channelId)||"114172".equals(channelId)||"114176".equals(channelId)||"114179".equals(channelId)||"114132".equals(channelId)){
							   %>
							   <thead id="headerContainer">
                                <tr class="listTableHead listTableHead-bb">
                                    <td width="30%">标题</td>
                                    <td width="8%">发布人</td>
                                    <td width="20%">部门</td>
									<td width="6%">状态</td>
									<td width="12%">生效日期</td>
									<td width="12%">结束日期</td>
                                    <td width="12%">发布日期</td>
                                </tr>
                            </thead>
							<tbody>
							  <%
							  for(int i=0;i<list.size();i++){
								 String [] arr = (String []) list.get(i);
								 String title = arr[1];
								 if(title.length()>20){
									 title = title.substring(0,20)+"...";
								 }
								%>
								<tr class="listTableLine1 listTableLine-bb">
								<td class="title-a" ><a style="cursor:pointer" href="javascript:void(0)" onclick="infoDetailView('<%=arr[0]%>');"><font title="<%=arr[1]%>"><%=title%></font></a></td>
								<td style="overflow: hidden;"><%=arr[10]%></td>
								<td ><%=arr[15]%></td>
								<%if("0".equals(arr[11])){
									if("0".equals(arr[12])){
								%>
								<td>有效</td>
								<td><%=arr[2]%></td>
								<td>--</td>
								<%}else if("1".equals(arr[12])){
								arr[13] = sdf.format(sdf.parse(arr[13]));
								arr[14] = sdf.format(sdf.parse(arr[14]));
								if(arr[14].compareTo(sdf.format(new java.util.Date()))<0){
								%>
								<td style="color:red;">废止</td>
								<%}else{%>
								<td >有效</td>
								<%}%>
								<td ><%=arr[13]%></td>
								<td ><%=arr[14]%></td>
								<%}}else if("1".equals(arr[11])){%>
								<td style="color:red;">废止</td>
								<td >--</td>
								<td >--</td>
								<%}%>

								<td ><%=arr[2]%></td>
							</tr>

						   <%}}else if("会议通知".equals(channelName)){
								for(int i=0;i<list.size();i++){
								 String [] arr = (String []) list.get(i);
								 String title = arr[12];
								 if(title.length()>30){
									 title = title.substring(0,30)+"...";
								 }
								%>
								<tr>
								<td class="td1 title" width="70%" align="center"><a href="javascript:void(0)" onclick="meetDetailView('<%=arr[0]%>');" title="<%=arr[12]%>"><%=title%><i class="fa fa-new"></i></a></td>
								<td width="15%" align="right" class="color-2"><%=arr[11]%></td>
								<td width="15%" align="right" class="color-2"><%=arr[1]%></td>
							</tr>
							<!--生活服务 班车信息实现点击标题下载附件 -->
							<%}}else if("23864".equals(channelId)||"23868".equals(channelId)||"783170".equals(channelId)||"783147".equals(channelId)){
							    for(int i=0;i<list.size();i++){
								 String [] arr = (String []) list.get(i);
								 String title = arr[1];
								 if(title.length()>30){
									 title = title.substring(0,30)+"...";
								 }

								 List appendList = accBD.getAccessory(arr[0]);
								 String infoPicName = "";
								 String infoPicSaveName = "";
								 String infoAppendName = "";
								 String infoAppendSaveName = "";
								 Object[] appendTmp = null;
								 String appendPath = "";
								 String verifyCode="";
								 EncryptUtil encryptUtil = new EncryptUtil();
								 if (appendList != null) {
							
									for (int j = 0; j < appendList.size(); j++) {
										appendTmp = (Object[]) appendList.get(j);
										if(appendTmp!=null && appendTmp[1]!=null){
											if (!"1".equals((appendTmp[4].toString()))) {
												infoAppendName = appendTmp[1].toString();
												infoAppendSaveName = appendTmp[2].toString();
												verifyCode= encryptUtil.getSysEncoderKeyVlaue("FileName", infoAppendSaveName, "dir");
												appendPath = "/defaultroot/public/download/download.jsp?verifyCode="+verifyCode+"&FileName="+infoAppendSaveName+"&name="+infoAppendName+"&path=information";
												break;
											}
										}
									}
								}%>
								<tr>
								<%if(appendPath!=null&&!"".equals(appendPath)){%>
								<td class="td1 title" width="70%" align="center"><a href="<%=appendPath%>" download="<%=infoAppendName%>" title="<%=arr[1]%>"><%=title%><i class="fa fa-new"></i></a></td>
								<%}else{%>
								<td class="td1 title" width="70%" align="center"><a href="javascript:void(0);" onclick="whir_alert('附件不存在！');" title="<%=arr[1]%>"><%=title%><i class="fa fa-new"></i></a></td>
								<%}%>
								
								<td width="15%" align="right" class="color-2">阅读<%=arr[8]%>次</td>
								<td width="15%" align="right" class="color-2"><%=arr[15]%></td>
								<td width="15%" align="right" class="color-2"><%=arr[2]%></td>
							</tr>
							<%}}else{
								for(int i=0;i<list.size();i++){
								 String [] arr = (String []) list.get(i);
								 String title = arr[1];
								 if(title.length()>30){
									 title = title.substring(0,30)+"...";
								 }

								 if("23864".equals(arr[4])||"23868".equals(arr[4])||"783170".equals(channelId)||"783147".equals(channelId)){
									 List appendList = accBD.getAccessory(arr[0]);
									 String infoPicName = "";
									 String infoPicSaveName = "";
									 String infoAppendName = "";
									 String infoAppendSaveName = "";
									 Object[] appendTmp = null;
									 String appendPath = "";
									 String verifyCode="";
									 EncryptUtil encryptUtil = new EncryptUtil();
									 if (appendList != null) {
								
										for (int j = 0; j < appendList.size(); j++) {
											appendTmp = (Object[]) appendList.get(j);
											if(appendTmp!=null && appendTmp[1]!=null){
												if (!"1".equals((appendTmp[4].toString()))) {
													infoAppendName = appendTmp[1].toString();
													infoAppendSaveName = appendTmp[2].toString();
													verifyCode= encryptUtil.getSysEncoderKeyVlaue("FileName", infoAppendSaveName, "dir");
													appendPath = "/defaultroot/public/download/download.jsp?verifyCode="+verifyCode+"&FileName="+infoAppendSaveName+"&name="+infoAppendName+"&path=information";
													break;
												}
											}
										}
									}%>
									<tr>
									<%if(appendPath!=null&&!"".equals(appendPath)){%>
									<td class="td1 title" width="70%" align="center"><a href="<%=appendPath%>" download="<%=infoAppendName%>" title="<%=arr[1]%>"><%=title%><i class="fa fa-new"></i></a></td>
									<%}else{%>
									<td class="td1 title" width="70%" align="center"><a href="javascript:void(0);" onclick="whir_alert('附件不存在！');" title="<%=arr[1]%>"><%=title%><i class="fa fa-new"></i></a></td>
									<%}%>
									
									<td width="15%" align="right" class="color-2">阅读<%=arr[8]%>次</td>
									<td width="15%" align="right" class="color-2"><%=arr[15]%></td>
									<td width="15%" align="right" class="color-2"><%=arr[2]%></td>
									</tr>
									<%}else{%>

								<tr>
								<td class="td1 title" width="70%" align="center"><a href="javascript:void(0)" onclick="infoDetailView('<%=arr[0]%>');" title="<%=arr[1]%>"><%=title%><i class="fa fa-new"></i></a></td>
								<td width="15%" align="right" class="color-2">阅读<%=arr[8]%>次</td>
								<td width="15%" align="right" class="color-2"><%=arr[15]%></td>
								<td width="15%" align="right" class="color-2"><%=arr[2]%></td>
							</tr>
							<%}}}}%>
                            </tbody>
                        </table>
						
                        <div class="wh-pager">
                            <div class="wh-pager-btn">
                                <input type="text" id="go_start_pager" name="go_start_pager" onkeydown="if(event.keyCode==13) pageBtnClick('input','go','<%=channelName%>');">
                                <input type="button" value="Go" onclick="pageBtnClick('input','go','<%=channelName%>');">
                            </div>
                            <div class="wh-pager-list">
                                <a id="previousPage" href="javascript:void(0)" class="wh-pager-previous" onclick="pageBtnClick('previous','','<%=channelName%>');" <%if(cpage==1){%>disabled="disabled"<%}%>>前页</a>

								<%
								if(ppage>0&&ppage<7){
								for(int i=0;i<ppage;i++){
								%>
								<a href="javascript:void(0);" onclick="pageBtnClick('input','<%=i+1%>','<%=channelName%>');" id="pagenum<%=i+1%>"><%=i+1%></a>

								<%
								}}else if(ppage>6&&cpage<4){
								for(int i=0;i<5;i++){
								%>
								<a href="javascript:void(0);" onclick="pageBtnClick('input','<%=i+1%>','<%=channelName%>');" id="pagenum<%=i+1%>"><%=i+1%></a>
								<%}%>
								<span><b>...</b></span>
                                <a href="javascript:void(0);" onclick="pageBtnClick('input','<%=ppage%>','<%=channelName%>');" id="pagenum<%=ppage%>"><%=ppage%></a>
								<%
								}else if(ppage>6&&cpage>ppage-3){
								%>
								<a href="javascript:void(0);" onclick="pageBtnClick('input','1','<%=channelName%>');" id="pagenum1">1</a>
								<span><b>...</b></span>
								<%
								for(int i=ppage-5;i<ppage;i++){%>
									<a href="javascript:void(0);" onclick="pageBtnClick('input','<%=i+1%>','<%=channelName%>');" id="pagenum<%=i+1%>"><%=i+1%></a>
								<%
								}}else if(ppage>6&&(cpage>3&&cpage<ppage-2)){
								%>
								<a href="javascript:void(0);" onclick="pageBtnClick('input','1','<%=channelName%>');" id="pagenum1">1</a>
								<span><b>...</b></span>
								<%
								for(int i=cpage-2;i<cpage+1;i++){%>
								<a href="javascript:void(0);" onclick="pageBtnClick('input','<%=i+1%>','<%=channelName%>');" id="pagenum<%=i+1%>"><%=i+1%></a>
								<%}%>
								<span><b>...</b></span>
                                <a href="javascript:void(0);" onclick="pageBtnClick('input','<%=ppage%>','<%=channelName%>');"id="pagenum<%=ppage%>"><%=ppage%></a>
								<%}%>
                                <a id="nextPage" href="javascript:void(0)" class="wh-pager-next" onclick="pageBtnClick('next','','<%=channelName%>');" <%if(cpage==ppage||ppage==0){%>disabled="disabled"<%}%>>后页</a>
                            </div>
                        </div>
						
						</form>
                    </div>
                </div>
            </div>
        </div>
    </div>
<%@ include file="/rd/info/index_pre_footer.jsp"%>	
	
    
    <script type="text/javascript">
	$(document).ready(function(){
		var skin = '<%=skin%>';
		if(skin == 'red'){
			$("#pagenum<%=cpage%>").attr("class", "current-a");
		}else{
			$("#pagenum<%=cpage%>").css("backgroundColor", "#004ea1");
			$("#pagenum<%=cpage%>").css("color", "#fff");
		}


		$(".side-nav .li_1 dl dd").last().css("margin-bottom","-20px");
		$(".side-nav .li_2 dl dd").last().css("margin-bottom","-20px");
		$(".side-nav .li_3 dl dd").last().css("margin-bottom","-20px");
		$(".side-nav .li_8 dl dd").last().css("margin-bottom","-20px");


		var orgName = "<%=orgName%>";
		$("#orgName").val(orgName);

		var infokeyForgzzd = '<%=infokeyForgzzd%>';
		if(infokeyForgzzd != ''){
			$("#infokeyForgzzd").val(infokeyForgzzd);
		}

		var channelName = "<%=channelName%>";
		var channelId = "<%=channelId%>";
		//新闻动态
		if(channelId=="23683"){
			$(".li_4").addClass("current");
		}
		//会议纪要
		else if(channelId=="23656"){
			$(".li_7").addClass("current");
		}
		//公告信息
		else if(channelId=="80245"){
			$(".li_5").addClass("current");
		}
		//会议通知
		else if(channelName=="会议通知"){
			$(".li_6").addClass("current");
		}
		//生活服务
		else if(channelId=="23862"){
			$(".li_2").addClass("current");
		}
		//班车信息
		else if(channelId=="23864"){
			$("#dl-shfu").css("display", "block");
			$("#dd-bcxx").addClass("current");
		}
		//厂区小卖部
		else if(channelId=="349413"){
			$("#dl-shfu").css("display", "block");
			$("#dd-cqxmb").addClass("current");
		}
		//工作餐食谱
		else if(channelId=="23868"){
			$("#dl-shfu").css("display", "block");
			$("#dd-gzcsp").addClass("current");
		}
		//感谢信
		else if(channelId=="23872"){
			$("#dl-shfu").css("display", "block");
			$("#dd-gxx").addClass("current");
		}
		//寻物启事
		else if(channelId=="23876"){
			$("#dl-shfu").css("display", "block");
			$("#dd-xwqs").addClass("current");
		}
		//失物招领
		else if(channelId=="23878"){
			$("#dl-shfu").css("display", "block");
			$("#dd-swzl").addClass("current");
		}
		//办公室生活服务单位值班信息
		else if(channelId=="305767"){
			$("#dl-shfu").css("display", "block");
			$("#dd-zbxx").addClass("current");
		}
        //规章制度
		else if(channelId=="114132"){
			$(".li_1").addClass("current");
		}
        //公司制度
		else if(channelId=="240672"){
			$("#dl-gzzd").css("display", "block");
			$("#dd-gszd").addClass("current");
		}
		//部门办法
		else if(channelId=="240688"){
			$("#dl-gzzd").css("display", "block");
			$("#dd-bmbf").addClass("current");
		}
		
		else if(channelId=="398610"){
			$("#dl-gzzd").css("display", "block");
			$("#dd-zybj").addClass("current");
		}
		//股份公司
		/*else if(channelId=="114161"){
			$("#dl-gzzd").css("display", "block");
			$("#dd-gfgs").addClass("current");
		}
		//总公司
		else if(channelId=="114168"){
			$("#dl-gzzd").css("display", "block");
			$("#dd-zgs").addClass("current");
		}
		//作业部
		else if(channelId=="114172"){
			$("#dl-gzzd").css("display", "block");
			$("#dd-zyb").addClass("current");
		}
		//职能部
		else if(channelId=="114176"){
			$("#dl-gzzd").css("display", "block");
			$("#dd-znb").addClass("current");
		}
		//迁钢公司
		else if(channelId=="114179"){
			$("#dl-gzzd").css("display", "block");
			$("#dd-qggs").addClass("current");
		}*/
		//专题专栏
		else if(channelId=="24119"){
			$(".li_3").addClass("current");
		}
		//两学一做
		else if(channelId=="24127"){
			$("#dl-ztzl").css("display", "block");
			$("#dd-lxyz").addClass("current");
		}
		//专题专栏
		else if(channelId=="92337"){
			$("#dl-ztzl").css("display", "block");
			$("#dd-ztzl").addClass("current");
		}
		//述职报告
		else if(channelId=="24198"){
			$("#dl-ztzl").css("display", "block");
			$("#dd-szbg").addClass("current");
		}
		//两化融合,管理体系
		else if(channelId=="24202"){
			$("#dl-ztzl").css("display", "block");
			$("#dd-lhrh").addClass("current");
		}
		//领导干部大讲坛
		else if(channelId=="24208"){
			$("#dl-ztzl").css("display", "block");
			$("#dd-ldgb").addClass("current");
		}
		//领导干部大讲坛
		else if(channelId=="23907"){
			$("#dl-ztzl").css("display", "block");
			$("#dd-qysc").addClass("current");
		}//廉政建设
		else if(channelId=="23784"){
			$(".li_8").addClass("current");
		}else if(channelId=="23790"){
			$("#dl-lzjs").css("display", "block");
			$("#dd-gzdt").addClass("current");
		}else if(channelId=="23792"){
			$("#dl-lzjs").css("display", "block");
			$("#dd-jzcm").addClass("current");
		}else if(channelId=="23794"){
			$("#dl-lzjs").css("display", "block");
			$("#dd-djfg").addClass("current");
		}else if(channelId=="23803"){
			$("#dl-lzjs").css("display", "block");
			$("#dd-lzzd").addClass("current");
		}else if(channelId=="23811"){
			$("#dl-lzjs").css("display", "block");
			$("#dd-ffzx").addClass("current");
		}else if(channelId=="23815"){
			$("#dl-lzjs").css("display", "block");
			$("#dd-ljwh").addClass("current");
		}else if(channelId=="23848"){
			$("#dl-lzjs").css("display", "block");
			$("#dd-xyjl").addClass("current");
		}


		//$("#pagenum<%=cpage%>").css("backgroundColor", "#09f");
		//$("#pagenum<%=cpage%>").css("color", "#fff");
		var cpage = "<%=cpage%>";
		var ppage = "<%=ppage%>";
		if(cpage=="1"){
		$("#previousPage").removeAttr("onclick");
		}else if(cpage==ppage){
		$("#nextPage").removeAttr("onclick");
		}
	});



//翻页
function pageBtnClick(flag,pagenum,channelname){
	if(channelname=="会议通知"){
		document.queryForm.action="/defaultroot/WebIndexSggfBD!getInfoListHytz.action";
	}else{
		document.queryForm.action="/defaultroot/BeforeInfoAction!getInformationListBF.action";
	}
	
	if(flag=="start"){
		$("#startPage").val('1');
		$("#queryForm").submit();
	}else if(flag=="previous"){
		$("#startPage").val('<%=cpage-1%>');
		$("#queryForm").submit();
	}else if(flag=="next"){
		$("#startPage").val('<%=cpage+1%>');
		$("#queryForm").submit();
	}else if(flag=="last"){
		$("#startPage").val('<%=ppage%>');
		$("#queryForm").submit();
	}else if(flag=="input"){
		if(pagenum==''){
			var ipage=$("#go_start_pager").val();
			$("#startPage").val(ipage);
		}else if(pagenum=='go'){
			var varInt=/^\d+$/;
			var ipage=$("#go_start_pager").val();
			var ppage="<%=ppage%>";
			if(!varInt.test(ipage)){
				return false;
			}else if(parseInt(ipage)<1||parseInt(ipage)>parseInt(ppage)){
				return false;
			}else{
				$("#startPage").val(ipage);
			}
		}else{
			var ipage=$("#pagenum"+pagenum).text();
			$("#startPage").val(ipage);
		}
		$("#queryForm").submit();
	}
}

//信息详细弹出框 
function  infoDetailView(id){
	openWin({url:'/defaultroot/WebIndexSggfBD!detailInfomation.action?id='+id,isFull:true,winName:'infoDetailView'});
}


function mychecked(obj){
	var cheVal=document.getElementById("rememberCheckbox").checked;
	if(cheVal==true){
		document.getElementById("isRemember").value= "1";
	}else{
		document.getElementById("isRemember").value= "0";
	}
}

function  meetDetailView(id){
	openWin({url:'/defaultroot/WebIndexSggfBD!detailMeeting.action?id='+id,isFull:true,winName:'meetDetailView'});
}

$(".li_2").hover(
  function () {
	  if($("#dl-shfu").css("display")=="none")
		$("#dl-shfu").css("display", "block");
  },
  function () {
    $("#dl-shfu").css("display", "none");
  }
);

$(".li_1").hover(
  function () {
	  if($("#dl-gzzd").css("display")=="none")
		$("#dl-gzzd").css("display", "block");
  },
  function () {
    $("#dl-gzzd").css("display", "none");
  }
);

$(".li_3").hover(
  function () {
	  if($("#dl-ztzl").css("display")=="none")
		$("#dl-ztzl").css("display", "block");
  },
  function () {
    $("#dl-ztzl").css("display", "none");
  }
);

$(".li_8").hover(
  function () {
	  if($("#dl-lzjs").css("display")=="none")
		$("#dl-lzjs").css("display", "block");
  },
  function () {
    $("#dl-lzjs").css("display", "none");
  }
);


function searchInfo(flag1,flag2){
	var infokey = '';
	if($("#infokeyForgzzd").length > 0){
		infokey = $("#infokeyForgzzd").val();
	}else{
		infokey = '';
	}
	if(flag2==1){
		if(flag1==1){
			document.queryForm.action="/defaultroot/WebIndexSggfBD!getInfoListHytz.action?flag=1";
		}else if(flag1==2){
			document.queryForm.action="/defaultroot/WebIndexSggfBD!getInfoListHytz.action?flag=2";
		}
	}else if(flag2==2){
		if(flag1==1){
			document.queryForm.action="/defaultroot/BeforeInfoAction!getInformationListBF.action?flag=1&infokey="+encodeURI(encodeURI(infokey));
		}else if(flag1==2){
			document.queryForm.action="/defaultroot/BeforeInfoAction!getInformationListBF.action?flag=2&infokey="+encodeURI(encodeURI(infokey));
		}
	}
	$("#queryForm").submit();
}

$("body").click(function(e){
		if($(e.target).attr('class')=="layui-layer-shade"){
			layer.closeAll();
		}
	});
    </script>
</body>

</html>
