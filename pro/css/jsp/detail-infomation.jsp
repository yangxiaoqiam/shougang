<%@ page import="com.whir.org.common.util.SysSetupReader"%>
<!DOCTYPE html>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
<%
SysSetupReader sysRed = SysSetupReader.getInstance();
String skin = sysRed.getBeforeLoginSkin("0");
String logoName="logo.png";
if("red".equals(skin)){
logoName="red-logo.png";
%>
<html lang="zh-cn" class="theme-red pixel-ratio-1" style="overflow: auto;">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
<%}else{%>
<html lang="zh-cn" class="theme-blue pixel-ratio-1" style="overflow: auto;">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
<%}%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/public/include/init.jsp"%>
<%@ page import="com.whir.rd.sggf.webindex.bd.*"%>
<%@ page import="com.whir.common.db.Dbutil"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.whir.common.util.UploadFile"%>
<%@ page import="com.whir.ezoffice.information.infomanager.bd.*"%>
<%@ include file="/public/include/meta_base.jsp"%>
<%@ include file="/public/include/meta_list.jsp"%>
<%String whir_custom_str_new="detail";%>
<%@ include file="/public/include/meta_base_2016.jsp"%>
<%
String infoPicName = request.getAttribute("infoPicName")!=null?request.getAttribute("infoPicName").toString():"";
String infoPicSaveName = request.getAttribute("infoPicSaveName")!=null?request.getAttribute("infoPicSaveName").toString():"";
String infoPicName2 = request.getAttribute("infoPicName2")!=null?request.getAttribute("infoPicName2").toString():"";
String infoPicSaveName2 = request.getAttribute("infoPicSaveName2")!=null?request.getAttribute("infoPicSaveName2").toString():"";
String[] imgs = null;
String[] imgs2 = null;
if(!infoPicName.equals("")){
	imgs = infoPicSaveName.split("\\|");
}

if(!infoPicName2.equals("")){
	imgs2 = infoPicSaveName2.split("\\|");
}


