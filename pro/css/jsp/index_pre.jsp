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
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.whir.rd.sggf.webindex.index.*"%>
<%@ page import="com.whir.rd.sggf.webindex.bd.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.whir.i18n.Resource" %>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.whir.org.basedata.bd.UnitSetBD" %>
<%@ page import="com.whir.org.basedata.po.UnitInfoPO" %>
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
<%@ page import="java.awt.Color" %>
<%@ page import="com.whir.common.db.Dbutil"%>
<%@ page import="org.jfree.chart.ChartFactory,org.jfree.chart.JFreeChart,org.jfree.chart.plot.PlotOrientation,org.jfree.chart.servlet.ServletUtilities,org.jfree.data.category.DefaultCategoryDataset,org.jfree.chart.renderer.category.BarRenderer3D,org.jfree.chart.plot.CategoryPlot,org.jfree.chart.labels.StandardCategoryItemLabelGenerator,org.jfree.data.category.CategoryDataset,org.jfree.data.general.DatasetUtilities,org.jfree.chart.labels.ItemLabelPosition,org.jfree.chart.labels.ItemLabelAnchor,org.jfree.ui.TextAnchor,org.jfree.chart.axis.AxisLocation,org.jfree.chart.axis.ValueAxis"%>

<script type="text/javascript">
	var whirRootPath = "<%=rootPath%>";
	var preUrl = "<%=preUrl%>"; 
	var whir_browser = "<%=whir_browser%>"; 
	var whir_agent = "<%=com.whir.component.security.crypto.EncryptUtil.htmlcode(whir_agent)%>"; 
	var whir_locale = "<%=whir_locale.toLowerCase()%>"; 
</script>
<head>
	<title>北京首钢股份有限公司</title>
	<meta name="renderer" content="ie-comp">
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
<body id="gfPortal">

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
String path = "information";
GetPortalInfo gpInfo=new GetPortalInfo();
WebIndexBD webIndexBD = new WebIndexBD();
List tpxwp=new ArrayList();
List tpxwpId=new ArrayList();
List xwdt=new ArrayList();
List hyjy=new ArrayList();
List ggxx=new ArrayList();
tpxwpId=gpInfo.getNewsPH("80707",orgId,60);
String strTpxwpId = "";
if(tpxwpId!=null&&tpxwpId.size()>0){
	int j=0;
	for(int i=0;i<tpxwpId.size();i++){
		String [] arr = (String [])tpxwpId.get(i);
		if(strTpxwpId.indexOf(arr[0])<0){
		   strTpxwpId += arr[0]+",";
		   j++;
	   }
	   if(j>5){
		   break;
	   }
	}
}
strTpxwpId = strTpxwpId.substring(0,strTpxwpId.length()-1);
//System.out.println("----------strTpxwpId------------:"+strTpxwpId);
tpxwp=gpInfo.getGfNewsPH("80707",orgId,60,strTpxwpId);
xwdt=gpInfo.getInfo("23683",orgId,24);
hyjy=gpInfo.getInfo("23656",orgId,24);
ggxx=gpInfo.getInfo("80245",orgId,24);

List ztzl=new ArrayList();
ztzl=gpInfo.getZtzlGF(12);

WebIndexSggfBD webIndexSggfBD=new WebIndexSggfBD();
List hytzFBSJ=new ArrayList();
List hytzHYSJ=new ArrayList();
hytzFBSJ = webIndexSggfBD.getInfoHytz("fbsj");
hytzHYSJ = webIndexSggfBD.getInfoHytz("hysj");
int todayNum=hytzHYSJ.size();

List zbxx=new ArrayList();
zbxx=webIndexBD.getRotaList();
List bmList = new ArrayList();
bmList = webIndexSggfBD.getOrgList2();
%>

<%
java.util.Date d = new java.util.Date();
java.text.SimpleDateFormat sdf01 = new java.text.SimpleDateFormat("yyyy");
java.text.SimpleDateFormat sdf02 = new java.text.SimpleDateFormat("MM/dd");
java.text.SimpleDateFormat sdf03 = new java.text.SimpleDateFormat("EEEE");
java.text.SimpleDateFormat sdf04 = new java.text.SimpleDateFormat("HH:mm:ss");
java.text.SimpleDateFormat sdf05 = new java.text.SimpleDateFormat("MM-dd");
String date01 = sdf01.format(d);
String date02 = sdf02.format(d);
String date03 = sdf03.format(d);
String date04 = sdf04.format(d);
%>
<!--头部公共文件-->
<%@ include file="/rd/info/index_pre_header.jsp"%>	



