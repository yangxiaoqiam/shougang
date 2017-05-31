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
<title>系统使用统计</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
    <link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/reset.css" />
	<link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/flexslider.css" />
	<link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/layer.css" />
	<link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/pro-style.css" />
	<link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/red.css" />
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
		<script type="text/javascript" src="<%=rootPath%>/scripts/plugins/highcharts/jquery.highcharts.js"></script>
 <style>
 
 </style>
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
        <div class="erji clearfix ">
            <div class="erji-fr-box w100 fr">
                <div class="erji-fr fr ">
                    <div class="location location-a clearfix ">
                        <p>您当前的位置：<a href="/defaultroot/index_pre.jsp">首页</a><i>&gt;</i><a>系统使用统计</a></p>
                    </div>
					<!-- 统计图 -->

                  <div class="gf-chat">
                         <div class="line"></div>
                         <div class="ban ban1 clearfix">
                                <div class="chat-title fl">用户激活度（人）：</div>
                                <div class="chat-main fr">
                                <p class="all" ><span id="peopleAllNum"></span></p>
                                      <div class="gf-bar" id="allbar">
                                            <div class="moblie" style="width: 20%" id="moblieBar"><div><em>移动端激活数</em><span id="moblieNum"></span></div></div>
                                            <div class="active-all" style="width: 50%" id="PCBar"><div><em>PC激活总数</em><span id="PCNum"></span></div></div>
                                      </div>
                                      <div class="all-person" id="allperson">用户总数 </div>

                                </div>
                         </div>
                          <div class="ban ban2 clearfix">
                                <div class="chat-title fl">门户使用情况（条）：</div>
                                <div class="chat-main mh fr">

                                 <a class="a1"><em></em><span id="infoNum"></span>条<p>累计发布信息</p></a>
                                       <a class="a2"><em></em><span id="weekInfoNum"></span>条<p>本周发布信息</p></a>
                                       <a class="a3"><em></em><span id="clickNum"></span>次<p>总点击量</p></a>
                                    <!--    <a class="a4"><em></em><span id="weekClickNum"></span>次<p>本周点击量</p></a> -->
                                </div>
                         </div>
                          <div class="ban ban3 clearfix">
                                <div class="chat-title fl">流程使用情况：</div>
                                <div class="chat-main  used fr">
                                <div class="line2"></div>
                                       <a class="a1"><em></em>发文</a>
                                       <a class="a2"><em></em>收文</a>
                                       <a class="a3"><em></em>请示报告</a>
                                       <a class="a4"><em></em>文件传递</a>
                                       <a class="a5"><em></em>会议纪要</a>
                                       <a class="a6"><em></em>汇报与反馈</a>
                                       <a class="a7"><em></em>事务性流程</a>

                                </div>
                         </div>
                          <div class="ban ban4 clearfix">
                                <div class="chat-title fl">总流程使用情况（个）：</div>
                                <div class="chat-main tu fr">
                                      <ul class="ul1 clearfix">
                                          <li>
												<div class="wrap1">
                                                <!--    <div class="wrap11">
                                                       <span class="span1" ></span>-->
                                                       <span class="span2" id="sendDealedNum" style="height: 100px;width:100px"></span>
                                                 </div>
												 <!--<div class="wrap11 wrap12">
                                                       <span class="span1" ></span>
                                                       <span class="span2" id="sendNum" style="height: 100%"></span>
                                                 </div>
                                            </div>-->
                                          </li>
                                          <li>
                                             <div class="wrap1">
                                                 <!--<div class="wrap11">
                                                       <span class="span1"></span> -->
                                                       <span class="span2" id="receiveDealedNum" style="height: 100px;width:100px"></span>
                                                 </div>
                                                 <!--<div class="wrap11 wrap12">
                                                       <span class="span1" ></span>
                                                       <span class="span2" id="receiveNum" style="height:100%"></span>
                                                 </div>
                                            </div>-->

                                          </li>
                                          <li>
                                             <div class="wrap1">
                                                <!-- <div class="wrap11">
                                                       <span class="span1"></span> -->
                                                       <span class="span2" id="askDealedNum" style="height: 100px;width:100px"></span>
                                                 </div>
                                                 <!--<div class="wrap11 wrap12">
                                                       <span class="span1" ></span>
                                                       <span class="span2" id="askNum" style="height: 60%"></span>
                                                 </div>
                                            </div>-->

                                          </li>
                                          <li>
                                             <div class="wrap1">
                                                 <!--<div class="wrap11">
                                                       <span class="span1"></span> -->
                                                       <span class="span2" id="passDealedNum" style="height: 100px;width:100px"></span>
                                                 </div>
                                                <!-- <div class="wrap11 wrap12">
                                                       <span class="span1" ></span>
                                                       <span class="span2" id="passNum" style="height: 80%"></span>
                                                 </div>
                                            </div>-->

                                          </li>
                                          <li>
                                             <div class="wrap1">
                                                 <!-- <div class="wrap11">
                                                       <span class="span1"></span> -->
                                                       <span class="span2" id="meetDealedNum" style="height: 100px;width:100px"></span>
                                                 </div>
                                                <!-- <div class="wrap11 wrap12">
                                                       <span class="span1" ></span>
                                                       <span class="span2" id="meetNum" style="height: 100%"></span>
                                                 </div>
                                            </div>-->

                                          </li>
                                          <li>
                                             <div class="wrap1">
                                                 <!--<div class="wrap11">
                                                       <span class="span1"></span> -->
                                                       <span class="span2" id="reportDealedNum" style="height: 100px;width:100px"></span>
                                                 </div>
                                                 <!--<div class="wrap11 wrap12">
                                                       <span class="span1" ></span>
                                                       <span class="span2" id="reportNum" style="height: 100%"></span>
                                                 </div>
                                            </div>-->

                                          </li>
                                            <li>
                                             <div class="wrap1">
                                                 <!--<div class="wrap11">
                                                       <span class="span1"></span> -->
                                                       <span class="span2" id="flowDealedNum" style="height: 100px;width:100px"></span>
                                                 </div>
                                                 <!--<div class="wrap11 wrap12">
                                                       <span class="span1" ></span>
                                                       <span class="span2" id="flowNum" style="height: 100%"></span>
                                                 </div>
                                            </div>-->

                                          </li>
                                     </ul>
									
                                </div>
                         </div>
                          <div class="ban ban5 clearfix">
                                <div class="chat-title fl">总流程平均办理时间（天）：</div>
								 <div class="chat-main tu fr">
									<ul class="clearfix">
                                          <li>
                                             <div class="wrap1">
                                              
                                                 <div class="wrap11 wrap12">
                                                       <span class="span1" ></span>
                                                       <span class="span2" id="sendTime" style="height: 100%"></span>
                                                 </div>
                                            </div>

                                          </li>
                                           <li>
                                             <div class="wrap1">
                                              
                                                 <div class="wrap11 wrap12">
                                                       <span class="span1" ></span>
                                                       <span class="span2" id="receiveTime" style="height: 100%"></span>
                                                 </div>
                                            </div>

                                          </li>
                                           <li>
                                             <div class="wrap1">
                                              
                                                 <div class="wrap11 wrap12">
                                                       <span class="span1" ></span>
                                                       <span class="span2" id="askTime" style="height: 100%"></span>
                                                 </div>
                                            </div>

                                          </li>
                                           <li>
                                             <div class="wrap1">
                                              
                                                 <div class="wrap11 wrap12">
                                                       <span class="span1" ></span>
                                                       <span class="span2" id="passTime" style="height: 50%"></span>
                                                 </div>
                                            </div>

                                          </li>
                                           <li>
                                             <div class="wrap1">
                                              
                                                 <div class="wrap11 wrap12">
                                                       <span class="span1" ></span>
                                                       <span class="span2" id="meetTime" style="height: 100%"></span>
                                                 </div>
                                            </div>

                                          </li>
                                           <li>
                                             <div class="wrap1">
                                              
                                                 <div class="wrap11 wrap12">
                                                       <span class="span1" ></span>
                                                       <span class="span2" id="reportTime" style="height: 50%"></span>
                                                 </div>
                                            </div>

                                          </li>
                                           <li>
                                             <div class="wrap1">
                                              
                                                 <div class="wrap11 wrap12">
                                                       <span class="span1" ></span>
                                                       <span class="span2" id="flowTime" style="height: 50%"></span>
                                                 </div>
                                            </div>

                                          </li>
                                         
                                     </ul>
							</div>
                         </div>
                          <div class="ban ban6 clearfix">
                                <div class="chat-title fl">上周流程使用情况（个）：</div>
								 <div class="chat-main tu fr">
								 <ul class="clearfix">
                                          <li>
                                             <div class="wrap1">
                                                 <!--<div class="wrap11">
                                                       <span class="span1">0</span>-->
                                                       <span class="span2" id="sendDealedWeekNum" style="height: 100px;width:100px"></span>
                                                 </div>
                                                 <!--<div class="wrap11 wrap12">
                                                       <span class="span1" >0</span>
                                                       <span class="span2" id="sendWeekNum" style="height: 1%"></span>
                                                 </div>
                                            </div>-->

                                          </li>
                                          <li>
                                             <div class="wrap1">
                                                <!-- <div class="wrap11">
                                                       <span class="span1">0</span>-->
                                                       <span class="span2" id="receiveDealedWeekNum" style="height: 100px;width:100px"></span>
                                                 </div>
                                                 <!--<div class="wrap11 wrap12">
                                                       <span class="span1" >0</span>
                                                       <span class="span2" id="receiveWeekNum" style="height: 1%"></span>
                                                 </div>
                                            </div>-->

                                          </li>
                                          <li>
                                             <div class="wrap1">
                                                 <!--<div class="wrap11">
                                                       <span class="span1">0</span> -->
                                                       <span class="span2" id="askDealedWeekNum" style="height: 100px;width:100px"></span>
                                                 </div>
                                                 <!--<div class="wrap11 wrap12">
                                                       <span class="span1" >0</span>
                                                       <span class="span2" id="askWeekNum" style="height: 1%"></span>
                                                 </div>
                                            </div>-->

                                          </li>
                                          <li>
                                             <div class="wrap1">
                                                 <!--<div class="wrap11">
                                                       <span class="span1">0</span> -->
                                                       <span class="span2" id="passDealedWeekNum" style="height: 100px;width:100px"></span>
                                                 </div>
                                                 <!--<div class="wrap11 wrap12">
                                                       <span class="span1" >0</span>
                                                       <span class="span2" id="passWeekNum" style="height: 1%"></span>
                                                 </div>
                                            </div>-->

                                          </li>
                                          <li>
                                             <div class="wrap1">
                                                 <!-- <div class="wrap11">
                                                       <span class="span1">0</span> -->
                                                       <span class="span2" id="meetDealedWeekNum" style="height: 100px;width:100px"></span>
                                                 </div>
                                                 <!--<div class="wrap11 wrap12">
                                                       <span class="span1" >0</span>
                                                       <span class="span2" id="meetWeekNum" style="height: 1%"></span>
                                                 </div>
                                            </div> -->

                                          </li>
                                          <li>
                                             <div class="wrap1">
                                                 <!--<div class="wrap11">
                                                       <span class="span1">0</span> -->
                                                       <span class="span2" id="reportDealedWeekNum" style="height: 100px;width:100px"></span>
                                                 </div>
                                                 <!--<div class="wrap11 wrap12">
                                                       <span class="span1" >0</span>
                                                       <span class="span2" id="reportWeekNum" style="height: 1%"></span>
                                                 </div>
                                            </div> -->

                                          </li>
                                            <li>
                                             <div class="wrap1">
                                                <!-- <div class="wrap11">
                                                       <span class="span1">0</span> -->
                                                       <span class="span2" id="flowDealedWeekNum" style="height: 100px;width:100px"></span>
                                                 </div>
                                                 <!--<div class="wrap11 wrap12">
                                                       <span class="span1" >0</span>
                                                       <span class="span2" id="flowWeekNum" style="height: 1%"></span>
                                                 </div>
                                            </div> -->

                                          </li>
                                     </ul>
                               </div>
                         </div>
                          <div class="ban ban7 clearfix">
                                <div class="chat-title fl">上周流程平均办理时间（天）：</div>
								<div class="chat-main tu fr">
                               <ul class="last clearfix">
                                          <li>
                                             <div class="wrap1">
                                              
                                                 <div class="wrap11 wrap12">
                                                       <span class="span1" >0</span>
                                                       <span class="span2" id="sendWeekTime" style="height: 1%"></span>
                                                 </div>
                                            </div>

                                          </li>
                                           <li>
                                             <div class="wrap1">
                                              
                                                 <div class="wrap11 wrap12">
                                                       <span class="span1" >0</span>
                                                       <span class="span2" id="receiveWeekTime" style="height: 1%"></span>
                                                 </div>
                                            </div>

                                          </li>
                                           <li>
                                             <div class="wrap1">
                                              
                                                 <div class="wrap11 wrap12">
                                                       <span class="span1" >0</span>
                                                       <span class="span2" id="askWeekTime" style="height: 1%"></span>
                                                 </div>
                                            </div>

                                          </li>
                                           <li>
                                             <div class="wrap1">
                                              
                                                 <div class="wrap11 wrap12">
                                                       <span class="span1" >0</span>
                                                       <span class="span2" id="passWeekTime" style="height: 1%"></span>
                                                 </div>
                                            </div>

                                          </li>
                                           <li>
                                             <div class="wrap1">
                                              
                                                 <div class="wrap11 wrap12">
                                                       <span class="span1" >0</span>
                                                       <span class="span2" id="meetWeekTime" style="height: 1%"></span>
                                                 </div>
                                            </div>

                                          </li>
                                           <li>
                                             <div class="wrap1">
                                              
                                                 <div class="wrap11 wrap12">
                                                       <span class="span1" >0</span>
                                                       <span class="span2" id="reportWeekTime" style="height: 1%"></span>
                                                 </div>
                                            </div>

                                          </li>
                                           <li>
                                             <div class="wrap1">
                                              
                                                 <div class="wrap11 wrap12">
                                                       <span class="span1" >0</span>
                                                       <span class="span2" id="flowWeekTime" style="height: 1%"></span>
                                                 </div>
                                            </div>

                                          </li>
                                         
                                     </ul>
                         </div>
                         </div>
                  </div>
                    <!-- 统计图 end-->
                </div>
            </div>
        </div>
    </div>
    <div class="footer ">
        <p>中国·首钢集团<span class="copyright ">Copyright &copy; 2003 shougang.com.cn, All Rights Reserved</span></p>
    </div>
