<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/public/include/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="com.whir.ezoffice.portal.bd.*"%>
<%@ page import="com.whir.ezoffice.portal.po.*"%>
<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache");
response.setDateHeader ("Expires", 0);

String id = request.getParameter("id");
PortalBD bd = new PortalBD();
String menuName = "";
List menuList = null;
if(id!=null&&!"".equals(id)&&!"null".equals(id)){
    menuList = bd.getXJMenuByMenuId(id);//二级菜单
    PortalMenuPO mpo = bd.loadMenu(new Long(id));
    menuName = mpo.getName();
}
//20160428 -by jqq 安全性漏洞改造
String skin = EncryptUtil.replaceHtmlcode(request,"skin");
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>图片新闻</title>
<link href="<%=rootPath%>/<%=skin%>/menu/css/css_whir.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=rootPath%>/scripts/jquery-1.11.1.min.js"></script>
<SCRIPT LANGUAGE="JavaScript" src="<%=rootPath%>/scripts/desktop/desktop.js"></SCRIPT>
<script language="javascript" type="text/javascript">
function reSetIframe() {
    var iframe = document.getElementById("divIfameId01");
    try {
        gg();
        var bHeight = iframe.contentWindow.document.body.scrollHeight;
        var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
        var height = Math.max(bHeight, dHeight);
        iframe.height = height;
    } catch (ex) { }
}

function gg() {
    var iframe = document.getElementById("divIfameId01");//注意这里的ID为menu_products_new，跟iframe的ID要对应
    iframe.height =500;//100;
 
}
</script>
</head>
<body class="MainFrameBox">
<div class="mainbox">
    <div class="main_nr1">
        <div class="">   
            <div class="left_bg" align="center">
                <table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr valign="top">
                        <td width="221" class="left_nr">
                            <div class="title01"><%=menuName%></div>
                            <div class="menu_nr">