<%
if("red".equals(skin)){
%>
	   
    <%
    List banner = new ArrayList();
	String sql="select WHIR$BANNER_TPLINK from whir$banner";
		banner = commonBD.getListBySQL(sql);
		String bannersrc="";
		
		Object[] obj = (Object[])banner.get(0);
		String   banName = (String)obj[0].toString();
		String[] bansrcs = banName.split(",");
		String   bansrc  = bansrcs[0];
		bannersrc= preUrl+"/upload/customform/"+bansrc.substring(0,6)+"/"+bansrc;
		
%>

<%
   if(bannersrc!=""&&bannersrc.length()>0){%>
	<div class="pro-banner" align="center">
      <img src="<%=bannersrc%>">
    </div>   
   <%}%>


   
 
 
 
 
 <%}%>
  <div class="pro-container clearfix">
    <div class="pro-cl">
      <div class="clearfix">
        <div class="pro-box pro-pic-info">   
          <div class="flexslider">
            <a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gftp&channelId=80707&startPage=1&pageSize=6&orgId=<%=orgId%>"><strong style="border-top: 0px">图片新闻</strong></a>
            <ul class="slides">
			<%
				if(tpxwp!=null&&tpxwp.size()>0){
					String  strInfromationId = "";
					for(int i=0;i<tpxwp.size();i++){
						String [] arr=(String [])tpxwp.get(i);
						if(strInfromationId.equals(arr[0])){
							continue;
						}
						strInfromationId = arr[0];
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
							String title = arr[1];
							if(title.length()>30){
								title = title.substring(0,30)+"...";
							}
						
					%>

					<li>
						<a href="javascript:void(0)" title='<%=arr[1]%>' onclick="infoDetailView('<%=arr[0]%>');">
						<img src="<%=smallSrcUrl%>" />
						<div>
						  <p><%=title%></p>
						  <!--<span><%=arr[7]%>「<%=arr[2]%>」</span>-->
						</div>
						</a>
					</li>
			<%}}}%>  
              
            </ul>
          </div>
        </div>
        <div class="pro-box pro-border pro-padding pro-new">
          <div class="pro-box-title">
            <span><em></em>新闻动态</span>
            <a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23683&startPage=1&pageSize=12&orgId=<%=orgId%>">更多>></a>
          </div>
          <div class="pro-list">
            <ul id="xwdtList" >
			<%
			if(xwdt!=null&&xwdt.size()>0){
				for(int i=0;i<xwdt.size()&&i<8;i++){
					String [] arr=(String [])xwdt.get(i);
					String title = arr[1];
					if(title.length()>20){
						title = title.substring(0,20)+"...";
					}

				%>
					<li >
                   
                        <font>■</font>
						 <a href="javascript:void(0)" title='<%=arr[1]%>' onclick="infoDetailView('<%=arr[0]%>');">
                        <em><%=title%></em>
						</a>
						
                        
					</li>
			<%}}%>
            </ul>
            <div class="page-div">
              <a href="javascript:void(0)" onclick="xwdtBefore();">上一页</a>
              <span>
			  <em id="xwdtNo">1</em>
			  <em>/</em>
			  <em>3</em>
			  </span>
              <a href="javascript:void(0)" onclick="xwdtNext();">下一页</a>
            </div>
          </div>
        </div>
      </div>

     <div class="pro-meeting-con clearfix">
            <div class="pro-box pro-meeting-jy">
                    <div class="pro-box-title">
                        <span><em></em>公告信息</span>
                        <a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=80245&startPage=1&pageSize=12&orgId=<%=orgId%>">更多>></a>
                    </div>
                    <div class="pro-meeting-container">
                        <div class="flexslider4">
                            <ul class="slides">
                                <li>
                                    <div id="ggxxList1" class="pro-list-div">
									<%
										if(ggxx!=null&&ggxx.size()>0){
											for(int i=0;i<ggxx.size()&&i<8;i++){
												String [] arr=(String [])ggxx.get(i);
												String title = arr[1];
												if(title.length()>50){
													title=title.substring(0,50)+"...";
												}
												String[] infoTimeArr = (arr[2].toString()).split("-");

										%>

                                        <div class="clearfix">
                                               <strong><span><%=infoTimeArr[2]%></span><br><%=infoTimeArr[1]%>月</strong>
                                           <a href="javascript:void(0);" title='<%=arr[1]%><%=arr[2]%>' onclick="infoDetailView('<%=arr[0]%>');">
                                                <p><%=title%></p>
                                            </a>
                                        </div>
                                       <%}}%>
                                    </div>
                                </li>
                                <li>
                                    <div id="ggxxList2" class="pro-list-div">
                                       <%
										if(ggxx!=null&&ggxx.size()>8){
											for(int i=8;i<ggxx.size()&&i<16;i++){
												String [] arr=(String [])ggxx.get(i);
												String title = arr[1];
												if(title.length()>50){
													title=title.substring(0,50)+"...";
												}
												String[] infoTimeArr = (arr[2].toString()).split("-");
										%>

                                        <div class="clearfix">
                                               <strong><span><%=infoTimeArr[2]%></span><br><%=infoTimeArr[1]%>月</strong>
                                           <a href="javascript:void(0);" title='<%=arr[1]%><%=arr[2]%>' onclick="infoDetailView('<%=arr[0]%>');">
                                                <p><%=title%></p>
                                            </a>
                                        </div>
                                       <%}}%>
                                    </div>
                                </li>
                                <li>
                                    <div id="ggxxList3" class="pro-list-div">
									<%
										if(ggxx!=null&&ggxx.size()>16){
											for(int i=16;i<ggxx.size()&&i<24;i++){
												String [] arr=(String [])ggxx.get(i);
												String title = arr[1];
												if(title.length()>50){
													title=title.substring(0,50)+"...";
												}
												String[] infoTimeArr = (arr[2].toString()).split("-");
										%>

                                        <div class="clearfix">
                                               <strong><span><%=infoTimeArr[2]%></span><br><%=infoTimeArr[1]%>月</strong>
                                           <a href="javascript:void(0);" title='<%=arr[1]%><%=arr[2]%>' onclick="infoDetailView('<%=arr[0]%>');">
                                                <p><%=title%></p>
                                            </a>
                                        </div>
                                       <%}}%>
                                        
                                       
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
				 <div class="pro-box pro-meeting  meeting-tab1">
                    <div class="pro-box-title">
                        <span name="hy" class="current"><em></em>会议通知</span>
                        <span name="hy" class="jy"><em></em>会议纪要</span>
                        <a href="javascript:void(0);" onclick="hyMore(this);">更多>></a>
                    </div>
                    <div class="pro-meeting-container">
                        <div class="tabbox" style="display: block;">
                             <div class="isf flexslider2">
								<ul class="slides">
								<%
								  if(hytzFBSJ!=null&&hytzFBSJ.size()>0){
									  int lineNum = 0;
									  if(hytzFBSJ.size()%8==0){
										  lineNum = hytzFBSJ.size()/8;
									  }
									  else{
										  lineNum = hytzFBSJ.size()/8 + 1;
									  }
									  for(int i=0;i<lineNum;i++){
											
								  %>
									<li>
										<div class="pro-list-div">
										 <%
										  for(int j=0;j<8&&(j+i*8)<hytzFBSJ.size();j++){
													String [] arr=(String [])hytzFBSJ.get(j+i*8);
													String title = arr[12];
													if(title.length()>50){
														title=title.substring(0,50)+"...";
													}
													String[] tt = arr[1].substring(0,10).split("-");
													String hytime=arr[1].substring(10,arr[1].toString().length());
										%>
											<div class="clearfix">
											<strong><span><%=tt[1]%>-<%=tt[2]%></span><br><%=hytime%></strong>
												<a href="javascript:void(0)" title='<%=arr[12]%><%=arr[1]%>' onclick="meetDetailView('<%=arr[0]%>');">
													<p><%=title%></p>
												</a>
											</div>
											<%}%>
										</div>
									</li>
                              <%}}%>
                            </ul>
                             </div>
                             <div class="isf flexslider3" style="display: none; ">
                            <ul class="slides">
								 <%
							  if(hytzHYSJ!=null&&hytzHYSJ.size()>0){
								  int lineNum = 0;
								 
								  if(hytzHYSJ.size()%8==0){
									  lineNum = hytzHYSJ.size()/8;
								  }
								  else{
									  lineNum = hytzHYSJ.size()/8 + 1;
								  }
								  for(int i=0;i<lineNum;i++){
										
							  %>
                                <li>
                                    <div class="pro-list-div">
                                      <%
									 for(int j=0;j<8&&(j+i*8)<hytzHYSJ.size();j++){
											String [] arr=(String [])hytzHYSJ.get(j+i*8);
											Date date = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm").parse(arr[10]); 
											String meetTime = new java.text.SimpleDateFormat("HH:mm").format(date);
											String title = arr[12];
											if(title.length()>50){
												title=title.substring(0,50)+"...";
											}
										%>
										<div class="clearfix">
											<strong style="height:35px;line-height: 35px;"><span><%=meetTime%></span><br></strong>
												<a href="javascript:void(0)" title='<%=arr[12]%><%=arr[1]%>' onclick="meetDetailView('<%=arr[0]%>');">
													<p><%=title%></p>
												</a>
											</div>
										<%}%>
                                    </div>
                                </li>
                                <%}}%>
                            </ul>
                             </div>
                             <div class="flex-btn clearfix" id="flex-btn1">
                                 <a href="javascript:void(0);" class="fb1 current"><em></em><span>发布时间排序</span></a>
								 <a href="javascript:void(0);" class="fb2"><em></em><span>今日会议（<%=todayNum%>）</span></a>
                             </div>
                        </div>

                       <div class="tabbox" style="display: none">
                             
                           <div class="flexslider9">
                            <ul class="slides">
                                <li>
                                    <div class="pro-list-div">
                                      <%
										if(hyjy!=null&&hyjy.size()>0){
											for(int i=0;i<hyjy.size()&&i<8;i++){
												String [] arr=(String [])hyjy.get(i);
												String title = arr[1];
												if(title.length()>50){
													title=title.substring(0,50)+"...";
												}
												String[] tt = arr[2].toString().split("-");
											%>
										 <div class="clearfix">
                                               <strong><span><%=tt[2]%></span><br><%=tt[1]%>月</strong>
                                           <a href="javascript:void(0);" title='<%=arr[1]%><%=arr[2]%>' onclick="infoDetailView('<%=arr[0]%>');">
                                                <p><%=title%></p>
                                            </a>
                                        </div>
									<%}}%>
                                    </div>
                                </li>
                                <li>
                                    <div class="pro-list-div">
									<%
										if(hyjy!=null&&hyjy.size()>8){
											for(int i=8;i<hyjy.size()&&i<16;i++){
												String [] arr=(String [])hyjy.get(i);
												String title = arr[1];
												if(title.length()>50){
													title=title.substring(0,50)+"...";
												}
												String[] tt = arr[2].toString().split("-");
											%>
										 <div class="clearfix">
                                               <strong><span><%=tt[2]%></span><br><%=tt[1]%>月</strong>
                                           <a href="javascript:void(0);" title='<%=arr[1]%><%=arr[2]%>' onclick="infoDetailView('<%=arr[0]%>');">
                                                <p><%=title%></p>
                                            </a>
                                        </div>
									<%}}%>
                                       
                                    </div>
                                </li>
                                <li>
                                    <div class="pro-list-div">
									<%
										if(hyjy!=null&&hyjy.size()>16){
											for(int i=16;i<hyjy.size()&&i<24;i++){
												String [] arr=(String [])hyjy.get(i);
												String title = arr[1];
												if(title.length()>50){
													title=title.substring(0,50)+"...";
												}
												String[] tt = arr[2].toString().split("-");
											%>
										 <div class="clearfix">
                                               <strong><span><%=tt[2]%></span><br><%=tt[1]%>月</strong>
                                            <a href="javascript:void(0);" title='<%=arr[1]%><%=arr[2]%>' onclick="infoDetailView('<%=arr[0]%>');">
                                                <p><%=title%></p>
                                            </a>
                                        </div>
									<%}}%>
                                    </div>
                                </li>
                            </ul>
                        </div>    
                        </div>
                    </div>
                </div>
            </div>
      <div class="pro-box pro-pro pro-border pro-padding pro-more pro-subject">
        <div class="pro-box-title">
          <span><em></em>专题专栏</span>
          <a href="/defaultroot/rd/info/gf-ztzl.jsp">更多>></a>
        </div>
        <div class="pro-box-con">
          <div class="flexslider5">
            <ul class="slides">
				<%
				if(ztzl!=null&&ztzl.size()>0){
				for(int i=0;i<ztzl.size();i++){
				String [] arr=(String [])ztzl.get(i);
				String accName=arr[2];
				String url = arr[3];
				//System.out.println("------------------------------------accName:"+accName);
				String src= preUrl+"/upload/customform/"+accName.substring(0,6)+"/"+accName;
				String title = arr[1];
				if(title.length()>20){
					title=title.substring(0,20)+"...";
				}
				%>
				<li>
					<a href="<%=url%>" title='<%=arr[1]%>'>
					<div class="wrap">
					<font><%=i+1%></font>
					<img src="<%=src%>"  alt="">
					<p><%=title%></p>
					</div>
					</a>
				</li>
			<%}}%> 
            </ul>
          </div>
        </div>
      </div>
    </div>
    <div class="pro-cr">
	<!-- 股票-->
    <div class="pro-box pro-border pro-padding pro-gupiao pro-more">
                <div class="pro-box-title clearfix">
                    <span class="fl"><em></em>股票</span>
                </div>
                <p class="part1">首钢股份[000959]</p>
                <p id="shareLogo" class="part2 zj "><em id="newPrice"></em> <span></span><em id="increase"></em> </p>
                <h3>上证：3217.93(+0.03%)</h3>
                <h3>深成：3217.93(+0.03%)</h3> 
           
            </div>

	<!-- 股票-->

 <div class="pro-box pro-border pro-padding pro-hyd pro-more">
