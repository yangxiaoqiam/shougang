<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/public/include/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="com.whir.ezoffice.portal.bd.*"%>
<%@ page import="com.whir.ezoffice.portal.po.*"%>
<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache");
response.setDateHeader ("Expires", 0);
String infokey2 = request.getAttribute("infokey2")==null ? "" : request.getAttribute("infokey2").toString();  
String orgId = request.getParameter("orgId")!=null?request.getParameter("orgId"):"" ;
String channelIds = request.getParameter("channelIds")!=null?request.getParameter("channelIds"):"" ;%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script type="text/javascript">
	var whirRootPath = "<%=rootPath%>";
	var preUrl = "<%=preUrl%>"; 
	var whir_browser = "<%=whir_browser%>"; 
	var whir_agent = "<%=com.whir.component.security.crypto.EncryptUtil.htmlcode(whir_agent)%>"; 
	var whir_locale = "<%=whir_locale.toLowerCase()%>"; 
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
		<%@ include file="/public/include/meta_base.jsp"%>
		<%@ include file="/public/include/meta_list.jsp"%>
        <title>查询列表</title>
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
		<link rel="stylesheet" href="themes/common/common.css" />
		<link rel="stylesheet" href="template/css/template_default/template.syly-before.css" />
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
    </head>
	
	<STYLE type="text/css">
	.listTable .listTableLine1 td a, .listTable .listTableLine2 td a{
	display:block;
    text-align:left;
	padding-left:10px;
	width:90%;
	line-height:40px;
	text-overflow: ellipsis;
    overflow: hidden;
    word-break: keep-all;
    word-wrap: normal;
    white-space: nowrap;

}
	</STYLE>
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

                    <li><a href="#">通讯录</a></li>
                </li>
            </ul>
        </div>
        <div class="before-logo-ri fr clearfix">
            <div class="header-buttom-fr fr">
                <input type="text" id="search" name="" value="<%=infokey2%>" onfocus="this.value=''" onblur="if(this.value==''){this.value='请输入文字'}">
                <a onclick="SearchInformation();" class="before-btn"><i class="fa fa-search fa-color"></i></a>
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
		openWin({url:whirRootPath+"/BeforeInfoAction!infolist.action?infokey=" + encodeURIComponent(infokey)+"&orgId=<%=orgId%>"+"&channelIds=21461,22389,22315,22479,21477,21510,42928,22058,22452,22462,22285,22287,22289,43464,22471",isFull:'true',winName: 'searchInfo'});
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
                <div class="siderbar-img"><img src="images/ver113/shougang/syly-img1.png"></div>
                <div class="side-nav">
                    <ul>
                        <li class="nav-li on"><a href="javascript:void(0);">搜索</a></li>

                    </ul>
                </div>
            </div>
            <div class="erji-fr-box fr">
                <div class="erji-fr fr ">
                    <div class="location clearfix ">
                        <div class="now">搜索</div>
                        <p>您当前的位置：<a target="_blank" href="/defaultroot/beforelz.jsp">首页</a><i>&gt;</i><a href="javascript:void(0);">搜索</a></p>
                    </div>
                    <div class="news-list ">
					<form name="queryForm" id="queryForm" action="BeforeInfoAction!getInfoListByKey.action" method="post" >
							<%@ include file="/public/include/form_list.jsp"%>
							<input type="hidden" name="channelIds" value="<%=channelIds%>">
							<input type="hidden" name="orgId" value="<%=orgId%>">
							<input type="hidden" name="infokey2" id="infokey2" value="<%=infokey2%>">
                         <table width="100%" border="0" cellpadding="0" cellspacing="0" id="searchTable" class="SearchBar">
                                <tbody>
                                    <tr>
                                            <td class="whir_td_searchtitle" >栏目名称：</td>
                                            <td class="whir_td_searchinput">
                                                    <select id="channelId" name="channelId" defaultvalue="0">
                                                        <option value="0" selected>===请选择栏目===</option>
														<option value="21461" >通知公告</option>
														<option value="21464" >会议通知</option>
														<option value="21477" >&nbsp;冷轧公司会议通知</option>
														<option value="21510" >&nbsp;股份公司会议通知</option>
														<option value="21709" >规章制度</option>
														<option value="21781" >&nbsp;现行制度目录</option>
														<option value="21816" >&nbsp;废止制度目录</option>
														<option value="21852" >&nbsp;生产安全</option>
														<option value="21879" >&nbsp;设备管理</option>
														<option value="21915" >&nbsp;技术质量</option>
														<option value="21935" >&nbsp;能源环保</option>
														<option value="21937" >&nbsp;劳动人事</option>
														<option value="21939" >&nbsp;武装保卫</option>
														<option value="21943" >&nbsp;财务管理</option>
														<option value="21949" >&nbsp;行政生活</option>
														<option value="43768" >公司看板</option>
														<option value="42928" >&nbsp;公文公告</option>
														<option value="22058" >&nbsp;会议纪要</option>
														<option value="22125" >&nbsp;督办</option>
														<option value="22148" >&nbsp;值班表/通讯录</option>
														<option value="22232" >专业公告</option>
														<option value="22285" >&nbsp;安全动态</option>
														<option value="22287" >&nbsp;人资动态</option>
														<option value="22289" >&nbsp;行政后勤</option>
														<option value="22389" >党员学习园地</option>
														<option value="22315" >党务公开</option>
														<option value="22443" >新闻动态</option>
														<option value="22452" >&nbsp;冷轧新闻</option>
														<option value="22462" >&nbsp;股份新闻</option>
														<option value="43464" >质量异议及抱怨</option>
														<option value="22471" >事故通报</option>
														<option value="22479" >TPM园地</option>
                                                    </select>
                                            </td>
                                            <td class="whir_td_searchtitle" >部门：</td>
                                            <td class="whir_td_searchinput">
													<!--<input type="hidden" name="orgIds" id="orgIds"/>
													<input type="hidden" name="pastOrgId" id="pastOrgId" value=""/>
													<input type="hidden" id="_orgId" value=""/>
													<input type="hidden" name="orgId" id="orgId" value=""/>
                                                    <input type="text" name="orgName" id="orgName" value="" readonly="readonly" id="searchOrgName" class="inputText" style="width:96%">
                                                    <a href="javascript:void(0);" class="selectIco" onclick="openSelect({allowId:'orgIds', allowName:'orgName', select:'org', single:'yes', show:'org', range:'0',callbackOK:'getFillLeader'});"></a>
                                            -->
											<input type="text" name="orgName" id="orgName" class="inputText" style="width:96%">
											</td>
                                            <td class="whir_td_searchtitle" nowrap="">关键字：</td>
                                            <td class="whir_td_searchinput">
                                                <input type="text" name="infokey" value="" id="infokey" class="inputText" style="width:99%">
                                            </td>
                                            </tr>
                                            <tr>
                                                <td class="whir_td_searchtitle" nowrap="">发布人：</td>
                                                <td class="whir_td_searchinput">
                                                    <input type="text" name="searchIssuerName" value="" id="searchIssuerName" class="inputText" style="width:96%">
                                                </td>
                                                <td class="whir_td_searchtitle" nowrap="">发布日期：</td>
                                                <td class="whir_td_searchinput" colspan="2">
                                                   <input name="startDate" class="Wdate whir_datebox" id="startDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'})" type="text" value=""/>&nbsp;至&nbsp;<input name="endDate" class="Wdate whir_datebox" id="endDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}'})" type="text" value=""/>
                                             </td>
                                            <td class="SearchBar_toolbar"></td>
                                    </tr>
                                </tbody>
                            </table>
                             <table width="100%" height="35px" border="0" cellpadding="0" cellspacing="0" class="inlineBottomLine">
                                <tbody>
                                    <tr>
                                         <td>
                                            <div class="whir_public_movebg">
                                                <div class="whir_flright Public_tag" style="float:right;padding-right:5px">
                                                    <div id="whir_titlesearch">
                                                        <input type="button" class="btnButton4font"  value="确定" onclick="search();" />
                                                        <input type="button" class="btnButton4font"  value="重置" onclick="resetForm(this);" />
                                                    </div>
                                                </div>
                                                <div class="Public_tag">
                                                    <ul class="clearfix">
                                                        <li class="tag_aon"><span class="tag_center">信息</span></li>
                                                   </ul>
                                                </div>
                                            </div>
                                         </td>
                                     </tr>
                                 </tbody>
                              </table>
                            <table width="100%" border="0" cellpadding="1" cellspacing="1" class="listTable">
                                <thead id="headerContainer">
                                    <tr class="listTableHead">
                                        <td nowrap whir-options="field:'informationTitle',width:'55%',renderer:infoTitle">标题</td>
                                        <td whir-options="field:'informationIssuer',width:'12%'">发布人</td>
                                        <td whir-options="field:'informationIssueOrg', width:'20%'">部门</td>
                                        <td whir-options="field:'informationIssueTime', width:'13%'">发布日期</td>
                                    </tr>
                                </thead>
                                <tbody id="itemContainer">
                                   
                                </tbody>
                            </table>
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="Pagebar">
                             <tr>
								<td>
									<%@ include file="/public/page/pager.jsp"%>
								</td>
							</tr>
                        </table>
						</form>
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


        });
        </script>
</body>
</html>
<script type="text/javascript">
$(document).ready(function(){
    initListFormToAjax({formId:"queryForm"});
});
</script>
<script type="text/javascript">
function infoTitle(po,i){
	var html = "", channelName="";
	channelName = po.channelName == null ? "" : po.channelName;
	var infoTitle = '<a onclick="openWin({url:\'BeforeInfoAction!getInformation.action?title='+po.informationTitle+'&id='+po.id+'&categoryName='+channelName+'\',winName:\'portalInfoList'+po.id+'\',isFull:true});" style="cursor:pointer"><font color="gray">'+HtmlEncode(po.informationTitle)+'</font></a>';
	
	html = infoTitle;
	return html;
}

function viewInfo(id, title, channelName){
	window.open(encodeURI('BeforeInfoAction!getInformation.action?title='+title+'&id='+id+'&categoryName='+channelName), '', 'menubar=0,scrollbars=yes,locations=0,width='+screenwidth+',height='+screenheight+',resizable=yes');
}

function search(){
	$("#infokey2").val("");
	$("#queryForm").submit();
}
</script>