</body>
<script type="text/javascript">
	$(document).ready(function(){

      $(".span2").each(function(){
                var span2height= $(this).height();
               $(this).prev().css({"bottom":span2height});
         });
		$("#moblieBar").hover(function(){
			$("#moblieNum").show();
			//$("#peopleAllNum").css("visibility","visible");
		},function(){
			$("#moblieNum").hide();
			//$("#peopleAllNum").css("visibility","hidden");
		});
		$("#PCBar").hover(function(){
			$("#PCNum").show();
			//	$("#peopleAllNum").css("visibility","visible");
		},function(){
			$("#PCNum").hide();
			//$("#peopleAllNum").css("visibility","hidden");
		});
		$("#allbar").hover(function(){
			 
			$("#peopleAllNum").css("visibility","visible");
		},function(){
			 
			$("#peopleAllNum").css("visibility","hidden");
		});
		
	 
		$("#allperson").hover(function(){
			 
			$("#peopleAllNum").css("visibility","visible");
		},function(){
			 
			$("#peopleAllNum").css("visibility","hidden");
		});
		
			var url = "/defaultroot/rd/govoffice/gov_documentmanager/forms/getChatInfo.jsp?randomid=" + (new Date()).getTime();
				$.ajax({
					url: url,
					type: "post",
					async: false,
					success: function (data) {
					data = data.replace(/(^\s*)|(\s*$)/g, '');
						if(data != ''){
						   data = eval('('+data+')');
						   //处理用户激活数
						   $("#PCNum").html(data.PCNum+"人");
						   $("#moblieNum").html(data.moblieNum+"人");
						   $("#peopleAllNum").html(data.peopleAllNum+"人");
						    $("#PCNum").hide();
						   $("#moblieNum").hide();
						   $("#peopleAllNum").css("visibility","hidden");
						   //通过控制显示条的宽度来达到百分比的效果
						   $("#moblieBar").css('width',(parseInt(data.moblieNum)/parseInt(data.peopleAllNum)).toFixed(2)*100+"%");
						   $("#PCBar").css('width',(parseInt(data.PCNum)/parseInt(data.peopleAllNum)).toFixed(2)*100+"%");

						   //处理门户使用情况
						   $("#infoNum").html(data.infoNum);
						   $("#weekInfoNum").html(data.weekInfoNum);
						   $("#clickNum").html(data.clickNum);
						   $("#weekClickNum").html(data.weekClickNum);

						   //处理流程使用情况
						   var flowData = data.flowData;
						   var maxNum = Math.max(parseInt(flowData.sendNum),parseInt(flowData.receiveNum),parseInt(flowData.askNum),parseInt(flowData.passNum),parseInt(flowData.meetNum),parseInt(flowData.reportNum),parseInt(flowData.flowNum));
						   
						    // 总流程使用情况
						  /** $("#sendDealedNum").css('height',(parseInt(flowData.sendDealedNum)/parseInt(maxNum)).toFixed(2)*100+"%");
						   $("#sendDealedNum").prev().css({"bottom":$("#sendDealedNum").height()});
						   $("#sendDealedNum").prev().html(flowData.sendDealedNum);
						   $("#sendNum").css('height',(parseInt(flowData.sendNum)/parseInt(maxNum)).toFixed(2)*100+"%");
						   $("#sendNum").prev().css({"bottom":$("#sendNum").height()});
						   $("#sendNum").prev().html(flowData.sendNum);
							**/
							
							var sendData = [
								 ['流程发起总数', parseInt(flowData.sendNum)],
								 ['流程办结总数', parseInt(flowData.sendDealedNum)]
							];
							createPie("sendDealedNum",sendData);
							
							
							
						  /** $("#receiveDealedNum").css('height',(parseInt(flowData.receiveDealedNum)/parseInt(maxNum)).toFixed(2)*100+"%");
						   $("#receiveDealedNum").prev().css({"bottom":$("#receiveDealedNum").height()});
						   $("#receiveDealedNum").prev().html(flowData.receiveDealedNum);
						   $("#receiveNum").css('height',(parseInt(flowData.receiveNum)/parseInt(maxNum)).toFixed(2)*100+"%");
						   $("#receiveNum").prev().css({"bottom":$("#receiveNum").height()});
						   $("#receiveNum").prev().html(flowData.receiveNum);
							**/
						   var receiveData = [
								 ['流程发起总数', parseInt(flowData.receiveNum)],
								 ['流程办结总数', parseInt(flowData.receiveDealedNum)]
							];
							createPie("receiveDealedNum",receiveData);
							
						/**   $("#askDealedNum").css('height',(parseInt(flowData.askDealedNum)/parseInt(maxNum)).toFixed(2)*100+"%");
						   $("#askDealedNum").prev().css({"bottom":$("#askDealedNum").height()});
						   $("#askDealedNum").prev().html(flowData.askDealedNum);
						   $("#askNum").css('height',(parseInt(flowData.askNum)/parseInt(maxNum)).toFixed(2)*100+"%");
						   $("#askNum").prev().css({"bottom":$("#askNum").height()});
						   $("#askNum").prev().html(flowData.askNum);
						**/
						
							var askData = [ 
									 ['流程发起总数', parseInt(flowData.askNum)],
									 ['流程办结总数', parseInt(flowData.askDealedNum)]
							];
							createPie("askDealedNum",askData);
							
						  /** $("#passDealedNum").css('height',(parseInt(flowData.passDealedNum)/parseInt(maxNum)).toFixed(2)*100+"%");
						   $("#passDealedNum").prev().css({"bottom":$("#passDealedNum").height()});
						   $("#passDealedNum").prev().html(flowData.passDealedNum);
						   $("#passNum").css('height',(parseInt(flowData.passNum)/parseInt(maxNum)).toFixed(2)*100+"%");
						   $("#passNum").prev().css({"bottom":$("#passNum").height()});
						   $("#passNum").prev().html(flowData.passNum);
							**/
						   var passData = [ 
									 ['流程发起总数', parseInt(flowData.passNum)],
									 ['流程办结总数', parseInt(flowData.passDealedNum)]
							];
							createPie("passDealedNum",passData);
							
							
						   /**
						   $("#meetDealedNum").css('height',(parseInt(flowData.meetDealedNum)/parseInt(maxNum)).toFixed(2)*100+"%");
						   $("#meetDealedNum").prev().css({"bottom":$("#meetDealedNum").height()});
						   $("#meetDealedNum").prev().html(flowData.meetDealedNum);
						   $("#meetNum").css('height',(parseInt(flowData.meetNum)/parseInt(maxNum)).toFixed(2)*100+"%");
						   $("#meetNum").prev().css({"bottom":$("#meetNum").height()});
						   $("#meetNum").prev().html(flowData.meetNum);
						   **/
						   var meetData = [ 
									 ['流程发起总数', parseInt(flowData.meetNum)],
									 ['流程办结总数', parseInt(flowData.meetDealedNum)]
							];
							createPie("meetDealedNum",meetData);
						   
						   
						   
						   /**
						   $("#reportDealedNum").css('height',(parseInt(flowData.reportDealedNum)/parseInt(maxNum)).toFixed(2)*100+"%");
						   $("#reportDealedNum").prev().css({"bottom":$("#reportDealedNum").height()});
						   $("#reportDealedNum").prev().html(flowData.reportDealedNum);
						   $("#reportNum").css('height',(parseInt(flowData.reportNum)/parseInt(maxNum)).toFixed(2)*100+"%");
						   $("#reportNum").prev().css({"bottom":$("#reportNum").height()});
						   $("#reportNum").prev().html(flowData.reportNum);
							**/
							
						   var reportData = [ 
									 ['流程发起总数', parseInt(flowData.reportNum)],
									 ['流程办结总数', parseInt(flowData.reportDealedNum)]
							];
							createPie("reportDealedNum",reportData);
							
							
							/**
						    $("#flowDealedNum").css('height',(parseInt(flowData.flowDealedNum)/parseInt(maxNum)).toFixed(2)*100+"%");
						   $("#flowDealedNum").prev().css({"bottom":$("#flowDealedNum").height()});
						   $("#flowDealedNum").prev().html(flowData.flowDealedNum);
						   $("#flowNum").css('height',(parseInt(flowData.flowNum)/parseInt(maxNum)).toFixed(2)*100+"%");
						   $("#flowNum").prev().css({"bottom":$("#flowNum").height()});
						   $("#flowNum").prev().html(flowData.flowNum);
							**/
							var  flow = [
									 ['流程发起总数', parseInt(flowData.flowNum)],
									 ['流程办结总数', parseInt(flowData.flowDealedNum)]
							];
							createPie("flowDealedNum",flow);
						   //总流程办理时间
						  var maxTime = Math.max(parseFloat(flowData.sendTime),parseFloat(flowData.receiveTime),parseFloat(flowData.askTime),parseFloat(flowData.passTime),parseFloat(flowData.meetTime),parseFloat(flowData.reportTime),parseFloat(flowData.flowTime));

						  $("#sendTime").css('height',(parseFloat(flowData.sendTime)/parseFloat(maxTime)).toFixed(2)*100+"%");
						  $("#sendTime").prev().css({"bottom":$("#sendTime").height()});
						  $("#sendTime").prev().html(parseFloat(flowData.sendTime).toFixed(0));

						  $("#receiveTime").css('height',(parseFloat(flowData.receiveTime)/parseFloat(maxTime)).toFixed(2)*100+"%");
						  $("#receiveTime").prev().css({"bottom":$("#receiveTime").height()});
						  $("#receiveTime").prev().html(parseFloat(flowData.receiveTime).toFixed(0));

						  $("#askTime").css('height',(parseFloat(flowData.askTime)/parseFloat(maxTime)).toFixed(2)*100+"%");
						  $("#askTime").prev().css({"bottom":$("#askTime").height()});
						  $("#askTime").prev().html(parseFloat(flowData.askTime).toFixed(0));

						  $("#passTime").css('height',(parseFloat(flowData.passTime)/parseFloat(maxTime)).toFixed(2)*100+"%");
						  $("#passTime").prev().css({"bottom":$("#passTime").height()});
						  $("#passTime").prev().html(parseFloat(flowData.passTime).toFixed(0));

						  $("#meetTime").css('height',(parseFloat(flowData.meetTime)/parseFloat(maxTime)).toFixed(2)*100+"%");
						  $("#meetTime").prev().css({"bottom":$("#meetTime").height()});
						  $("#meetTime").prev().html(parseFloat(flowData.meetTime).toFixed(0));

						  $("#reportTime").css('height',(parseFloat(flowData.reportTime)/parseFloat(maxTime)).toFixed(2)*100+"%");
						  $("#reportTime").prev().css({"bottom":$("#reportTime").height()});
						  $("#reportTime").prev().html(parseFloat(flowData.reportTime).toFixed(0));

						  $("#flowTime").css('height',(parseFloat(flowData.flowTime)/parseFloat(maxTime)).toFixed(2)*100+"%");
						  $("#flowTime").prev().css({"bottom":$("#flowTime").height()});
						  $("#flowTime").prev().html(parseFloat(flowData.flowTime).toFixed(0));

						  //上周流程使用情况
						  var flowWeekData = data.flowWeekData;
						  var maxWeekNum = Math.max(parseInt(flowWeekData.sendWeekNum),parseInt(flowWeekData.receiveWeekNum),parseInt(flowWeekData.askWeekNum),parseInt(flowWeekData.passWeekNum),parseInt(flowWeekData.meetWeekNum),parseInt(flowWeekData.reportWeekNum),parseInt(flowWeekData.flowWeekNum));
						  console.info(maxWeekNum);
						//  if(maxWeekNum+"" != '0' ){
							/**  $("#sendDealedWeekNum").css('height',(parseInt(flowWeekData.sendDealedWeekNum)/parseInt(maxWeekNum)).toFixed(2)*100+"%");
							  $("#sendDealedWeekNum").prev().css({"bottom":$("#sendDealedWeekNum").height()});
							  $("#sendDealedWeekNum").prev().html(flowWeekData.sendDealedWeekNum);
							  $("#sendWeekNum").css('height',(parseInt(flowWeekData.sendWeekNum)/parseInt(maxWeekNum)).toFixed(2)*100+"%");
							  $("#sendWeekNum").prev().css({"bottom":$("#sendWeekNum").height()});
							  $("#sendWeekNum").prev().html(flowWeekData.sendWeekNum);
**/
							var sendWeekData = [
								 ['流程发起总数', parseInt(flowWeekData.sendWeekNum)],
								 ['流程办结总数', parseInt(flowWeekData.sendDealedWeekNum)]
							];
							console.info(flowWeekData.sendWeekNum+"=="+flowWeekData.sendDealedWeekNum);
							if(parseInt(flowWeekData.sendWeekNum) == 0 || flowWeekData.sendWeekNum == undefined){
								sendWeekData = [
								 ['流程发起总数', 0],
								 ['流程办结总数', 0]
								];
							}
							
							createPie("sendDealedWeekNum",sendWeekData);

							 /** $("#receiveDealedWeekNum").css('height',(parseInt(flowWeekData.receiveDealedWeekNum)/parseInt(maxWeekNum)).toFixed(2)*100+"%");
							  $("#receiveDealedWeekNum").prev().css({"bottom":$("#receiveDealedWeekNum").height()});
							  $("#receiveDealedWeekNum").prev().html(flowWeekData.receiveDealedWeekNum);
							  $("#receiveWeekNum").css('height',(parseInt(flowWeekData.receiveWeekNum)/parseInt(maxWeekNum)).toFixed(2)*100+"%");
							  $("#receiveWeekNum").prev().css({"bottom":$("#receiveWeekNum").height()});
							  $("#receiveWeekNum").prev().html(flowWeekData.receiveWeekNum);
								**/
								
							var receiveWeekData = [
								 ['流程发起总数', parseInt(flowWeekData.receiveWeekNum)],
								 ['流程办结总数', parseInt(flowWeekData.receiveDealedWeekNum)]
							];
							
							if(parseInt(flowWeekData.receiveWeekNum) == 0 || flowWeekData.receiveWeekNum == undefined){
								receiveWeekData = [
								 ['流程发起总数', 0],
								 ['流程办结总数', 0]
								];
							}
							createPie("receiveDealedWeekNum",receiveWeekData);
								
							/**	
							  $("#askDealedWeekNum").css('height',(parseInt(flowWeekData.askDealedWeekNum)/parseInt(maxWeekNum)).toFixed(2)*100+"%");
							  $("#askDealedWeekNum").prev().css({"bottom":$("#askDealedWeekNum").height()});
							  $("#askDealedWeekNum").prev().html(flowWeekData.askDealedWeekNum);
							  $("#askWeekNum").css('height',(parseInt(flowWeekData.askWeekNum)/parseInt(maxWeekNum)).toFixed(2)*100+"%");
							  $("#askWeekNum").prev().css({"bottom":$("#askWeekNum").height()});
							  $("#askWeekNum").prev().html(flowWeekData.askWeekNum);
							**/
							
							var askWeekData = [
								 ['流程发起总数', parseInt(flowWeekData.askWeekNum)],
								 ['流程办结总数', parseInt(flowWeekData.askDealedWeekNum)]
							];
							
							if(parseInt(flowWeekData.askWeekNum) == 0 || flowWeekData.askWeekNum == undefined){
								askWeekData = [
								 ['流程发起总数', 0],
								 ['流程办结总数', 0]
								];
							}
							createPie("askDealedWeekNum",askWeekData);
							
							
							
							/**
							  $("#passDealedWeekNum").css('height',(parseInt(flowWeekData.passDealedWeekNum)/parseInt(maxWeekNum)).toFixed(2)*100+"%");
							  $("#passDealedWeekNum").prev().css({"bottom":$("#passDealedWeekNum").height()});
							  $("#passDealedWeekNum").prev().html(flowWeekData.passDealedWeekNum);
							  $("#passWeekNum").css('height',(parseInt(flowWeekData.passWeekNum)/parseInt(maxWeekNum)).toFixed(2)*100+"%");
							  $("#passWeekNum").prev().css({"bottom":$("#passWeekNum").height()});
							  $("#passWeekNum").prev().html(flowWeekData.passWeekNum);
									**/
								var passDealedWeekData = [
								 ['流程发起总数', parseInt(flowWeekData.passWeekNum)],
								 ['流程办结总数', parseInt(flowWeekData.passDealedWeekNum)]
							];
							
							if(parseInt(flowWeekData.passWeekNum) == 0 || flowWeekData.passWeekNum == undefined){
								passDealedWeekData = [
								 ['流程发起总数', 0],
								 ['流程办结总数', 0]
								];
							}
							createPie("passDealedWeekNum",passDealedWeekData);	
									
								/**	
							  $("#meetDealedWeekNum").css('height',(parseInt(flowWeekData.meetDealedWeekNum)/parseInt(maxWeekNum)).toFixed(2)*100+"%");
							  $("#meetDealedWeekNum").prev().css({"bottom":$("#meetDealedWeekNum").height()});
							  $("#meetDealedWeekNum").prev().html(flowWeekData.meetDealedWeekNum);
							  $("#meetWeekNum").css('height',(parseInt(flowWeekData.meetWeekNum)/parseInt(maxWeekNum)).toFixed(2)*100+"%");
							  $("#meetWeekNum").prev().css({"bottom":$("#meetWeekNum").height()});
							  $("#meetWeekNum").prev().html(flowWeekData.meetWeekNum);
								**/
							var meetDealedWeekData = [
								 ['流程发起总数', parseInt(flowWeekData.meetWeekNum)],
								 ['流程办结总数', parseInt(flowWeekData.meetDealedWeekNum)]
							];
							
							if(parseInt(flowWeekData.meetWeekNum) == 0 || flowWeekData.meetWeekNum == undefined){
								meetDealedWeekData = [
								 ['流程发起总数', 0],
								 ['流程办结总数', 0]
								];
							}
							createPie("meetDealedWeekNum",meetDealedWeekData);	
								
								
							/**
							  $("#reportDealedWeekNum").css('height',(parseInt(flowWeekData.reportDealedWeekNum)/parseInt(maxWeekNum)).toFixed(2)*100+"%");
							  $("#reportDealedWeekNum").prev().css({"bottom":$("#reportDealedWeekNum").height()});
							  $("#reportDealedWeekNum").prev().html(flowWeekData.reportDealedWeekNum);
							  $("#reportWeekNum").css('height',(parseInt(flowWeekData.reportWeekNum)/parseInt(maxWeekNum)).toFixed(2)*100+"%");
							  $("#reportWeekNum").prev().css({"bottom":$("#reportWeekNum").height()});
							  $("#reportWeekNum").prev().html(flowWeekData.reportWeekNum);
								**/
							var reportDealedWeekData = [
								 ['流程发起总数', parseInt(flowWeekData.reportWeekNum)],
								 ['流程办结总数', parseInt(flowWeekData.reportDealedWeekNum)]
							];
							
							if(parseInt(flowWeekData.reportWeekNum) == 0 || flowWeekData.reportWeekNum == undefined){
								reportDealedWeekData = [
								 ['流程发起总数', 0],
								 ['流程办结总数', 0]
								];
							}
							createPie("reportDealedWeekNum",reportDealedWeekData);	
								
							/**	
							  $("#flowDealedWeekNum").css('height',(parseInt(flowWeekData.flowDealedWeekNum)/parseInt(maxWeekNum)).toFixed(2)*100+"%");
							  $("#flowDealedWeekNum").prev().css({"bottom":$("#flowDealedWeekNum").height()});
							  $("#flowDealedWeekNum").prev().html(flowWeekData.flowDealedWeekNum);
							  $("#flowWeekNum").css('height',(parseInt(flowWeekData.flowWeekNum)/parseInt(maxWeekNum)).toFixed(2)*100+"%");
							  $("#flowWeekNum").prev().css({"bottom":$("#flowWeekNum").height()});
							  $("#flowWeekNum").prev().html(flowWeekData.flowWeekNum);
							  **/
							  var flowDealedWeekData = [
								 ['流程发起总数', parseInt(flowWeekData.flowWeekNum)],
								 ['流程办结总数', parseInt(flowWeekData.flowDealedWeekNum)]
							];
							
							if(parseInt(flowWeekData.flowWeekNum) == 0 || flowWeekData.flowWeekNum == undefined){
								flowDealedWeekData = [
								 ['流程发起总数', 0],
								 ['流程办结总数', 0]
								];
							}
							createPie("flowDealedWeekNum",flowDealedWeekData);	
								
							  
							  
							  
							  
							  
						 // }

						   //上周流程办理时间
						  var maxWeekTime = Math.max(parseFloat(flowWeekData.sendWeekTime),parseFloat(flowWeekData.receiveWeekTime),parseFloat(flowWeekData.askWeekTime),parseFloat(flowWeekData.passWeekTime),parseFloat(flowWeekData.meetWeekTime),parseFloat(flowWeekData.reportWeekTime),parseFloat(flowWeekData.flowWeekTime));
						  if(maxWeekTime+"" != '0.0'){
							  $("#sendWeekTime").css('height',(parseFloat(flowWeekData.sendWeekTime)/parseFloat(maxWeekTime)).toFixed(2)*100+"%");
							  $("#sendWeekTime").prev().css({"bottom":$("#sendWeekTime").height()});
							  $("#sendWeekTime").prev().html(parseFloat(flowWeekData.sendWeekTime).toFixed(2));

							  $("#receiveWeekTime").css('height',(parseFloat(flowWeekData.receiveWeekTime)/parseFloat(maxWeekTime)).toFixed(2)*100+"%");
							  $("#receiveWeekTime").prev().css({"bottom":$("#receiveWeekTime").height()});
							  $("#receiveWeekTime").prev().html(parseFloat(flowWeekData.receiveWeekTime).toFixed(2));

							  $("#askWeekTime").css('height',(parseFloat(flowWeekData.askWeekTime)/parseFloat(maxWeekTime)).toFixed(2)*100+"%");
							  $("#askWeekTime").prev().css({"bottom":$("#askWeekTime").height()});
							  $("#askWeekTime").prev().html(parseFloat(flowWeekData.askWeekTime).toFixed(2));

							  $("#passWeekTime").css('height',(parseFloat(flowWeekData.passWeekTime)/parseFloat(maxWeekTime)).toFixed(2)*100+"%");
							  $("#passWeekTime").prev().css({"bottom":$("#passWeekTime").height()});
							  $("#passWeekTime").prev().html(parseFloat(flowWeekData.passWeekTime).toFixed(2));

							  $("#meetWeekTime").css('height',(parseFloat(flowWeekData.meetWeekTime)/parseFloat(maxWeekTime)).toFixed(2)*100+"%");
							  $("#meetWeekTime").prev().css({"bottom":$("#meetWeekTime").height()});
							  $("#meetWeekTime").prev().html(parseFloat(flowWeekData.meetWeekTime).toFixed(2));

							  $("#reportWeekTime").css('height',(parseFloat(flowWeekData.reportWeekTime)/parseFloat(maxWeekTime)).toFixed(2)*100+"%");
							  $("#reportWeekTime").prev().css({"bottom":$("#reportWeekTime").height()});
							  $("#reportWeekTime").prev().html(parseFloat(flowWeekData.reportWeekTime).toFixed(2));

							  $("#flowWeekTime").css('height',(parseFloat(flowWeekData.flowWeekTime)/parseFloat(maxWeekTime)).toFixed(2)*100+"%");
							  $("#flowWeekTime").prev().css({"bottom":$("#flowWeekTime").height()});
							  $("#flowWeekTime").prev().html(parseFloat(flowWeekData.flowWeekTime).toFixed(2));
						  }


						}	
						
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
					}
				});
		});

		
 function createPie(id,data){
	 
	var title = {
            text: ''
        };
	var tooltip = {
			headerFormat:"",
			useHTML: true,
			crosshairs: true,
			pointFormat:"<div style='color:#063990;font-weight:bold' >"+data[0][0]+":</b><br/>"+data[0][1]+"个</b><br/>"+data[1][0]+":</b><br/>"+data[1][1]+"个</div>"	 
        };
		
	if(data[0][1] == 0 ){
		tooltip = {
			headerFormat:"",
			useHTML: true,
			crosshairs: true,
			pointFormat:"<div style='color:#063990;font-weight:bold' >"+data[0][0]+":</b><br/>0个</b><br/>"+data[1][0]+":</b><br/>0个</div>"
		};
		
		data = [
                ['', 100]
               
            ];
	}else if(data[1][1] == 0){
		tooltip = {
			headerFormat:"",
			useHTML: true,
			crosshairs: true,
			pointFormat:"<div style='color:#063990;font-weight:bold' >"+data[0][0]+":</b><br/>"+data[0][1]+"个</b><br/>"+data[1][0]+":</b><br/>0个</div>"
		};
		
		data = [
                ['', 100]
               
            ];
	}
		
	var colors = ['#063990', '#51B2D1'];
	var plotOptions = {
            pie: {
                allowPointSelect: false,
                dataLabels: {
                    enabled:false
                }
            }
        };
		
		
	$("#"+id).highcharts({ 
		title: title,
        tooltip: tooltip,
		colors: colors,
        plotOptions: plotOptions,
		
        series: [{
            type: 'pie',
            name: '',
            data: data
        }]
    });
}	

</script>
</html>