List list=new ArrayList();
String id=request.getAttribute("id").toString();
WebIndexSggfBD webIndexSggfBD=new WebIndexSggfBD();
String [] arr=null;
list = webIndexSggfBD.getInfomation(id);
if(list!=null&&list.size()>0){
arr = (String [])list.get(0);
webIndexSggfBD.updateInfoKits(id,Integer.valueOf(arr[5]));
String strPic = webIndexSggfBD.getInfoPictureAll(id);
String informationType = arr[3];
String content = arr[6];
String displayImage = arr[8];
String informationIssuer=arr[7];
String informationIssueTime=arr[2];
String informationIssueOrg=arr[4];

if(informationIssueOrg.indexOf(".")!=-1){
	String [] arrs=informationIssueOrg.split("\\.");
        if(arrs.length>2){ 
        	informationIssueOrg="";
        	for(int i=2;i<arrs.length;i++){
        		informationIssueOrg += arrs[i]+".";
        	}
        }
}
if(informationIssueOrg.endsWith("."))informationIssueOrg = informationIssueOrg.substring(0,informationIssueOrg.length()-1);

String prevInformationId = request.getAttribute("prevInformationId")!=null?request.getAttribute("prevInformationId").toString():"";
String nextInformationId = request.getAttribute("nextInformationId")!=null?request.getAttribute("nextInformationId").toString():"";

String path = "information";
InformationAccessoryBD accBD = new InformationAccessoryBD();
String historyId = "";
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>信息详细</title>
    <meta charset="utf-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
	<script src="<%=rootPath%>/scripts/main/whir.application_2016.js" language="javascript"></script>
	<%if("grey".equals(skin)){%>
	<link rel="stylesheet" type="text/css" href="<%=rootPath%>/pro/css/gray.css" />
	<%}%>

</head>
<%
if(informationType.equals("2")){
%>
<body>
<script type="text/javascript">
location.href = '<%=content%>';
</script>
</body>
</html>
<%}else{%>
<body onload="Load();">
    <div class="detailbox">
        <div class="gf-detail">
           <div class="detail-close"></div>
        </div>
    </div>

	<div class="wh-wrapper">
    <div class="wh-view wh-detail wh-d-info">
	 <div class="wh-dtl-top" id="info-top-div">
        <div class="container">
          <!-------------  信息所属栏目 ---------------->
		  <div class="wh-dtl-bread">
            <i class="fa fa-circle fa-color"></i>
			<span class="dtl-fst" style="cursor:pointer"><s:property value="#request.channelNameString"/></span>
		</div>
          <!-------------  版本 附件 属性 关联 等下拉结构 start---------------->
         
		  <div class="wh-dtl-nav pull-right">
            <ul class="nav" role="tablist">
              <!-------------------------------------------版本 处理--------------------------------------------->
			  <li id="versionDropdown" role="presentation" class="dropdown">
				<a href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><s:text name="info.detailversion"/><span class="arrow"><em></em></span></a>
                <div class="version dropdown-menu"> 
                  <div class="version-con">
                    <ol id="versionol">
                    </ol>
                  </div>
                </div>
              </li>
            <!-------------------------------------------附件 处理--------------------------------------------->
			<%
			String infoAppendName = request.getAttribute("infoAppendName")!=null?request.getAttribute("infoAppendName").toString():"";
			String infoAppendSaveName = request.getAttribute("infoAppendSaveName")!=null?request.getAttribute("infoAppendSaveName").toString():"";
			%>
			<s:if test="information.forbidCopy != 1">
				<s:if test="information.informationType == 4">
				<%
				infoAppendName += "|"+content+".doc";
				infoAppendSaveName += "|"+content+".doc";
				%>
				</s:if>
				<s:if test="information.informationType == 5">
				<%
				infoAppendName += "|"+content+".xls";
				infoAppendSaveName += "|"+content+".xls";
				%>
				</s:if>
				<s:if test="information.informationType == 6">
				<%
				infoAppendName += "|"+content+".ppt";
				infoAppendSaveName += "|"+content+".ppt";
				%>
				</s:if>
			</s:if>
			<%
				//2013-09-18-----处理附件问题
				if(infoAppendName.startsWith("|")){
					infoAppendName =infoAppendName.substring(1,infoAppendName.length());
				}
				if(infoAppendSaveName.startsWith("|")){
					infoAppendSaveName =infoAppendSaveName.substring(1,infoAppendSaveName.length());
				}
				//2013-09-18-----处理附件问题
				//20160607 -by jqq 统计附件数量
				int appendNum = 0;
				if(infoAppendSaveName !=null && !"".equals(infoAppendSaveName)){
					String[] appendArr = infoAppendSaveName.split("\\|");
					appendNum = appendArr.length;
				}
				
			%>
			<li role="presentation" class="dropdown">
                <a href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><s:text name="info.viewattachment"/><%if(appendNum!=0){%><span class="badge"><%=appendNum%></span><%}%><span class="arrow"><em></em></span></a>
                <div id="infoAppendId" class="doc dropdown-menu">
					<input type="hidden" name="infoAppendName" id="infoAppendName" value="<%=infoAppendName%>"/>
					<input type="hidden" name="infoAppendSaveName" id="infoAppendSaveName" value="<%=infoAppendSaveName%>"/>
					<jsp:include page="/public/upload_2016/uploadify/upload_include.jsp" flush="true">
					   <jsp:param name="dir" value="<%=path%>" />
					   <jsp:param name="uniqueId" value="uploadAppend" />
					   <jsp:param name="realFileNameInputId" value="infoAppendName" />
					   <jsp:param name="saveFileNameInputId" value="infoAppendSaveName" /> 
					   <jsp:param name="canModify" value="no" /> 
					   <jsp:param name="width" value="90" />
					   <jsp:param name="height" value="20" />
					   <jsp:param name="multi" value="true" />  
					   <jsp:param name="buttonClass" value="upload_btn" />
					   <jsp:param name="buttonText" value="上传附件" />
					   <jsp:param name="fileSizeLimit" value="0" /> 
					   <jsp:param name="fileTypeExts" value="" /> 
					   <jsp:param name="uploadLimit" value="0" /> 
					</jsp:include>
					<script type="text/javascript">
					<!--
						<%if(appendNum==0){%>
						$(function(){
							var remindTip2 = '<p style="color:#bababa;">没有上传的附件</p>';
							$("#filesDiv").html(remindTip2);
						}); 
						<%}%>
					//-->
					</script>
                </div>
			</li>
            </ul>
          </div>
		  </div>
		</div>


		<div  class="wh-dtl-con">
		<div class="container">
		<div class="wh-dtl-tit">
			<span style="font-size:28px;line-height:42px;"><s:property value="information.informationTitle"/></span>
		</div>
		  <div class="wh-dtl-meta">
            <!---------------------发布时间  发布人------------------------->
			<div class="meta-l">
              <span class="meta-date"><s:date name="information.informationIssueTime" format="yyyy-MM-dd HH:mm:ss"/></span>
              <strong class="meta-author"><s:text name="info.searchareapublisher"/>：</strong>
              <span class="meta-aname"><%=informationIssueOrg%>.<s:property value="information.informationIssuer"/></span>
            </div>
			 <!---------------------  阅读情况 ------------------------->
            <div class="meta-more meta-r" id="info-moreinfo">
              <a href="javascript:void(0);" class="meta-m-view" onclick="browser();" title='<s:text name="info.ReadCircumstance"/>'><i class="fa fa-eye"></i><span><%=arr[5]%></span></a>
            </div>
          </div>

		<%
			if("1".equals(displayImage)){
			if("0".equals(informationType)||"1".equals(informationType)){
				if(imgs != null){
				for(int i=0;i<imgs.length;i++){
							String img = imgs[i];
							String realSrcUrl = preUrl+"/upload/"+path+"/"+img;
							String smallName = img.substring(0,img.lastIndexOf("."))+"_small"+img.substring(img.indexOf("."),img.length());
							String smallSrcUrl = preUrl+"/upload/"+path+"/"+smallName;
							java.io.File file = new java.io.File(realSrcUrl);
							
							if(!file.exists()){
								realSrcUrl = preUrl+"/upload/"+path+"/"+img.substring(0,6)+"/"+img;
								smallSrcUrl = preUrl+"/upload/"+path+"/"+img.substring(0,6)+"/"+smallName;
							}
		%>
			<div align="center">
				<p><img name="image" src="<%=smallSrcUrl%>" onerror="this.src='<%=realSrcUrl%>';this.onerror=null;" onclick="openRealPic('<%=realSrcUrl%>');" style="cursor:pointer"/></p>
			</div>
		<%
			}}
				}else{	
					if(imgs2 != null){
					for(int i=0;i<imgs2.length;i++){
							String img2 = imgs2[i];
							String realSrcUrl2 = preUrl+"/upload/"+path+"/"+img2;
							String smallName2 = img2.substring(0,img2.lastIndexOf("."))+"_small"+img2.substring(img2.indexOf("."),img2.length());
							String smallSrcUrl2 = preUrl+"/upload/"+path+"/"+smallName2;
							java.io.File file2 = new java.io.File(realSrcUrl2);
							if(!file2.exists()){
								realSrcUrl2 = preUrl+"/upload/"+path+"/"+img2.substring(0,6)+"/"+img2;
								smallSrcUrl2 = preUrl+"/upload/"+path+"/"+img2.substring(0,6)+"/"+smallSrcUrl2;
							}

		%>
		<div align="center">
			<p><img name="image" src="<%=smallSrcUrl2%>" onerror="this.src='<%=realSrcUrl2%>';this.onerror=null;" onclick="openRealPic('<%=realSrcUrl2%>');" style="cursor:pointer"/></p>
		</div>
		<%}}}}%>
		
		<%if("4".equals(informationType)||"5".equals(informationType)||"6".equals(informationType)){%>
		<div class="content_font">
			<form name="webform" method="post">
				<div id="panel3" name="panel3" style="display:none;" align=center>
					<%@ include file="/public/iWebOfficeSign/iWebOfficeVersion2.jsp"%>
				</div>
			</form>
		</div>
		<%}else if("0".equals(informationType)){%>
			<div class="content_font" id="contentDiv">
			<%
			char[] tmp = content.toCharArray();
			for(int i = 0; i < tmp.length; i ++){
				if(tmp[i] == '\n'){
					out.print("<br>");
				}else if(tmp[i] == (char) 32){
					out.print("&nbsp;");
				}else{
					out.print(tmp[i]);
				}
			}%>
			</div>
		<%}else if("3".equals(informationType)){
			
				if(arr[6]!=null&&!"".equals(arr[6])){
				String infoAppendName1 = arr[6].split(":")[0];
				String infoAppendSaveName1 = arr[6].split(":")[1];
				String appendPath = "";
				String verifyCode="";
		        EncryptUtil encryptUtil = new EncryptUtil();
				verifyCode= encryptUtil.getSysEncoderKeyVlaue("FileName", infoAppendSaveName1, "dir");
				appendPath = "/defaultroot/public/download/download.jsp?verifyCode="+verifyCode+"&FileName="+infoAppendSaveName1+"&name="+infoAppendName1+"&path=information";%>
						
			<div class="content_font"><p><a href="<%=appendPath%>" download="<%=infoAppendName1%>"><%=!"".equals(arr[6])?infoAppendName1:"&nbsp;"%></a></p></div>
			<%}}else if("1".equals(informationType)){%>
			<div class="content_font" id="contentDiv" style="z-index:-9999;"><%=!"".equals(arr[6])?arr[6]:"&nbsp;"%></div>
			<%}else{
			    arr[6] = arr[6].replaceAll("<p[^>]+>","<p style='margin-bottom:13px;text-indent:2em;'>");
				arr[6] = arr[6].replaceAll("<span[^>]+>","<span>");
				arr[6] = arr[6].replaceAll("<font[^>]+>","<font>");
				arr[6] = arr[6].replaceAll("<div[^>]+>","<div>");
				arr[6] = arr[6].replaceAll("<ul[^>]+>","<ul>");
				arr[6] = arr[6].replaceAll("<li[^>]+>","<li>");
			%>
			<div class="content_font" style="font-size:16px;line-height:29px;font-family： Arial,'PingFang SC','Hiragino Sans GB','Source Han Sans CN',Roboto,'Microsoft Yahei',sans-serif;"><%=!"".equals(arr[6])?arr[6]:"&nbsp;"%></div>
			<script>
				$("img").css({"display":"block","margin":"0 auto"});
            </script>
		<%}%>
    
		   <style>
		   .wh-dtl-con .container img{max-width:100%;}
		   .gf-detail-fujian{width:100%;}
            .gf-detail-fujian table{ empty-cells: show; border-collapse: collapse;  table-layout: fixed;margin:30px 0;}
             .gf-detail-fujian table td,.gf-detail-fujian table th{border:1px solid #cecccc;padding:0px 10px;height:30px;line-height:30px;}
             .gf-detail-fujian table th{background:#e5e3e3;}
             .gf-detail-fujian table a{    color: #0073c6;}
          </style>
          <div class="gf-detail-fujian">
          	   <table cellpadding="0" cellspacing="0" border="0" width="100%">
          	      	<tr>
          	      		   <th width="10%" align="center" style="text-align:center">序号</th>
          	      		   <th width="80%">附件标题</th>
          	      		   <th width="10%" align="center" style="text-align:center">预览</th>
          	      	</tr>
          	      	<tr>
          	      		 <td align="center">1</td>
          	      		 <td class="fujian-title"><a href="###">附件标题附件标题附件标题附件标题附件标题</a></td>
          	      		 <td class="fujian-yulan" align="center"><a href="###" ><i class="fa fa-eye"></i></a></td>
          	      	</tr>
          	      	<tr>
          	      		 <td align="center">1</td>
          	      		 <td class="fujian-title"><a href="###">附件标题附件标题附件标题附件标题附件标题</a></td>
          	      		 <td class="fujian-yulan" align="center"><a href="###" ><i class="fa fa-eye"></i></a></td>
          	      	</tr>
          	      	<tr>
          	      		 <td align="center">1</td>
          	      		 <td class="fujian-title"><a href="###">附件标题附件标题附件标题附件标题附件标题</a></td>
          	      		 <td class="fujian-yulan" align="center"><a href="###" ><i class="fa fa-eye"></i></a></td>
          	      	</tr>
          	      	<tr>
          	      		 <td align="center">1</td>
          	      		 <td class="fujian-title"><a href="###">附件标题附件标题附件标题附件标题附件标题</a></td>
          	      		 <td class="fujian-yulan" align="center"><a href="###" ><i class="fa fa-eye"></i></a></td>
          	      	</tr>
          	   </table>
          </div>
		<div class="wh-dtl-nav" id="info-next-div">
            <%if(!"".equals(prevInformationId)){%>
			<a id="beforeInfo" class="wh-dtl-btn wh-dtl-prev" href="#" onclick="goNextInfo('<%=prevInformationId%>');"><s:text name="info.beforeinfo"/></a>
			<%}%>
            <s:if test='information.forbidCopy!=1 && #request.canPrint==1'>
			<a id="printpreview" class="wh-dtl-btn wh-dtl-print" href="javascript:void(0);" onclick="printView()"><s:text name="info.printpreview"/></a>
			</s:if>
			<%if(!"".equals(nextInformationId)){%>
			<a id="nextInfo" class="wh-dtl-btn wh-dtl-next" href="#" onclick="goNextInfo('<%=nextInformationId%>');"><s:text name="info.nextinfo"/></a>
			<%}%>
          </div>
		</div>
	 <s:form id="historyForm" name="historyForm" action="Information!historyList.action" method="post" >
		<s:hidden id="informationId" name="information.informationId" />
	</s:form>
    
</body>

</html>

<script>
    $(".detail-close").click(function(){
         window.close(); 
     });
       
<%if("0".equals(informationType)||"1".equals(informationType)){%>
       $(document).ready(function(){
    	   $("#contentDiv").find("p,font,span").attr("name","notable");
   		   $("#contentDiv").find("table").find("p,font,span").attr("name","table");
   		   $("#contentDiv").find("h1").find("p,font,span").attr("name","title");
   		   //$("[name='notable']").removeAttr("style");
   		   $("[name='notable']").css({"font-family":"宋体","font-size":"16px","line-height":"30px","color":"#454545","text-indent":"2em","font-style":"normal","text-decoration":"none","background-color":""});
       });
<%}%>

function FormatImagesSize(w){
  var e=new Image();
  for(i=0;i<document.images.length;i++){
    if (document.images[i]){
	  if(document.images[i].resize!=0){
        e.src=document.images[i].src;
        if (e.width>w) {
		  var pic=document.images[i];
		  pic.width=w;
		  pic.style.width="";
		  pic.style.height="";
          //pic.title="";
          //pic.style.cursor="hand";
          //pic.onclick=function(){}
		}
	  }
    }
  }
}

function goNextInfo(id){
	whir_tips('',1,'',function(){
				location_href('/defaultroot/WebIndexSggfBD!detailInfomation.action?id='+id);
			});

}

//点击版本下拉菜单，加载版本数据
$('#versionDropdown').on('show.bs.dropdown', function () {
  var html = "";
  //最新版本信息
	var informationId = '<s:property value="information.informationId"/>';
	var formId = "historyForm";
	var moditime = '<s:property value="information.informationModifyTime"/>';
	var issuemen = '<s:property value="information.informationIssuer"/>';
	var issuemen2 = '';
	var modimen = '<s:property value="information.inforModifyMen"/>';
	var modimen2 = '';
	if(issuemen!=null && issuemen!='' && issuemen.length>8){
		issuemen2 = issuemen.substring(0,8)+'...';
	}
	if(modimen!=null && modimen!='' && modimen.length>8){
		modimen2 = modimen.substring(0,8)+'...';
	}
	//分页参数等html、公共js事件绑定
	initList(formId);
 	var jq_form = $('#'+formId);
	jq_form.ajaxForm({
		success:function(responseText){
			if(responseText!=null && responseText!=""){
				//解析服务器返回的json字符串
				var json = eval("("+responseText+")").data;
				var data = json.data;
				//如果只有当前第一个版本，则版本图标不带有箭头：<i>↑</i>
				if(data.length == 0){
					//如果没有版本修改，则仅一个版本
					if(moditime == null || moditime == ''){
						html = '<li id="lastest-li" class="current"><a href="javascript:void(0);" class="clearfix"><em><s:property value="information.informationVersion"/></em><p><span title="'+issuemen+'"><s:text name="info.viewmodifier"/>：'+(issuemen2=='' ? issuemen : issuemen2 )+'</span><span><s:text name="info.viewpubtime"/>：<s:date name="information.informationIssueTime" format="yyyy-MM-dd HH:mm:ss"/></span></p></a></li>';
					}else{
						//如果有版本修改，但历史版本被删除，最后版本取修改人与时间
						html = '<li id="lastest-li" class="current"><a href="javascript:void(0);" class="clearfix"><em><s:property value="information.informationVersion"/></em><p><span title="'+modimen+'"><s:text name="info.viewmodifier"/>：'+(modimen2=='' ? modimen : modimen2 )+'</span><span><s:text name="info.viewpubtime"/>：<s:date name="information.informationModifyTime" format="yyyy-MM-dd HH:mm:ss"/></span></p></a></li>';
					}
				}else{
					if('<%=historyId%>' == ''){
						html = '<li id="lastest-li" class="current"><a href="javascript:void(0);" class="clearfix"><em><s:property value="information.informationVersion"/></em><p><span title="'+modimen+'"><s:text name="info.viewmodifier"/>：'+(modimen2=='' ? modimen : modimen2 )+'</span><span><s:text name="info.viewpubtime"/>：<s:date name="information.informationModifyTime" format="yyyy-MM-dd HH:mm:ss"/></span></p></a><i class="arrowtip">&#8593;</i></li>';
					}else{
						html = '<li id="lastest-li"><a href="javascript:void(0);" class="clearfix"><em><s:property value="information.informationVersion"/></em><p><span title="'+modimen+'"><s:text name="info.viewmodifier"/>：'+(modimen2=='' ? modimen : modimen2 )+'</span><span><s:text name="info.viewpubtime"/>：<s:date name="information.informationModifyTime" format="yyyy-MM-dd HH:mm:ss"/></span></p></a><i class="arrowtip">&#8593;</i></li>';
					}
						
				}
				//循环数据信息
				for (var i=0; i<data.length; i++) {
					var po = data[i];
					var li = '';
					//查看历史页面，对应版本高亮显示
					if('<%=historyId%>' == po.historyId){
						li = '<li class="current"><a href="javascript:void(0);" class="clearfix" >';
					}else{
						li = '<li><a href="javascript:void(0);" class="clearfix" >';
					}
					//var li = '<li><a href="javascript:void(0);" class="clearfix" onclick="historyView(\''+po.historyId+'\',\''+po.historyVersion+'\')">';
					li += '<em>'+po.historyVersion+'</em>';
					var issuename2 = '';
					if(po.historyIssuerName!=null && po.historyIssuerName!='' && po.historyIssuerName.length>8){
						issuename2 = po.historyIssuerName.substring(0,8)+'...';;
					}
					li += '<p><span title="'+po.historyIssuerName+'"><s:text name="info.viewmodifier"/>：'+(issuename2=='' ? po.historyIssuerName : issuename2 )+'</span><span><s:text name="info.viewpubtime"/>：'+po.historyTime+'</span></p>';
					//最后一个版本后面不加箭头
					if(i == data.length -1){
						li += '</a>';
						
						li += '</li>';
					}else{
						li += '</a><i class="arrowtip">&#8593;</i>';
						
						li += '</li>';
					}
					html += li;
				}
				$("#versionol").html(html);
			}
		},
		error:function(XMLHttpRequest, textStatus, errorThrown){
			$.dialog({id:"Tips"}).close();
			$.dialog.alert(comm.loadfailure,function(){});
		}
	}); 
	//初次提交表单获得数据
	$("#"+formId).submit();
});

//关闭下拉菜单时候
$('#versionDropdown').on('hide.bs.dropdown', function () {
	var html = "";
	$("#versionol").html(html);
});


function printView(){
	var informationId = "<s:property value='information.informationId'/>";
	openWin({url:'/defaultroot/WebIndexSggfBD!detailInfomation.action?printPreview=1&id='+informationId,isFull:true,winName:"printPreview"});
}



FormatImagesSize(800);

function Load(){
	<%if("4".equals(informationType)){%>
    webform.WebOffice.WebUrl="http://<%=request.getServerName()+":"+request.getServerPort()%><%=rootPath%>/officeserverservlet";
    webform.WebOffice.RecordID="<%=content%>";
    webform.WebOffice.Template="";
    webform.WebOffice.FileName="<%=content%>.doc";
    webform.WebOffice.FileType=".doc";
    webform.WebOffice.EditType="-1,2,0,0,0,0,0,0";
    webform.WebOffice.UserName="ezoffice";
    webform.WebOffice.showMenu = "0";
    webform.WebOffice.EnablePrint ="-1,2,0,0,0,0,0,0";
    webform.WebOffice.WebOpen();
    webform.WebOffice.ShowType="1";

    WebToolsVisible('Standard',false);  //标准
    WebToolsVisible('Formatting',false);  //格式

    WebToolsVisible('Tables and Borders',false);  //表格和边框
    WebToolsVisible('Database',false);  // 数据库
    WebToolsVisible('Drawing',false);  //绘图
    WebToolsVisible('Forms',false);  //窗体
    WebToolsVisible('Visual Basic',false);  //Visual Basic
    WebToolsVisible('Mail Merge',false);  //邮件合并
    WebToolsVisible('Extended Formatting',false);  //其它格式
    WebToolsVisible('AutoText',false);  //自动图文集
    WebToolsVisible('Web',false);  //Web
    WebToolsVisible('Picture',false);  //图片
    WebToolsVisible('Control Toolbox',false); //控件工具箱
    WebToolsVisible('Web Tools',false);  //Web工具箱
    WebToolsVisible('Frames',false);//  框架集
    WebToolsVisible('WordArt',false);  //艺术字

    WebToolsVisible('符号栏',false);  //符号栏
    WebToolsVisible('Outlining',false); // 大纲
    WebToolsVisible('E-mail',false); //电子邮件
    WebToolsVisible('Word Count',false); //字数统计

    //隐藏按钮
    webform.WebOffice.VisibleTools("新建文件",false); //隐藏“新建文件”功能按钮
    webform.WebOffice.VisibleTools("打开文件",false); //隐藏“打开文件”功能按钮
    webform.WebOffice.VisibleTools("保存文件",false);
    webform.WebOffice.VisibleTools("文字批注",false);
    webform.WebOffice.VisibleTools("手写批注",false);
    webform.WebOffice.VisibleTools("文档清稿",false);
    webform.WebOffice.VisibleTools("重新批注",false);

    ShowRevision(false);

    document.all.panel3.style.display="";

    <%}else if("5".equals(informationType)){%>
    webform.WebOffice.WebUrl="http://<%=request.getServerName()+":"+request.getServerPort()%><%=rootPath%>/officeserverservlet";
    webform.WebOffice.RecordID="<%=content%>";
    webform.WebOffice.Template="";
    webform.WebOffice.FileName="<%=content%>.xls";
    webform.WebOffice.FileType=".xls";
    webform.WebOffice.EditType="-1,2,0,0,0,0,0,0";
    webform.WebOffice.UserName="ezoffice";
    webform.WebOffice.showMenu = "0";
    webform.WebOffice.EnablePrint ="-1,2,0,0,0,0,0,0";

    webform.WebOffice.WebOpen();  	//打开该文档    交互OfficeServer的OPTION="LOADTEMPLATE"
    webform.WebOffice.ShowType="1";
    //StatusMsg(webform.WebOffice.Status);
    WebToolsVisible('Standard',false);  //标准
    WebToolsVisible('Formatting',false);  //格式

    WebToolsVisible('Tables and Borders',false);  //表格和边框
    WebToolsVisible('Database',false);  // 数据库
    WebToolsVisible('Drawing',false);  //绘图
    WebToolsVisible('Forms',false);  //窗体
    WebToolsVisible('Visual Basic',false);  //Visual Basic
    WebToolsVisible('Mail Merge',false);  //邮件合并
    WebToolsVisible('Extended Formatting',false);  //其它格式
    WebToolsVisible('AutoText',false);  //自动图文集
    WebToolsVisible('Web',false);  //Web
    WebToolsVisible('Picture',false);  //图片
    WebToolsVisible('Control Toolbox',false); //控件工具箱
    WebToolsVisible('Web Tools',false);  //Web工具箱
    WebToolsVisible('Frames',false);//  框架集
    WebToolsVisible('WordArt',false);  //艺术字

    WebToolsVisible('符号栏',false);  //符号栏
    WebToolsVisible('Outlining',false); // 大纲
    WebToolsVisible('E-mail',false); //电子邮件
    WebToolsVisible('Word Count',false); //字数统计

    //隐藏按钮
    webform.WebOffice.VisibleTools("新建文件",false); //隐藏“新建文件”功能按钮
    webform.WebOffice.VisibleTools("打开文件",false); //隐藏“打开文件”功能按钮
    webform.WebOffice.VisibleTools("保存文件",false);
    webform.WebOffice.VisibleTools("文字批注",false);
    webform.WebOffice.VisibleTools("手写批注",false);
    webform.WebOffice.VisibleTools("文档清稿",false);
    webform.WebOffice.VisibleTools("重新批注",false);


    ShowRevision(false);
    document.all.panel3.style.display="";

    <%}else if("6".equals(informationType)){%>
    webform.WebOffice.WebUrl="http://<%=request.getServerName()+":"+request.getServerPort()%><%=rootPath%>/officeserverservlet";
    webform.WebOffice.RecordID="<%=content%>";
    webform.WebOffice.Template="";
    webform.WebOffice.FileName="<%=content%>.ppt";
    webform.WebOffice.FileType=".ppt";
    webform.WebOffice.EditType="-1,2,0,0,0,0,0,0";
    webform.WebOffice.UserName="ezoffice";
    webform.WebOffice.showMenu = "0";
    webform.WebOffice.EnablePrint ="-1,2,0,0,0,0,0,0";

    webform.WebOffice.WebOpen();  	//打开该文档    交互OfficeServer的OPTION="LOADTEMPLATE"
    //StatusMsg(webform.WebOffice.Status);
    WebToolsVisible('Standard',false);  //标准
    WebToolsVisible('Formatting',false);  //格式

    WebToolsVisible('Tables and Borders',false);  //表格和边框
    WebToolsVisible('Database',false);  // 数据库
    WebToolsVisible('Drawing',false);  //绘图
    WebToolsVisible('Forms',false);  //窗体
    WebToolsVisible('Visual Basic',false);  //Visual Basic
    WebToolsVisible('Mail Merge',false);  //邮件合并
    WebToolsVisible('Extended Formatting',false);  //其它格式
    WebToolsVisible('AutoText',false);  //自动图文集
    WebToolsVisible('Web',false);  //Web
    WebToolsVisible('Picture',false);  //图片
    WebToolsVisible('Control Toolbox',false); //控件工具箱
    WebToolsVisible('Web Tools',false);  //Web工具箱
    WebToolsVisible('Frames',false);//  框架集
    WebToolsVisible('WordArt',false);  //艺术字

    WebToolsVisible('符号栏',false);  //符号栏
    WebToolsVisible('Outlining',false); // 大纲
    WebToolsVisible('E-mail',false); //电子邮件
    WebToolsVisible('Word Count',false); //字数统计

    //隐藏按钮
    webform.WebOffice.VisibleTools("新建文件",false); //隐藏“新建文件”功能按钮
    webform.WebOffice.VisibleTools("打开文件",false); //隐藏“打开文件”功能按钮
    webform.WebOffice.VisibleTools("保存文件",false);
    webform.WebOffice.VisibleTools("文字批注",false);
    webform.WebOffice.VisibleTools("手写批注",false);
    webform.WebOffice.VisibleTools("文档清稿",false);
    webform.WebOffice.VisibleTools("重新批注",false);

    //ShowRevision(false);
    document.all.panel3.style.display="";
    // webform.WebOffice.WebSlideShow();
    <%}%>
}

function WebToolsVisible(ToolName,Visible){
    try{
    webform.WebOffice.WebToolsVisible(ToolName,Visible);
    StatusMsg(webform.WebOffice.Status);
    }catch(e){}
}

//作用：显示操作状态
function StatusMsg(mString){
    StatusBar.innerText=mString;
}

function ShowRevision(mValue){
}

</script>
<%}}%>