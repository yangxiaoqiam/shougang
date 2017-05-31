<!DOCTYPE html>
<html lang="zh-cn" class="theme-red">
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
xwdt=gpInfo.getInfo("23683",orgId,15);
hyjy=gpInfo.getInfo("23656",orgId,18);
ggxx=gpInfo.getInfo("80245",orgId,18);

List ztzl=new ArrayList();
ztzl=gpInfo.getZtzlGF(12);

WebIndexSggfBD webIndexSggfBD=new WebIndexSggfBD();
List hytzFBSJ=new ArrayList();
List hytzHYSJ=new ArrayList();
hytzFBSJ = webIndexSggfBD.getInfoHytz("fbsj");
hytzHYSJ = webIndexSggfBD.getInfoHytz("hysj");

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
<body>
    <div class="pro-header-tips">
    <ul>
      <li class="t1">
        <a >
          <em></em>
          <span>扫描二维码</span>
        </a>
		<div class="weixin-tan">
			<div class="qrcode">
				<ul>
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
						<li><img src="<%=fileServer+"/upload/loginpage/"+ewmArr[0].substring(0,6)+"/"+ewmArr[0]%>" />
						 <p><%=ewmNameArr[0] %></p>
						</li>
						
					<%  //}
					}else{
					%>
						<li>
						 <p></p>
						</li>
					<%}%>
				</ul>
			</div>
			<div class="arrow"></div>
		</div>
      </li>
      <li class="t2">
		<a href="#" onclick="addFavorite2();" rel="sidebar">
          <em></em>
          <span>收藏本站</span>
        </a>
      </li>
      <li class="t3">
        <a >
          <em></em>
          <span>公司链接</span>
        </a>
        <div class="link">
			<a target="_blank" href="http://oa.shougang.com.cn">首钢集团</a>
			<a target="_blank" href="http://www.sgdaily.com">首钢日报</a>
			<a target="_blank" href="/defaultroot/beforesale.jsp">营销管理部</a>
			<a target="_blank" href="/defaultroot/beforelz.jsp" style="border-bottom: none;">首钢冷轧公司</a>
		</div>
      </li>
      <li class="t4">
        <a >
          <em></em>
          <span>常用系统</span>
        </a>
         <div class="system-tanbox_a">
        <div class="system-tanbox clearfix">
                            <div class="system-tan">
                               
                                <table>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <a target="_blank" href="http://onekey.sgqg.com/"><font>■</font>迁钢统一登录平台  </a>
                                                <a target="_blank" href="http://oa.sgqg.com/"><font>■</font>办公自动化系统    </a>
                                                <a target="_blank" href="http://10.3.250.115/"><font>■</font>学分制管理系统     </a>
                                                <a target="_blank" href="http://report.sgqg.com/"><font>■</font>迁钢生产经营日报   </a>
                                                <a target="_blank" href="http://web.sgqg.com/kejian/kejian1.swf"><font>■</font>职工培训课件    </a>
                                                <a target="_blank" href="http://10.3.250.138/login.aspx"><font>■</font>生产用车管理系统    </a>
                                                <a target="_blank" href="http://www.qgcard.com/"><font>■</font>一卡通系统     </a>
                                                <a target="_blank" href="http://10.3.250.243:8080/qgmrp/"><font>■</font>材料供应系统   </a>
                                                <a target="_blank" href="http://10.3.184.143/nyzx/index.html"><font>■</font>污染源在线监测系统    </a>
                                                <a target="_blank" href="http://irkm.sgqg.com/cis/_portal_Index.do"><font>■</font>信息资源知识管理平台   </a>
                                                <a target="_blank" href="http://mail.sgqg.com/"><font>■</font>公司邮箱    </a>
                                            </td>
                                            <td>
                                                <a target="_blank" href="http://10.3.250.37:8088/Default.aspx"><font>■</font>数字图书馆（万方）   </a>
                                                <a target="_blank" href="http://10.1.155.9/bz/default.jsp"><font>■</font>首钢冶金标准管理系统  </a>
                                                <a target="_blank" href="http://gbcp.sgqg.com/ERP/df.do"><font>■</font>年度绩效评测系统   </a>
                                                <a target="_blank" href="http://10.1.250.85/loginindex.do"><font>■</font>首钢人力资源管理系统  </a>
                                                <a target="_blank" href="http://10.3.250.129/sgqghr"><font>■</font>迁钢人力资源管理系统  </a>
                                                <a target="_blank" href="http://10.3.68.29/sbb/sbb.html"><font>■</font>设备管理系统    </a>
                                                <a target="_blank" href="http://10.3.250.245:8080/wzjl/"><font>■</font>物资计量系统  </a>
                                                <a target="_blank" href="http://time.sgqg.com/NTPManger/index.jsp"><font>■</font>时间同步系统   </a>
                                                <a target="_blank" href="http://web.sgqg.com/web/ztlm/phone/phone.html"><font>■</font>电话号码本  </a>
                                                <a target="_blank" href="http://ssis.sgqg.com/gindex.aspx"><font>■</font>硅钢信息系统  </a>
                                                <a target="_blank" href="http://sgxs.shougang.com.cn/cmsp-web/notice/noticeIndex2.action"><font>■</font>首钢客户营销服务平台  </a>
                                                <a target="_blank" href="http://10.3.250.229:8080/fbrole/main/loginframe/login.jsp"><font>■</font>LIMS一期    </a>
                                            </td>
                                            <td>
                                                <a target="_blank" href="http://10.3.250.102:8080/fbrole/main/loginframe/login.jsp"><font>■</font>LIMS二期  </a>
                                                <a target="_blank" href="http://2lgscgk.sgqg.com:9002/mes-tms-app/loginInit.action"><font>■</font>二炼钢生产管控  </a>
                                                <a target="_blank" href="http://1580mes.sgqg.com:9002/mes-hotrolling-app/loginInit.action"><font>■</font>1580MES    </a>
                                                <a target="_blank" href="http://10.3.250.127:9002/ams-aqd-app/"><font>■</font>热轧AQD    </a>
                                                <a target="_blank" href="http://10.3.250.227:7778/forms/frmservlet?config=sgmes_qg"><font>■</font>2160MES    </a>
                                                <a target="_blank" href="http://10.3.250.30:8080/mes-oqs-app/"><font>■</font>2160在线判定  </a>
                                                <a target="_blank" href="http://qgcc.sgqg.com/wtm_hot_app/login.htm"><font>■</font>热轧自动仓储  </a>
                                                <a target="_blank" href="http://qglz1stwtm.sgqg.com:8003/wtm_cold_app/login.htm"><font>■</font>冷轧仓储  </a>
                                                <a target="_blank" href="http://qglzaqd.sgqg.com:7003/mes-aqd-app/"><font>■</font>冷轧AQD    </a>
                                                <a target="_blank" href="http://qglzams.sgqg.com:8003/mes-ams-app/"><font>■</font>冷轧AMS   </a>
                                                <a target="_blank" href="http://10.3.247.74:8080/hyslimstapp/auth/login.jsp"><font>■</font>一炼钢LIMS  </a>
                                            </td>
                                            <td>
                                                <a target="_blank" href="http://10.3.247.36:8080/fbrole/main/loginframe/login.jsp"><font>■</font>冷轧LIMS    </a>
                                                <a target="_blank" href="http://10.3.250.239:7001/itms-app/login.jsp"><font>■</font>ITMS  </a>
                                                <a target="_blank" href="http://qglz2ndmes.sgqg.com:7003/mes-coldrolling-app/"><font>■</font>二冷轧MES   </a>
                                                <a target="_blank" href="http://qglz2ndwtm.sgqg.com:8003/wtm_cold_app/login.htm"><font>■</font>二冷轧仓储    </a>
                                                <a target="_blank" href="http://2160dhs.sgqg.com:7001/mes-2160-app/loginInit.action"><font>■</font>一炼钢DHS   </a>
                                                <a target="_blank" href="http://10.3.247.135:8010/mes-sx-app/"><font>■</font>钢加酸洗MES    </a>
                                                <a target="_blank" href="http://10.3.247.135:9010/wtm_pickling_app/login.htm"><font>■</font>钢加酸洗仓储   </a>
                                                <a target="_blank" href="http://10.3.21.55:8090"><font>■</font>能源二级基础管理系统    </a>
                                                <a target="_blank" href="http://10.3.129.3:7001/mes-wzjl-app/login.jsp"><font>■</font>无人值守计量系统   </a>
                                                <a target="_blank" href="http://10.3.250.146:7001/emp/login.do"><font>■</font>迁钢设备管理系统    </a>
                                                <a target="_blank" href="http://10.3.250.146:7002/qgsbcf/com.sgai.qgsbcf.framework.view.Login.d"><font>■</font>迁钢设备数据管理平台   </a>
                                                <a target="_blank" href="http://10.1.250.231:7001/mes_opm_app/"><font>■</font>首钢进口矿管理平台  </a>
                                            </td>
                                            <td>
                                                <a target="_blank" href="http://10.3.247.122:7003/permission-app/permission/frame/login.htm"><font>■</font>迁钢质量过程控制系统  </a>
                                                <a target="_blank" href="http://10.3.250.43:8282/eam/com.eam.framework.main.Login.d"><font>■</font>测量管理体系信息平台   </a>
                                                <a target="_blank" href="http://10.3.247.142:8003/itsm_app/"><font>■</font>ITSM运维管理系统   </a>
                                                <a target="_blank" href="http://10.3.247.152:7003/mes-dtm-app/"><font>■</font>迁顺订单交货期管理   </a>
                                                <a target="_blank" href="http://www.sgkpi.com/"><font>■</font>首钢经营管理平台    </a>
                                                <a target="_blank" href="http://ec.sgai.com.cn/"><font>■</font>首钢采购电子商务平台  </a>
                                                <a target="_blank" href="http://10.3.247.63:7003/srp/"><font>■</font>隐患排查治理和安全生产预警系统    </a>
                                                <a target="_blank" href="http://10.1.250.233:7001/mes-iom-webapp/"><font>■</font>合同评审系统   </a>
												<a target="_blank" href="http://10.3.250.55:8000/worksheet/v2/index.jsp"><font>■</font>全员自主创新平台   </a>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
        </div>
      </div>
      </li>
    </ul>
  </div>
  <div class="pro-header">
            <div class="pro-container clearfix">
                <a class="pro-logo"><img src="../defaultroot/pro/img/logo.png" /></a>
                <ul class="clearfix">
                    <li class="current">
                        <a href="/defaultroot/index_pre.jsp">
                            <em class="nav1"></em>
                            <span>首页</span>
                        </a>
                    </li>
                    <li>
                        <a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=114132&startPage=1&pageSize=12&orgId=<%=orgId%>">
						<em class="nav2"></em>
                    <span>规章制度</span>
                    </a>
                        <dl>
							<!--<dd><a href="javascript:void(0);" onclick="
							openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=114168&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">总公司</a></dd>
                            <dd><a href="javascript:void(0);" onclick="
							openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=114161&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">股份公司</a></dd>
                            <dd><a href="javascript:void(0);" onclick="
							openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=114179&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">迁钢公司</a></dd>
							<dd><a href="javascript:void(0);" onclick="
							openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=114176&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">职能部</a></dd>
							<dd style="border-bottom: none;"><a href="javascript:void(0);" onclick="
							openWin({url:'/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=114172&startPage=1&pageSize=12&orgId=<%=orgId%>', isFull:true});">作业部</a></dd>-->
							<dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=240672&startPage=1&pageSize=12&orgId=<%=orgId%>">股份公司级</a></dd>
                            <dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=240688&startPage=1&pageSize=12&orgId=<%=orgId%>">职能部门级</a></dd>
							<dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=398610&startPage=1&pageSize=12&orgId=<%=orgId%>">作业部级</a></dd>
                        </dl>
                    </li>
                    <li>
                        <a href="/defaultroot/WebIndexSggfBD!getTxlList.action">
                           <em class="nav3"></em>
                            <span> 通讯录 </span>
                        </a>
                    </li>
                    <li>
                        <a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23862&startPage=1&pageSize=12&orgId=<%=orgId%>">
                           <em class="nav4"></em>
                            <span>生活服务</span>
                        </a>
                        <dl>	
                            <dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23864&startPage=1&pageSize=12&orgId=<%=orgId%>">班车信息</a></dd>
							<dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=349413&startPage=1&pageSize=12&orgId=<%=orgId%>">厂区小卖部</a></dd>
                            <dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23868&startPage=1&pageSize=12&orgId=<%=orgId%>">工作餐食谱</a></dd>
                            <dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23872&startPage=1&pageSize=12&orgId=<%=orgId%>">感谢信</a></dd>
							<dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23876&startPage=1&pageSize=12&orgId=<%=orgId%>">寻物启事</a></dd>
							<dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23878&startPage=1&pageSize=12&orgId=<%=orgId%>">失物招领</a></dd>
							<dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=305767&startPage=1&pageSize=12&orgId=<%=orgId%>" title="办公室生活服务单位值班信息">办公室生活服...</a></dd>
							<!--<dd style="border-bottom: none;"><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23886&startPage=1&pageSize=12&orgId=<%=orgId%>">迁钢通讯</a></dd>-->
                        </dl>
                    </li>
                </ul>
                <div class="fixed-sys fr">
                    <div class="t4" >
                        <a href="javascript:void(0)">
                            <em></em>
                            <span>常用系统</span>
                        </a>
                         <div class="system-tanbox_a">
                        <div class="system-tanbox">
                            <div class="system-tan">
                                
                                <table>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <a target="_blank" href="http://onekey.sgqg.com/"><font>■</font>迁钢统一登录平台  </a>
                                                <a target="_blank" href="http://oa.sgqg.com/"><font>■</font>办公自动化系统    </a>
                                                <a target="_blank" href="http://10.3.250.115/"><font>■</font>学分制管理系统     </a>
                                                <a target="_blank" href="http://report.sgqg.com/"><font>■</font>迁钢生产经营日报   </a>
                                                <a target="_blank" href="http://web.sgqg.com/kejian/kejian1.swf"><font>■</font>职工培训课件    </a>
                                                <a target="_blank" href="http://10.3.250.138/login.aspx"><font>■</font>生产用车管理系统    </a>
                                                <a target="_blank" href="http://www.qgcard.com/"><font>■</font>一卡通系统     </a>
                                                <a target="_blank" href="http://10.3.250.243:8080/qgmrp/"><font>■</font>材料供应系统   </a>
                                                <a target="_blank" href="http://10.3.184.143/nyzx/index.html"><font>■</font>污染源在线监测系统    </a>
                                                <a target="_blank" href="http://irkm.sgqg.com/cis/_portal_Index.do"><font>■</font>信息资源知识管理平台   </a>
                                                <a target="_blank" href="http://mail.sgqg.com/"><font>■</font>公司邮箱    </a>
                                            </td>
                                            <td>
                                                <a target="_blank" href="http://10.3.250.37:8088/Default.aspx"><font>■</font>数字图书馆（万方）   </a>
                                                <a target="_blank" href="http://10.1.155.9/bz/default.jsp"><font>■</font>首钢冶金标准管理系统  </a>
                                                <a target="_blank" href="http://gbcp.sgqg.com/ERP/df.do"><font>■</font>年度绩效评测系统   </a>
                                                <a target="_blank" href="http://10.1.250.85/loginindex.do"><font>■</font>首钢人力资源管理系统  </a>
                                                <a target="_blank" href="http://10.3.250.129/sgqghr"><font>■</font>迁钢人力资源管理系统  </a>
                                                <a target="_blank" href="http://10.3.68.29/sbb/sbb.html"><font>■</font>设备管理系统    </a>
                                                <a target="_blank" href="http://10.3.250.245:8080/wzjl/"><font>■</font>物资计量系统  </a>
                                                <a target="_blank" href="http://time.sgqg.com/NTPManger/index.jsp"><font>■</font>时间同步系统   </a>
                                                <a target="_blank" href="http://web.sgqg.com/web/ztlm/phone/phone.html"><font>■</font>电话号码本  </a>
                                                <a target="_blank" href="http://ssis.sgqg.com/gindex.aspx"><font>■</font>硅钢信息系统  </a>
                                                <a target="_blank" href="http://sgxs.shougang.com.cn/cmsp-web/notice/noticeIndex2.action"><font>■</font>首钢客户营销服务平台  </a>
                                                <a target="_blank" href="http://10.3.250.229:8080/fbrole/main/loginframe/login.jsp"><font>■</font>LIMS一期    </a>
                                            </td>
                                            <td>
                                                <a target="_blank" href="http://10.3.250.102:8080/fbrole/main/loginframe/login.jsp"><font>■</font>LIMS二期  </a>
                                                <a target="_blank" href="http://2lgscgk.sgqg.com:9002/mes-tms-app/loginInit.action"><font>■</font>二炼钢生产管控  </a>
                                                <a target="_blank" href="http://1580mes.sgqg.com:9002/mes-hotrolling-app/loginInit.action"><font>■</font>1580MES    </a>
                                                <a target="_blank" href="http://10.3.250.127:9002/ams-aqd-app/"><font>■</font>热轧AQD    </a>
                                                <a target="_blank" href="http://10.3.250.227:7778/forms/frmservlet?config=sgmes_qg"><font>■</font>2160MES    </a>
                                                <a target="_blank" href="http://10.3.250.30:8080/mes-oqs-app/"><font>■</font>2160在线判定  </a>
                                                <a target="_blank" href="http://qgcc.sgqg.com/wtm_hot_app/login.htm"><font>■</font>热轧自动仓储  </a>
                                                <a target="_blank" href="http://qglz1stwtm.sgqg.com:8003/wtm_cold_app/login.htm"><font>■</font>冷轧仓储  </a>
                                                <a target="_blank" href="http://qglzaqd.sgqg.com:7003/mes-aqd-app/"><font>■</font>冷轧AQD    </a>
                                                <a target="_blank" href="http://qglzams.sgqg.com:8003/mes-ams-app/"><font>■</font>冷轧AMS   </a>
                                                <a target="_blank" href="http://10.3.247.74:8080/hyslimstapp/auth/login.jsp"><font>■</font>一炼钢LIMS  </a>
                                            </td>
                                            <td>
                                                <a target="_blank" href="http://10.3.247.36:8080/fbrole/main/loginframe/login.jsp"><font>■</font>冷轧LIMS    </a>
                                                <a target="_blank" href="http://10.3.250.239:7001/itms-app/login.jsp"><font>■</font>ITMS  </a>
                                                <a target="_blank" href="http://qglz2ndmes.sgqg.com:7003/mes-coldrolling-app/"><font>■</font>二冷轧MES   </a>
                                                <a target="_blank" href="http://qglz2ndwtm.sgqg.com:8003/wtm_cold_app/login.htm"><font>■</font>二冷轧仓储    </a>
                                                <a target="_blank" href="http://2160dhs.sgqg.com:7001/mes-2160-app/loginInit.action"><font>■</font>一炼钢DHS   </a>
                                                <a target="_blank" href="http://10.3.247.135:8010/mes-sx-app/"><font>■</font>钢加酸洗MES    </a>
                                                <a target="_blank" href="http://10.3.247.135:9010/wtm_pickling_app/login.htm"><font>■</font>钢加酸洗仓储   </a>
                                                <a target="_blank" href="http://10.3.21.55:8090"><font>■</font>能源二级基础管理系统    </a>
                                                <a target="_blank" href="http://10.3.129.3:7001/mes-wzjl-app/login.jsp"><font>■</font>无人值守计量系统   </a>
                                                <a target="_blank" href="http://10.3.250.146:7001/emp/login.do"><font>■</font>迁钢设备管理系统    </a>
                                                <a target="_blank" href="http://10.3.250.146:7002/qgsbcf/com.sgai.qgsbcf.framework.view.Login.d"><font>■</font>迁钢设备数据管理平台   </a>
                                                <a target="_blank" href="http://10.1.250.231:7001/mes_opm_app/"><font>■</font>首钢进口矿管理平台  </a>
                                            </td>
                                            <td>
                                                <a target="_blank" href="http://10.3.247.122:7003/permission-app/permission/frame/login.htm"><font>■</font>迁钢质量过程控制系统  </a>
                                                <a target="_blank" href="http://10.3.250.43:8282/eam/com.eam.framework.main.Login.d"><font>■</font>测量管理体系信息平台   </a>
                                                <a target="_blank" href="http://10.3.247.142:8003/itsm_app/"><font>■</font>ITSM运维管理系统   </a>
                                                <a target="_blank" href="http://10.3.247.152:7003/mes-dtm-app/"><font>■</font>迁顺订单交货期管理   </a>
                                                <a target="_blank" href="http://www.sgkpi.com/"><font>■</font>首钢经营管理平台    </a>
                                                <a target="_blank" href="http://ec.sgai.com.cn/"><font>■</font>首钢采购电子商务平台  </a>
                                                <a target="_blank" href="http://10.3.247.63:7003/srp/"><font>■</font>隐患排查治理和安全生产预警系统    </a>
                                                <a target="_blank" href="http://10.1.250.233:7001/mes-iom-webapp/"><font>■</font>合同评审系统   </a>
												<a target="_blank" href="http://10.3.250.55:8000/worksheet/v2/index.jsp"><font>■</font>全员自主创新平台   </a>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                      </div>
                    </div>
                </div>
                <div class="header-search">
                    <div class="search-form clearfix">
                        <form>
							<input type="text" class="search-text" id="search" name="" value="请输入文字" onfocus="this.value=''" onblur="if(this.value==''){this.value='请输入文字'}" onkeydown="if(event.keyCode==13)SearchInformation();return false;">
                            <input type="button" name="" value="" style="cursor: pointer;" class="search-btn" onclick="SearchInformation();"/>
                        </form>
                    </div>
                    <button onclick="javascript:clearfeedBack();">登录</button>
                </div>
            </div>
        </div>

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
            <ul id="xwdtList" style="height:274px;">
			<%
			if(xwdt!=null&&xwdt.size()>0){
				for(int i=0;i<xwdt.size()&&i<5;i++){
					String [] arr=(String [])xwdt.get(i);
					String title = arr[1];
					if(title.length()>35){
						title = title.substring(0,35)+"...";
					}

				%>
					<li>
                   
                        <font>■</font>
						 <a href="javascript:void(0)" title='<%=arr[1]%><%=arr[2]%>' onclick="infoDetailView('<%=arr[0]%>');">
                        <em><%=title%></em>
						</a>
						<span class="wh-pending-time"><%=arr[2]%></span>
                        
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
        <div class="pro-box pro-meeting">
          <div class="pro-box-title">
            <span><em></em>会议通知</span>
            <a href="/defaultroot/WebIndexSggfBD!getInfoListHytz.action?startPage=1&pageSize=12&orgId=<%=orgId%>">更多>></a>
          </div>
          <div class="pro-meeting-container">
            <div class="isf flexslider2">
              <ul class="slides">
			  <%

			  if(hytzFBSJ!=null&&hytzFBSJ.size()>0){
				  int lineNum = 0;
				  if(hytzFBSJ.size()%6==0){
					  lineNum = hytzFBSJ.size()/6;
				  }
				  else{
					  lineNum = hytzFBSJ.size()/6 + 1;
				  }
				  for(int i=0;i<lineNum;i++){
						
			  %>
                <li>
                  <div class="pro-list-div">
				  <%
				  for(int j=0;j<6&&(j+i*6)<hytzFBSJ.size();j++){
							String [] arr=(String [])hytzFBSJ.get(j+i*6);
							String title = arr[12];
							if(title.length()>33){
								title=title.substring(0,33)+"...";
							}
							String tt = arr[1].substring(5,10);
						%>
							<div class="clearfix">
								<strong><%=tt%></strong>
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
				  if(hytzHYSJ.size()%6==0){
					  lineNum = hytzHYSJ.size()/6;
				  }
				  else{
					  lineNum = hytzHYSJ.size()/6 + 1;
				  }
				  for(int i=0;i<lineNum;i++){
						
			  %>
                <li>
                  <div class="pro-list-div">
				  <%
				  for(int j=0;j<6&&(j+i*6)<hytzHYSJ.size();j++){
							String [] arr=(String [])hytzHYSJ.get(j+i*6);
							Date date = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm").parse(arr[10]); 
							String meetTime = new java.text.SimpleDateFormat("HH:mm").format(date);
							String title = arr[12];
							if(title.length()>33){
								title=title.substring(0,33)+"...";
							}
						%>
							<div class="clearfix">
								<strong><%=meetTime%></strong>
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
            <div class="flex-btn clearfix">
              <a href="javascript:void(0);" class="fb1 current"><em></em><span>发布时间排序</span></a>
              <a href="javascript:void(0);" class="fb2"><em></em><span>会议时间排序</span></a>
            </div>
          </div>
        </div>
        <div class="pro-box pro-meeting-jy">
          <div class="pro-box-title">
            <span><em></em>会议纪要</span>
            <a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23656&startPage=1&pageSize=12&orgId=<%=orgId%>">更多>></a>
          </div>
          <div class="pro-meeting-container">
            <div class="flexslider4">
              <ul class="slides">
                <li>
                  <div class="pro-list-div">
				  <%
					if(hyjy!=null&&hyjy.size()>0){
						for(int i=0;i<hyjy.size()&&i<6;i++){
							String [] arr=(String [])hyjy.get(i);
							String title = arr[1];
							if(title.length()>35){
								title=title.substring(0,35)+"...";
							}
							String tt = arr[2].substring(5,10);
						%>
							<div class="clearfix">
								<strong><%=tt%></strong>
								<a href="javascript:void(0)" title='<%=arr[1]%><%=arr[2]%>' onclick="infoDetailView('<%=arr[0]%>');">
								<p><%=title%></p>
								</a>
							</div>
					<%}}%>
                  </div>
                </li>
                <li>
                  <div class="pro-list-div">
                    <%
					if(hyjy!=null&&hyjy.size()>6){
						for(int i=6;i<hyjy.size()&&i<12;i++){
							String [] arr=(String [])hyjy.get(i);
							String title = arr[1];
							if(title.length()>35){
								title=title.substring(0,35)+"...";
							}
							String tt = arr[2].substring(5,10);
						%>
							<div class="clearfix">
								<strong><%=tt%></strong>
								<a href="javascript:void(0)" title='<%=arr[1]%><%=arr[2]%>' onclick="infoDetailView('<%=arr[0]%>');">
								<p><%=title%></p>
								</a>
							</div>
					<%}}%>
                  </div>
                </li>
                <li>
                  <div class="pro-list-div">
                    <%
					if(hyjy!=null&&hyjy.size()>12){
						for(int i=12;i<hyjy.size()&&i<18;i++){
							String [] arr=(String [])hyjy.get(i);
							String title = arr[1];
							if(title.length()>35){
								title=title.substring(0,35)+"...";
							}
							String tt = arr[2].substring(5,10);
						%>
							<div class="clearfix">
								<strong><%=tt%></strong>
								<a href="javascript:void(0)" title='<%=arr[1]%><%=arr[2]%>' onclick="infoDetailView('<%=arr[0]%>');">
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
      <div class="pro-box pro-pro pro-border pro-padding pro-more pro-subject">
        <div class="pro-box-title">
          <span><em></em>专题专栏</span>
          <a href="/defaultroot/rd/info/gf-ztzl.jsp">更多>></a>
        </div>
        <div class="pro-box-con" style="height: 278px;">
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
      <div class="pro-box pro-border pro-padding pro-date pro-more">
	  
        <div class="pro-box-title">
          <span><em></em>日期</span>
		   <iframe allowtransparency="true" frameborder="0" width="135" height="36" scrolling="no" src="//tianqi.2345.com/plugin/widget/index.htm?s=3&z=3&t=1&v=1&d=1&bd=0&k=&f=&q=0&e=1&a=1&c=54511&w=180&h=36&align=left" class="waether fr"></iframe>
		   <!--<iframe name="weather_inc" src="http://i.tianqi.com/index.php?c=code&id=31" width="135" height="25" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
		  -->
        </div>
		<p>
          <strong id="date01"><%=date01%></strong>
          <strong id="date02"><%=date02%></strong>
        </p>
        <p>
          <strong id="date03"><%=date03%></strong>
          <strong id="date04"><%=date04%></strong>
        </p>

          
		
        
      </div>

<div class="pro-box pro-border pro-padding pro-duty pro-more xinzeng1">
<%

	String sql1=" SELECT COUNT (*) FROM org_employee emp, org_organization_user org_user, org_organization org WHERE     emp.emp_id = org_user.emp_id AND org.org_id = org_user.org_id AND org.orgidstring LIKE '%12667%' and emp.USERISDELETED=0 and org.ORGSTATUS=0 ";
	String sql2=" SELECT COUNT (*) FROM security_onlineuser onlineuser,org_organization_user org_user,org_organization org WHERE onlineuser.user_id = org_user.emp_id AND org.org_id = org_user.org_id AND org.orgidstring LIKE '%12667%' and org.ORGSTATUS=0 ";
	String sql3=" SELECT COUNT (*) FROM org_employee emp, org_organization_user org_user, org_organization org WHERE     emp.MOBILE_USER_FLAG = 1 AND emp.emp_id = org_user.emp_id AND org.org_id = org_user.org_id AND org.orgidstring LIKE '%12667%' and emp.USERISDELETED=0 and org.ORGSTATUS=0 ";

	//1. 当天发起流程个数：
	String sql4="select   count(*)  from  ez_flow_hi_procinst    t   where   to_char(start_time_,'yyyy-mm-dd')=to_char(SYSDATE,'yyyy-mm-dd')";

	//2.  每个正常办理结束的流程的 平均 花费时间   单位（天）
	String sql5="select  avg(cast(t.end_time_ as date)-cast(t.start_time_ as date))    from  ez_flow_hi_procinst  t  where      t.whir_status=100";

	//3.  超过两天办理的流程 
	String sql6="select count(*) from  ez_flow_hi_procinst t  where  (  t.whir_status=100  and   (cast(t.end_time_ as date)-cast(t.start_time_ as date))>=2 ) or ( t.end_time_ is   null  and  (SYSDATE-cast(t.start_time_ as date))>=2)";



	//Map varMap1=new HashMap();
	Map varMap2=new HashMap();
	Map varMap3=new HashMap();
	Map varMap4=new HashMap();
	Map varMap5=new HashMap();
	Map varMap6=new HashMap();
	Dbutil  dbUtil=new Dbutil();
	//Object []workInfoObj1=null;
	Object []workInfoObj2=null;
	Object []workInfoObj3=null;
	Object []workInfoObj4=null;
	Object []workInfoObj5=null;
	Object []workInfoObj6=null;
	try {
		//workInfoObj1=dbUtil.getFirstDataBySQL(sql1, varMap1);
		workInfoObj2=dbUtil.getFirstDataBySQL(sql2, varMap2);
		workInfoObj3=dbUtil.getFirstDataBySQL(sql3, varMap3);
		workInfoObj4=dbUtil.getFirstDataBySQL(sql4, varMap4);
		workInfoObj5=dbUtil.getFirstDataBySQL(sql5, varMap5);
		workInfoObj6=dbUtil.getFirstDataBySQL(sql6, varMap6);
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
	//System.out.println("---------------------------"+workInfoObj1[0]);
	//System.out.println("---------------------------"+workInfoObj2[0]);
	//System.out.println("---------------------------"+workInfoObj3[0]);
	%>
                <div class="pro-box-title">
                    <span><em class="icon-zbxx"></em>OA活跃度</span>
                </div>
				<table class="hyd" align="center " cellpadding="0 " cellspacing="0 ">
				<tr> 
				<td rowspan=2 style="text-aline:center;">活跃用户</td>
				<td>激活人数</td>
				<td>在线人数</td>
				</tr>
				<tr> 
				<td><%=workInfoObj3[0]%>(人)</td>
				<td><%=workInfoObj2[0]%>(人)</td>
				</tr>
				<tr>
				<td>今日流程</td>
				<td colspan=2><%=workInfoObj4[0]%>(个)</td>
				
				</tr>
				<tr> 
				<td rowspan=2 style="text-aline:center;">流程绩效</td>
				<td>流转平均时间</td>
				<td>超限流程数</td>
				</tr>
				<tr> 
				<td><%=strAvg%>(天)</td>
				<td><%=workInfoObj6[0]%>(个)</td>
				</tr>
				</table>
            </div>
             <div class="pro-box pro-border pro-padding pro-notice pro-more">
        <div class="pro-box-title">
          <span><em class="icon-hyjy"></em>公告信息</span>
          <a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=80245&startPage=1&pageSize=12&orgId=<%=orgId%>">更多>></a>
        </div>
        <div class="flexslider1">
          <ul class="slides">
            <li>
              <div id="ggxxList1" class="pro-list">
				<%
				if(ggxx!=null&&ggxx.size()>0){
					for(int i=0;i<ggxx.size()&&i<6;i++){
						String [] arr=(String [])ggxx.get(i);
						String title = arr[1];
						if(title.length()>25){
							title=title.substring(0,25)+"...";
						}
					%>
						<div class="gg-item" style="height:48px;">
							
                            <font>■</font>
							<a href="javascript:void(0)" title='<%=arr[1]%><%=arr[2]%>' onclick="infoDetailView('<%=arr[0]%>');">
                            <em><%=title%></em>
							</a>
							<span class="wh-pending-time"><%=arr[2]%></span>
							
						</div>
				<%}}%>

              </div>
            </li>
            <li>
              <div id="ggxxList2" class="pro-list">
				<%
				if(ggxx!=null&&ggxx.size()>6){
					for(int i=6;i<ggxx.size()&&i<12;i++){
						String [] arr=(String [])ggxx.get(i);
						String title = arr[1];
						if(title.length()>25){
							title=title.substring(0,25)+"...";
						}
					%>
						<div class="gg-item">
                            <font>■</font>
							<a href="javascript:void(0)" title='<%=arr[1]%><%=arr[2]%>' onclick="infoDetailView('<%=arr[0]%>');">
                            <em><%=title%></em>
							</a>
							<span class="wh-pending-time"><%=arr[2]%></span>
						</div>
				<%}}%>

              </div>
            </li>
            <li>
              <div id="ggxxList3" class="pro-list">
       
				<%
				if(ggxx!=null&&ggxx.size()>12){
					for(int i=12;i<ggxx.size()&&i<18;i++){
						String [] arr=(String [])ggxx.get(i);
						String title = arr[1];
						if(title.length()>25){
							title=title.substring(0,25)+"...";
						}
					%>
						<div class="gg-item">
                            <font>■</font>
							<a href="javascript:void(0)" title='<%=arr[1]%><%=arr[2]%>' onclick="infoDetailView('<%=arr[0]%>');">
                            <em><%=title%></em>
							</a>
							<span class="wh-pending-time"><%=arr[2]%></span>
						</div>
				<%}}%>
               
              </div>
            </li>
          </ul>
        </div>
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
          <!--<div class="title">
          	<strong>部门值班</strong>
          </div>
        	<div class="list">
        		<div class="wrap">
        			<ul style="top:0px;">
					<%if(zbxx!=null && zbxx.size()>0){
					for(int i=0;i<zbxx.size();i++){
					String [] arr = (String[])zbxx.get(i);
					String dpt = arr[1];
					String name = arr[0];
					String phone = arr[2];
					if(!"12770".equals(arr[4])){
						if(arr[1].length()>6){
							dpt = arr[1].substring(0,6);
						}
						if(arr[0].length()>3){
							name = arr[0].substring(0,3);
						}
						if(arr[2].length()>12){
							phone = arr[2].substring(0,12);
						}
					
					%>
		            <li class="item">
		            	<em class="dpt" title="<%=arr[1]%>"><%=dpt%></em> 
		            	<em class="name" title="<%=arr[0]%>"><%=name%></em> 
		            	<em class="phone" title="<%=arr[2]%>"><%=phone%></em>
		            </li>
		            <%}}}%>
		          </ul>	
        		</div>
	           <div class="arrow" id="J_duty-scroll">
	          	<a href="javascript:void(0)" class="disable" direction="1">top</a>
	          	<a href="javascript:void(0)" direction="-1">bottom</a>
	          </div>
          </div>
          -->
          <div class="more">
          	<a href="##" >查看当月信息</a>	
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
	 <div class="footer">
	 		<p>中国·首钢集团<span class="copyright">Copyright &copy; 2003 shougang.com.cn, All Rights Reserved</span></p>
	 </div>
   <!-- 登录页弹出  -->
   <div class="tan-loginbox">  
		<div class="tan-login">
            <div class="login-box">
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
						<input  type="text" name="userAccount" id="userAccount" class="fr" onkeydown="if(event.keyCode==13)javascript:submitForm();"/>
                    </div>
                    <div class="ban before-password clearfix">
                        <label class="fl" style="color:#333">密码</label>
                        <input  type="password" name="userPassword" id="userPassword" class="fr" autocomplete="off" onkeydown="if(event.keyCode==13)javascript:submitForm();"/>
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
                        <input  type="button" class="dl fr" value="登录" onclick="javascript:submitForm();"/>
                    </div>
					</form>
                    <ul class="others clearfix">
						<!--<li><a onclick="javascript:change(0);">扫描二维码</a></li>-->
						<li><a href="/defaultroot/public/edit/logindownload/Logindownload.jsp?fileName=activex.msi">控件安装</a></li>
						<li></li>
						<li><a href="/defaultroot/help/help_set.html"  target="_blank">设置帮助</a></li>
                    </ul>
                </div>
            </div>
        </div>

		</div>

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

function clearfeedBack(){
	$("#feedback").val("0");
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

function SearchInformation(){
	var infokey = $("#search").val();
	window.location.href = whirRootPath+"/WebIndexSggfBD!infolist.action?infokey=" + encodeURIComponent(infokey)+"&orgId=<%=orgId%>"+"&channelIds=80707,23683,23656,80245,23864,23868,23872,23876,23878";
}

function xwdtNext(){
	var no = $("#xwdtNo").text();
	if(no == "1"){
		$("#xwdtNo").text("2");
		$("#xwdtList").empty();
		<%
		if(xwdt!=null&&xwdt.size()>5){
			for(int i=5;i<xwdt.size()&&i<10;i++){
				String [] arr=(String [])xwdt.get(i);
				String title = arr[1];
				if(title.length()>35){
					title = title.substring(0,35)+"...";
				}
			%>
				$("#xwdtList").append("<li><font>■</font><a href=\"javascript:void(0)\" title=\'<%=arr[1]%><%=arr[2]%>\' onclick=\"infoDetailView(\'<%=arr[0]%>\');\"><em><%=title%></em></a><span class=\"wh-pending-time\"><%=arr[2]%></span></li>");
		<%}}%>
		$(".pro-list ul li").last().css("border-bottom","none");

	}else if(no == "2"){
		$("#xwdtNo").text("3");
		$("#xwdtList").empty();
		<%
		if(xwdt!=null&&xwdt.size()>10){
			for(int i=10;i<xwdt.size()&&i<15;i++){
				String [] arr=(String [])xwdt.get(i);
				String title = arr[1];
				if(title.length()>35){
					title = title.substring(0,35)+"...";
				}
			%>
				$("#xwdtList").append("<li><font>■</font><a href=\"javascript:void(0)\" title=\'<%=arr[1]%><%=arr[2]%>\' onclick=\"infoDetailView(\'<%=arr[0]%>\');\"><em><%=title%></em></a><span class=\"wh-pending-time\"><%=arr[2]%></span></li>");
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
			for(int i=5;i<xwdt.size()&&i<10;i++){
				String [] arr=(String [])xwdt.get(i);
				String title = arr[1];
				if(title.length()>35){
					title = title.substring(0,35)+"...";
				}
			%>
				$("#xwdtList").append("<li><font>■</font><a href=\"javascript:void(0)\" title=\'<%=arr[1]%><%=arr[2]%>\' onclick=\"infoDetailView(\'<%=arr[0]%>\');\"><em><%=title%></em></a><span class=\"wh-pending-time\"><%=arr[2]%></span></li>");
		<%}}%>
		$(".pro-list ul li").last().css("border-bottom","none");
	}else if(no == "2"){
		$("#xwdtNo").text("1");
		$("#xwdtList").empty();
		<%
		if(xwdt!=null&&xwdt.size()>0){
			for(int i=0;i<xwdt.size()&&i<5;i++){
				String [] arr=(String [])xwdt.get(i);
				String title = arr[1];
				if(title.length()>35){
					title = title.substring(0,35)+"...";
				}
			%>
				$("#xwdtList").append("<li><font>■</font><a href=\"javascript:void(0)\" title=\'<%=arr[1]%><%=arr[2]%>\' onclick=\"infoDetailView(\'<%=arr[0]%>\');\"><em><%=title%></em></a><span class=\"wh-pending-time\"><%=arr[2]%></span></li>");
		<%}}%>
		$(".pro-list ul li").last().css("border-bottom","none");
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

//添加收藏夹
function addFavorite2() {
   var url = window.location;
   var title = '首钢股份公司协同办公系统';
   if (window.sidebar) {
	 //火狐浏览器用
	 window.sidebar.addPanel(title, url, "");
   }
   else if (document.all) {
	 try{
	   window.external.toString(); //360浏览器不支持window.external，无法收藏  
       window.alert("国内开发的360浏览器等不支持主动加入收藏。\n您可以尝试通过浏览器菜单栏或快捷键 ctrl+D 进行收藏。");  
	 }catch (e){  
	   try{  
           window.external.addFavorite(window.location,title);  
       }catch (e){  
           window.external.addToFavoritesBar(window.location, title);  //IE8  
       }  
   }}else { 
	   try{  
           window.external.addFavorite(window.location,title);  
       }catch (e){  
		   try{ 
           window.external.addToFavoritesBar(window.location, title);  //IE8 
		   }catch (e){
			   whir_alert('国内开发的360浏览器等不支持主动加入收藏。\n您可以尝试通过浏览器菜单栏或快捷键 ctrl+D 进行收藏。');  
			   }
       } 
   }  

}

//信息详细弹出框 
function  infoDetailView(id){
	//var offsetWidth = document.body.offsetWidth*0.66+"px";
	//var offsetHeight = document.body.offsetHeight*0.4+"px";
	layer.open({
		type: 2,
		title: '信息详情',
		shadeClose: false,
		shade: 0.8,
		area: ['80%', '80%'],
		scrollbar: false,
		content: '/defaultroot/WebIndexSggfBD!detailInfomation.action?id='+id
	});
}

function  meetDetailView(id){
	layer.open({
		type: 2,
		title: '会议详情',
		shadeClose: false,
		shade: 0.8,
		area: ['80%', '80%'],
		scrollbar: false,
		content: '/defaultroot/WebIndexSggfBD!detailMeeting.action?id='+id
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
 
</script>
</html>