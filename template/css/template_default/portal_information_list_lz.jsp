<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/public/include/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="com.whir.ezoffice.portal.bd.*"%>
<%@ page import="com.whir.ezoffice.portal.po.*"%>
<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache");
response.setDateHeader ("Expires", 0);
System.out.println("channelName=========================");
String channelName = request.getAttribute("channelName")!=null?request.getAttribute("channelName").toString():"";
System.out.println("channelName========================="+channelName);
String orgId=request.getAttribute("orgId")!=null?request.getAttribute("orgId").toString():"";
String pageCount=request.getAttribute("pageCount")!=null?request.getAttribute("pageCount").toString():"0";
String recordCount=request.getAttribute("recordCount")!=null?request.getAttribute("recordCount").toString():"0";
String currentPage=request.getAttribute("currentPage")!=null?request.getAttribute("currentPage").toString():"0";
String pageSize=request.getAttribute("pageSize")!=null?request.getAttribute("pageSize").toString():"0";
List list=(List)request.getAttribute("list");
String channelId= request.getAttribute("channelId")!=null?request.getAttribute("channelId").toString():"";

int cpage=0;
int ppage=0;
if(!"".equals(cpage)){
	cpage=Integer.parseInt(currentPage);
}
if(!"".equals(ppage)){
	ppage=Integer.parseInt(pageCount);
}


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<base url="defaultroot">
        <title><%=channelName%></title>
        <%@ include file="/public/include/meta_base.jsp"%>
        <%@ include file="/public/include/meta_list.jsp"%>
       
        <script src="<%=rootPath%>//platform/portal/info/info_list_js.js" type="text/javascript"></script>
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
		<script type="text/javascript" src="scripts/plugins/jquery/jquery.min.js"></script>
		<script type="text/javascript" src="scripts/plugins/superslide/jquery.SuperSlide.2.1.1.js"></script>

       
    </head>
<%
	//当前session页码
	//int curPageSize = com.whir.common.util.CommonUtils.getSessionUserPageSize(request);  
	//页码集合
	//String[] a = com.whir.common.util.CommonUtils.getSysPageSizeArray(request);  