<%

	String sql1=" SELECT COUNT (*) FROM org_employee emp, org_organization_user org_user, org_organization org WHERE     emp.emp_id = org_user.emp_id AND org.org_id = org_user.org_id AND org.orgidstring LIKE '%12667%' and emp.USERISDELETED=0 and org.ORGSTATUS=0 ";
	String sql2=" SELECT COUNT (*) FROM security_onlineuser onlineuser,org_organization_user org_user,org_organization org WHERE onlineuser.user_id = org_user.emp_id AND org.org_id = org_user.org_id AND org.orgidstring LIKE '%12667%' and org.ORGSTATUS=0 ";
	String sql3=" SELECT COUNT (*) FROM org_employee emp, org_organization_user org_user, org_organization org WHERE     emp.MOBILE_USER_FLAG = 1 AND emp.emp_id = org_user.emp_id AND org.org_id = org_user.org_id AND org.orgidstring LIKE '%12667%' and emp.USERISDELETED=0 and org.ORGSTATUS=0 ";

	//1. 当天发起流程个数：
	String sql4="select   count(*)  from  ez_flow_hi_procinst    t   where   to_char(start_time_,'yyyy-mm-dd')=to_char(SYSDATE,'yyyy-mm-dd')";

	//2.  每个正常办理结束的流程的 平均 花费时间   单位（天）
	String sql5="select  avg(cast(t.end_time_ as date)-cast(t.start_time_ as date))    from  ez_flow_hi_procinst  t  where      t.whir_status=100";

	//3.  超过两天办理的流程  yucz 20172021 改为流程总数
	String sql6="select sum(bj),sum(jxz) from (select code as lcbm,sort as lcpxm,processname as lcmc,lctype as lclx,sum(case when aa.whir_status is not null then 1  else 0 end ) fqzs, sum(case when aa.whir_status =100 then 1  else 0 end ) bj, sum(case when aa.whir_status =1 then 1  else 0 end ) jxz,sum(case when aa.whir_status =-1 then 1  else 0 end ) thzf, sum(case when aa.whir_status =-2 then 1  else 0 end ) qx from (select code,whir_processdesignername,lctype,start_time_ ,end_time_,whir_status,lctime,activttime,zz.sort,zz.processname from (SELECT substr(proc_def_id_,1,instr(proc_def_id_,':',1)-1) as code, whir_processdesignername as whir_processdesignername, case when t.whir_update_url like '%GovDoc%' then '公文' else '事务性流程' end as lctype,  t.start_time_ as start_time_ ,t.end_time_ as end_time_,t.whir_status as whir_status, round((cast(end_time_ as date)-cast(start_time_ as date))*24,2) as lctime,case when (SELECT COUNT(DISTINCT tt.task_def_key_) FROM ez_flow_hi_taskinst tt WHERE tt.proc_inst_id_=t.id_)=0 then 0 else  round((CAST(t.end_time_ AS DATE)-CAST(t.start_time_ AS DATE))*24/ (SELECT COUNT(DISTINCT tt.task_def_key_) FROM ez_flow_hi_taskinst tt WHERE tt.proc_inst_id_=t.id_ ),2) end AS activttime FROM ez_flow_hi_procinst t where start_time_ >to_date('2017-01-10 00:00:00','YYYY-MM-DD HH24:MI:SS') and whir_isdeleted=0) ww, ez_flow_de_designer zz where ww.code=zz.processid order by ww.lctype asc, zz.sort asc,whir_processdesignername) aa where code not in ('XSGSHBFK') group by code,sort,lctype,processname order by lctype desc, sort asc,processname)";

	//4.今日发布信息
	String sql7="select count(*) from oa_information where   to_char(informationissuetime,'yyyy-mm-dd')=to_char(SYSDATE,'yyyy-mm-dd')";

	//Map varMap1=new HashMap();
	Map varMap2=new HashMap();
	Map varMap3=new HashMap();
	Map varMap4=new HashMap();
	Map varMap5=new HashMap();
	Map varMap6=new HashMap();
	Map varMap7=new HashMap();
	Dbutil  dbUtil=new Dbutil();
	//Object []workInfoObj1=null;
	Object []workInfoObj2=null;
	Object []workInfoObj3=null;
	Object []workInfoObj4=null;
	Object []workInfoObj5=null;
	Object []workInfoObj6=null;
	Object []workInfoObj7=null;
	try {
		//workInfoObj1=dbUtil.getFirstDataBySQL(sql1, varMap1);
		workInfoObj2=dbUtil.getFirstDataBySQL(sql2, varMap2);
		workInfoObj3=dbUtil.getFirstDataBySQL(sql3, varMap3);
		workInfoObj4=dbUtil.getFirstDataBySQL(sql4, varMap4);
		workInfoObj5=dbUtil.getFirstDataBySQL(sql5, varMap5);
		workInfoObj6=dbUtil.getFirstDataBySQL(sql6, varMap6);
		workInfoObj7=dbUtil.getFirstDataBySQL(sql7, varMap7);
	} catch (Exception e) { 
		e.printStackTrace();
	}
	String strAvg = workInfoObj5[0].toString();
	if(strAvg.indexOf(".")>0){
		int i = strAvg.indexOf(".");
		if(strAvg.length()>i+3){
			strAvg= strAvg.substring(0,i+3);
		}
	}
	String bjlc=workInfoObj6[0]==null?"0":workInfoObj6[0].toString();
	String jxzlc=workInfoObj6[1]==null?"0":workInfoObj6[1].toString();
	
	int yxlc=0;
	if(!"".equals(bjlc)){
		yxlc=Integer.parseInt(bjlc);
	}
	
	if(!"".equals(jxzlc)){
		yxlc=yxlc+Integer.parseInt(jxzlc);
	}
	
	//System.out.println("---------------------------"+workInfoObj1[0]);
	//System.out.println("---------------------------"+workInfoObj2[0]);
	//System.out.println("---------------------------"+workInfoObj3[0]);
	%>
	<!-- oa活跃度-->
             
                <div class="pro-box-title clearfix">
                    <span class="fl"><em></em>系统使用统计</span>
                    <!--<a target="_blank" href="/defaultroot/rd/info/gf-chat.jsp">更多>></a>-->
                </div>

               <div class="hyd">
                     <div class="box clearfix ">
                        <div class="fl title">活跃用户</div>
                        <div class="fr clearfix">
                           <p><span >活跃人数</span><em><%=workInfoObj3[0]%>(人)</em></p>
                           <p><span>在线人数</span><em><%=workInfoObj2[0]%>(人)</em></p>
                        </div>

                      </div>
                      <div class="box clearfix ">
                        <div class="fl title">流程绩效</div>
                        <div class="fr clearfix">
                           <p><span >流转平均时间</span><em><%=strAvg%>(天)</em></p>
                           <p><span>流程总数</span><em><%=yxlc%>(个)</em></p>
                        </div>

                      </div>
                       <div class="box clearfix ">
                           <div class="fl title" style="height: 25px;line-height: 25px;">今日流程</div>
                           <div class="fr clearfix" >
                              <p>
							  <span></span>
							  <em><%=workInfoObj4[0]%>(个)</em>
							  </p>
                             </div>
                      </div>
                      <div class="box clearfix ">
                           <div class="fl title" style="height: 25px;line-height: 25px;">今日发布信息</div>
                           <div class="fr clearfix" >
                              <p>
							  <span></span>
							  <em><%=workInfoObj7[0]%>(个)</em></p>
                             </div>
                      </div>
               </div>
                
           
            </div>
		<!-- oa活跃度-->

       <!-- 天气预报 -->

            <div class="pro-box pro-border pro-padding pro-tqyb">
                <div class="pro-box-title clearfix">
                    <span class="fl"><em></em>天气预报 </span>
                  
                </div>
                <div class="clearfix rq">
                    <span>迁安</span>
                    <em id="dateInfo"></em>
                </div>
                
                <div class="clearfix tiqnqi1">
                <div class="img fl"><img id="weatherPng" src="pro/img/weather/PNG/1.png"></div>
                   <div class="pbox fl">
                          <p><span id="weather"></span> &nbsp;  <span id="temp"></span></p>
                          <p><span id="wind"></span>&nbsp;   湿度：<span id="humidity"></span></p>
                          <div class="line"></div>
                          <p>空气质量：<span id="air"></span></p>
                          <p>AQI：<span id="aqi"></span>   PM2.5：<span id="pm25"></span></p>
                    </div>
                </div>
                   
            </div>

            <!-- 生活指数 -->

            <div class="pro-box pro-border pro-padding pro-shzs">
                <div class="pro-box-title clearfix">
                    <span class="fl"><em></em>生活指数</span>
                  
                </div>
                
               <table>
                     <tr>
                          <td>
                               <div class="icon icon01 fl"></div>
                               <div class="jt">紫外线强度:<span id="live1"></span></div>
                          </td>
                          <td>
                               <div class="icon icon02 fl"></div>
                               <div class="fl jt">感冒指数:<span id="live2"></span></div>
                          </td>
                          
                     </tr>
                     <tr>
                          <td>
                               <div class="icon icon03 fl"></div>
                               <div class="jt">雨伞指数:<span id="live3"></span></div>
                          </td>
                          <td>
                               <div class="icon icon04 fl"></div>
                               <div class="fl jt">穿衣指数:<span id="live4"></span></div>
                          </td>
                          
                     </tr>
               </table>
            </div>

