<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="/public/include/init.jsp"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.whir.i18n.Resource" %>
<%@ page import="com.whir.rd.coremail.CoreMail"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.sql.Statement"%>
<%@page import="com.whir.am.AmClient"%>
<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache");
response.setDateHeader ("Expires", 0);
//theme-red theme-pure-red
if(session==null || session.getAttribute("userId")==null){
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
location.href="login.jsp";
//-->
</SCRIPT>
<%
}else{
		
			 String  __canViewOA=""+session.getAttribute("canViewOA");
			 String  norhidehide="";


			 boolean  __isnoright=false;
			 if(__canViewOA.equals("1")){
				 
			 } else{
				 //没有权限
				   __isnoright=true; 
				   norhidehide=" style='display:none' ";
			 }


		    //-------------------正式 注释开始  ----------------
			  //先只控制  cuiyh0270  供测试
			 if(!"cuiyh0270".equals(""+session.getAttribute("userAccount"))){
				 //
				 //__isnoright=false;
			 }

			 // __isnoright=false;

			 //-------------------正式 注释结束  ----------------
	
	//coremail 邮件整合--start
				
				CoreMail coremail = new CoreMail();
				String userEmail_coremail=session.getAttribute("CoreMailAccount")+"";
				//String userEmail_coremail = CoreMailAccount;
				//System.out.println("userEmail_coremail=============="+userEmail_coremail);

				//单点登录URL
				String ssoURL_coremail="";
				if(userEmail_coremail!=null&&!"".equals(userEmail_coremail)){
					
					ssoURL_coremail = coremail.getSSOURL(userEmail_coremail);
					
				}
				if(ssoURL_coremail==null||"".equals(ssoURL_coremail)){
					ssoURL_coremail = "http://192.168.139.30/";
				}
				//System.out.println("ssoURL_coremail======desktop========:"+ssoURL_coremail);

				session.setAttribute("ssoURL_coremail",ssoURL_coremail);
				
				//新增收件箱链接 yucz 20161201
				String sjxURL="";
				if(userEmail_coremail!=null&&!"".equals(userEmail_coremail)){
					
					sjxURL = coremail.getSJXURL(userEmail_coremail);
					
				}
				if(sjxURL==null||"".equals(sjxURL)){
					sjxURL = "http://192.168.139.38/";
				}
				//System.out.println("sjxURL======desktop========:"+sjxURL);

				session.setAttribute("sjxURL",sjxURL);
				
				//写外部邮件链接 wangyajing 20161202
				String WriteURL="";
				if(userEmail_coremail!=null&&!"".equals(userEmail_coremail)){
					
					 WriteURL = coremail.getWriteURL(userEmail_coremail);
					
				}
				if(WriteURL==null||"".equals(WriteURL)){
					WriteURL = "http://192.168.139.38/";
				}
			    //System.out.println("WriteURL======desktop========:"+WriteURL);
				
				
				//未读邮件链接 wangyajing 20161202
				String UnreadURL="";
				if(userEmail_coremail!=null&&!"".equals(userEmail_coremail)){
					
					UnreadURL = coremail.getUnreadURL(userEmail_coremail);
					
				}
				if(UnreadURL==null||"".equals(UnreadURL)){
					UnreadURL = "http://192.168.139.38/";
				}
				//System.out.println("UnreadURL======desktop========:"+UnreadURL);

				session.setAttribute("UnreadURL",UnreadURL);

				//获取未读邮件总数和邮件列表
				List totalList = null;
				List mailList = null;
				try {

				List list_coremail =null;
				if(userEmail_coremail!=null&&!"".equals(userEmail_coremail)){
					list_coremail = coremail.getUnReadMailNumberAndList(userEmail_coremail);
				}
				

				if(list_coremail!=null&&list_coremail.size()>0){
					totalList = (List)(list_coremail.get(0));
					mailList = (List)(list_coremail.get(1));
				}


				}catch(Exception e){

				}
				
				String New_coremail =  (mailList==null||mailList.size()<=0)?"0":mailList.size()+"";
				String aaaaaa =  (totalList==null||totalList.size()<=0)?"0":totalList.size()+"";
				session.setAttribute("New_coremail",New_coremail);
				System.out.println("未读邮件数======desktop.jsp========"+New_coremail+"*******"+aaaaaa);

			//coremail 邮件整合--end 	

			String weekArr[] = {"星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"};
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日");
			Calendar calendar = Calendar.getInstance();
			String week = weekArr[calendar.get(Calendar.DAY_OF_WEEK)-1];
			Date date = calendar.getTime();
		    String dateStr=sdf.format(date);


		
%>



<%@ include file="/public/desktop/include_desktop_menubaseInfo.jsp"%> 
<html lang="zh-cn" class="wh-gray-bg <%=whir_2016_skin_color%> <%=whir_2016_skin_styleColor%> <%=whir_pageFontSize_css%>">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%=webTitle%></title> 
	<script>
		var _usePortalLayout = false;
		<%if(session.getAttribute("layoutId")!=null){%>
			_usePortalLayout = true;
		<%}%>



		function openDesktopNew(){
			//是否启用个人门户。
			var clickFirst=$("#desktop_hidden_isfirstClick").val(); 
			//false 此判断功能去掉
			if(false&&clickFirst=="1"){
				//默认个人门户
				var defaultId=$("#desktop_hidden_defaultMyLayoutId").val();
				if(defaultId!=""&&defaultId!="null"){
					selectLayout(defaultId);
				} 
			}else{
				var layoutId=Cookie("ezofficePortal<%=userId%>");
				if(layoutId==null || layoutId=="" || layoutId=="null"){
					layoutId = initPortalNew('');
					selectLayout(layoutId);
				}else{
					layoutId = initPortalNew(layoutId);
					if(layoutId==''){
						layoutId = initPortalNew('');
					}
					selectLayout(layoutId);
				}   
			
			}  
		};

		/**
		切换门户
		*/
		function selectLayout(layoutId){ 
			 
			setCookie("ezofficePortal<%=userId%>",layoutId,expdate, "/", null, false);
			var portalURL="";
			<%if(session.getAttribute("layoutId")!=null){%>
				if(_usePortalLayout){
					_usePortalLayout = false;
					portalURL = whirRootPath+"/platform/portal/portal_main.jsp?preview=1&id=<%=session.getAttribute("layoutId")%>&ismain=1";//+layoutId;
				}else{
					portalURL = whirRootPath+"/platform/portal/portal_main.jsp?preview=1&id="+layoutId+"&ismain=1";
				}
			<%}else{%>
				portalURL = whirRootPath+"/platform/portal/portal_main.jsp?preview=1&id="+layoutId+"&ismain=1";
			<%}%>
			//class="current"

			//$("#mainFrame").attr("src",portalURL);
			 
			yanchiSetIframe(portalURL);

			// 现在换为 显示影藏按钮 ，不显示影藏荣容器
			//$("#desktop_leftTh").hide();   
			$('.wh-content').addClass('close-l-nav');
		    $("#switchShow").hide(); 


			//initPortalNew(layoutId);
			//设置选中的样式 ，没有选中删除样式
            $("#gateway_div a[id^=Layout]").removeClass("current");
			$("#Layout"+layoutId).addClass("current");//.siblings().removeClass("current");
			addDesktopBJ();
				
				//右侧iframe 显示,新版本样式影响--xiehd20161109
				$("#mainFrame").show();
				$("#mainFrame").parent().attr("class","wh-r-content wh-r-iframe wh-ios-iframe-bug");
				//$("#mainFrame").attr("src", encodeURI(url)); 
				$("#mainDIV").hide();
		}
         
		//有可能没mainFrame 没渲染完毕 就执行了 打开首页。
		function yanchiSetIframe(portalURL){
		   if($("#mainFrame").length>0){
			   $("#mainFrame").attr("src",portalURL);  
		   }else{
			   setTimeout('yanchiSetIframe(\''+portalURL+'\')',300);
		   } 
		}
		 
    </script>
    <%@ include file="/public/include/meta_desktop_base.jsp"%> 
	 <link rel="stylesheet" type="text/css" href="/defaultroot/pro/css/pro-style.css">
	
</head>
<body onload="feedBack()">
<div class="wh-wrapper">
<div class="mh-header-tips">
<div class="pro-header-tips">
        <ul>
            <li class="t1">
                <a href="##">
                    <em></em>
                    <span>扫描二维码</span>
                </a>
                <div class="weixin-tan">
                    <div class="qrcode">
                        <img src="./img/qr.png">
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
            
            <li class="t4">
                <a>
          <em></em>
          <span>常用系统</span>
        </a>
         <div class="system-tanbox_a">
         <div class="system-tanbox clearfix">
                            <div class="system-tan">
                                     <div class="site-count site-count1">
                                          <h2>个人办公</h2>
                                          <ul class="site-list clearfix">
											   <li> <a target="_blank" href="http://web.sgqg.com/web/ztlm/phone/phone.html">岗位电话本   </a></li>
                                               <li> <a target="_blank" href="http://10.3.247.63:7003/srp/">隐患排查治理和安全生产预警系统  </a></li>
                                               <li> <a target="_blank" href="http://oa.shougang.com.cn/">首钢集团   </a></li>
                                               <li> <a target="_blank" href="http://www.sgdaily.com/">首钢日报  </a></li>
                                               <li> <a target="_blank" href="http://web.sgqg.com/web/html/main/index.html">迁钢内网  </a></li>
                                               <li> <a target="_blank" href="http://oa.sgqg.com/">办公自动化系统    </a></li>
                                               <li> <a target="_blank" href="http://mail.sgqg.com/">迁钢邮箱  </a></li>
                                               <li> <a target="_blank" href="http://www.qgcard.com/">一卡通系统   </a></li>
                                               <li> <a target="_blank" href="http://10.3.250.115/customize/nwc_755_newvlms/login/login.aspx">学分制管理系统  </a></li>
                                               <li> <a target="_blank" href="http://10.3.250.55:8000/worksheet/v2/index.jsp">全员自主创新平台  </a></li>
                                          </ul>
                                    </div>
                                    <div class="site-count site-count1">
                                          <h2>信息平台</h2>
                                          <ul class="site-list clearfix">
                                                <li><a target="_blank" href="http://www.cnki.net/">数字图书馆（知网） </a></li>
												<li><a target="_blank" href="http://10.3.250.37:8088/Default.aspx">数字图书馆（万方）  </a></li>
                                                <li><a target="_blank" href="http://10.1.155.9/bz/default.jsp">首钢冶金标准管理系统  </a></li>
                                                <li><a target="_blank" href="http://irkm.sgqg.com/cis/_portal_Index.do">信息资源知识管理平台  </a></li>
                                                <li><a target="_blank" href="http://report.sgqg.com/">迁钢生产经营日报    </a></li>
                                                <li><a target="_blank" href="http://ssis.sgqg.com/gindex.aspx">硅钢信息系统    </a></li>
                                                <li><a target="_blank" href="http://sgxs.shougang.com.cn/cmsp-web/notice/noticeIndex2.action">硅钢客户营销平台  </a></li>
                                          </ul>
                                    </div>
									<div class="site-count">
                                          <h2>生产管理</h2>
                                          <ul class="site-list clearfix">
                                                 <li><a target="_blank" href="http://10.3.247.74:8080/hyslimstapp/auth/login.jsp">一炼钢LIMS  </a></li>
												 <li><a target="_blank" href="http://2160dhs.sgqg.com:7001/mes-2160-app/loginInit.action">一炼钢DHS    </a></li>
                                                 <li><a target="_blank" href="http://10.1.250.231:7001/mes_opm_app/">首钢进口矿管理平台     </a></li>
                                                 <li><a target="_blank" href="http://10.3.247.122:7003/permission-app/permission/frame/login.htm">迁钢质量过程控制系统   </a></li>
                                                 <li><a target="_blank" href="http://10.3.247.152:7003/mes-dtm-app/">迁顺订单交货期管理    </a></li>
                                                 <li><a target="_blank" href="http://www.sgkpi.com/">首钢经营管理平台   </a></li>
                                                 <li><a target="_blank" href="http://ec.sgai.com.cn/">首钢采购电子商务平台     </a></li>
                                                 <li><a target="_blank" href="http://10.1.250.233:7001/mes-iom-webapp/">合同评审系统   </a></li>
                                                 <li><a target="_blank" href="http://scgk.ylgmes.sgqg.com:7003/mes-lg-app/">一炼钢生产管控    </a></li>
                                                 <li><a target="_blank" href="http://1580mes.sgqg.com:9002/mes-hotrolling-app/loginInit.action">1580MES   </a></li>
                                                 <li><a target="_blank" href="http://10.3.250.127:9002/ams-aqd-app/">热轧AQD    </a></li>
												 <li><a target="_blank" href="http://2lgscgk.sgqg.com:9002/mes-tms-app/loginInit.action">二炼钢生产管控    </a></li>
												 <li><a target="_blank" href="http://10.3.250.30:8080/mes-oqs-app/">2160在线判定    </a></li>
												 <li><a target="_blank" href="http://qgcc.sgqg.com/wtm_hot_app/login.htm">热轧自动仓储    </a></li>
												 <li><a target="_blank" href="http://10.3.250.227:7778/forms/frmservlet?config=sgmes_qg">2160MES    </a></li>
												 <li><a target="_blank" href="http://qglz1stwtm.sgqg.com:8003/wtm_cold_app/login.htm">冷轧仓储    </a></li>
												 <li><a target="_blank" href="http://qglzaqd.sgqg.com:7003/mes-aqd-app/">冷轧AQD    </a></li>
												 <li><a target="_blank" href="http://qglz1stmes.sgqg.com:7003/mes-coldrolling-app/">冷轧MES    </a></li>
												 <li><a target="_blank" href="http://qglz2ndmes.sgqg.com:7003/mes-coldrolling-app/">二冷轧MES    </a></li>
												 <li><a target="_blank" href="http://qglz2ndwtm.sgqg.com:8003/wtm_cold_app/login.htm">二冷轧仓储    </a></li>
												 <li><a target="_blank" href="http://qglzams.sgqg.com:8003/mes-ams-app/">冷轧AMS    </a></li>
												 <li><a target="_blank" href="http://10.3.247.135:9010/wtm_pickling_app/login.htm">钢加酸洗仓储    </a></li>
												 <li><a target="_blank" href="http://10.3.250.176:7001/mes-xc-app/">线材MES    </a></li>
												 <li><a target="_blank" href="http://10.3.247.135:8010/mes-sx-app/">钢加酸洗MES    </a></li>
												 <li><a target="_blank" href="http://10.3.250.229:8080/fbrole/main/loginframe/login.jsp">LIMS一期    </a></li>
												 <li><a target="_blank" href="http://10.3.250.102:8080/fbrole/main/loginframe/login.jsp">LIMS二期    </a></li>
												 <li><a target="_blank" href="http://10.3.247.36:8080/fbrole/main/loginframe/login.jsp">冷轧LIMS    </a></li>
                                          </ul>
                                    </div>
                                     <div class="site-count site-count1">
                                          <h2>设备管理</h2>
                                          <ul class="site-list clearfix">
                                                <li><a target="_blank" href="http://10.3.250.146:7002/qgsbcf/com.sgai.qgsbcf.framework.view.Login.d">迁钢设备数据管理平台    </a></li>
                                                <li><a target="_blank" href="http://10.3.68.29/sbb/sbb.html">设备管理系统  </a></li>
                                                <li><a target="_blank" href="http://10.3.250.158/spms/">迁钢备件管理系统  </a></li>
                                                <li><a target="_blank" href="http://10.3.250.178/Login.aspx?page=index.aspx">设备检修项目管理系统    </a></li>
                                                <li><a target="_blank" href="http://10.3.250.71/qgemstn/">电机变压器综合管理系统  </a></li>
                                                <li><a target="_blank" href="http://10.3.68.29/ocms/">液压油管理系统    </a></li>
                                                <li><a target="_blank" href="http://10.3.250.43/MMIS_SBGL.aspx">测量管理系统   </a></li>
                                                <li><a target="_blank" href="http://10.3.68.29/sesms/">特种设备管理系统    </a></li>
                                                <li><a target="_blank" href="http://10.3.250.26:8080/spotcheck/login.jsp?goto=http://10.3.250.26:8080/spotcheck/">精确点检系统  </a></li>
												<li><a target="_blank" href="http://10.3.250.212/sgqgdj/">精密点检系统  </a></li>
                                                <li><a target="_blank" href="http://10.3.250.213/">高炉鼓风机在线监测系统    </a></li>
                                                <li><a target="_blank" href="http://10.3.198.190:8888/scmltfc/inc/index.jsp">炼铁作业部设备动态管理系统   </a></li>
                                                <li><a target="_blank" href="http://10.3.198.190:8888/scmltfc/inc/index.jsp">炼钢作业部设备动态管理系统  </a></li>
												<li><a target="_blank" href="http://10.3.153.20:8888/scmrzfc/inc/index.jsp">热轧作业部动态管理系统  </a></li>
												<li><a target="_blank" href="http://10.3.50.43:8080/qgbb/">炼钢作业部设备功能精密度管理系统 </a></li>
                               
                                          </ul>
                                    </div>
                                    <div class="site-count site-count1">
                                          <h2>其他系统</h2>
                                          <ul class="site-list clearfix">
                                                <li><a target="_blank" href="http://10.3.247.142:8003/itsm_app/">ITSM运维管理系统  </a></li>
                                                <li><a target="_blank" href="http://10.3.250.138/login.aspx">生产用车管理系统   </a></li>
												<li><a target="_blank" href="http://10.3.247.143:8066/">年度绩效测评系统   </a></li>
												<li><a target="_blank" href="http://10.1.250.85/loginindex.do">首钢人力资源管理系统   </a></li>
												<li><a target="_blank" href="http://10.3.250.129/sgqghr/login.aspx">迁钢人力资源管理系统   </a></li>
												<li><a target="_blank" href="http://10.3.250.245:8080/wzjl/">物资计量系统   </a></li>
												<li><a target="_blank" href="http://time.sgqg.com/NTPManger/index.jsp">时间同步系统   </a></li>
												<li><a target="_blank" href="http://10.3.250.239:7001/itms-app/login.jsp">IT运行管理系统   </a></li>
												<li><a target="_blank" href="http://10.3.21.55:8090/">能源二级基础能源管理系统   </a></li>
												<li><a target="_blank" href="http://10.3.129.3:7001/mes-wzjl-app/login.jsp">无人值守计量系统   </a></li>
												<li><a target="_blank" href="http://bim.shougang.com.cn/bim-webui/">首钢统一用户管理平台   </a></li>
                                               
                                          
                                          </ul>
                                    </div>
                                    <div class="site-count site-count1">
                                          <h2>首钢集团上网单位</h2>
                                          <ul class="site-list clearfix">
                                               <li><a target="_blank" href="http://www.shougang.com.cn/sgweb/html/index.html">首钢总公司   </a></li>
											   <li><a target="_blank" href="http://bjdnserror1.wo.com.cn:8080/html/index.html">首钢设计院   </a></li>
											   <li><a target="_blank" href="http://www.sggf.com.cn/">首钢股份公司   </a></li>
											   <li><a target="_blank" href="http://www.zs.com.cn/cn/index.asp">中首公司   </a></li>
											   <li><a target="_blank" href="http://www.sgtraining.net/">首钢党校   </a></li>
											   <li><a target="_blank" href="http://www.sgzy.com.cn/">首钢工会   </a></li>
											   <li><a target="_blank" href="http://www.sgpx.com.cn/sgstudyonline/MainPage/index.aspx">首钢职工在线学习网   </a></li>
											   <li><a target="_blank" href="http://www.sgjx.com.cn/">首钢高级技工学校网   </a></li>
											   <li><a target="_blank" href="http://www.sgyy.com.cn/">首钢总医院   </a></li>
											   <li><a target="_blank" href="http://www.sqsteel.com.cn/">首秦金属材料有限公司   </a></li>
											   <li><a target="_blank" href="http://www.sgjtsteel.com/portal/">首钢京唐钢铁联合有限责任公司   </a></li>
                                                
                                          </ul>
                                    </div>
                                    <div class="site-count site-count1" style="border:0 none">
                                          <h2>世界知名钢铁公司</h2>
                                          <ul class="site-list clearfix">
                                                <li><a target="_blank" href="http://www.arcelormittalna.com/">英国米塔尔公司   </a></li>
												<li><a target="_blank" href="http://www.ussteel.com/corp/index.htm">美国钢铁公司   </a></li>
												<li><a target="_blank" href="http://www.tatasteeleurope.com/en/">英国克鲁斯集团   </a></li>
												<li><a target="_blank" href="http://www.thyssenkrupp.com/">德国蒂森克虏伯集团   </a></li>
												<li><a target="_blank" href="http://www.csc.com.tw/index.html">台湾中钢公司   </a></li>
												<li><a target="_blank" href="http://www.arcelormittal.com/">法国阿塞洛公司   </a></li>
												<li><a target="_blank" href="http://www.nsc.co.jp/">日本新日铁   </a></li>
												<li><a target="_blank" href="http://www.jfe-steel.co.jp/">日本JFE钢铁   </a></li>
												<li><a target="_blank" href="http://www.baosteel.com/group/index.html">中国宝钢集团   </a></li>
												<li><a target="_blank" href="http://www.nucor.com/">美国纽柯钢铁公司   </a></li>
                                          </ul>
                                    </div>
                            </div>
					 </div>
			  </div>
           </li>  
           <li class="t6">
              <a href="javascript:void(0)">
				 <em></em>
				 <span>在线人数</span>
              </a>
               <div class="wh-hd-group-num wh-hd-box-shadow" >
						<span class="s-point"><em></em></span>
                        <div class="wh-hd-group-a clearfix"><a href="#" class="fl"  onclick="openInnerUser();return false;"><%=Resource.getValue(local,"common","comm.allusers")%><i class="fa fa-user fa-color"></i></a></div>
                        <div class="wh-hd-group-a clearfix"><a href="#" class="fl" onclick="openUserList();return false;"><%=Resource.getValue(local,"common","comm.currentin")%><i class="fa fa-angle-right"></i></a></div>
               </div>
            </li>

            <li class="t5">
               <!-- <a href="javascript:void(0)" onClick="openHelp();">-->
			    <a href="/defaultroot/help/help_set.html"  target="_blank">
                    <em></em>
                    <span>帮助</span>
                </a>
             </li>
        </ul>
    </div>
 </div>
   <div class="wh-header">
		
        <div class="wh-container clearfix"  id="desktop_container_div"> 
			<!-- <a href="#" class="wh-logo" style="background-image: url('<%=logoFile%>')"></a> --> 
		    <a href="#" class="wh-logo" id="desktop_logo_a"><img src="<%=logoFile%>" alt=""  id="desktop_logoFileImage"  data-pich="50" /></a>
			<%@ include file="/public/desktop/include_desktop_menu.jsp"%>   
		    <ul class="wh-hd-r-nav clearfix" id="desktop_right_ul">
                <li style="display:none;">
                    <a href="javascript:void(0)" class="wh-hd-user-info"  onclick="chooseDefaultMyLayout(); return false;" ><img src="<%=_userImage_small%>" alt=""/></a>
                    <div class="wh-hd-user-detail wh-hd-box-shadow" >
						<span class="s-point"><em></em></span>
                        <div class="wh-hd-user-welcome">
                            <p class="wh-hd-user-welcome-title clearfix">
                                <a href="#"><img src="<%=_userImage_small%>" alt="#" onclick="modiMyPhoto(); return false;"/></a>
                                <a href="javascript:void(0)"  onclick="modiMyInfo(); return false;"  class="wel-p-info" title="<%=Resource.getValue(local,"common","comm.myinfos")%>"><%=Resource.getValue(local,"common","comm.myinfos")%><!--个人资料--></a>
                                <span>|</span>
                                <!-- <a href="javascript:void(0)"  class="wh-hd-user-center welcomea wh-hd-user-faclick"><span onclick="chooseDefaultMyLayout(); return false;" title="<%=Resource.getValue(local,"common","comm.mylayout")%>"><%=Resource.getValue(local,"common","comm.mylayout")%></span> <i class="fa fa-angle-right"></i></a> --> 
								<a href="javascript:void(0)" title="<%=Resource.getValue(local,"common","comm.peels")%>" class="wh-sys-setting-skin-change welcome-skin-btn"  onclick="modiMySkinSC();return false;"><i class="fa fa-skin fa-color"></i></a> 
                                <a href="javascript:void(0)" title="<%=Resource.getValue(local,"common","comm.help")%>" class="welcome-help-btn" onClick="openHelp();"><i class="fa fa-info-circle fa-color"></i></a> 
                            </p>
                            <a href="javascript:void(0)" class="welcomea"><span title="<%=Resource.getValue(local,"common","comm.welcomeyou")%>"><%=Resource.getValue(local,"common","comm.welcomeyou")%><!-- 欢迎您 --></span>：<em title="<%=session.getAttribute("userName")%>"><%=session.getAttribute("userName")%></em></a>
                            <!--<i class="fa fa-circle-o"></i>-->
                            <a href="javascript:void(0)" class="wh-hd-user-click-change welcomea wh-hd-user-faclick"><span title="<%=Resource.getValue(local,"common","comm.status")%>"><%=Resource.getValue(local,"common","comm.status")%><!-- 状态 --></span>：<em id="">上班</em><i class="fa fa-angle-right"></i></a>
                            <a href="javascript:void(0)" class="wh-hd-group-click-change wh-hd-user-click-change welcomea wh-hd-user-faclick"><span title="<%=Resource.getValue(local,"common","comm.orgnization")%>"><%=Resource.getValue(local,"common","comm.orgnization")%><!-- 组织 --></span>：<em id="currentOrgName-old" title="<%=orgSimpleName%>"><%=orgSimpleName%></em><i class="fa fa-angle-right"></i></a>
							<input type="hidden" name="gggggggg" value="<%=whir_pageFontSize%>">
							<%
							String smallClass="";
							String bigClass="";
							//字号大小
							if(whir_pageFontSize.equals("14")){
								smallClass=" noselect";
							}else{
								bigClass=" noselect";
							}  
							%>
							<a href="javascript:void(0)" class="wh-hd-font-click-change welcomea"><span title="<%=Resource.getValue(local,"common","comm.pageFontsize")%>"><%=Resource.getValue(local,"common","comm.pageFontsize")%></span>：<em class="wh-font-small<%=smallClass%>" onclick="updatePagaFontSize('12')" title="12">-A</em><em class="wh-font-big<%=bigClass%>" onclick="updatePagaFontSize('14')"  title="14">+A</em></a>
							<div class="wh-hd-statecontainer">
								<div class="wh-hd-user-state wh-hd-state" id="destop_user_state_div">  
								</div>
							</div>
							<div class="wh-hd-statecontainer">
								<div class="wh-hd-group-state wh-hd-state">
								<input type="hidden" id="curOrgId" name="curOrgId" value="<%=orgId%>">
							   <%
								for(int m=0; m<allOrgList.size(); m++){
									Object[] objSideOrg = (Object[])allOrgList.get(m);
									String _objSideOrg_name = (String)objSideOrg[3];
									if(_objSideOrg_name.length()>10){
										_objSideOrg_name = _objSideOrg_name.substring(0, 9) + "...";
									}
									String org_class="";
									if(orgId.equals(objSideOrg[0]+"")){
										org_class="class=\"current\"";
									}
								%> 
									 <a href="javascript:void(0)" <%=org_class%> onClick="changeCurOrg('<%=objSideOrg[0]%>','<%=objSideOrg[1]%>','<%=objSideOrg[2]%>','<%=objSideOrg[3]%>','<%=objSideOrg[4]%>',this);"><span title="<%=objSideOrg[3]%>"><%=_objSideOrg_name%></span><i class="fa"></i></a>
								<%}%> 
								</div>
							</div>
                        </div>
                        <!--div class="wh-hd-center-state wh-hd-state"> 
						
                        </div-->
				
                    </div>
                </li>
                 <!-- title="<%=Resource.getValue(local,"common","comm.create")%>" -->
				<li class="wh-sys-quickset" style="display:none;">
					<a href="javascript:void(0);" class="wh-r-nav-a" >
						<i class="fa fa-plus fa-color"></i>
					</a>
					<div class="wh-sys-quicksetting-list wh-hd-box-shadow">
						<span class="s-point"><em></em></span>
						<div>  
						    <%if(!__isnoright){%>
							 <p><i class="fa fa-envelope"></i><a href="#" title="<%=Resource.getValue(local,"common","comm.mail")%>" onClick="javascript:openWin({url:'<%=rootPath%>/innerMail!openAddMail.action',isFull:true,winName:'newMail'});">站内信</a></p>
							 <p><i class="fa fa-envelope"></i><a href="#" title="<%=Resource.getValue(local,"common","comm.mail")%>" onClick="javascript:window.open('<%=WriteURL%>','','');	">写邮件</a></p> 
							 <p><i class="fa fa-step-pre fa-color"></i><a href="#" title="信息发布" onClick="javascript:openWin({url:'<%=rootPath%>/Information!add.action?channelType=0&userChannelName=信息管理&userDefine=0',isFull:true,winName:'newinfo'});">信息发布</a> </p>
							 <!--<p><i class="fa fa-pencil"></i><a href="#"  title="<%=Resource.getValue(local,"common","comm.worklog")%>"onClick="javascript:openWin({url:'<%=rootPath%>/WorkLogAction!addMyWorkLog.action',isFull:true,winName:'worklog'});"><%=Resource.getValue(local,"common","comm.worklog")%></a> </p>
							 <p><i class="fa fa-work-rep"></i><a href="#" title="<%=Resource.getValue(local,"common","comm.workreport")%>" onClick="javascript:openWin({url:'<%=rootPath%>/WorkReportAction!addWorkReport.action?isFromDesktop=1&reportType=week',isFull:true,winName:'workreport'});"><%=Resource.getValue(local,"common","comm.workreport")%></a> </p>
							 <p><i class="fa fa-attendance-mana"></i><a href="#" title="<%=Resource.getValue(local,"common","comm.schedule")%>" onClick="javascript:openWin({url:'<%=rootPath%>/EventAction!addMyEvent.action?flagChangeEventType=1',isFull:true,winName:'taskcenter'});"><%=Resource.getValue(local,"common","comm.schedule")%></a> </p>
								-->	
							<%//hw 2017-1-2 modify
							if(showCreateMeetingNoteMenu(session.getAttribute("orgId")+"")){%>
							<p><i class="fa fa-attendance-mana"></i><a href="#" title="会议通知" onClick="javascript:openWin({url:'<%=rootPath%>/EzFormMantence!addCustomMantence.action?menuId=104270&formId=104227&moduleType=customizeAdd&trigSettingId=-1',isFull:true,winName:'taskcenter'});">会议通知</a> </p>
							<%}%>
							 <%}%>
					   </div>
				</li>

                <li <%=norhidehide%>>
                    <a href="#" class="wh-r-nav-a"><i class="fa fa-search fa-color" ></i></a>
                    <div class="wh-hd-search wh-hd-box-shadow" >
						<span class="s-point"><em></em></span>
                        <div class="wh-sys-notice-list-form">
                            <input type="text" class="wh-hd-search-text" id="searchKey" name="searchKey" />
							<input type="hidden" name="searchType" id="searchType" value="info">
                            <div class="wh-hd-search-box open">
								<div class="clearfix">
									<a href="javascript:void(0);" class="fa wh-hd-search-info" style="display:none"><em id="searchType_span"><%=Resource.getValue(local,"common","comm.information1")%></em><i class="fa fa-angle-right"></i> </a><input type="button" class="wh-hd-search-btn" value="<%=Resource.getValue(local,"common","comm.search")%>" onclick="ezLuceneSearch();"/>
								</div>
								
								<div class="wh-hd-user-seachcontainer">
									<div class="wh-hd-user-state wh-hd-state wh-hd-user-search-list">
										<a href="javascript:void(0)" class="current" onclick="changeSearchType('info','<%=Resource.getValue(local,"common","comm.information1")%>',this);"><span title="<%=Resource.getValue(local,"common","comm.information1")%>"><i class="fa"></i>&nbsp;<%=Resource.getValue(local,"common","comm.information1")%><!-- 信息 --></span></a>
										<a href="javascript:void(0)" onclick="changeSearchType('filedeal','<%=Resource.getValue(local,"filetransact","file.luceneWorkFlow")%>',this);"><span  title="<%=Resource.getValue(local,"filetransact","file.luceneWorkFlow")%>"><i class="fa"></i>&nbsp;<%=Resource.getValue(local,"filetransact","file.luceneWorkFlow")%><!-- 文件办理 --></span></a>
										<a href="javascript:void(0)" onclick="changeSearchType('sendfile','<%=Resource.getValue(local,"common","comm.sendfile1")%>',this);"><span title="<%=Resource.getValue(local,"common","comm.sendfile1")%>"><i class="fa"></i>&nbsp;<%=Resource.getValue(local,"common","comm.sendfile1")%><!-- 发文 --></span></a>
										<a href="javascript:void(0)" onclick="changeSearchType('receivefile','<%=Resource.getValue(local,"common","comm.receivefile1")%>',this);"><span title="<%=Resource.getValue(local,"common","comm.receivefile1")%>"><i class="fa"></i>&nbsp;<%=Resource.getValue(local,"common","comm.receivefile1")%><!-- 收文 --></span></a>
										<a href="javascript:void(0)" onclick="changeSearchType('govcheck','文件传递',this);"><span title="文件传递"><i class="fa"></i>&nbsp;文件传递<!-- 送审 --></span></a>
										<a href="javascript:void(0)" onclick="changeSearchType('forum','问题反馈',this);"><span title="问题反馈"><i class="fa"></i>&nbsp;问题反馈<!-- 论坛 --></span></a>
										
										<a href="javascript:void(0)" onclick="changeSearchType('mail','站内信',this);"><span title="站内信"><i class="fa"></i>&nbsp;站内信<!-- 邮件 --></span></a>

									</div>
								</div>
								
							</div>

                        </div>
                    </div>
                </li>
                <li class="wh-sys-setting-dialog-click"   style="display:none;">
                    <span class="wh-sys-warn-pos"  id="desktop_all_remindNum_span"></span>
                    <a href="javascript:void(0);" class="wh-r-nav-a wh-sys-sdc" id="desktop_all_remindNum_a">
                        <i class="fa fa-bell fa-color"></i>
                    </a>
                    <div class="wh-sys-notice-list wh-hd-box-shadow">
						<span class="s-point"><em></em></span>
                        <div id="desktop_remindModule1_div">
                            <p remindModule="waitFile"  <%=_remindShow1%>><i class="fa fa-pencil-square-o"></i><a href="#" onclick="jumpnew('platform/bpm/bpm_menu.jsp?expNodeCode=myWatingDeal','wfdealwith!dealwithList.action?openType=waitingDeal&noTreatment=0');"
							 title="<%=Resource.getValue(local,"common","comm.docWaitForProcess")%>"><%=Resource.getValue(local,"common","comm.docWaitForProcess")%><!--待办文件--></a><span>(0)</span></p>
						    <p remindModule="waitJTFile"  <%=_remindShow11%>><i class="fa fa-pencil-square-o"></i><a href="#" onclick="javascript:jumpnew('<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/platform/bpm/bpm_menu_transcenter.jsp%3FexpNodeCode=myWatingDeal','<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/wfdealwith!dealwithList.action%3FopenType=waitingDeal%26noTreatment=0');"
							 title="<%=Resource.getValue(local,"common","comm.docWaitForProcess")%>"><%=Resource.getValue(local,"common","comm.docWaitForProcess")%>(集团)<!--待办文件--></a><span>(0)</span></p>
							<p remindModule="waitRead" <%=_remindShow2%>><i class="fa fa-receiving-doc"></i><a href="#" onclick="jumpnew('platform/bpm/bpm_menu.jsp?expNodeCode=myWatingRead','wfdealwith!dealwithList.action?openType=waitingRead&noTreatment=0');"  title="<%=Resource.getValue(local,"common","comm.docWaitForReview")%>"><%=Resource.getValue(local,"common","comm.docWaitForReview")%></a><span>(0)</span></p>
							<p remindModule="waitReadJT" <%=_remindShow55%>><i class="fa fa-receiving-doc"></i><a href="#" onclick="javascript:jumpnew('<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=workflow&reurl=<%=rootPath%>/platform/bpm/bpm_menu_transcenter.jsp%3FstatusType%3D1%26fouce%3DwaitingRead','<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=workflow&reurl=<%=rootPath%>/wfdealwith!dealwithList.action%3FopenType%3DwaitingRead');"
							 title="<%=Resource.getValue(local,"common","comm.docWaitForReview")%>"><%=Resource.getValue(local,"common","comm.docWaitForReview")%>(集团)<!--待阅文件--></a><span>(0)</span></p>
						   <p remindModule="matureFile" <%=_remindShow3%>><i class="fa fa-inbox"></i><a href="#"  onclick="javascript:jumpnew('/defaultroot/GovDoc!menu.action?expNodeCode=notRead','/defaultroot/GovRecvDocSet!notRead.action');"  title="<%=Resource.getValue(local,"common","comm.newgovdocumentfile")%>" ><%=Resource.getValue(local,"common","comm.newgovdocumentfile")%><!-- 新收文 --></a><span>(0)</span> </p>
							<p remindModule="matureJTFile" <%=_remindShow33%>><i class="fa fa-inbox"></i><a href="#"  onclick="javascript:jumpnew('<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/GovDoc!menu.action%3FexpNodeCode=notRead','<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/GovRecvDocSet!notRead.action');"  title="<%=Resource.getValue(local,"common","comm.newgovdocumentfile")%>" ><%=Resource.getValue(local,"common","comm.newgovdocumentfile")%>(集团)<!-- 新收文 --></a><span>(0)</span> </p>
                            <p remindModule="newMail" <%=_remindShow4%>><i class="fa fa-envelope"></i><a href="#" onclick="javascript:jumpnew('/defaultroot/innerMail!innermailMenu.action?expNodeCode=mymail','/defaultroot/innerMail!notreadMailList.action');"  title="<%=Resource.getValue(local,"common","comm.newemail")%>">站内信<!--新邮件--></a><span>(0)</span></p>
							<p remindModule="newJTMail" <%=_remindShow44%>><i class="fa fa-envelope"></i><a href="#" onclick="javascript:jumpnew('<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/innerMail!innermailMenu.action%3FexpNodeCode=mymail','<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/innerMail!notreadMailList.action');"  title="<%=Resource.getValue(local,"common","comm.newemail")%>">站内信(集团)<!--新邮件--></a><span>(0)</span></p> 
  							<!--<p remindModule="newMail" <%=_remindShow4%>><i class="fa fa-envelope"></i><a href="#" onclick="javascript:window.open('<%=ssoURL_coremail%>','','');"  title="<%=Resource.getValue(local,"common","comm.newemail")%>"><%=Resource.getValue(local,"common","comm.newemail")%></a><span>(0)</span></p>-->
							<p remindModule="newTask" <%=_remindShow5%>><i class="fa fa-flag"></i><a href="#"  onclick="javascript:jumpnew('/defaultroot/modules/personal/personal_menu.jsp?expNodeCode=newTask','/defaultroot/taskCenter!selectPrincipalTask.action');" title="<%=Resource.getValue(local,"common","comm.newtask")%>"><%=Resource.getValue(local,"common","comm.newtask")%><!--新任务--></a><span>(0)</span></p>
							
							<p remindModule="newEvent" <%=_remindShow6%>><i class="fa fa-comment"></i><a href="#" onclick="javascript:jumpnew('/defaultroot/modules/personal/personal_menu.jsp?expNodeCode=newEvent','/defaultroot/EventAction!eventList.action?menuType=mine');" title="<%=Resource.getValue(local,"common","comm.newevent")%>"><%=Resource.getValue(local,"common","comm.newevent")%><!--新事件--></a><span>(0)</span></p>
							<p remindModule="newPress" <%=_remindShow7%>><i class="fa fa-clock-o"></i><a href="#" onclick="javascript:jumpnew('/defaultroot/modules/personal/personal_menu.jsp?expNodeCode=pressdeal','/defaultroot/PressManageAction!receivePressList.action');" title="<%=Resource.getValue(local,"common","comm.newpress")%>"><%=Resource.getValue(local,"common","comm.newpress")%><!--新催办--></a><span>(0)</span></p> 
							<p remindModule="newContract" <%=_remindShow8%>><i class="fa fa-contract-mana"></i><a href="#" onclick="javascript:jumpnew('/defaultroot/subsidiaryMenu!toSubsidiaryMenu.action?expNodeCode=contract','/defaultroot/contract!reminderList.action');" title="<%=Resource.getValue(local,"common","comm.newhetong")%>"><%=Resource.getValue(local,"common","comm.newhetong")%><!--合同提醒--></a><span>(0)</span></p> 
							<p remindModule="newWord" <%=_remindShow9%>><i class="fa fa-short-mes"></i><a href="#" onclick="javascript:jumpnew('/defaultroot/platform/bpm/bpm_menu.jsp?expNodeCode=newWord','/defaultroot/wfdealwith!flowMessageList.action');" title="<%=Resource.getValue(local,"common","comm.newWord")%>"><%=Resource.getValue(local,"common","comm.newWord")%><!--新留言--></a><span>(0)</span></p> 							
							<p remindModule="coremail" <%=_remindShow10%>><i class="fa fa-envelope"></i><a href="#" onclick="javascript:window.open('<%=sjxURL%>','','');" title="CoreMail">新邮件<!--CoreMail--></a><span>(0)</span></p>							
                        </div>
                    </div>
                </li>
                <li><a href="#" class="wh-r-nav-a" onclick="jumpnew('ChannelMenu!menu.action?channelType=0&userChannelName=信息管理&userDefine=0','InfoList!allList.action?type=all&channelType=0&userChannelName=信息管理&userDefine=0');return false;"><i class="fa fa-file-text fa-color"></i></a></li>
                <li><a href="#" class="wh-r-nav-a" title="<%=Resource.getValue(local,"common","comm.saftlogout")%>" onClick="delSSOCookie();return false;" ><i class="fa fa-power-off fa-color"></i></a></li>
            </ul>
        </div>
		

        <div style="position: absolute; top: 0; right: 10px; "> 
        </div>
    </div>
 <div class="perbox-a">
	<div class="perbox">
    <div class="wh-personal-card-content pro-user-info">
     <a><img src="<%=_userImage_small%>" alt=""/></a>
      <div class="user-info">
        <strong>
          <%=session.getAttribute("userName")%>
        </strong>
    
        <i class="click-info fa fa-angle-down"></i>

        <p class="date"><%=dateStr%> &nbsp; <em><%=week%>&nbsp; <span id="timeStr"></span></em></p>
        <p class="day"></p>
           <div class="wh-hd-user-detail wh-personal-card-state  wh-hd-box-shadow" >
          <div class="title title1 clearfix"><span class="fl"><em id="desktop_userstatus_em">上班</em></span><a href="#" onclick="setStateHtmNew();"><i class="fr fa fa-angle-down"></i></a></div>
           <div class="per-wh-hd-user-state" >
               <div id="destop_user_state_div_new">
                     
                </div>
           </div>
              <div class="title title1 clearfix"><span class="fl"><em id="currentOrgName" title="<%=orgSimpleName%>"><%=orgSimpleName%></em></span><i class="fr fa fa-angle-down"></i></div>
                   <div class="per-wh-hd-user-state icons" >
				   <div class="wh-hd-statecontainer">
						<div class="wh-hd-group-state wh-hd-state">
								<input type="hidden" id="curOrgId" name="curOrgId" value="<%=orgId%>">
							   <%
								for(int m=0; m<allOrgList.size(); m++){
									Object[] objSideOrg = (Object[])allOrgList.get(m);
									String _objSideOrg_name = (String)objSideOrg[3];
									if(_objSideOrg_name.length()>10){
										_objSideOrg_name = _objSideOrg_name.substring(0, 9) + "...";
									}
									String org_class="";
									if(orgId.equals(objSideOrg[0]+"")){
										org_class="class=\"current\"";
									}
								%> 
									 <a href="javascript:void(0)" <%=org_class%> onClick="changeCurOrg('<%=objSideOrg[0]%>','<%=objSideOrg[1]%>','<%=objSideOrg[2]%>','<%=objSideOrg[3]%>','<%=objSideOrg[4]%>',this);"><span title="<%=objSideOrg[3]%>"><%=_objSideOrg_name%></span><i class="fa"></i></a>
								<%}%> 
						</div>
					</div>
				</div>
           <div class="set">
               <div>
				   <a href="#" onclick="jumpnew('/modules/personal/personal_menu.jsp','/MyInfoAction!modiMyInfo.action');">个人设置</a>
                   <a href="#" onclick="jumpnew('/modules/personal/personal_menu.jsp','/MyInfoAction!modiMyPassword.action');">密码设置</a>
                   </div>
           </div>
        </div>

      </div>


    </div>

   <div class="quick-link clearfix" id="desktop_remindmodule_div_new">
   <ul class="clearfix" >
       <li>
           <a>
               <i class="i1"></i>
               我的发起
           </a>
		   <div class="s-dropdown">
          <span class="s-point"><em></em></span>
          <div>
            <%if(!__isnoright){%>
				<p><i class="fa fa-envelope"></i><a href="#" title="<%=Resource.getValue(local,"common","comm.mail")%>" onClick="javascript:openWin({url:'<%=rootPath%>/innerMail!openAddMail.action',isFull:true,winName:'newMail'});">站内信</a></p>
				<p><i class="fa fa-envelope"></i><a href="#" title="<%=Resource.getValue(local,"common","comm.mail")%>" onClick="javascript:window.open('<%=WriteURL%>','','');	">写邮件</a></p> 
				<p><i class="fa fa-step-pre fa-color"></i><a href="#" title="信息发布" onClick="javascript:openWin({url:'<%=rootPath%>/Information!add.action?channelType=0&userChannelName=信息管理&userDefine=0',isFull:true,winName:'newinfo'});">信息发布</a> </p>
				<%//hw 2017-1-2 modify
				if(showCreateMeetingNoteMenu(session.getAttribute("orgId")+"")){%>
				<p><i class="fa fa-attendance-mana"></i><a href="#" title="会议通知" onClick="javascript:openWin({url:'<%=rootPath%>/EzFormMantence!addCustomMantence.action?menuId=104270&formId=104227&moduleType=customizeAdd&trigSettingId=-1',isFull:true,winName:'taskcenter'});">会议通知</a> </p>
				<%}%>
			 <%}%>
          </div>
        </div>
       </li>
        <li style="display:none;">
           <a>
               <i class="i2"></i>
               我的日程
           </a>
           <div class="s-dropdown">
          <span class="s-point"><em></em></span>
          <div>
            <p><a href="" title="If u want to say loving me, just tell me now.">If u want to say loving me, just tell me now.</a><span>(6)</span> </p>
            <p><a href="">新邮件</a><span>(0)</span> </p>
            <p><a href="">新收文</a><span>(1)</span> </p>
          </div>
        </div>
       </li>
        <li>
           <a>
               <i class="i3"><span id="allwaitNums">0</span></i>
               我的流程
           </a>
		    <div class="s-dropdown">
			<span class="s-point"><em></em></span>
		   <div>
		   <p remindModule="waitFile"  <%=_remindShow1%>><i class="fa fa-pencil-square-o"></i><a href="#" onclick="jumpnew('platform/bpm/bpm_menu.jsp?expNodeCode=myWatingDeal','wfdealwith!dealwithList.action?openType=waitingDeal&noTreatment=0');"
							 title="<%=Resource.getValue(local,"common","comm.docWaitForProcess")%>"><%=Resource.getValue(local,"common","comm.docWaitForProcess")%><!--待办文件--></a><span>(0)</span></p>
			<p remindModule="waitJTFile"  <%=_remindShow11%>><i class="fa fa-pencil-square-o"></i><a href="#" onclick="javascript:jumpnew('<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/platform/bpm/bpm_menu_transcenter.jsp%3FexpNodeCode=myWatingDeal','<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/wfdealwith!dealwithList.action%3FopenType=waitingDeal%26noTreatment=0');"
							 title="<%=Resource.getValue(local,"common","comm.docWaitForProcess")%>"><%=Resource.getValue(local,"common","comm.docWaitForProcess")%>(集团)<!--待办文件--></a><span>(0)</span></p>
			<p remindModule="waitRead" <%=_remindShow2%>><i class="fa fa-receiving-doc"></i><a href="#" onclick="jumpnew('platform/bpm/bpm_menu.jsp?expNodeCode=myWatingRead','wfdealwith!dealwithList.action?openType=waitingRead&noTreatment=0');"  title="<%=Resource.getValue(local,"common","comm.docWaitForReview")%>"><%=Resource.getValue(local,"common","comm.docWaitForReview")%></a><span>(0)</span></p>
			<p remindModule="waitReadJT" <%=_remindShow55%>><i class="fa fa-receiving-doc"></i><a href="#" onclick="javascript:jumpnew('<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=workflow&reurl=<%=rootPath%>/platform/bpm/bpm_menu_transcenter.jsp%3FstatusType%3D1%26fouce%3DwaitingRead','<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=workflow&reurl=<%=rootPath%>/wfdealwith!dealwithList.action%3FopenType%3DwaitingRead');"
							 title="<%=Resource.getValue(local,"common","comm.docWaitForReview")%>"><%=Resource.getValue(local,"common","comm.docWaitForReview")%>(集团)<!--待阅文件--></a><span>(0)</span></p>
			<p remindModule="matureFile" <%=_remindShow3%>><i class="fa fa-inbox"></i><a href="#"  onclick="javascript:jumpnew('/defaultroot/GovDoc!menu.action?expNodeCode=notRead','/defaultroot/GovRecvDocSet!notRead.action');"  title="<%=Resource.getValue(local,"common","comm.newgovdocumentfile")%>" ><%=Resource.getValue(local,"common","comm.newgovdocumentfile")%><!-- 新收文 --></a><span>(0)</span> </p>
			<p remindModule="matureJTFile" <%=_remindShow33%>><i class="fa fa-inbox"></i><a href="#"  onclick="javascript:jumpnew('<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/GovDoc!menu.action%3FexpNodeCode=notRead','<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/GovRecvDocSet!notRead.action');"  title="<%=Resource.getValue(local,"common","comm.newgovdocumentfile")%>" ><%=Resource.getValue(local,"common","comm.newgovdocumentfile")%>(集团)<!-- 新收文 --></a><span>(0)</span> </p>
		   </div>
		   <div>
       </li>
        <li style="display:none;">
           <a>
               <i class="i4"></i>
               我的任务
           </a>
       </li>
        <li style="display:none;">
           <a>
               <i class="i5"></i>
               我的会议
           </a>
       </li>

        <li>
           <a href="#" onclick="javascript:window.open('<%=sjxURL%>','','');" title="CoreMail">
              <i class="i6"><span id="coremailNums">0</span></i>
                我的邮件
           </a>
       </li>
        <li>
           <a href="#" onclick="javascript:jumpnew('/defaultroot/innerMail!innermailMenu.action?expNodeCode=mymail','/defaultroot/innerMail!notreadMailList.action');"  title="<%=Resource.getValue(local,"common","comm.newemail")%>">
               <i class="i7"><span id="mailNums">0</span></i>
               站内信
           </a>
		   <div class="s-dropdown">
		   <span class="s-point"><em></em></span>
		   <div>
				 <p remindModule="newMail" <%=_remindShow4%>><i class="fa fa-envelope"></i><a href="#" onclick="javascript:jumpnew('/defaultroot/innerMail!innermailMenu.action?expNodeCode=mymail','/defaultroot/innerMail!notreadMailList.action');"  title="<%=Resource.getValue(local,"common","comm.newemail")%>">站内信<!--新邮件--></a><span>(0)</span></p>
				<p remindModule="newJTMail" <%=_remindShow44%>><i class="fa fa-envelope"></i><a href="#" onclick="javascript:jumpnew('<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/innerMail!innermailMenu.action%3FexpNodeCode=mymail','<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/innerMail!notreadMailList.action');"  title="<%=Resource.getValue(local,"common","comm.newemail")%>">站内信(集团)<!--新邮件--></a><span>(0)</span></p> 
		   </div>
		   </div>
       </li>
        <li style="display:none;">
           <a>
               <i class="i8"></i>
               我的文档
           </a>
       </li>
	   </ul>
     </div>
  
  </div>
</div>
    <!--container -->
	<div id="desktop_leftContainer" class="wh-content">
	  <span id="switchShow" class="btn-switch-show"><i class="fa fa-caret-right"></i><i class="fa fa-caret-left"></i></span>
	  <div id="desktop_leftTh"	class="wh-l-content" switch-tip="true">
		<div id="leftMenuDiv" class="wh-left-menuList">
		  <%//左侧树内容  %>
		</div>
	  </div>
	  <!-- "../platform/portal/information.shtml" -->
	  <div class="wh-r-content wh-r-iframe wh-ios-iframe-bug">
		<iframe src="" allowtransparency="transparent" scrolling="auto" class="wh-portal" width="100%" height="100%" marginheight="0" marginwidth="0" frameborder="0" id="mainFrame" name="mainFrame" ></iframe> 
        <div class="wh-view view-lists" id="mainDIV" name="mainDIV"></div>
	  </div>
    </div>



    <!--提醒事项-->
    <div class="wh-sys-setting-dialog" style="display: none">
        <div class="wh-sys-notice wh-sys-notice-list-setting">
            <div class="setting-contents clearfix" id="desktop_remindmodule_div">
				<div remindModule="waitFile" <%=_remindShow1%> onclick="jumpnew('platform/bpm/bpm_menu.jsp?expNodeCode=myWatingDeal','wfdealwith!dealwithList.action?openType=waitingDeal&noTreatment=0');closeRemindEdit();" >
                    <i class="fa fa-pencil-square-o">&#xf060;</i>
					<span>0</span>
                    <p title="<%=Resource.getValue(local,"common","comm.docWaitForProcess")%>"><%=Resource.getValue(local,"common","comm.docWaitForProcess")%></p> 
                </div>
				<div remindModule="waitJTFile" style="display:none;" <%=_remindShow11%> onclick="javascript:jumpnew('<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/platform/bpm/bpm_menu_transcenter.jsp%3FexpNodeCode=myWatingDeal','<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/wfdealwith!dealwithList.action%3FopenType=waitingDeal%26noTreatment=0');closeRemindEdit();" >
                    <i class="fa fa-pencil-square-o">&#xf060;</i>
					<span>0</span>
                    <p title="<%=Resource.getValue(local,"common","comm.docWaitForProcess")%>"><%=Resource.getValue(local,"common","comm.docWaitForProcess")%>(集团)</p> 
                </div> 
                <div remindModule="waitRead" <%=_remindShow2%>  onclick="jumpnew('platform/bpm/bpm_menu.jsp?expNodeCode=myWatingRead','wfdealwith!dealwithList.action?openType=waitingRead&noTreatment=0');closeRemindEdit();">
                    <i class="fa fa-receiving-doc">&#xf06a;</i>
					<span>0</span>
                    <p title="<%=Resource.getValue(local,"common","comm.docWaitForReview")%>"><%=Resource.getValue(local,"common","comm.docWaitForReview")%></p> 
                </div>
                <div remindModule="matureFile" <%=_remindShow3%>   onclick="javascript:jumpnew('/defaultroot/GovDoc!menu.action?expNodeCode=notRead','/defaultroot/GovRecvDocSet!notRead.action');closeRemindEdit();">
                    <i class="fa fa-inbox">&#xf077;</i>
					<span>0</span>
                    <p title="<%=Resource.getValue(local,"common","comm.newgovdocumentfile")%>"><%=Resource.getValue(local,"common","comm.newgovdocumentfile")%></p> 
                </div>
			     <div remindModule="matureJTFile" style="display:none;" <%=_remindShow33%>   onclick="javascript:jumpnew('<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/GovDoc!menu.action%3FexpNodeCode=notRead','<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/GovRecvDocSet!notRead.action');closeRemindEdit();">
                    <i class="fa fa-inbox">&#xf077;</i>
					<span>0</span>
                    <p title="<%=Resource.getValue(local,"common","comm.newgovdocumentfile")%>"><%=Resource.getValue(local,"common","comm.newgovdocumentfile")%>(集团)</p> 
                </div>
               <!--<div remindModule="newMail" <%=_remindShow4%> onclick="javascript:jumpnew('/defaultroot/innerMail!innermailMenu.action?expNodeCode=mymail','/defaultroot/innerMail!notreadMailList.action');closeRemindEdit();">-->
  		
		<div remindModule="newMail" <%=_remindShow4%> onclick="javascript:jumpnew('/defaultroot/innerMail!innermailMenu.action?expNodeCode=mymail','/defaultroot/innerMail!notreadMailList.action');closeRemindEdit();">
                    <i class="fa fa-envelope">&#xf02a;</i>
					<span>0</span>
                    <p title="站内信">站内信<!--新邮件--></p> 
                </div>
				 <div remindModule="newJTMail" style="display:none;" <%=_remindShow44%> onclick="javascript:jumpnew('<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/innerMail!innermailMenu.action%3FexpNodeCode=mymail','<%=rootPath%>/platform/system/transcenter/loginCheck.jsp?module=gov&reurl=<%=rootPath%>/innerMail!notreadMailList.action');closeRemindEdit();" >
                    <i class="fa fa-envelope">&#xf02a;</i>
					<span>0</span>
                    <p title="站内信(集团)">站内信(集团)<!--新邮件--></p> 
                </div>
                <div remindModule="newTask" <%=_remindShow5%>  onclick="javascript:jumpnew('/defaultroot/modules/personal/personal_menu.jsp?expNodeCode=newTask','/defaultroot/taskCenter!selectPrincipalTask.action');closeRemindEdit();">
                    <i class="fa fa-flag">&#xf07e;</i>
					<span>0</span>
                    <p title="<%=Resource.getValue(local,"common","comm.newtask")%>"><%=Resource.getValue(local,"common","comm.newtask")%><!--新任务--></p> 
                </div>
                <div remindModule="newEvent" <%=_remindShow6%> onclick="javascript:jumpnew('/defaultroot/modules/personal/personal_menu.jsp?expNodeCode=newEvent','/defaultroot/EventAction!eventList.action?menuType=mine');closeRemindEdit();">
                    <i class="fa fa-comment">&#xf072;</i>
					<span>0</span>
                    <p title="<%=Resource.getValue(local,"common","comm.newevent")%>"><%=Resource.getValue(local,"common","comm.newevent")%><!--新事件--></p> 
                </div>
			    <div remindModule="newPress" <%=_remindShow7%>  onclick="javascript:jumpnew('/defaultroot/modules/personal/personal_menu.jsp?expNodeCode=pressdeal','/defaultroot/PressManageAction!receivePressList.action');closeRemindEdit();">
                    <i class="fa fa-clock-o">&#xf024;</i>
					<span>0</span>
                    <p title="<%=Resource.getValue(local,"common","comm.newpress")%>"><%=Resource.getValue(local,"common","comm.newpress")%><!--新催办--></p> 
                </div>  
                <div remindModule="newContract" <%=_remindShow8%> onclick="javascript:jumpnew('/defaultroot/subsidiaryMenu!toSubsidiaryMenu.action?expNodeCode=contract','/defaultroot/contract!reminderList.action');closeRemindEdit();">
                    <i class="fa fa-contract-mana">&#xf04f;</i>
					<span>0</span>
                    <p title="<%=Resource.getValue(local,"common","comm.newhetong")%>"><%=Resource.getValue(local,"common","comm.newhetong")%><!--合同提醒--></p> 
                </div>
				 <div remindModule="newWord" <%=_remindShow9%> onclick="javascript:jumpnew('/defaultroot/platform/bpm/bpm_menu.jsp?expNodeCode=newWord','/defaultroot/wfdealwith!flowMessageList.action');closeRemindEdit();">
                    <i class="fa fa-short-mes">&#xf034;</i>
					<span>0</span>
                    <p title="<%=Resource.getValue(local,"common","comm.newWord")%>"><%=Resource.getValue(local,"common","comm.newWord")%><!--新留言--></p> 
		    </div>
				
				
				<div remindModule="coremail" <%=_remindShow10%> onclick="javascript:window.open('<%=ssoURL_coremail%>','','');closeRemindEdit();">
                   <i class="fa fa-envelope">&#xf02a;</i>
					<span>0</span>
                    <p title="CoreMail">新邮件<!--CoreMail--></p> 
                </div>
              
                <div class="edit-notice">
                    <i class="fa fa-plus">&#xf001;</i>
                    <p title="<%=Resource.getValue(local,"common","comm.editremind")%>"><%=Resource.getValue(local,"common","comm.editremind")%><!--编辑提醒--></p>
                </div>
            </div>
        </div>
        <div class="wh-sys-notice wh-sys-notice-list-setting-edit">
             <div class="setting-tips setting-tips-to-close">
                <i class="fa fa-angle-left setting-edit-back"></i>
                <p title="<%=Resource.getValue(local,"common","comm.backlast")%>"><%=Resource.getValue(local,"common","comm.backlast")%><!--返回上页--></p>
            </div>
            <div class="setting-contents-edit clearfix"  id="desktop_remind_editshowhide_div">
			   <%if(!__isnoright){%>
                <div remindModule="waitFile">
                    <i class="fa fa-pencil-square-o"></i>
                    <p title="<%=Resource.getValue(local,"common","comm.docWaitForProcess")%>"><%=Resource.getValue(local,"common","comm.docWaitForProcess")%></p>
                    <%=_remindSpan1%>
                </div>
				<div remindModule="waitJTFile" >
                    <i class="fa fa-pencil-square-o"></i>
                    <p title="<%=Resource.getValue(local,"common","comm.docWaitForProcess")%>"><%=Resource.getValue(local,"common","comm.docWaitForProcess")%>(集团)</p>
                    <%=_remindSpan11%>
                </div>
				<div remindModule="waitReadJT" >
                    <i class="fa fa-pencil-square-o"></i>
                    <p title="<%=Resource.getValue(local,"common","comm.docWaitForReview")%>"><%=Resource.getValue(local,"common","comm.docWaitForReview")%>(集团)</p>
                    <%=_remindSpan55%>
                </div>
                <div remindModule="waitRead">
                    <i class="fa fa-receiving-doc"></i>
                    <p title="<%=Resource.getValue(local,"common","comm.docWaitForReview")%>"><%=Resource.getValue(local,"common","comm.docWaitForReview")%></p>
                    <%=_remindSpan2%>
                </div>
                <div remindModule="matureFile">
                    <i class="fa fa-inbox"></i>
                    <p title="<%=Resource.getValue(local,"common","comm.newgovdocumentfile")%>"><%=Resource.getValue(local,"common","comm.newgovdocumentfile")%></p>
                    <%=_remindSpan3%>
                </div>
				 <div remindModule="matureJTFile">
                    <i class="fa fa-inbox"></i>
                    <p title="<%=Resource.getValue(local,"common","comm.newgovdocumentfile")%>"><%=Resource.getValue(local,"common","comm.newgovdocumentfile")%>(集团)</p>
                    <%=_remindSpan33%>
                </div>
                <div remindModule="newMail">
                    <i class="fa fa-envelope"></i>
                    <p title="站内信">站内信<!--新邮件--></p>
                    <%=_remindSpan4%>
                </div>

			   <div remindModule="newJTMail">
                    <i class="fa fa-envelope"></i>
                    <p title="站内信(集团)">站内信(集团)<!--新邮件--></p>
                    <%=_remindSpan44%>
                </div>
                <div remindModule="newTask">
                    <i class="fa fa-flag"></i>
                    <p title="<%=Resource.getValue(local,"common","comm.newtask")%>"><%=Resource.getValue(local,"common","comm.newtask")%><!--新任务--></p>
                    <%=_remindSpan5%>
                </div>
                <div remindModule="newEvent">
                    <i class="fa fa-comment"></i>
                    <p title="<%=Resource.getValue(local,"common","comm.newevent")%>"><%=Resource.getValue(local,"common","comm.newevent")%><!--新事件--></p>
                    <%=_remindSpan6%>
                </div>
               <div remindModule="newPress">
                    <i class="fa fa-clock-o"></i>
                    <p title="<%=Resource.getValue(local,"common","comm.newpress")%>"><%=Resource.getValue(local,"common","comm.newpress")%><!--新催办--></p>
                    <%=_remindSpan7%>
                </div>
                <div remindModule="newContract">
                    <i class="fa fa-contract-mana"></i>
                    <p title="<%=Resource.getValue(local,"common","comm.newhetong")%>"><%=Resource.getValue(local,"common","comm.newhetong")%><!--合同提醒--></p>
                    <%=_remindSpan8%>
                </div>
				<div remindModule="newWord">
                    <i class="fa fa-short-mes"></i>
                    <p title="<%=Resource.getValue(local,"common","comm.newWord")%>"><%=Resource.getValue(local,"common","comm.newWord")%><!--新留言--></p>
                    <%=_remindSpan9%>
                </div>	
				<%}%>
				<div remindModule="coremail">
                    <i class="fa fa-envelope"></i>
                    <p title="CoreMail">新邮件<!--coremail--></p>
                    <%=_remindSpan10%>
                </div>	
            </div>
        </div>
    </div>
</div> 
<%@ include file="/public/desktop/include_desktop_other.jsp"%>
<%@ include file="/public/desktop/include_desktop_window.jsp"%> 
<div style="display:none">
  <form id="frm">
    <input type="hidden" name="docKeyCode" value="0">
  </form>
  <iframe id="iframe1" src="" scrolling="no"></iframe>
  <iframe id="iframe2" src="" scrolling="no"></iframe>
</div> 
</body>
</html>
<%}%>


