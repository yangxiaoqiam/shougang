<%@page import="com.whir.ezoffice.commonBD.CommonBD"%>
<%
CommonBD commonBD = new CommonBD();
%>
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
					String infokeyForsearch = request.getAttribute("infokey") == null?"":request.getAttribute("infokey").toString();
					String position = request.getParameter("position") == null?"":request.getParameter("position").toString();

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
			<a target="_blank" href="/defaultroot/beforesale.jsp">营销管理部</a>
			<a target="_blank" href="/defaultroot/beforelz.jsp" style="border-bottom: none;">首钢冷轧公司</a>
		</div>
      </li>
      <li class="t4">
        <a >
          <em></em>
          <span>常用链接</span>
        </a>
       <!--常用系统公共页面-->
	  <%@ include file="/rd/info/index_pre_cyxt.jsp"%>
      </li>
		<li class="t5">
                <a href="/defaultroot/help/help_set.html"  target="_blank">
                    <em></em>
                    <span>帮助</span>
                </a>
         </li>
    </ul>
  </div>
  <div class="pro-header">
            <div class="pro-container clearfix">
                <a class="pro-logo"  href="/defaultroot/index_pre.jsp" ><img src="/defaultroot/pro/img/<%=logoName%>" /></a>
                <ul class="clearfix">
                    <li id="sy" name="nav" class="current">
                        <a href="/defaultroot/index_pre.jsp">
                            <em class="nav1"></em>
							<span>首页</span>
                        </a>
                    </li>
                    <li id="gzzd" name="nav">
                        <a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=114132&startPage=1&pageSize=12&position=gzzd&orgId=<%=orgId%>">
						<em class="nav2"> </em>
						<span>规章制度 </span>
                    </a>
                        <dl>
							<dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=240672&startPage=1&pageSize=12&position=gzzd&orgId=<%=orgId%>">股份公司级</a></dd>
                            <dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=240688&startPage=1&pageSize=12&position=gzzd&orgId=<%=orgId%>">职能部门级</a></dd>
							<dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=398610&startPage=1&pageSize=12&position=gzzd&orgId=<%=orgId%>">作业部级</a></dd>
                        </dl>
                    </li>

					<li id="lzjs" name="nav">
                   <a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23784&startPage=1&pageSize=12&position=lzjs&orgId=<%=orgId%>">
                        <em class="nav5"></em>
                        <span>廉政建设</span>
                    </a>
					 <dl>
						<dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23790&startPage=1&pageSize=12&position=lzjs&orgId=<%=orgId%>">工作动态</a></dd>
                        <dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23792&startPage=1&pageSize=12&position=lzjs&orgId=<%=orgId%>">警钟长鸣</a></dd>
						<dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23794&startPage=1&pageSize=12&position=lzjs&orgId=<%=orgId%>">党纪法规</a></dd>
						<dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23803&startPage=1&pageSize=12&position=lzjs&orgId=<%=orgId%>">廉政制度</a></dd>
						<dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23811&startPage=1&pageSize=12&position=lzjs&orgId=<%=orgId%>">反腐在线</a></dd>
						<dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23815&startPage=1&pageSize=12&position=lzjs&orgId=<%=orgId%>">廉洁文化</a></dd>
						<dd><a href="/defaultroot/BeforeInfoAction!getInformationListBF.action?type=gfgs&channelId=23848&startPage=1&pageSize=12&position=lzjs&orgId=<%=orgId%>">学习交流</a></dd>
                    </dl>
				  </li>
                    <li id="txl" name="nav">
                        <a href="/defaultroot/WebIndexSggfBD!getTxlList.action?position=txl">
                            <em class="nav3"></em>
                            <span> 通讯录 </span>
                        </a>
                    </li>
                 </ul>

				 <div class="fixed-sys fr">
                <div class="t4">
                    <a href="javascript:void(0)">
                        <em></em>
                        <span>常用链接</span>
                    </a>
                     <!--常用系统公共页面-->
					<%@ include file="/rd/info/index_pre_cyxt.jsp"%>
                </div>
            </div>
			<div class="header-search">
                    <div class="search-form clearfix">
                        <form action="WebIndexSggfBD!infolist.action" method="post" name="searchForm" id="searchForm">
							<input type="text" class="search-text" id="infokey" name="infokey" value="请输入文字" onfocus="this.value=''" onblur="if(this.value==''){this.value='请输入文字'}" onkeydown="if(event.keyCode==13)javascript:SearchInformation();">
							<input type="hidden" name="channelIds" id="channelIds" value="80707,23683,23656,80245,23864,23868,23872,23876,23878">
							<input type="hidden" name="orgId" id="orgId" value="<%=orgId%>">
                            <input type="button" name="" value="" style="cursor: pointer;" class="search-btn" onclick="SearchInformation();"/>
                        </form>
                    </div>
                    <button onclick="javascript:clearfeedBack();">登录</button>
                </div>
            </div>
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
                        <input type="password" name="userPassword" id="userPassword" class="fr" autocomplete="off" onkeydown="if(event.keyCode==13)javascript:submitForm();"/>
						<input type="hidden" id="userPasswordTemp" name="userPasswordTemp"/>
						<input type="hidden" id="time" name="time"/>
                    </div>
                    <%if("1".equals(useCaptcha)||(inputPwdErrorNum>2 && "2".equals(useCaptcha))){%>
						 <div class="ban before-username clearfix captchaAnswer-a">
							<input type="text" name="captchaAnswer" id="captchaAnswer" class="fr" style="width: 175px;"/>
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
						<li style="width:50%;text-align:left;letter-spacing:8px;" ><a href="/defaultroot/public/edit/logindownload/Logindownload.jsp?fileName=activex.msi">控件安装</a></li>
						<li style="width:50%;text-align:right;letter-spacing:8px;" ><a href="/defaultroot/help/help_set.html"  target="_blank">使用帮助</a></li>
						<li style="width:50%;text-align:left;" ><a href="/defaultroot/downloadfile/GFXT_IM--WIN-2.0.exe">PCIM安装(WIN)</a></li>
						<li style="width:50%;text-align:right" ><a href="/defaultroot/downloadfile/GFXT_IM--XP-2.0.exe">PCIM安装(XP)</a></li>
                    </ul>
                </div>
            </div>
        </div>
		</div>
<script type="text/javascript">
var position = '<%=position%>';
$("li[name='nav']").attr("class","");
if(position == 'gzzd'){
	$("#gzzd").attr('class','current');
}else if(position == 'lzjs'){
	$("#lzjs").attr('class','current');
}else if(position == 'txl'){
	$("#txl").attr('class','current');
}else{
	$("#sy").attr('class','current');
}

var infokeyForsearch = '<%=infokeyForsearch%>';
if(infokeyForsearch != '' ){
	$("#infokey").val(infokeyForsearch);
}


function SearchInformation(){
	$("#searchForm").submit();
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


function clearfeedBack(){
	$("#feedback").val("0");
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
        whir_alert('该浏览器不支持主动加入收藏。\n您可以尝试通过浏览器菜单栏或快捷键 ctrl+D 进行收藏。');  
	 }catch (e){  
	   try{  
           window.external.addFavorite(window.location,title);  
       }catch (e){  
           //window.external.addToFavoritesBar(window.location, title);  //IE8  
		    whir_alert('该浏览器不支持主动加入收藏。\n您可以尝试通过浏览器菜单栏或快捷键 ctrl+D 进行收藏。');  
       }  
   }}else { 
	   try{  
           window.external.addFavorite(window.location,title);  
       }catch (e){  
		   try{ 
           window.external.addToFavoritesBar(window.location, title);  //IE8 
		   }catch (e){
			   whir_alert('该浏览器不支持主动加入收藏。\n您可以尝试通过浏览器菜单栏或快捷键 ctrl+D 进行收藏。');  
			   }
       } 
   }

 
}


</script>


     
    





	






          

      
      