<script type="text/javascript">
		var timerID = null;
		var timerRunning = false;

		function stopclock (){
			if(timerRunning)
			clearTimeout(timerID);
			timerRunning = false;
		}

		function startclock () {
			stopclock();
			showtime();
		}
		function showtime () {
			var now = new Date();
			var hours = now.getHours();
			var minutes = now.getMinutes();
			var seconds = now.getSeconds()
			var timeValue = "";
			timeValue +=  hours
			timeValue += ((minutes < 10) ? ":0" : ":") + minutes
			timeValue += ((seconds < 10) ? ":0" : ":") + seconds
			$('#timeStr').html(timeValue);
			timerID = setTimeout("showtime()",1000);
			timerRunning = true;
		}
		
			
	$(document).ready(function(){
		jQuery.support.cors = true;
		startclock();
			var url = "/defaultroot/rd/govoffice/gov_documentmanager/forms/getDataInfo.jsp?randomid=" + (new Date()).getTime();
				$.ajax({
					url: url,
					type: "post",
					async: false,
					success: function (data) {
					data = data.replace(/(^\s*)|(\s*$)/g, '');
						if(data != ''){
							data = eval('('+data+')');
							//日期和时间
							var html=data.date +'&nbsp;&nbsp;'+data.week+'&nbsp;&nbsp;农历'+data.lunar+'<br><em id="timeStr"></em>&nbsp;&nbsp;天气实况'
							$("#dateInfo").html(html);

							//空气质量
							$("#air").html(data.kqzl);
						
							$("#aqi").html(data.aqi);
						
							$("#pm25").html(data.pm25);

							//天气
							$("#weather").html(data.tq);

							var weatherPng = "-1";
							if(data.tq == '晴'){
								weatherPng = '0';
							}else if(data.tq == '多云'){
								weatherPng = '1';
							}else if (data.tq == '阴'){
								weatherPng = '2';
							}else if (data.tq.indexOf("雨")!= -1){
								weatherPng = '8';
							}else if (data.tq.indexOf("雪")!= -1){
								weatherPng = '15';
							}else{
								weatherPng = '0';
							}

							$("#weatherPng").attr('src','pro/img/weather/PNG/'+weatherPng+'.png');
						
							$("#temp").html(data.wd+"℃");
						
							$("#wind").html(data.fx+data.fl);
						
							$("#humidity").html(data.sd);

							//生活指数
							$("#live1").html(data.zwx);
						
							$("#live2").html(data.gmzs);
						
							$("#live3").html(data.xszs);
						
							$("#live4").html(data.cyzs);
						}
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	});
</script>

             <!-- 生活服务 -->

            <div class="pro-box pro-border pro-padding pro-shzs pro-shfy pro-more">
                <div class="pro-box-title clearfix">
                    <span class="fl"><em></em>生活服务</span>
                  
                </div>
                
               <table>
                     <tr>
                          <td>
                               <div class="icon icon05 fl"></div>
                               <div class="fl jt"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23864&startPage=1&pageSize=12&orgId=<%=orgId%>">班车信息</a></div>
                          </td>
                          <td>
                               <div class="icon icon06 fl"></div>
                               <div class="fl jt"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23876&startPage=1&pageSize=12&orgId=<%=orgId%>">寻物启事</a></div>
                          </td>
                          
                     </tr>
                     <tr>
                          <td>
                               <div class="icon icon07 fl"></div>
                               <div class="fl jt"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=349413&startPage=1&pageSize=12&orgId=<%=orgId%>">厂区小卖部</a></div>
                          </td>
                          <td>
                               <div class="icon icon08 fl"></div>
                               <div class="fl jt"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23878&startPage=1&pageSize=12&orgId=<%=orgId%>">失物招领</a></div>
                          </td>
                          
                     </tr>
                      <tr>
                          <td>
                               <div class="icon icon09 fl"></div>
                               <div class="fl jt"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23868&startPage=1&pageSize=12&orgId=<%=orgId%>">工作餐食谱</a></div>
                          </td>
                          <td>
                               <div class="icon icon10 fl"></div>
                               <div class="fl jt" style="margin-left: -9px;"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=305767&startPage=1&pageSize=12&orgId=<%=orgId%>" title="办公室生活服务单位值班信息">办公室生活服务</a></div>
                          </td>
                          
                     </tr>
                      <tr>
                          <td>
                               <div class="icon icon11 fl"></div>
                               <div class="fl jt"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23872&startPage=1&pageSize=12&orgId=<%=orgId%>">感谢信</a></div>
                          </td>
                          <td>
                               <div class="icon icon12 fl"></div>
                               <div class="fl jt"><a href="RotaAction!detailRota.action" target="_blank">单位值班信息</a></div>
                          </td>
                          
                     </tr>
               </table>
                   
            </div>

      <div class="pro-box pro-border pro-padding pro-duty pro-more">
        <div class="pro-box-title">
        	<span><em class="icon-zbxx"></em>值班信息</span>
        </div>
		<%
		String zbrq = "";
		String zbld = "未设置";
		String lxdh = "";
		if(zbxx!=null && zbxx.size()>0){
			for(int i=0;i<zbxx.size();i++){
			String [] arr = (String[])zbxx.get(i);
			if("12770".equals(arr[4])){
				zbrq = arr[3];
				zbld = arr[0];
				lxdh = "联系电话："+arr[2];
				break;
		}}}
		%>
        <div class="duty-card">
          <div class="title">值班领导</div>
        	<div class="time"><%=zbrq%></div>
        	<div class="name"><strong><%=zbld%></strong></div>
          <div class="concat"></div>
        </div>
        <div class="duty-info">
          <div class="more">
          	<a href="RotaAction!detailRota.action" target="_blank">查看当月信息</a>	
          </div>
          <div>
            <em class="top"></em>
            <em class="bottom"></em>
          </div>
        </div>
        </div>
      </div>
      <div class="pro-tips">
	    		<div href="##" class="weixin-wrap">
	    			<a href="##" class="weixin" id="J_qrcode" onclick="Feedback()"></a>
	    			
			    	
	    		</div>
		    	<a href="javascript:scrollTo(0, 0)" class="gotop" id="J_gotop"></a>
		    	
		  </div>
    </div>
<!--底部公共文件-->
<%@ include file="/rd/info/index_pre_footer.jsp"%>	

   

		<!-- 查看当月信息弹框  -->
    <div class="tan-thismonth-box">
        <div class="tan-thismonth">
            <div class="data-a">
            <div class="thismonth-close"></div>
                <div class="pro-sche">
                    <div class="sche-title">值班日历</div>
                    <div id="datetimepicker"></div>
					<input type="text" id="mirror_field" readonly hidden>
                </div>
                <div  class="slideBox-meeting">
				    <div class="bd">
					    <div class="infoList-title">
                            <span>
							    <input type="text" id="selectPost" class="text" style="color: #A2A0A0;text-align: center;"  readonly="true" value="请选择部门">
                         </span>
                            <em>姓名</em>
                            <font>电话</font>
                        </div>
						<ul id="zbryDetail">
						<%if(zbxx!=null && zbxx.size()>0){
						int no = 0;
						if(zbxx.size()%5==0){
							no=zbxx.size()/5;
						}else{
							no=zbxx.size()/5+1;
						}
						for(int i=0;i<no;i++){%>
						<li>
							<%
							for(int j=0+i*5;(j<5*(i+1)&&j<zbxx.size());j++){
								String [] arr = (String[])zbxx.get(j);
								String dpt = arr[1];
								if(arr[1].length()>6){
									dpt = arr[1].substring(0,6);
								}
								%>
							   
								<div class="meeting-item clearfix">
									  <span title="<%=arr[1]%>"><%=dpt%></span><em><%=arr[0]%></em>
										<font><%=arr[2]%></font>
								</div>
							<%}%>
						</li>
					<%}}%>
					<%
					for(int i=0;i<5;i++){%>
					<li></li>
					<%}%>
					</ul>
				</div>
				<!-- 下面是前/后按钮代码，如果不需要删除即可 -->
				<div class="meeting-btn">
					<a class="prev" href="javascript:void(0)"></a>
					<a class="next" href="javascript:void(0)"></a>
				</div>
			</div>

			<div class="per-drop">
                <div class="ac_title">
                    <a class="ac_close fr" style="cursor:pointer" title="关闭"><img src="<%=rootPath%>/pro/img/close-a.png"></a>
                </div>
                <ul id="BMList" class="list clearfix" style="display:block">
				<li>全部组织</li>
				<%
				if(bmList!=null&&bmList.size()>0){
				for(int i=0;i<bmList.size()&&i<17;i++){
					String [] arr = (String[])bmList.get(i);
				%>
					<li><%=arr[0]%></li>
					<%}}%>
                </ul>

                <div class="fanye" style="color: #666;"><a onclick="prev();">«&nbsp;上一页</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;<a onclick="next();">下一页&nbsp;»</a></div>
               </div>  
        </div>
		
            </div>
        </div>
    </div>

</body>

<script type="text/javascript">	

$(document).ready(function(){
		SharesData();
});


$(".pro-list ul li").last().css("border-bottom","none");
$("#ggxxList1 div").last().css("border-bottom","none");
$("#ggxxList2 div").last().css("border-bottom","none");
$("#ggxxList3 div").last().css("border-bottom","none");



function Feedback(){
	 if($(".tan-loginbox").hasClass("open")){
         $(".tan-loginbox").removeClass("open");
		 $("#feedback").val("0");
      }
      else{
         $(".tan-loginbox").addClass("open");
		 $("#feedback").val("1");
		 
      }
}



window.setInterval("SharesData()",10000);
function SharesData(){
			$.ajax({
				url: "/defaultroot/rd/govoffice/gov_documentmanager/forms/getSharesData.jsp?randomid=" + (new Date()).getTime(),
				type: "post",
				async: false,
				timeout:8000,
				success: function (data) {
				data = data.replace(/(^\s*)|(\s*$)/g, '');
						if(data != ''){
							data = eval('('+data+')');
							var result = data.result.list[0].value+"";
							var resultArr = result.split(",");//收盘价，开盘价，最新价
							var PreClose = resultArr[0];
							var Open =  resultArr[1];
							var New = resultArr[2];
							if(Open == '0' || New == '0'){//尚未开盘，取昨天收盘的数据
									$("#newPrice").html(PreClose);
									//$("#shareLogo").css('display','none');
									$("#increase").html("+0.00(+0.00%)");
							}else{
									$("#newPrice").html(New);
									var OpenFloat = parseFloat(PreClose);
									var NewFloat = parseFloat(New);
									var difference;
									var percent;
									if(NewFloat  >  OpenFloat){//涨
										difference = parseFloat(NewFloat-OpenFloat).toFixed(2);
										percent = (((NewFloat - OpenFloat)/OpenFloat)*100).toString().substring(0,4)+"%";
										$("#increase").html("+"+difference+"(+"+percent+")");
									
									}else if (NewFloat == OpenFloat){//持平
										$("#shareLogo").css('display','none');
										$("#increase").html("+0.00(+0.00%)");
									}else{//跌
										difference = parseFloat(OpenFloat-NewFloat).toFixed(2);
										percent = (((OpenFloat - NewFloat)/OpenFloat)*100).toString().substring(0,4)+"%";
										$("#shareLogo").attr('class','part2 zj js');
										$("#increase").html("-"+difference+"(-"+percent+")");
									}

							}	


						}
					
					
				},
			error: function (XMLHttpRequest, textStatus, textStatus) {
					}
			});
}




</script>	

<script type="text/javascript">	
<%
String errorType=(String)request.getAttribute("errorType");
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
    whir_alert("<%=Resource.getValue(localeCode,"common","comm.loginremind31")%><%=inputPwdErrorNumMax-inputPwdErrorNum%><%=Resource.getValue(localeCode,"common","comm.loginremind32")%>",function(){
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
<%}else if("zhuyun".equals(errorType)){%>
	whir_alert("账号或密码错误！");
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

function mychecked(obj){
	var cheVal=document.getElementById("rememberCheckbox").checked;
	if(cheVal==true){
		document.getElementById("isRemember").value= "1";
	}else{
		document.getElementById("isRemember").value= "0";
	}
}



function xwdtNext(){
	var no = $("#xwdtNo").text();
	if(no == "1"){
		$("#xwdtNo").text("2");
		$("#xwdtList").empty();
		<%
		if(xwdt!=null&&xwdt.size()>5){
			for(int i=8;i<xwdt.size()&&i<16;i++){
				String [] arr=(String [])xwdt.get(i);
				String title = arr[1];
				if(title.length()>20){
					title = title.substring(0,20)+"...";
				}
			%>
				$("#xwdtList").append("<li><font>■</font><a href=\"javascript:void(0)\" title=\'<%=arr[1]%>\' onclick=\"infoDetailView(\'<%=arr[0]%>\');\"><em><%=title%></em></a></li>");
		<%}}%>
		$(".pro-list ul li").last().css("border-bottom","none");

	}else if(no == "2"){
		$("#xwdtNo").text("3");
		$("#xwdtList").empty();
		<%
		if(xwdt!=null&&xwdt.size()>10){
			for(int i=16;i<xwdt.size()&&i<24;i++){
				String [] arr=(String [])xwdt.get(i);
				String title = arr[1];
				if(title.length()>20){
					title = title.substring(0,20)+"...";
				}
			%>
				$("#xwdtList").append("<li><font>■</font><a href=\"javascript:void(0)\" title=\'<%=arr[1]%>\' onclick=\"infoDetailView(\'<%=arr[0]%>\');\"><em><%=title%></em></a></li>");
		<%}}%>
		$(".pro-list ul li").last().css("border-bottom","none");
	}
}

function xwdtBefore(){
	var no = $("#xwdtNo").text();
	if(no == "3"){
		$("#xwdtNo").text("2");
		$("#xwdtList").empty();
		<%
		if(xwdt!=null&&xwdt.size()>5){
			for(int i=8;i<xwdt.size()&&i<16;i++){
				String [] arr=(String [])xwdt.get(i);
				String title = arr[1];
				if(title.length()>20){
					title = title.substring(0,20)+"...";
				}
			%>
				$("#xwdtList").append("<li><font>■</font><a href=\"javascript:void(0)\" title=\'<%=arr[1]%>\' onclick=\"infoDetailView(\'<%=arr[0]%>\');\"><em><%=title%></em></a></li>");
		<%}}%>
		$(".pro-list ul li").last().css("border-bottom","none");
	}else if(no == "2"){
		$("#xwdtNo").text("1");
		$("#xwdtList").empty();
		<%
		if(xwdt!=null&&xwdt.size()>0){
			for(int i=0;i<xwdt.size()&&i<8;i++){
				String [] arr=(String [])xwdt.get(i);
				String title = arr[1];
				if(title.length()>20){
					title = title.substring(0,20)+"...";
				}
			%>
				$("#xwdtList").append("<li><font>■</font><a href=\"javascript:void(0)\" title=\'<%=arr[1]%>\' onclick=\"infoDetailView(\'<%=arr[0]%>\');\"><em><%=title%></em></a></li>");
		<%}}%>
		$(".pro-list ul li").last().css("border-bottom","none");
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

var format = function(time, format){
    var t = new Date(time);
    var tf = function(i){return (i < 10 ? '0' : '') + i};
    return format.replace(/yyyy|MM|dd|HH|mm|ss/g, function(a){
        switch(a){
            case 'yyyy':
                return tf(t.getFullYear());
                break;
            case 'MM':
                return tf(t.getMonth() + 1);
                break;
            case 'mm':
                return tf(t.getMinutes());
                break;
            case 'dd':
                return tf(t.getDate());
                break;
            case 'HH':
                return tf(t.getHours());
                break;
            case 'ss':
                return tf(t.getSeconds());
                break;
        }
    })
}

//日期时间时时更新
var originalDate = new Date($.ajax({async: false}).getResponseHeader("Date"));
var newDate = originalDate + (3600000 * 8);
newDate = newDate.replace("28800000","");
newDate = format(newDate, 'yyyy-MM-dd HH:mm:ss');
var oDate = new Date(Date.parse(newDate.replace(/-/g,"/")));
var t=oDate.getTime();
showClock();
function showClock(){
	oDate=new Date(t);
	$("#date01").text(oDate.getFullYear());
	$("#date02").text(oDate.getMonth()+1+"/"+oDate.getDate());
	$("#date03").text(new Array("星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六")[oDate.getDay()]);
	var oHours = oDate.getHours();
	var oMinutes = oDate.getMinutes();
	var oSeconds = oDate.getSeconds();
	if(oHours<10){
			oHours = "0"+oHours;
	}
	if(oMinutes<10){
		oMinutes = "0"+oMinutes;
	}
	if(oSeconds<10){
		oSeconds = "0"+oSeconds;
	}
	$("#date04").text(oHours+":"+oMinutes+":"+oSeconds);
	t =t+1000;
	setTimeout("showClock()",1000);
}



//信息详细弹出框 
function  infoDetailView(id){
	//var offsetWidth = document.body.offsetWidth*0.66+"px";
	//var offsetHeight = document.body.offsetHeight*0.4+"px";
	/*layer.open({
		type: 2,
		title: '信息详情',
		shadeClose: false,
		shade: 0.8,
		area: ['80%', '80%'],
		scrollbar: false,
		content: '/defaultroot/WebIndexSggfBD!detailInfomation.action?id='+id
	});*/
	//openWin({url:'/defaultroot/WebIndexSggfBD!detailInfomation.action?id='+id,isFull:true,winName:'infoDetailView',isPost:false});
	window.open('/defaultroot/WebIndexSggfBD!detailInfomation.action?id='+id);
	

}

function  meetDetailView(id){
	/*layer.open({
		type: 2,
		title: '会议详情',
		shadeClose: false,
		shade: 0.8,
		area: ['80%', '80%'],
		scrollbar: false,
		content: '/defaultroot/WebIndexSggfBD!detailMeeting.action?id='+id
	});*/
	//openWin({url:'/defaultroot/WebIndexSggfBD!detailMeeting.action?id='+id,isFull:true,winName:'infoDetailView',isPost:false});
	window.open('/defaultroot/WebIndexSggfBD!detailMeeting.action?id='+id);
}


function hyMore(obj){
	//alert($(".current").html());
	$("span[name='hy']").each(function(){
		if($(this).attr("class").indexOf('current') != -1){
			if($(this).html().indexOf('会议通知') != -1){
			//openWin({url:"/defaultroot/WebIndexSggfBD!getInfoListHytz.action?startPage=1&pageSize=12&orgId=<%=orgId%>",isFull:true,winName:'meetMoreView',isPost:false});
			window.location.href="/defaultroot/WebIndexSggfBD!getInfoListHytz.action?startPage=1&pageSize=12&orgId=<%=orgId%>";
			}else if($(this).html().indexOf('会议纪要') != -1){
			//openWin({url:"/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23656&startPage=1&pageSize=12&orgId=<%=orgId%>",isFull:true,winName:'meetMoreView',isPost:false});
			window.location.href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23656&startPage=1&pageSize=12&orgId=<%=orgId%>";
			}
		}

	
	});

}

//股份各部门人员OA在线统计 
function  onLineNumber(){
	layer.open({
		type: 2,
		title: 'OA在线详情',
		shadeClose: false,
		shade: 0.8,
		area: ['80%', '80%'],
		scrollbar: false,
		content: '/defaultroot/WebIndexSggfBD!onLineNumber.action'
	});
}

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

	$(".slideBox-meeting").slide({mainCell:".bd ul",autoPlay:false});


	var zbrqList = null;
	var varZbrq = "";

	$(document).ready(function(){
	showZbxx();
	getZbxx('<%=zbrq%>');
});

	function getZbxx(zbrq){
		varZbrq = zbrq;
		$.ajax({
			type: "POST",
			url: "WebIndexSggfBD!getZbxx.action",
			data: "zbrq="+zbrq,
			async:false,
			cache:false,
			success: function(obj){
				var json = eval('(' + obj + ')'); 
				zbrqList = json.data.data;
			},
			error: function(){
				whir_alert("获取值班信息失败！");
			}	
		});
		$("#selectPost").val("请选择部门");
		var html= "";
	    if(zbrqList!=null && zbrqList.length>0){
			
			var no = 0;
			if(zbrqList.length%5==0){
				no=zbrqList.length/5;
			}else{
				no=Math.floor(zbrqList.length/5)+1;
			}
			for(var i=0;i<no;i++){
				html+="<li>";
				
				for(var j=0+i*5;(j<5*(i+1)&&j<zbrqList.length);j++){
					var dpt = zbrqList[j].bm;
					var orgidstring = zbrqList[j].orgidstring;
					<%
					if(bmList!=null&&bmList.size()>0){
						for(int i=0;i<bmList.size();i++){
							String [] arr = (String[])bmList.get(i);
							%>
							var bmId = "<%=arr[1]%>";
							if(orgidstring.indexOf(bmId)>0){
								dpt = "<%=arr[0]%>";
							}
					<%}}%>
					if(dpt.length>10){
						dpt = dpt.substring(0,10);
					}
					
					html+="<div class=\"meeting-item clearfix\"><span title=\""+zbrqList[j].bm+"\">"+dpt+"</span><em>"+zbrqList[j].zbry+"</em><font>"+zbrqList[j].lxdh+"</font></div>";
				}
					html+="</li>";
				}
			}
			$("#zbryDetail").empty();
			$("#zbryDetail").append(html);
		
	}

	$(".more").click(function(){
		$('#datetimepicker').datetimepicker({
			language: 'zh',
			maxView: '0',
			todayHighlight: '1'
		});
	});

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


	//查看当月信息部门下拉
    $(".ac_close").click(function(){

        $(".per-drop").css({"display":"none"})
    })

     $(".slideBox-meeting .infoList-title .text").click(function(){

        $(".per-drop").css({"display":"block"})
    })

	$('#BMList li').click(function() {
		$("#selectPost").val(this.innerHTML);
		$(".per-drop").css({"display":"none"})
		showZbxx();
	});

	function showZbxx(){
		var html = "";
		var post = $("#selectPost").val();
		if(post=='全部组织'||post=='请选择部门'){
			post="";
		}
		if(varZbrq==""){
			var zbrq = format(new Date(), 'yyyy-MM-dd');
			$.ajax({
				type: "POST",
				url: "WebIndexSggfBD!getZbxx.action",
				data: "zbrq="+zbrq,
				async:false,
				cache:false,
				success: function(obj){
					var json = eval('(' + obj + ')'); 
					zbrqList = json.data.data;
				},
				error: function(){
					whir_alert("获取值班信息失败！");
				}	
			});
		}
		if(post==""){
			if(zbrqList!=null && zbrqList.length>0){
				if(zbrqList.length%5==0){
					no=zbrqList.length/5;
				}else{
					no=Math.floor(zbrqList.length/5)+1;
				}
				for(var i=0;i<no;i++){
					html+="<li>";
					
					for(var j=0+i*5;(j<5*(i+1)&&j<zbrqList.length);j++){
						var dpt = zbrqList[j].bm;
						var orgidstring = zbrqList[j].orgidstring;
						<%
						if(bmList!=null&&bmList.size()>0){
							for(int i=0;i<bmList.size();i++){
								String [] arr = (String[])bmList.get(i);
								%>
								var bmId = "<%=arr[1]%>";
								if(orgidstring.indexOf(bmId)>0){
									dpt = "<%=arr[0]%>";
								}
						<%}}%>
						if(dpt.length>10){
							dpt = dpt.substring(0,10);
						}
						html+="<div class=\"meeting-item clearfix\"><span title=\""+zbrqList[j].bm+"\">"+dpt+"</span><em>"+zbrqList[j].zbry+"</em><font>"+zbrqList[j].lxdh+"</font></div>";
					}
					html+="</li>";
				}
			}
		}else if(post!=""){
			if(zbrqList!=null && zbrqList.length>0){

			var bmId = "";
			var dpt = post;
			if(dpt.length>10){
				dpt = dpt.substring(0,10);
			}

			<%
			if(bmList!=null&&bmList.size()>0){
				for(int i=0;i<bmList.size();i++){
					String [] arr = (String[])bmList.get(i);
					%>
					var bm = "<%=arr[0]%>";
					if(post==bm){
						bmId = "<%=arr[1]%>";
					}
			<%}}%>

			var selZbxx = "";
			var no = 0;
			for(var i=0;i<zbrqList.length;i++){
				var orgidstring = zbrqList[i].orgidstring;
				if(orgidstring.indexOf(bmId)>0){
					selZbxx+=JSON.stringify(zbrqList[i])+",";
				}
			}
			selZbxx = selZbxx.substring(0,selZbxx.length-1);
			selZbxx = eval('([' + selZbxx + '])');
			if(selZbxx!=null && selZbxx.length>0){
				if(selZbxx.length%5==0){
					no=selZbxx.length/5;
				}else{
					no=Math.floor(selZbxx.length/5)+1;
				}
				for(var i=0;i<no;i++){
					html+="<li>";
					
					for(var j=0+i*5;(j<5*(i+1)&&j<selZbxx.length);j++){
						html+="<div class=\"meeting-item clearfix\"><span title=\""+selZbxx[j].bm+"\">"+dpt+"</span><em>"+selZbxx[j].zbry+"</em><font>"+selZbxx[j].lxdh+"</font></div>";
					}
					html+="</li>";
				}
			}
		}}
		/*for(var i=0;i<100;i++){
			html+="<li></li>";
		}*/
		$("#zbryDetail").empty();
		$("#zbryDetail").append(html);
	}

var num = 0;
var varBmList= "";

	function prev(){
		var html = "<li onclick='selBm(\"\")'>全部组织</li>";
		$.ajax({
			type: "POST",
			url: "WebIndexSggfBD!getOrgList3.action",
			data: "",
			async:false,
			cache:false,
			success: function(obj){
				var json = eval('(' + obj + ')'); 
				varBmList = json.data.data;
			},
			error: function(){
				whir_alert("获取值班信息失败！");
			}	
		});


		if(num==0){
		}else{
			num--;
			for(var i=0+num*17;i<varBmList.length&&i<(num+1)*17;i++){
				html+="<li onclick='selBm(\""+varBmList[i].orgname+"\")'>"+varBmList[i].orgname+"</li>";
			}
			$("#BMList").empty();
			$("#BMList").append(html);
		}
	}

	function next(){
		var html = "<li onclick='selBm(\"\")'>全部组织</li>";

		$.ajax({
			type: "POST",
			url: "WebIndexSggfBD!getOrgList3.action",
			data: "",
			async:false,
			cache:false,
			success: function(obj){
				var json = eval('(' + obj + ')'); 
				//alert(JSON.stringify(json));
				varBmList = json.data.data;
			},
			error: function(){
				whir_alert("获取部门信息失败！");
			}	
		});
		num++;
		if(num*17<varBmList.length){
			for(var i=0+num*17;i<varBmList.length&&i<(num+1)*17;i++){
				html+="<li onclick='selBm(\""+varBmList[i].orgname+"\")'>"+varBmList[i].orgname+"</li>";
			}
			$("#BMList").empty();
			$("#BMList").append(html);
		}else{
			num--;
		}
	}

	function selBm(orgName){
		$("#selectPost").val(orgName);
		$(".per-drop").css({"display":"none"})
		showZbxx();
	}

	var mainheight = $("#gfPortal").height();
	//var rightIframeH =$(window.parent.document).find(".wh-con-table .wh-r-content");
	var leftIframeH =$(window.parent.document).find("#portalHtmlForDiv");
	//rightIframeH.css({'height':mainheight});
	leftIframeH.css({'height':mainheight});
	



 
</script>
</html>