<script>

 $(function(){

      $(".click-info").on('click', function(){ 
        if($(this).hasClass("up")){
          $(this).removeClass("up");
        }else{
          $(this).addClass("up");
        }
        $(".wh-hd-user-detail").slideToggle();
      })

     $(".pro-user-info .wh-hd-user-detail .title").click(function(){

        if($(this).next(".per-wh-hd-user-state").hasClass("open")){
               $(this).next(".per-wh-hd-user-state").removeClass("open");
          }
        else
           {
             $(this).next(".per-wh-hd-user-state").addClass("open");
          }
     });

    $(".pro-user-info .per-wh-hd-user-state.open a").click(function(){
       
          $(this).addClass("current").siblings("a").removeClass("current");  
    })

 
    /*  $('.per-wh-hd-user-state a').click(function () {
        $(this).addClass('current').siblings().removeClass('current');
    });
*/
	startclock();

  });

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
	
	//在改造后的位置显示状态
	function setStateHtmNew(){
			 //先清空
	$("#destop_user_state_div_new").html("");

    var str0 = getStates(); //0,0|正常;101|请假;102|调休;103|出差;104|外出;
 
    var str1;
    var str2="";//存放statusName
    var str3="";//存放StatusId
    //str1[0] 选中状态;str2自定义状态组
    if(str0 != ""){
        str1 = str0.split(",");//str1[0]为当前状态id；str1[1]为所有状态id和name组成的串
    }
	var state = str1[0].replace(/\n|\r/g,"");//当前状态id


    var str1Temp = new Array();
    str1Temp = str1[1].split(";");
    for(var ss=0;ss<str1Temp.length-1;ss++){
        var str1Temp2 = new Array();
        str1Temp2 = str1Temp[ss].split("|");
        //str2 += str1Temp2[1]+",";//存放所有状态name组成的串
        //str3 += str1Temp2[0]+",";//存放所有状态id组成的串 
		var statusName = str1Temp2[1];
        if(str1Temp2[1]=='正常'){
            statusName = '上班';
        }else if(str1Temp2[1]=='请假'){
            statusName = '请假';
        }else if(str1Temp2[1]=='调休'){
            statusName = '调休';
        }else if(str1Temp2[1]=='外出'){
            statusName = '外出';
        }else if(str1Temp2[1]=='出差'){
            statusName = '出差';
        } 

        var statusClass="";
		if(str1Temp2[0]==state){ 
			currentStatusName = statusName;
			statusClass="class=\"current\"";
		}
		$("#destop_user_state_div_new").append("<a href=\"javascript:void(0)\" id=\"destop_a_"+str1Temp2[0]+"\"  onclick=\"setDefineStatesByStatusId('"+str1Temp2[0]+"',this);return false;\"        "+statusClass+" ><span title='"+statusName+"'>"+statusName+"</span><i class=\"fa\"></i></a>"); 
    }
   
    //显示自定义
    $("#destop_user_state_div_new").append("<a href=\"\" class=\"state-self\" onClick=\"openWin({url:'StatusSetupAction!addStatusClass.action',width:445,height:120,winName:'addStatus'});return false;\"><span title='自定义'>自定义</span></a>"); 
		
	}



	//问题反馈跳转到论坛 yucz 20161228
	function feedBack(){
		<%
		String feedBack=session.getAttribute("feedBack")==null?"0":session.getAttribute("feedBack").toString();
		if("1".equals(feedBack)){
		%>
		openWin({url:'/defaultroot/ForumAction!addForum.action?forumFlag=topic&forumClassId=139805',isFull:true,winName:'问题反馈'});
		<%}%>
	}
	
	function delCookie(name,path,domain) {
		var today = new Date();
		var deleteDate = new Date(today.getTime() - 48 * 60 * 60 * 1000);
		var cookie = name + "="
			+ ((path == null) ? "" : "; path=" + path)
			+ ((domain == null) ? "" : "; domain=" + domain)
			+ "; expires=" + deleteDate;
		document.cookie = cookie;
	}

	function delSSOCookie() {
		var isNetscape = (document.layers);
		if (isNetscape == false || navigator.appVersion.charAt(0) >= 5) {
			for (var i=0; i<document.links.length; i++) {
				if (document.links[i].href == "javascript:top.close()") {
					document.links[i].focus();
					break;
				}
			}
		}

		delCookie('BBCloudBAMSession', '/','.wfccb.com');
		var subdomain;
		var domain = new String(document.domain);
		
		var index = domain.indexOf(".");
		while (index > 0) {
			subdomain = domain.substring(index, domain.length);
			
			if (subdomain.indexOf(".", 1) > 0) {
				delCookie('BBCloudBAMSession', '/', subdomain);
			}
			domain = subdomain;
			index = domain.indexOf(".", 1);
		}
		top.location.href = whirRootPath + "/index_pre.jsp";

	}
</script>

<%!
/*
判断当前用户是否属于“营销管理部”或“首钢冷轧公司”这两个组织及其下级组织，如果是则不显示“新建会议通知”菜单 
hw 2017-1-2
*/
private boolean showCreateMeetingNoteMenu(String orgId) {
	boolean show = true;
	if(orgId == null || orgId.equals("null")) {
		return show;
	}
	com.whir.common.util.DataSourceBase dsb = new com.whir.common.util.DataSourceBase();
	java.sql.Connection conn = null;
	try {
		conn = dsb.getDataSource().getConnection();
		//营销管理部：12861、首钢冷轧公司：12867
		java.sql.PreparedStatement pstmt = conn.prepareStatement("select 1 from org_organization where (orgidstring like '%$12861$%' or orgidstring like '%$12867$%') and org_id=?");
		pstmt.setLong(1, Long.parseLong(orgId));
		java.sql.ResultSet rs = pstmt.executeQuery();
		if(rs.next()) {
			show = false;
		}
		rs.close();
		pstmt.close();
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		try {
			conn.close();
		} catch(java.sql.SQLException e1) {
			e1.printStackTrace();
		}
	}
	return show;
}
%>