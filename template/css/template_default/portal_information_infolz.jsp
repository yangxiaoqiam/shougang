<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/public/include/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.whir.ezoffice.information.infomanager.bd.*"%>
<%@ page import="com.whir.common.util.UploadFile"%>
<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache");
response.setDateHeader ("Expires", 0);

String categoryName = request.getParameter("categoryName");
String title = request.getParameter("title")==null?"":request.getParameter("title").toString();
Object[] obj = request.getAttribute("po")==null?null:(Object[])request.getAttribute("po");
java.text.SimpleDateFormat sf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
String informationId = obj[0].toString();
String informationType = (String)obj[5];
String content = obj[2]!=null?obj[2].toString():"";
String displayImage = obj[6]!=null?obj[6].toString():"";
String channelName= obj[8]!=null?obj[8].toString():"";
String channelId= obj[9]!=null?obj[9].toString():"";
String informationIssuer=obj[3]!=null?obj[3].toString():"";
String informationIssueTime=obj[4]!=null?obj[4].toString():"";
String informationIssueOrg=obj[10]!=null?obj[10].toString():"";
InformationAccessoryBD accBD = new InformationAccessoryBD();
List listAcc = null;
if(!"0".equals(displayImage)){
    listAcc = accBD.getAccessory(informationId);
}
if(informationIssueOrg.indexOf(".")!=-1){
	String [] arrs=informationIssueOrg.split("\\.");
        if(arrs.length>0){
        	informationIssueOrg=arrs[arrs.length-1];
        }
}
Date IssDate=sf.parse(informationIssueTime);
informationIssueTime=sf.format(IssDate);
title = obj[1].toString();
title = title.replaceAll("<","&lt;").replaceAll(">","&gt;");
int smartInUse = 0;
//java.util.Map sysMap = com.whir.org.common.util.SysSetupReader.getInstance().getSysSetupMap("0");
if(sysMap != null && sysMap.get("附件上传") != null){
    smartInUse = Integer.parseInt(sysMap.get("附件上传").toString());
}
String fileServer = com.whir.component.config.ConfigReader.getFileServer(request.getRemoteAddr());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<title><%=title%></title>
<script type="text/javascript" src="<%=rootPath%>/scripts/jquery-1.11.1.min.js"></script>

 <%@ include file="/public/include/meta_base.jsp"%>
 <%@ include file="/public/include/meta_list.jsp"%>
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
		openWin({url:whirRootPath+"/BeforeInfoAction!infolist.action?infokey2=" + encodeURIComponent(infokey)+"&channelIds=21461,22389,22315,22479,21477,21510,42928,22058,22452,22462,22285,22287,22289,43464,22471",isFull:'true',winName: 'searchInfo'});

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
            <div class="erji-fr-box  detail-contact-width fr">
                <div class="erji-fr fr ">
                    <div class="location clearfix ">
                        <p>您当前的位置：<a target="_blank" href="/defaultroot/beforelz.jsp">首页</a><i>&gt;</i><a href="javascript:void(0);"><%if("21781".equals(channelId)||"21816".equals(channelId)||"21852".equals(channelId)||"21879".equals(channelId)||"21915".equals(channelId)||"21935".equals(channelId)||"21937".equals(channelId)||"21939".equals(channelId)||"21943".equals(channelId)||"21949".equals(channelId)){%>规章制度&nbsp;>&nbsp;<%}%><%=channelName%></a></p>
                    </div>
                     <div class="detail-contact">
            <p style="text-align:center" class="detail-title"><%=title%></p>
            <p style="text-align:center" class="time"><span><%=informationIssueTime%></span> &nbsp;&nbsp;&nbsp;<%=informationIssueOrg%> ：<%=informationIssuer%></p>
            <div class="juti" id="content">
				 <%if(!"0".equals(displayImage)){%>
		<div align="center">
		<%
			String imageName = "";
			for(int i=0;i<listAcc.size();i++){
				Object[] objAcc = (Object[]) listAcc.get(i);
				if (((Integer) objAcc[4]).intValue() == 1) {
					imageName = objAcc[2].toString(); //标记已找到图片,标记为附件名称
					String datePath = imageName.substring(0,6);
					String subFolder = "";
					if(smartInUse==0){
						com.whir.common.util.UploadFile upFile = new com.whir.common.util.UploadFile();
						subFolder = upFile.getSubFolder(imageName);
						if(subFolder.length()>0){
							subFolder += "/";
						}
					}
					imageName=(smartInUse==1?rootPath+"/upload/information/"+datePath+"/"+imageName:fileServer+"/upload/information/"+subFolder+imageName);
		%>
			<img src="<%=imageName%>" />
		<%
				}
			}
		%>
		</div>
        <%}%>
        <%if("4".equals(informationType)||"5".equals(informationType)||"6".equals(informationType)){%>
        <div class="content_font">
            <form name="webform" method="post">
            <div id="panel3" name="panel3" style="display:none;" align=center>
                <%@ include file="/public/iWebOfficeSign/iWebOfficeVersion2.jsp"%>
            </div>
            </form>
        </div>
        <%}else if("0".equals(informationType)){%>
        <div class="content_font">
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
            }
        %>
        </div>
        <%}else if("3".equals(informationType)){
			UploadFile upFile = new UploadFile();
			String fileType = obj[2]!=null && obj[2].toString().endsWith(".pdf") ? "pdf" :"";
			if(fileType.equals("pdf")){
				String saveName = obj[2].toString().split(":")[1];
				String subFolder = saveName.substring(0,6);
				String encrypt = upFile.getFileEncrypt(saveName);
				if("1".equals(encrypt)){
					String localPath = session.getServletContext().getRealPath("upload");
					String decode = localPath+"\\information\\"+subFolder+"\\"+"decode-"+saveName;
					String file = localPath+"\\information\\"+subFolder+"\\"+saveName;
					File decodeFile = new File(decode);
					if(!decodeFile.exists()){
						BufferedInputStream input = new BufferedInputStream(new FileInputStream(file));
						BufferedOutputStream output = new BufferedOutputStream(new FileOutputStream(decodeFile));
						byte[] buf = new byte[8192];
						int n = -1;
						while( -1 != (n = input.read(buf, 0, buf.length))) {
							for(int i0 = 0; i0 < n; i0++) {
								buf[i0] = (byte)(buf[i0] + 1);
							}
							output.write(buf, 0, n);
						}
						output.flush();
					}
					saveName = "decode-"+saveName;
				}
		%>
		<div align="center">
			<iframe name="dd" src="<%=rootPath%>/modules/govoffice/gov_documentmanager/viewPDF.jsp?url=<%=preUrl%>/upload/information/<%=subFolder+"/"+saveName%>" frameborder=0 style="width:900px;height:630px;" border=0></iframe>
		</div>
		<%	}else{%>
        <div class="content_font"><%=obj[2]!=null?(obj[2].toString().indexOf(":")!=-1?obj[2].toString().split(":")[0]:obj[2].toString()):"&nbsp;"%></div>
        <%}}else{%>
        <div class="content_font"><%=obj[2]!=null?obj[2].toString():"&nbsp;"%></div>
        <%}%>
		
		<!-------------------- 附件处理 start --------------------->
		<div>
		
		<%
		//附件处理
		List appendList = accBD.getAccessory(informationId);
		String infoPicName = "";
		String infoPicSaveName = "";
		String infoAppendName = "";
		String infoAppendSaveName = "";
		Object[] appendTmp = null;
		String appendPath = "";
		String verifyCode="";
		EncryptUtil encryptUtil = new EncryptUtil();
		if (appendList != null&&appendList.size()>0) {
			
			int j=0;
			for (int i = 0; i < appendList.size(); i++) {
				appendTmp = (Object[]) appendList.get(i);
				if(appendTmp!=null && appendTmp[1]!=null){
					if (appendTmp[4].toString().equals("1")) {
						//infoPicName += appendTmp[1].toString()+"|";
						//infoPicSaveName += appendTmp[2].toString()+"|";
					} else {
						j=j+1;
						
						infoAppendName = appendTmp[1].toString();
						infoAppendSaveName = appendTmp[2].toString();
						verifyCode= encryptUtil.getSysEncoderKeyVlaue("FileName", infoAppendSaveName, "dir");
						appendPath = "/defaultroot/public/download/download.jsp?verifyCode="+verifyCode+"&FileName="+infoAppendSaveName+"&name="+infoAppendName+"&path=information";
						if(j==1){
							%>
							<p><strong>附件：</strong><a href="<%=appendPath%>" download="<%=infoAppendName%>"><%=infoAppendName%></a></p>
						<%
						}else{
							%>
							<p><a href="<%=appendPath%>" download="<%=infoAppendName%>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=infoAppendName%></a></p>
							<%
						}
					}
				}
			}
		}%>
		
		</div>
		<!-------------------- 附件处理 end --------------------->
            </div>
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
			
			<%if("1".equals(informationType)){%>
			//信息内容默认字体
			$("#content").find("p,font,span").removeAttr("style");
			$("#content").find("p,font,span").attr("style","font-family:宋体; font-size:16px;line-height:30px;font-size:16px;color:#454545;text-indent: 2em;");
			<%}%>
	   });
        </script>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
<!--
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
//-->
</SCRIPT>
<%}%>