<%
String firstUrl = "about:blank";
if(menuList!=null){
    for(int i0=0; i0<menuList.size(); i0++){
        PortalMenuPO mpo = (PortalMenuPO)menuList.get(i0);
        String _href = "javascript:void(0);";
        String mid = mpo.getId()+"";
        String linkUrl = mpo.getLinkUrl();
        String menuType = mpo.getMenuType();
        String menuId = mpo.getMenuId()+"";
		//String viewType = mpo.getViewType();
        if("1".equals(mpo.getLinkType())){
            if(linkUrl!=null){
                if(!linkUrl.trim().startsWith("http://")){
                    _href = "http://" + linkUrl.trim();
                }else{
                    _href = linkUrl.trim();
                }
            }

            if("3".equals(menuType)){
				//if(viewType.equals("0")){//列表显示
					_href = rootPath + "/PortalInformation!informationList.action?channelId="+menuId+"&mid="+mid;
				//}else{//图片显示
				//	_href = rootPath + "/PortalMenuThumb!childThumbList.action?id="+mid;
				//}
            }else if("4".equals(menuType)){
                _href = rootPath + "/PortletForumAction!forumTopicList.action?forumClassId="+menuId+"&mid="+mid;
            }

            if(firstUrl.equals("about:blank")&&!_href.equals("javascript:void(0);"))firstUrl=_href;
        }
%>
                                <h1 class="<%=mpo.getId().equals(id)?"on":(i0==0?"on":"")%>"><a href="<%=_href%>" <%if("0".equals(mpo.getLinkType())){%>onclick="clicked('<%=id%>','<%=mpo.getLinkUrl()%>','<%=mpo.getMenuType()%>','<%=mpo.getMenuId()%>','','<%=mpo.getLinkType()%>');"<%}%> target="divIfameId01" onclick="setH1Css(this,'<%=mpo.getId()%>');"><%=mpo.getName()%></a></h1>
								<div class="divh2" id="divh2<%=mpo.getId()%>" style="<%=mpo.getId().equals(id)?"":(i0==0?"":"display:none;")%>">
<%	
		List menuList1 = bd.getXJMenuByMenuId(mid);
		if(menuList1!=null){
			for(int j=0; j<menuList1.size(); j++){
				PortalMenuPO mpo1 = (PortalMenuPO)menuList1.get(j);
				String _href1 = "javascript:void(0);";
				String mid1 = mpo1.getId()+"";
				String linkUrl1 = mpo1.getLinkUrl();
				String menuType1 = mpo1.getMenuType();
				String menuId1 = mpo1.getMenuId()+"";
				//String viewType1 = mpo1.getViewType();
				if("1".equals(mpo1.getLinkType())){
					if(linkUrl1!=null){
						if(!linkUrl1.trim().startsWith("http://")){
							_href1 = "http://" + linkUrl1.trim();
						}else{
							_href1 = linkUrl1.trim();
						}
					}

					if("3".equals(menuType1)){
						//if(viewType1.equals("0")){//列表显示
							_href1 = rootPath + "/PortalInformation!informationList.action?channelId="+menuId1+"&mid="+mid1;
						//}else{//图片显示
						//	_href1 = rootPath + "/PortalMenuThumb!childThumbList.action?id="+mid1;
						//}
					}else if("4".equals(menuType1)){
						_href1 = rootPath + "/PortletForumAction!forumTopicList.action?forumClassId="+menuId1+"&mid="+mid1;
					}

					if(firstUrl.equals("about:blank")&&!_href1.equals("javascript:void(0);"))firstUrl=_href1;
				}
				%>
				<h2 class="<%=mpo1.getId().equals(mid1)?"on":(j==0?"on":"")%>"><a href="<%=_href1%>" <%if("0".equals(mpo1.getLinkType())){%>onclick="clicked('<%=id%>','<%=mpo1.getLinkUrl()%>','<%=mpo1.getMenuType()%>','<%=mpo1.getMenuId()%>','','<%=mpo1.getLinkType()%>');"<%}%> target="divIfameId01"><%=mpo1.getName()%></a></h2>
				<%
			}
		}
		%>
								</div>
		<%
	}
}
%>
                            </div>    
                        </td>
    
                        <td width="3"></td>
                        <td class="right_nr1">
                            <iframe id="divIfameId01" name="divIfameId01" width="100%" height="500" marginwidth="0" marginheight="0" hspace="0" vspace="0" frameborder="0" scrolling="no" allowtransparency="true" src="<%=firstUrl%>"></iframe>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="clear_1"></div>
    </div>
</div>
</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
<!--
$(parent.document).find("#MainDesktop").load(function(){
    var main = $(parent.document).find("#MainDesktop");
    var thisheight = $(document).height()+30;
    main.height(document.documentElement.scrollHeight);

    if(main.height()<550){
        //$(main).height(550);
    }
});

function clicked(id,linkURL,menuType,menuId,hasChild,linkType){
	if(menuType=='0'){
		if(linkURL.indexOf("http://")>-1){
		}else{
			linkURL="http://"+linkURL;
		}
		window.open(linkURL, '', '');
	}else if(menuType=='3'){
		window.open("<%=rootPath%>/PortalInformation!informationList.action?channelId="+menuId+"&mid="+id);
	}else if(menuType=='4'){
		window.open("<%=rootPath%>/PortletForumAction!forumTopicList.action?forumClassId="+menuId+"&mid="+id);
	}
}

function setHeight(){
    var main = $(parent.document).find("#MainDesktop");
    var divIfameId01 = $(document).find("#divIfameId01");
    
    var thisheight = $(document).height()+130;
    //main.height(600);//default

    //alert(document.all.divIfameId01.document.documentElement.scrollHeight);
    //alert(document.all.divIfameId01.readyState);
    if(document.all.divIfameId01.readyState!='complete'){
        window.setTimeout('setHeight()', 500);
    }else{
        if(main.height()<divIfameId01.height()){
            $(main).height(divIfameId01.height() + 30);
        }
        if(main.height()<550){
            //$(main).height(550);
        }
    }
}

function setH1Css(obj,id){
    $('.on').each(function(){
        $(this).removeClass('on');
    });
    $(obj).parent().addClass('on');
	$('.divh2').each(function(){
        $(this).hide();
    });
	$("#divh2"+id).show();
    setHeight();
}
//-->
</SCRIPT>