%>
<body>
    <!--- top  -->
    <div class="before-top clearfix w1280">
        <a class="before-logo fl"><img src="../defaultroot/images/ver113/shougang/logo.png"></a>
        <div class="before-nav fl">
            <ul class="clearfix">
                <li>
                    <a target="_blank" href="/defaultroot/beforelz.jsp">首页</a>
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
		openWin({url:whirRootPath+"/BeforeInfoAction!infolist.action?infokey2=" + encodeURIComponent(infokey)+"&orgId=<%=orgId%>"+"&channelIds=21461,22389,22315,22479,21477,21510,42928,22058,22452,23683,22285,22287,22289,43464,22471,364064,23094,23713",isFull:'true',winName: 'searchInfo'});

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

       <!--- 信息列表页 -->
    <div class="wh-container wh-portaler w1280 w-in">
        <div class="erji clearfix ">
            <div class="siderbar fl ">
			<%if("21781".equals(channelId)||"21816".equals(channelId)||"21852".equals(channelId)||"21879".equals(channelId)||"21915".equals(channelId)||"21935".equals(channelId)||"21937".equals(channelId)||"21939".equals(channelId)||"21943".equals(channelId)||"21949".equals(channelId)){}else{%>
                <div class="siderbar-img" ><img src="images/ver113/shougang/syly-img1.png"></div>
			<%}%>
                <div class="side-nav" <%if("21781".equals(channelId)||"21816".equals(channelId)||"21852".equals(channelId)||"21879".equals(channelId)||"21915".equals(channelId)||"21935".equals(channelId)||"21937".equals(channelId)||"21939".equals(channelId)||"21943".equals(channelId)||"21949".equals(channelId)){%>style="margin-top:0px;"<%}%>>
                    <ul>
					<%if("21461".equals(channelId)||"22471".equals(channelId)||"22479".equals(channelId)||"23094".equals(channelId)||"23713".equals(channelId)){%>
                        <li class="nav-li on"><a href="javascript:void(0);"><%=channelName%></a></li>
					<%}else if("21477".equals(channelId)||"21510".equals(channelId)){%>
						<li <%if("21477".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("21477".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21477&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>冷轧公司会议通知</a></li>
						<li <%if("21510".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("21510".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/WebIndexSggfBD!getInfoListHytz.action?type=sylz&channelId=21510&startPage=1&pageSize=12&orgId=12867"<%}%>>股份公司会议通知</a></li>
					<%}else if("42928".equals(channelId)||"22058".equals(channelId)||"22125".equals(channelId)||"22148".equals(channelId)){%>
						<li <%if("42928".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("42928".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=42928&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>公文公告</a></li>
						<li <%if("22058".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("22058".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=22058&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>会议纪要</a></li>
						<li <%if("22125".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("22125".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=22125&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>督办</a></li>
						<li <%if("22148".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("22148".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=22148&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>值班表/通讯录</a></li>
					<%}else if("22285".equals(channelId)||"22287".equals(channelId)||"22289".equals(channelId)){%>
						<li <%if("22285".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("22285".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=22285&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>安全动态</a></li>
						<li <%if("22287".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("22287".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=22287&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>人力资源</a></li>
						<li <%if("22289".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("22289".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=22289&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>行政后勤</a></li>
					<%}else if("22389".equals(channelId)||"22315".equals(channelId)){%>
						<li <%if("22389".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("22389".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=22389&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>党员学习园地</a></li>
						<li <%if("22315".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("22315".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=22315&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>党务公开</a></li>
					<%}else if("22452".equals(channelId)||"23683".equals(channelId)){%>
						<li <%if("22452".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("22452".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=22452&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>冷轧新闻</a></li>
						<li <%if("23683".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("23683".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=23683&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>股份新闻</a></li>
					<%}else if("21781".equals(channelId)||"21816".equals(channelId)||"21852".equals(channelId)||"21879".equals(channelId)||"21915".equals(channelId)||"21935".equals(channelId)||"21937".equals(channelId)||"21939".equals(channelId)||"21943".equals(channelId)||"21949".equals(channelId)){%>
						<li <%if("21781".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("21781".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21781&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>现行制度目录</a></li>
						<li <%if("21816".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("21816".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21816&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>废止制度目录</a></li>
						<li <%if("21852".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("21852".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21852&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>生产安全</a></li>
						<li <%if("21879".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("21879".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21879&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>设备管理</a></li>
						<li <%if("21915".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("21915".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21915&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>技术质量</a></li>
						<li <%if("21935".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("21935".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21935&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>能源环保</a></li>
						<li <%if("21937".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("21937".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21937&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>劳动人事</a></li>
						<li <%if("21939".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("21939".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21939&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>武装保卫</a></li>
						<li <%if("21943".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("21943".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21943&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>财务管理</a></li>
						<li <%if("21949".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("21949".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=21949&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>行政生活</a></li>
					<%}else if("43464".equals(channelId)||"364064".equals(channelId)){%>
						<li <%if("43464".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("43464".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=43464&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>质量异议及抱怨</a></li>
						<li <%if("364064".equals(channelId)){%>class="nav-li on"<%}else{%>class="nav-li"<%}%>><a <%if("364064".equals(channelId)){%>href="javascript:void(0);"<%}else{%>href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=sylz&channelId=364064&startPage=1&pageSize=12&orgId=<%=orgId%>"<%}%>>质量日清日结</a></li>
					<%}%>
                    </ul>
                </div>
            </div>
            <div class="erji-fr-box fr">
                <div class="erji-fr fr ">
                    <div class="location clearfix ">
                        <div class="now"><%=channelName%></div>
                        <p>您当前的位置：<a target="_blank" href="/defaultroot/beforelz.jsp">首页</a><i>&gt;</i><a href="javascript:void(0)"><%if("21781".equals(channelId)||"21816".equals(channelId)||"21852".equals(channelId)||"21879".equals(channelId)||"21915".equals(channelId)||"21935".equals(channelId)||"21937".equals(channelId)||"21939".equals(channelId)||"21943".equals(channelId)||"21949".equals(channelId)){%>规章制度&nbsp;>&nbsp;<%}%><%=channelName%></a></p>
                    </div>
                    <div class="news-list ">
					<%if("21510".equals(channelId)){%>
					<form name="queryForm" id="queryForm" action="/defaultroot/WebIndexSggfBD!getInfoListHytz.action" method="post">
					<%}else{%>
					<form name="queryForm" id="queryForm" action="/defaultroot/BeforeInfoAction!getInformationListBF.action" method="post">
					<%}%>
						<input name="type" id="type" type="hidden" value="sylz"/>
						<input name="channelId" id="channelId" type="hidden" value="<%=channelId%>"/>
						<input name="startPage" id="startPage" type="hidden" value="0"/>
						<input name="orgId" id="orgId" type="hidden" value="<%=orgId%>"/>
						<input name="pageSize" id="pageSize" type="hidden" value="<%=pageSize%>"/>
                        <table border="0 " align="center " cellpadding="0 " cellspacing="0 " style="width:100%; ">
						
                            <tbody>
                                <%if(list!=null&&list.size()>0){
								if("21510".equals(channelId)){
									for(int i=0;i<list.size();i++){
								 String [] arr = (String []) list.get(i);
								 String title = arr[12];
								 if(title.length()>30){
									 title = title.substring(0,30)+"...";
								 }
								%>
								<tr>
								<td class="td1 title" width="70% " align="center "><a href="javascript:void(0)" onclick="meetDetailView('<%=arr[0]%>');" title="<%=arr[12]%>"><%=title%><i class="fa fa-new"></i></a></td>
								<td width="15% " align="right " class="color-2"><%=arr[11]%></td>
								<td width="15% " align="right " class="color-2"><%=arr[1]%></td>
							</tr>
								<%}}else{
									for(int i=0;i<list.size();i++){
										String [] arr = (String []) list.get(i);
										String title=arr[1];
										if(title.length()>20){
											title=title.substring(0,20)+"...";
										}
									%>
									<tr>
                                    <td class="td1 title" width="55%" align="center" ><a href="/defaultroot/BeforeInfoAction!getInformation.action?id=<%=arr[0]%>" target="_blank"><%=title%></a></td>
                                    <td width="15% " align="right "><%=arr[7]%></td>
                                    <td width="15% " align="right "><%=arr[10]%></td>
                                    <td width="15% " align="right "><%=arr[2]%></td>
                                </tr>
								<%}}}%>
                            </tbody>
                        </table>
						<%if(!"0".equals(pageCount)&&!"".equals(pageCount)&&pageCount!=null){%>
                        <div class="syly-pager clearfix ">
						<input type="hidden" name="startPage" id="startPage" value="1" />
						<input type="hidden" name="currentPage" id="currentPage" value="<%=currentPage%>" />
                            <div class="wh-pager-desc fr ">
                               &nbsp;&nbsp;&nbsp; 共&nbsp;<em class="current "><%=currentPage%></em>/<%=pageCount%>&nbsp;页
                            </div>
                            <div class="syly-page">
                                <a href="javascript:void(0)" <%if(cpage>1){%>onclick="pageBtnClick('start');" <%}%>>首页</a>
                                <a href="javascript:void(0)" <%if(cpage>1){%>onclick="pageBtnClick('previous');"<%}%>> <<上一页</a>
								<a href="javascript:void(0)" <%if(cpage!=ppage){%>onclick="pageBtnClick('next');"<%}%>>下一页>></a>
                                <a href="javascript:void(0)" <%if(cpage!=ppage){%>onclick="pageBtnClick('last');"<%}%>>尾页</a>
                                <input type="text" name="pageSearch" id="pageSearch" onfocus="$(this).attr('class','clicked');" onblur="$(this).attr('class','');"/>
                                <a href="javascript:void(0)" onclick="pageBtnClick('input');">跳转</a>
                                      
                            </div>							
                        </div>
						<%}%>
                    </div>
                </div>
            </div>
        </div>
      
    
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

		$("#pageSearch").bind('focus keyup blur mouseout',function(){
        //数字校验
        checkNumber($("#pageSearch"));
        
        var go_start_pager = $("#pageSearch").val();
        if(go_start_pager == ""){
            return false;
        }
        
        var page_count = $formId.find("#page_count").val();
        if( (go_start_pager*1+0) > (page_count*1+0) ){
            $go_start_pager.val(page_count);
        }
        if( go_start_pager != "" && (go_start_pager*1+0) == 0 ){
            $go_start_pager.val(1);
        }
    });	

			
        });
        </script>
</body>

<script type="text/javascript">
function checkNumber(obj){
    $(obj).val($(obj).val().replace(/\D/g,''));
    //如果第二位不是.则第一位不能是0
    if($(obj).val()!="" && (($(obj).val())*1+0)==0){
        $(obj).val("0");
    }
}


function pageBtnClick(flag){
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
		var ipage=$("#pageSearch").val();
		var ppage='<%=pageCount%>';
		if(ipage!=null&&ipage!=""&&ipage!="0"){
			if(Number(ipage)<Number(ppage)){
				$("#startPage").val(ipage);
				$("#queryForm").submit();
			}
			
		}else{
			return false;
		}
	}
}

//-->
</script>
</html>
