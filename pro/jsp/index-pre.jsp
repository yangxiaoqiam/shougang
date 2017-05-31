<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
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
String ewmpicacc = rootPath+"../defaultroot/images/ewm.jpg";
String logobroadpicacc = rootPath+"../defaultroot/images/bg1.jpg";
String userPhoto = rootPath+"../defaultroot/images/ver113/login/user.jpg";
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
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="stylesheet" type="text/css" href="../defaultroot/pro/css/reset.css" />
    <link rel="stylesheet" type="text/css" href="../defaultroot/pro/css/flexslider.css" />
    <link rel="stylesheet" type="text/css" href="../defaultroot/pro/css/pro-style.css" />
	<script src="<%=rootPath%>/scripts/main/whir.application.js" type="text/javascript"></script>
	
</head>

<body>
    <div class="pro-header-tips">
    <ul>
      <li class="t1">
        <a href="##">
          <em></em>
          <span>扫描二维码</span>
        </a>
        <div class="weixin-tan">
             <div class="qrcode">
                <img src="../defaultroot/pro/img/qr.png">
              </div>
              <div class="arrow"></div>
        </div>
      </li>
      <li class="t2">
        <a href="##">
          <em></em>
          <span>收藏本站</span>
        </a>
      </li>
      <li class="t3">
        <a href="##">
          <em></em>
          <span>公司链接</span>
        </a>
        <div class="link">
            <a href="#">百度</a>
            <a href="#">百度</a>
            <a href="#">百度</a>
            <a href="#">百度</a>
        </div>
      </li>
      <li class="t4">
        <a href="javascript:void(0)">
          <em></em>
          <span>常用系统</span>
        </a>
         <div class="system-tanbox_a">
         <div class="icon01"><img src="../defaultroot/pro/img/icon01.png"></div>
        <div class="system-tanbox clearfix">
                            <div class="system-tan">
                               
                                <table>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <a href="#"><font>■</font>迁钢统一登录平台  </a>
                                                <a href="#"><font>■</font>办公自动化系统    </a>
                                                <a href="#"><font>■</font>学分制管理系统     </a>
                                                <a href="#"><font>■</font>迁钢生产经营日报   </a>
                                                <a href="#"><font>■</font>职工培训课件    </a>
                                                <a href="#"><font>■</font>生产用车管理系统    </a>
                                                <a href="#"><font>■</font>一卡通系统     </a>
                                                <a href="#"><font>■</font>材料供应系统   </a>
                                                <a href="#"><font>■</font>污染源在线监测系统    </a>
                                                <a href="#"><font>■</font>信息资源知识管理平台   </a>
                                                <a href="#"><font>■</font>公司邮箱    </a>
                                            </td>
                                            <td>
                                                <a href="#"><font>■</font>数字图书馆（万方）   </a>
                                                <a href="#"><font>■</font>首钢冶金标准管理系统  </a>
                                                <a href="#"><font>■</font>年度绩效评测系统   </a>
                                                <a href="#"><font>■</font>首钢人力资源管理系统  </a>
                                                <a href="#"><font>■</font>迁钢人力资源管理系统  </a>
                                                <a href="#"><font>■</font>设备管理系统    </a>
                                                <a href="#"><font>■</font>物资计量系统  </a>
                                                <a href="#"><font>■</font>时间同步系统   </a>
                                                <a href="#"><font>■</font>电话号码本  </a>
                                                <a href="#"><font>■</font>硅钢信息系统  </a>
                                                <a href="#"><font>■</font>首钢客户营销服务平台  </a>
                                                <a href="#"><font>■</font>LIMS一期    </a>
                                            </td>
                                            <td>
                                                <a href="#"><font>■</font>LIMS二期  </a>
                                                <a href="#"><font>■</font>二炼钢生产管控  </a>
                                                <a href="#"><font>■</font>1580MES    </a>
                                                <a href="#"><font>■</font>热轧AQD    </a>
                                                <a href="#"><font>■</font>2160MES    </a>
                                                <a href="#"><font>■</font>2160在线判定  </a>
                                                <a href="#"><font>■</font>热轧自动仓储  </a>
                                                <a href="#"><font>■</font>热轧自动仓储  </a>
                                                <a href="#"><font>■</font>冷轧仓储  </a>
                                                <a href="#"><font>■</font>冷轧AQD    </a>
                                                <a href="#"><font>■</font>冷轧AMS   </a>
                                                <a href="#"><font>■</font>一炼钢LIMS  </a>
                                            </td>
                                            <td>
                                                <a href="#"><font>■</font>冷轧LIMS    </a>
                                                <a href="#"><font>■</font>ITMS  </a>
                                                <a href="#"><font>■</font>二冷轧MES   </a>
                                                <a href="#"><font>■</font>二冷轧仓储    </a>
                                                <a href="#"><font>■</font>一炼钢DHS   </a>
                                                <a href="#"><font>■</font>钢加酸洗MES    </a>
                                                <a href="#"><font>■</font>钢加酸洗仓储   </a>
                                                <a href="#"><font>■</font>能源二级基础管理系统    </a>
                                                <a href="#"><font>■</font>无人值守计量系统   </a>
                                                <a href="#"><font>■</font>迁钢设备管理系统    </a>
                                                <a href="#"><font>■</font>迁钢设备数据管理平台   </a>
                                                <a href="#"><font>■</font>首钢进口矿管理平台  </a>
                                            </td>
                                            <td>
                                                <a href="#"><font>■</font>迁钢质量过程控制系统  </a>
                                                <a href="#"><font>■</font>测量管理体系信息平台   </a>
                                                <a href="#"><font>■</font>ITSM运维管理系统   </a>
                                                <a href="#"><font>■</font>迁顺订单交货期管理   </a>
                                                <a href="#"><font>■</font>首钢经营管理平台    </a>
                                                <a href="#"><font>■</font>首钢采购电子商务平台  </a>
                                                <a href="#"><font>■</font>隐患排查治理和安全生产  </a>
                                                <a href="#"><font>■</font>预警系统    </a>
                                                <a href="#"><font>■</font>合同评审系统   </a>
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
                <a href="##" class="pro-logo"><img src="../defaultroot/pro/img/logo.png" /></a>
                <ul class="clearfix">
                    <li class="current">
                        <a>
                            <em><img src="../defaultroot/pro/img/nav-icon01.png"></em>
                            <span>首页</span>
                        </a>
                    </li>
                    <li>
                        <a><em><img src="../defaultroot/pro/img/nav-icon02.png"> </em>
                    <span>规章制度 </span>
                    </a>
                        <dl>
                            <dd><a href="#">规章制度规章</a></dd>
                            <dd><a href="#">规章规章</a></dd>
                            <dd><a href="#">规章规章</a></dd>
                        </dl>
                    </li>
                    <li>
                        <a>
                            <em><img src="../defaultroot/pro/img/nav-icon03.png"></em>
                            <span> 通讯录 </span>
                        </a>
                        <dl>
                            <dd><a href="#">规章制度规章</a></dd>
                            <dd><a href="#">规章规章</a></dd>
                            <dd><a href="#">规章规章</a></dd>
                        </dl>
                    </li>
                    <li>
                        <a>
                            <em><img src="../defaultroot/pro/img/nav-icon04.png"></em>
                            <span>生活服务</span>
                        </a>
                        <dl>
                            <dd><a href="#">规章制度规章</a></dd>
                            <dd><a href="#">规章规章</a></dd>
                            <dd><a href="#">规章规章</a></dd>
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
                           <div class="icon01"><img src="../defaultroot/pro/img/icon01.png"></div>
                        <div class="system-tanbox">
                            <div class="system-tan">
                                
                                <table>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <a href="#"><font>■</font>迁钢统一登录平台  </a>
                                                <a href="#"><font>■</font>办公自动化系统    </a>
                                                <a href="#"><font>■</font>学分制管理系统     </a>
                                                <a href="#"><font>■</font>迁钢生产经营日报   </a>
                                                <a href="#"><font>■</font>职工培训课件    </a>
                                                <a href="#"><font>■</font>生产用车管理系统    </a>
                                                <a href="#"><font>■</font>一卡通系统     </a>
                                                <a href="#"><font>■</font>材料供应系统   </a>
                                                <a href="#"><font>■</font>污染源在线监测系统    </a>
                                                <a href="#"><font>■</font>信息资源知识管理平台   </a>
                                                <a href="#"><font>■</font>公司邮箱    </a>
                                            </td>
                                            <td>
                                                <a href="#"><font>■</font>数字图书馆（万方）   </a>
                                                <a href="#"><font>■</font>首钢冶金标准管理系统  </a>
                                                <a href="#"><font>■</font>年度绩效评测系统   </a>
                                                <a href="#"><font>■</font>首钢人力资源管理系统  </a>
                                                <a href="#"><font>■</font>迁钢人力资源管理系统  </a>
                                                <a href="#"><font>■</font>设备管理系统    </a>
                                                <a href="#"><font>■</font>物资计量系统  </a>
                                                <a href="#"><font>■</font>时间同步系统   </a>
                                                <a href="#"><font>■</font>电话号码本  </a>
                                                <a href="#"><font>■</font>硅钢信息系统  </a>
                                                <a href="#"><font>■</font>首钢客户营销服务平台  </a>
                                                <a href="#"><font>■</font>LIMS一期    </a>
                                            </td>
                                            <td>
                                                <a href="#"><font>■</font>LIMS二期  </a>
                                                <a href="#"><font>■</font>二炼钢生产管控  </a>
                                                <a href="#"><font>■</font>1580MES    </a>
                                                <a href="#"><font>■</font>热轧AQD    </a>
                                                <a href="#"><font>■</font>2160MES    </a>
                                                <a href="#"><font>■</font>2160在线判定  </a>
                                                <a href="#"><font>■</font>热轧自动仓储  </a>
                                                <a href="#"><font>■</font>热轧自动仓储  </a>
                                                <a href="#"><font>■</font>冷轧仓储  </a>
                                                <a href="#"><font>■</font>冷轧AQD    </a>
                                                <a href="#"><font>■</font>冷轧AMS   </a>
                                                <a href="#"><font>■</font>一炼钢LIMS  </a>
                                            </td>
                                            <td>
                                                <a href="#"><font>■</font>冷轧LIMS    </a>
                                                <a href="#"><font>■</font>ITMS  </a>
                                                <a href="#"><font>■</font>二冷轧MES   </a>
                                                <a href="#"><font>■</font>二冷轧仓储    </a>
                                                <a href="#"><font>■</font>一炼钢DHS   </a>
                                                <a href="#"><font>■</font>钢加酸洗MES    </a>
                                                <a href="#"><font>■</font>钢加酸洗仓储   </a>
                                                <a href="#"><font>■</font>能源二级基础管理系统    </a>
                                                <a href="#"><font>■</font>无人值守计量系统   </a>
                                                <a href="#"><font>■</font>迁钢设备管理系统    </a>
                                                <a href="#"><font>■</font>迁钢设备数据管理平台   </a>
                                                <a href="#"><font>■</font>首钢进口矿管理平台  </a>
                                            </td>
                                            <td>
                                                <a href="#"><font>■</font>迁钢质量过程控制系统  </a>
                                                <a href="#"><font>■</font>测量管理体系信息平台   </a>
                                                <a href="#"><font>■</font>ITSM运维管理系统   </a>
                                                <a href="#"><font>■</font>迁顺订单交货期管理   </a>
                                                <a href="#"><font>■</font>首钢经营管理平台    </a>
                                                <a href="#"><font>■</font>首钢采购电子商务平台  </a>
                                                <a href="#"><font>■</font>隐患排查治理和安全生产  </a>
                                                <a href="#"><font>■</font>预警系统    </a>
                                                <a href="#"><font>■</font>合同评审系统   </a>
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
                            <input type="text" name="" class="search-text" />
                            <input type="submit" name="" value="" class="search-btn" />
                        </form>
                    </div>
                    <button>登录</button>
                </div>
            </div>
        </div>
  <div class="pro-banner">
  </div>
  <div class="pro-container clearfix">
    <div class="pro-cl">
      <div class="clearfix">
        <div class="pro-box pro-pic-info">
		<%
		List tpxwp=new ArrayList();
		List xwdt=new ArrayList();
		List hytz=new ArrayList();
		List hyjy=new ArrayList();
		List ggxx=new ArrayList();
		List ztzlp=new ArrayList();
		tpxwp=gpInfo.getNewsPH("62460",orgId,6);
		xwdt=gpInfo.getInfo("62578",orgId,5);
		hytz=gpInfo.getInfo("23854",orgId,6);
		hyjy=gpInfo.getInfo("62637",orgId,6);
		ggxx=gpInfo.getInfo("62667",orgId,8);
		ztzlp=gpInfo.getNewsPH("24119",orgId,9);
		
		%>
          <div class="flexslider">
            <strong>图片新闻</strong>
            <ul class="slides">
			<%
				if(tpxwp!=null&&tpxwp.size()>0){
					for(int i=0;i<tpxwp.size();i++){
						String [] arr=(String [])tpxwp.get(i);
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

					<li>
						<a href="javascript:void(0)" title='<%=arr[1]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});">
						<img src="<%=smallSrcUrl%>" />
						<div>
						  <p><%=arr[1]%></p>
						  <span><%=arr[7]%>「<%=arr[2]%>」</span>
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
            <a href="##">更多>></a>
          </div>
          <div class="pro-list">
            <ul>
			<%
			if(xwdt!=null&&xwdt.size()>0){
				for(int i=0;i<xwdt.size();i++){
					String [] arr=(String [])xwdt.get(i);
				%>
					<li>
						<a href="javascript:void(0)" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});">
                        <font>■</font>
                        <em><%=arr[1]%></em>
							<span class="wh-pending-time"><%=arr[2]%></span>
						</a>
					</li>
			<%}}%>
            </ul>
            <div class="page-div">
              <a href="##">上一页</a>
              <span>1/3</span>
              <a href="##">下一页</a>
            </div>
          </div>
        </div>
      </div>
      <div class="pro-meeting-con clearfix">
        <div class="pro-box pro-meeting">
          <div class="pro-box-title">
            <span><em></em>会议通知</span>
            <a href="##">更多>></a>
          </div>
          <div class="pro-meeting-container">
            <div class="isf flexslider2">
              <ul class="slides">
                <li>
                  <div class="pro-list-div">
				  <%
					if(hytz!=null&&hytz.size()>0){
						for(int i=0;i<hytz.size();i++){
							String [] arr=(String [])hytz.get(i);
						%>
							<div class="clearfix">
								<a href="javascript:void(0)" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});">
									<strong><%=arr[2]%></strong>
									<p><%=arr[1]%></p>
								</a>
							</div>
					<%}}%>
                  </div>
                </li>
                <li>
                  <div class="pro-list-div">
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                  </div>
                </li>
              </ul>
            </div>
            <div class="isf flexslider3" style="display: none; ">
              <ul class="slides">
                <li>
                  <div class="pro-list-div">
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部3技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部3技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部3技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部3技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部3技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部3技改工程项目推进会</p>
                      </a>
                    </div>
                  </div>
                </li>
                <li>
                  <div class="pro-list-div">
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部4技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部4技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部4技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部4技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部4技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部4技改工程项目推进会</p>
                      </a>
                    </div>
                  </div>
                </li>
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
            <a href="##">更多>></a>
          </div>
          <div class="pro-meeting-container">
            <div class="flexslider4">
              <ul class="slides">
                <li>
                  <div class="pro-list-div">
				  <%
					if(hyjy!=null&&hyjy.size()>0){
						for(int i=0;i<hyjy.size();i++){
							String [] arr=(String [])hyjy.get(i);
						%>
							<div class="clearfix">
								<a href="javascript:void(0)" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});">
									<strong><%=arr[2]%></strong>
									<p><%=arr[1]%></p>
								</a>
							</div>
					<%}}%>
                  </div>
                </li>
                <li>
                  <div class="pro-list-div">
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                  </div>
                </li>
                <li>
                  <div class="pro-list-div">
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
                    <div class="clearfix">
                      <a href="">
                        <strong>2016/09/27</strong>
                        <p>关于组织召开动力作业部2技改工程项目推进会</p>
                      </a>
                    </div>
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
          <a href="##">更多>></a>
        </div>
        <div class="pro-box-con">
          <div class="flexslider5">
            <ul class="slides">
			<%
				if(ztzlp!=null&&ztzlp.size()>0){
					for(int i=0;i<ztzlp.size();i++){
						String [] arr=(String [])ztzlp.get(i);
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

					<li>
						<a href="javascript:void(0)" title='<%=arr[1]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});">
						<div class="wrap">
						<img src="<%=smallSrcUrl%>" />
						  <p><%=arr[1]%></p>
						</div>
						</a>
					</li>
			<%}}}%>  
            </ul>
          </div>
        </div>
      </div>
    </div>
    <div class="pro-cr">
      <div class="pro-box pro-border pro-padding pro-date pro-more">
        <div class="pro-box-title">
          <span><em></em>日期</span>
        </div>
		<%
		java.util.Date d = new java.util.Date();
		java.text.SimpleDateFormat sdf01 = new java.text.SimpleDateFormat("yyyy");
		java.text.SimpleDateFormat sdf02 = new java.text.SimpleDateFormat("MM/dd");
		java.text.SimpleDateFormat sdf03 = new java.text.SimpleDateFormat("EEEE");
		java.text.SimpleDateFormat sdf04 = new java.text.SimpleDateFormat("aK:mm");
		String date01 = sdf01.format(d);
		String date02 = sdf02.format(d);
		String date03 = sdf03.format(d);
		String date04 = sdf04.format(d);
		%>
        <p>
          <strong><%=date01%></strong>
          <strong><%=date02%></strong>
        </p>
        <p>
          <strong><%=date03%></strong>
          <strong><%=date04%></strong>
        </p>
      </div>
      <div class="pro-box pro-border pro-padding pro-notice pro-more">
        <div class="pro-box-title">
          <span><em class="icon-hyjy"></em>公告信息</span>
          <a href="##">更多>></a>
        </div>
        <div class="flexslider1">
          <ul class="slides">
            <li>
              <div class="pro-list">
                <ul>
				<%
				if(ggxx!=null&&ggxx.size()>0){
					for(int i=0;i<ggxx.size();i++){
						String [] arr=(String [])ggxx.get(i);
					%>
						<li>
							<a href="javascript:void(0)" title='<%=arr[1]%><%=arr[2]%>' onclick="openWin({url:'/defaultroot/BeforeInfoAction!getInformation.action?title=<%=arr[1]%>&id=<%=arr[0]%>', isFull:true});">
                            <font>■</font>
                            <em><%=arr[1]%></em>
								<span class="wh-pending-time"><%=arr[2]%></span>
							</a>
						</li>
				<%}}%>
                </ul>
              </div>
            </li>
            <li>
              <div class="pro-list">
                <ul>
                <li><a href=""><font>■</font><em>设备部开展“爱我所爱 感恩你我”主题 团日活动 </em><span>2016-02-12</span></a></li>
		              <li><a href=""><font>■</font><em>设备部开展“爱我所爱 感恩你我”主题 团日活动 </em> <span>2016-02-12</span></a></li>
		              <li><a href=""><font>■</font><em>设备部开展“爱我所爱 感恩你我”主题 团日活动 </em> <span>2016-02-12</span></a></li>
		              <li><a href=""><font>■</font><em>设备部开展“爱我所爱 感恩你我”主题 团日活动 </em> <span>2016-02-12</span></a></li>
		              <li><a href=""><font>■</font><em>设备部开展“爱我所爱 感恩你我”主题 团日活动 </em> <span>2016-02-12</span></a></li>
		              <li><a href=""><font>■</font><em>设备部开展“爱我所爱 感恩你我”主题 团日活动 </em> <span>2016-02-12</span></a></li>
		              <li><a href=""><font>■</font><em>设备部开展“爱我所爱 感恩你我”主题 团日活动 </em> <span>2016-02-12</span></a></li>
		              <li><a href=""><font>■</font><em>设备部开展“爱我所爱 感恩你我”主题 团日活动 </em> <span>2016-02-12</span></a></li>
                </ul>
              </div>
            </li>
            <li>
              <div class="pro-list">
                <ul>
                  <li><a href=""><font>■</font><em>设备部开展“爱我所爱 感恩你我”主题 团日活动 </em> <span>2016-02-12</span></a></li>
		              <li><a href=""><font>■</font><em>设备部开展“爱我所爱 感恩你我”主题 团日活动 </em> <span>2016-02-12</span></a></li>
		              <li><a href=""><font>■</font><em>设备部开展“爱我所爱 感恩你我”主题 团日活动 </em> <span>2016-02-12</span></a></li>
		              <li><a href=""><font>■</font><em>设备部开展“爱我所爱 感恩你我”主题 团日活动 </em> <span>2016-02-12</span></a></li>
		              <li><a href=""><font>■</font><em>设备部开展“爱我所爱 感恩你我”主题 团日活动 </em> <span>2016-02-12</span></a></li>
		              <li><a href=""><font>■</font><em>设备部开展“爱我所爱 感恩你我”主题 团日活动 </em> <span>2016-02-12</span></a></li>
		              <li><a href=""><font>■</font><em>设备部开展“爱我所爱 感恩你我”主题 团日活动 </em> <span>2016-02-12</span></a></li>
		              <li><a href=""><font>■</font><em>设备部开展“爱我所爱 感恩你我”主题 团日活动 </em> <span>2016-02-12</span></a></li>
                </ul>
              </div>
            </li>
          </ul>
        </div>
      </div>
      <div class="pro-box pro-border pro-padding pro-duty pro-more">
        <div class="pro-box-title">
        	<span><em class="icon-zbxx"></em>值班信息</span>
        </div>
        <div class="duty-card">
          <div class="title">值班领导</div>
        	<div class="time">2016-12-09</div>
        	<div class="name"><strong>王志安</strong></div>
          <div class="concat">联系电话：13900045642</div>
        </div>
        <div class="duty-info">
          <div class="title">
          	<strong>部门值班</strong>
          </div>
        	<div class="list">
        		<div class="wrap">
        			<ul style="top:0px;">
		            <li class="item">
		            	<em class="dpt">办公室</em> 
		            	<em class="name">崔桂军</em> 
		            	<em class="phone">7703263</em>
		            </li>
		            <li class="item">
		            	<em class="dpt">办公室</em> 
		            	<em class="name">崔桂军</em> 
		            	<em class="phone">7703263</em>
		            </li>
		            <li class="item">
		            	<em class="dpt">办公室</em> 
		            	<em class="name">崔桂军</em> 
		            	<em class="phone">7703263</em>
		            </li>
		            <li class="item">
		            	<em class="dpt">办公室</em> 
		            	<em class="name">崔桂军</em> 
		            	<em class="phone">7703263</em>
		            </li>
		            <li class="item">
		            	<em class="dpt">办公室</em> 
		            	<em class="name">崔桂军</em> 
		            	<em class="phone">7703263</em>
		            </li>
		            <li class="item">
		            	<em class="dpt">办公室</em> 
		            	<em class="name">崔桂军</em> 
		            	<em class="phone">7703263</em>
		            </li>
		            <li class="item">
		            	<em class="dpt">办公室</em> 
		            	<em class="name">崔桂军</em> 
		            	<em class="phone">7703263</em>
		            </li>
		            <li class="item">
		            	<em class="dpt">办公室</em> 
		            	<em class="name">崔桂军</em> 
		            	<em class="phone">7703263</em>
		            </li>
		            <li class="item">
		            	<em class="dpt">办公室</em> 
		            	<em class="name">崔桂军</em> 
		            	<em class="phone">7703263</em>
		            </li>
		          </ul>	
        		</div>
	           <div class="arrow" id="J_duty-scroll">
	          	<a href="##" class="disable" direction="1">top</a>
	          	<a href="##" direction="-1">bottom</a>
	          </div>
          </div>
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
	    		<div href="##" class="weixin-wrap"">
	    			<a href="##" class="weixin" id="J_qrcode"></a>
	    			<div class="qrcode">
			    		<img src="./img/qr.png">
			    	</div>
			    	<div class="arrow"></div>
	    		</div>
		    	<a href="javascript:scrollTo(0, 0)" class="gotop" id="J_gotop"></a>
		    	
		  </div>
    </div>
	 <div class="footer">
	 		<p>中国·首钢集团<span class="copyright">Copyright &copy; 2003 shougang.com.cn, All Rights Reserved</span></p>
	 </div>
   <!-- 登录页弹出  -->
   <div class="tan-login">
            <div class="login-box">
                <div class="close"></div>
                <div class="login-contact">
				<form action="LogonActionBF!logon.action" method="post" name=LogonForm target="_parent">
				<input type="hidden" name="random_form" value=<%=random%>></input>
				<input type="hidden" name="domainAccount" value="whir"></input>
                    <div class="login-tit">OA登录</div>
                    <div class="ban before-username clearfix">
                        <label class="fl">账号</label>
						<input type="text" name="userAccount" id="userAccount" class="fr" />
                    </div>
                    <div class="ban before-password clearfix">
                        <label class="fl">密码</label>
                        <input type="password" name="userPassword" id="userPassword" class="fr" autocomplete="off" />
                    </div>
                    <div class="ban before-password clearfix">
                        <label class="fl">语言</label>
                        <div class="wh-portal-l-select">
                            <span class="lang-default">简体中文</span>
                            <ul class="lang-list" style="display: none;">
                                <li>简体中文</li>
                                <li>繁体中文</li>
                                <li>韩国语</li>
                                <li>日本语</li>
                                <li>English</li>
                            </ul>
                        </div>
                    </div>
                    <div ban class="remember clearfix">
						<em class="rebp fl open"><input type="checkbox" checked="true" id="isRememberEm" name="isRememberEm" onclick="javascript:mychecked();">记住密码</em>
						<input type="hidden" id="isRemember" name="isRemember" value="1">
                        <input type="submit" name="" class="dl fr" value="登录">
                    </div>
					</form>
                    <ul class="others clearfix">
						<li><a onclick="javascript:change(0);">扫描二维码</a></li>
						<li><a href="/defaultroot/public/edit/logindownload/Logindownload.jsp?fileName=activex.msi">控件安装</a></li>
						<li><a href="/defaultroot/help/help_set.html"  target="_blank">设置帮助</a></li>
                    </ul>
                </div>
            </div>
        </div>
  <script type="text/javascript" src="../defaultroot/pro/js/jquery.min.js"></script>
  <script type="text/javascript" src="../defaultroot/pro/js/jquery.flexslider.js"></script>
  <script type="text/javascript" src="../defaultroot/pro/js/index.js"></script>
	
</body>
<script language="JavaScript">
	
/*$(document).ready(function() {
	var userAccount = $('#userAccount');
	userAccount.focus();
});*/


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
	var cheVal=document.getElementById("isRememberEm").checked;
	if(cheVal==true){
		document.getElementById("isRemember").value= "1";
	}else{
		document.getElementById("isRemember").value= "0";
	}
}


</script>
</html>