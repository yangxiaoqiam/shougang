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
<script type="text/javascript">
	var whirRootPath = "<%=rootPath%>";
	var preUrl = "<%=preUrl%>"; 
	var whir_browser = "<%=whir_browser%>"; 
	var whir_agent = "<%=com.whir.component.security.crypto.EncryptUtil.htmlcode(whir_agent)%>"; 
	var whir_locale = "<%=whir_locale.toLowerCase()%>"; 
</script>
<head>
<title>专题专栏</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
    <link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/reset.css" />
	<link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/flexslider.css" />
	<link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/layer.css" />
	<link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/pro-style.css" />
	<link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/red.css" />
	<%if("grey".equals(skin)){%>
	<link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/gray.css" />
	<%}%>
	<script src="<%=rootPath%>/scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
	<script type="text/javascript" src="<%=rootPath%>/scripts/plugins/superslide/jquery.SuperSlide.2.1.1.js"></script>
	<script src="<%=rootPath%>/scripts/i18n/<%=whir_locale%>/CommonResource.js" type="text/javascript"></script>
	<script src="<%=rootPath%>/scripts/plugins/lhgdialog/lhgdialog.js?skin=idialog" type="text/javascript"></script>
	<script type="text/javascript" src="<%=rootPath%>/rd/js/util/loginbf2.js"></script>
	<script src="<%=rootPath%>/scripts/main/whir.validation.js" type="text/javascript"></script>
	<script src="<%=rootPath%>/scripts/main/whir.application.js" type="text/javascript"></script>
	<script src="<%=rootPath%>/scripts/main/whir.util.js" type="text/javascript"></script>
	<script src="<%=rootPath%>/scripts/util/cookie.js" type="text/javascript"></script>
	<script type="text/javascript" src="<%=rootPath%>/scripts/plugins/security/security.js"></script>
	<script type="text/javascript" src="<%=rootPath%>/pro/js/jquery.flexslider.js"></script>
	<script type="text/javascript" src="<%=rootPath%>/pro/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="<%=rootPath%>/pro/js/layer.js"></script>
	<script type="text/javascript" src="<%=rootPath%>/pro/js/index.js"></script>
</head>
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
String orgId="8847";
GetPortalInfo gpInfo=new GetPortalInfo();
List ztzl=new ArrayList();
ztzl=gpInfo.getZtzlGF(12);
%>

<body>
<!--头部公共文件-->
	<%@ include file="index_pre_header.jsp"%>
    <div class="pro-container clearfix">
        <!--  列表页  -->
        <div class="erji clearfix">
            <div class="erji-fr-box w100 fr">
                <div class="erji-fr fr">
                    <div class="location location-a clearfix">
                        <p>您当前的位置：<a href="/defaultroot/index_pre.jsp">首页</a><i>&gt;</i><a>专题专栏</a></p>
                    </div>
                    <div class="ztzl-list">
                         <ul class="clearfix">
						 <%
							if(ztzl!=null&&ztzl.size()>0){
							for(int i=0;i<ztzl.size();i++){
							String [] arr=(String [])ztzl.get(i);
							String accName=arr[2];
							String url = arr[3];
							String src= preUrl+"/upload/customform/"+accName.substring(0,6)+"/"+accName;
							%>
							<li>
								<a href="<%=url%>">
								<img src="<%=src%>">
								<p><%=arr[1]%></p>
								</a>
							</li>
						<%}}%>  
                         </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="footer">
        <p>中国·首钢集团<span class="copyright">Copyright &copy; 2003 shougang.com.cn, All Rights Reserved</span></p>
    </div>
    <!-- 登录页弹出  -->
   <div class="tan-loginbox">  
		<div class="tan-login">
            <div class="login-box ">
                <div class="close"></div>
                <div class="login-contact">
				<form action="LogonActionBF!logon.action" method="post" name=LogonForm target="_parent">
				<input type="hidden" name="random_form" value=<%=random%>/>
				<input type="hidden" name="type" value="gfgs"/>
				<input type="hidden" name="feedback" id="feedback" value=""/>
				<input type="hidden" name="domainAccount" value="whir"/>
                    <div class="login-tit" style="color:#333">OA登录</div>
                    <div class="ban before-username clearfix">
                        <label class="fl" style="color:#333">账号</label>
						<input style="background:#00a0e9;color:#fff" type="text" name="userAccount" id="userAccount" class="fr" onkeydown="if(event.keyCode==13)javascript:submitForm();"/>
                    </div>
                    <div class="ban before-password clearfix">
                        <label class="fl" style="color:#333">密码</label>
                        <input style="background:#00a0e9;color:#fff" type="password" name="userPassword" id="userPassword" class="fr" autocomplete="off" onkeydown="if(event.keyCode==13)javascript:submitForm();"/>
						<input type="hidden" id="userPasswordTemp" name="userPasswordTemp"/>
						<input type="hidden" id="time" name="time"/>
                    </div>
                    <%if("1".equals(useCaptcha)||(inputPwdErrorNum>2 && "2".equals(useCaptcha))){%>
						 <div class="ban before-username clearfix captchaAnswer-a">
							<input style="background:#00a0e9" type="text" name="captchaAnswer" id="captchaAnswer" class="fr" style="width: 175px;"/>
							<img id="yzm" src="<%=rootPath%>/captcha.png" onclick="document.getElementById('yzm').src='<%=rootPath%>/captcha.png?'+new Date().getTime();">
						</div>
					<%}%>
                    <div ban class="remember clearfix">
					<div id="checkbox-a">
						<input type="checkbox" id="rememberCheckbox" name="rememberCheckbox" onclick="javascript:mychecked();">记住密码
						</div>
						<input type="hidden" id="isRemember" name="isRemember" value="0"/>
                        <input style="background:#00a0e9" type="button" class="dl fr" value="登录" onclick="javascript:submitForm();"/>
                    </div>
					</form>
                    <ul class="others clearfix">
						<!--<li><a onclick="javascript:change(0);">扫描二维码</a></li>-->
						<li><a href="/defaultroot/public/edit/logindownload/Logindownload.jsp?fileName=activex.msi">控件安装</a></li>
						<li><a href="/defaultroot/downloadfile/GFXT_IM-V1.1.exe">PCIM安装</a></li>
						<li><a href="/defaultroot/help/help_set.html"  target="_blank">使用帮助</a></li>
                    </ul>
                </div>
            </div>
        </div>

</body>
</html>
<script type="text/javascript">
function SearchInformation(){
	var infokey = $("#search").val();
	window.location.href = whirRootPath+"/WebIndexSggfBD!infolist.action?infokey=" + encodeURIComponent(infokey)+"&orgId=<%=orgId%>"+"&channelIds=80707,23683,23656,80245,23864,23868,23872,23876,23878";
}
</script>
