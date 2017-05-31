<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/public/include/init.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>领导日程-展示页面-月</title>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    <%@ include file="/public/include/meta_base.jsp"%>
    <%@ include file="/public/include/meta_list.jsp"%>
    <!--这里可以追加导入模块内私有的js文件或css文件-->
    <script src="<%=rootPath%>/modules/personal/leader/display_month_js.js" type="text/javascript"></script>
    <link  href="<%=rootPath%>/modules/personal/leader/leader_displayStyle.css" rel="stylesheet" type="text/css"/>
    <script src="<%=rootPath%>/scripts/i18n/<%=whir_locale%>/PersonalworkResource.js" type="text/javascript"></script>
    <link  href="<%=rootPath%>/template/css/template_default/selectcolor.css" rel="stylesheet" type="text/css"/>
</head>
<%
Boolean isOperatLeader=(Boolean)request.getAttribute("isOperatLeader");
%>
<style>
				span.week_time{display: block;background:#F5F1F1;}
				
</style> 
<body class="MainFrameBox">
    <s:form name="queryForm" id="queryForm" action="LeaderAction!displayByMonthAction.action" method="post" theme="simple">
    <input type="hidden" name="menuType" id="menuType" value="<%=request.getParameter("menuType")%>" />	
    <input type="hidden" name="displayType" id="displayType" value="<%=request.getParameter("displayType")%>" />	
    <input type="hidden" id="queryLeaderId_from" value="<%=request.getParameter("queryLeaderId")==null?"":request.getParameter("queryLeaderId")%>" />
	<input type="hidden" id="leaderTag_from" value="<%=request.getParameter("leaderTag")==null?"":request.getParameter("leaderTag")%>" />
	<input type="hidden" id="workCotent_from" value="<%=request.getParameter("workCotent")==null?"":request.getParameter("workCotent")%>" />
    <!-- SEARCH PART START -->
    <%@ include file="/public/include/form_list.jsp"%>
    
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="SearchBar">
	
	     <tr>
		   <td class="whir_td_searchtitle">领导：</td>
            <td class="whir_td_searchinput">
			    <%if("mine".equals(request.getParameter("menuType"))){%>
				<select name="queryLeaderId" id="queryLeaderId" class="easyui-combobox" disabled="disabled" style="width:290px;" data-options="panelHeight:'200'">
                   <option value=""><%=request.getAttribute("queryUserName")%></option>                      
                </select>
				<%}else{%>
                <select name="queryLeaderId" id="queryLeaderId" class="easyui-combobox"  <%if("mine".equals(request.getParameter("menuType"))){%>disabled="disabled"<%}%>  style="width:290px;" data-options="panelHeight:'200'">
                        <%if(isOperatLeader){%>					    
				        <option value="-1">负责的领导</option>
						<option value="">所有领导</option>
				       <%}else{%>
					    <option value="">所有领导</option>
					   <%}%>		
                        <s:iterator var="obj" value="#request.queryLeaderList">
                            <option value="<s:property value='#obj[0]' />" ><s:property value='%{#obj[1]}' escape='false'/></option>
                        </s:iterator>
                </select>
				<%}%>
            </td>
			 
			<td class="whir_td_searchtitle">日期：</td>  
            <td class="whir_td_searchinput" colspan=3 >  
                <input type="text" class="Wdate whir_datebox" name="queryPeriodReferDate" id="queryPeriodReferDate" value='<%=EncryptUtil.htmlcode(request.getParameter("queryPeriodReferDate")==null ? "" :request.getParameter("queryPeriodReferDate")) %>' onclick="WdatePicker({el:'queryPeriodReferDate',isShowWeek:false, isShowClear:true, readOnly:true, dateFmt:'yyyy-MM-dd'})"/>             
                <s:hidden name="queryPeriodReferOffset" id="queryPeriodReferOffset" value="" />
            </td>          			
        </tr>
        <tr>
           
        <tr>
            <td class="whir_td_searchtitle">工作内容：</td>
            <td class="whir_td_searchinput">
			    <input type="text" class="inputText"  name="workCotent" id="workCotent" style="width: 93.5%;" />              
            </td> 
            <td class="whir_td_searchtitle">标签：</td>
            <td class="whir_td_searchinput">
                <select  name="leaderTag" id="leaderTag" class="easyui-combobox" style="width:290px;" data-options="selectOnFocus:true,editable:true">                         
				   <option value="" >--请选择/输入--</option>
				   <s:iterator var="obj" value="#request.tagList" >
				   <option value="<s:property value='#obj[0]' />" ><s:property value='%{#obj[0]}' escape='false'/></option>
				   </s:iterator>
               </select>	
            </td>
        
            <td colspan="2" class="SearchBar_toolbar">       
                <input type="button" class="btnButton4font" id="query_btn" onclick="refreshListForm('queryForm');" value='<s:text name="comm.searchnow"/>' />
                <!--resetForm(obj)为公共方法-->
                <input type="button" class="btnButton4font" onclick="resetForm(this);" value='<s:text name="comm.clear"/>' />
            </td>
        </tr>       
    </table>
    <!-- SEARCH PART END -->
    
    <!-- MIDDLE BUTTONS START -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="toolbarBottomLine">
        <tr>
            <td align="left">
                <div class="Public_tag">
                    <ul>                        
                        <li><span class="tag_center" onclick="changeDisplayType('week');">周</span><span class="tag_right"></span></li>
                        <li class="tag_aon"  onclick="changeDisplayType('month');"><span class="tag_center">月</span><span class="tag_right"></span></li>
                        <li><span class="tag_center" onclick="changeDisplayType('list');">列表</span><span class="tag_right"></span></li>
                    </ul>
                    <span class="changePeriod">
                        <img src="<%=rootPath%>/<%=whir_skin%>/images/prev.gif" onclick="changeQueryByDateOffset('-1');" title='<s:text name="calendar.previousmonth" />' style="vertical-align:middle;" />
                        <img src="<%=rootPath%>/<%=whir_skin%>/images/next.gif" onclick="changeQueryByDateOffset('1');" title='<s:text name="calendar.nextmonth" />' style="vertical-align:middle;" />
                        <input type="button" class="btnButton4font" onclick="changeQueryDate_toCur();" value='<s:text name="calendar.curMonth" />' style="vertical-align:middle;" />
                        <span id="periodsShow"></span>
                    </span>
                </div>
            </td>
            <td align="right" class="bottomline" style="width:15%;" nowrap>
			    <%				
				if("leader".equals(request.getParameter("menuType"))){
				   if(isOperatLeader){
				%>			
                <input type="button" class="btnButton4font" onclick="addLeaderEvent();" value='<s:text name="comm.add"/>' />  
				<%}}else{%>	
                <input type="button" class="btnButton4font" onclick="addLeaderEvent();" value='<s:text name="comm.add"/>' />  
                <%}%>							
                <input type="button" class="btnButton4font" onclick="exportQueryExcel();" value='<s:text name="comm.export"/>' />
				<!--<input type="button" class="btnButton4font" onclick="cmdPrint();" value='打&nbsp;&nbsp;印' />-->				
            </td>
        </tr>
    </table>
    <!-- MIDDLE BUTTONS END -->

    <!-- LIST PART START -->    
    <table width="100%" border="0" cellpadding="1" cellspacing="1" class="listTable">
        <thead id="headerContainer">
            <tr class="listTableHead">
                <td width="16%" >星期一</td>
                <td width="16%" >星期二</td>
                <td width="16%" >星期三</td>
                <td width="16%" >星期四</td>
                <td width="16%" >星期五</td>
                <td width="20%" >星期六/星期天</td>
            </tr>
        </thead>
        <tbody id="itemContainer">
        </tbody>
    </table>
    <!-- LIST PART END -->

    <!-- PAGER PART START -->
    <!-- PAGER PART END -->
    </s:form>
</body>


<script type="text/javascript">

$(document).ready(function(){    
    //初始化列表页form表单,"queryForm"是表单id，可修改。
    //initListFormToAjax({formId:"queryForm"}); 
    //if(initDisplaySearchForm()){
       // initDisplayFormToAjax({"formId":'queryForm', "displayType":'month'}); 
    //} 
	if(initModiForm()){
    initDisplayFormToAjax({"formId":'queryForm', "displayType":'month'}); 
    }	
});
function initModiForm(){   
	var menuType=$('#menuType').val();	
    var queryLeaderId_from=$('#queryLeaderId_from').val();
      if(menuType=='leader'){
	     if((queryLeaderId_from!="null")&&(queryLeaderId_from!="")){
		   $('#queryLeaderId').combobox('setValue',queryLeaderId_from);
	     //whirCombobox.setText('queryLeaderId', $('#cUserName').val());
		 }	     
	  } 
      $('#leaderTag').combobox('setValue',$('#leaderTag_from').val());
      $('#workCotent').val($('#workCotent_from').val());  	  
      return true;
}

//在span前增加一个div yucz 20170421
$(document).ready(function(){    
   $(".week_time").before("<div class=""> </div>");
});
</script>

</html>

