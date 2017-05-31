//enter键
document.onkeydown=function(event){
    var e = event || window.event || arguments.callee.caller.arguments[0];    
     if(e && e.keyCode==13){ 
		 var act = document.activeElement.id;
         if(act=="queryLeaderId"||act=="queryPeriodReferDate"||act=="workCotent"||act=="leaderTag"){
		   $("#query_btn").click(refreshListForm('queryForm'));
		 }
          
    }
};
//修改领导日程
function modiLeaderEvent(id){
    if(id != '' && id != undefined){
        var vUrl = whirRootPath + '/LeaderAction!modiLeaderEvent.action?showType=edit&leaderEventId=' + id;
		openWin({url:vUrl, width:820, height:500, winName:'modiLeaderEvent'});         
    }
}
//查看领导日程
function viewLeaderEvent(id,dateStr){
    var menuType=$('#menuType').val();
    if(id != '' && id != undefined){
	    var vUrl = whirRootPath + '/LeaderAction!modiLeaderEvent.action?showType=view&leaderEventId=' + id+"&menuType="+menuType;
	    if(dateStr!=""){
		    vUrl = vUrl+"&dateStr="+dateStr;
		}       
		openWin({url:vUrl, width:820, height:500, winName:'viewLeaderEvent'});         
    }
}
 
// 新增领导日程
function addLeaderEvent(){
 var menuType=$('#menuType').val();
 var vUrl = whirRootPath + '/LeaderAction!addLeaderEvent.action?showType=add&menuType='+menuType+"&newMeet=0";;
 openWin({url:vUrl, width:820, height:500, winName:'addMyEvent'});    
}

//新会议
function addNewMeet(){
 var menuType=$('#menuType').val();
 var vUrl = whirRootPath + '/LeaderAction!addLeaderEvent.action?showType=add&menuType='+menuType+"&newMeet=1";
 openWin({url:vUrl, width:820, height:700, winName:'addNewMeet'});    
}
// 导出"领导日程"Excel
function exportQueryExcel(){
    var vUrl=whirRootPath + '/LeaderAction!displayByWeekAction.action?exportFlag=1&displayType=other';
    commonExportExcel({formId:"queryForm", action:vUrl});
}

//打印
function cmdPrint(){
   var menuType=$("#menuType").val();
   var vUrl=whirRootPath + '/LeaderAction!displayByWeek_print.action?displayType=other&menuType='+menuType;
   vUrl += '&queryPeriodReferDate=' + "";
   vUrl += '&queryPeriodReferOffset=' + "";  
   //vUrl += '&queryLeaderId=' + whirCombobox.getValue('queryLeaderId');
   vUrl += '&queryLeaderId=' + $('#queryLeaderId').val();//后来改动下拉框，不用easyui
   vUrl += '&leaderTag=' + $('#leaderTag').val();
   vUrl += '&workCotent=' + $('#workCotent').val(); 
   openWin({url:vUrl,width:1200,height:600,winName:'printWord'});
}
function changeQueryPeriodReferDate(dateStr){
    $('#queryPeriodReferDate').val(dateStr);
    //$("#queryForm").submit();
    refreshListForm('queryForm');
} 
// 修改"领导日程"
function modiLeaderEvent(id){
    if(id != '' && id != undefined){
        var vUrl = whirRootPath + '/LeaderAction!modiLeaderEvent.action?showType=edit&leaderEventId=' + id;
		openWin({url:vUrl, width:820, height:670, winName:'modiLeaderEvent'});         
    }
}
//删除领导日程
function delLeaderEvent(id, obj){
    if(id != '' && id != undefined){
        var vUrl = whirRootPath + '/LeaderAction!deleteLeaderEvent.action?leaderEventId=' + id;
        ajaxDelete(vUrl, obj);
        //openWin({url:vUrl, width:620, height:200, winName:'modiLeaderEvent'});
    }
}
// 创建视图显示基础--月
function createDisplayBasicHtml_month(){
    var html = '';
    for(var vi=1; vi<7; vi++){// 5行
        // 星期一~星期六
        html += '<tr class="monthDate" name="monthRow_' + vi + '">';
        for(var vj=1; vj<7; vj++){// 6列
            var span_period = '<div id= "date_' + vi + '_' + vj + '"></div>';
            html += '<td>' + span_period + '</td>';
        }
        html += '</tr>';
        html += '<tr class="monthContainer" name="monthRow_' + vi + '" >';
        for(var vj=1; vj<7; vj++){// 5列
            var span_content = '<div name="container" id= "container_' + vi + '_' + vj + '"></div>';
            if(vj<6){
                html += '<td rowspan="3">' + span_content + '</td>';
            }else{
                html += '<td>' + span_content + '</td>';
            }
        }
        html += '</tr>';
        
        // 星期天
        html += '<tr class="monthDate" name="monthRow_' + vi + '" >';
        html += '<td><div id= "date_' + vi +'_7"></div></td>';
        html += '</tr>';
        html += '<tr class="monthContainer" name="monthRow_' + vi + '" >';
        html += '<td><div name="container" id= "container_' + vi +'_7"></div></td>';
        html += '</tr>';
    }
    html += '';
    return html;
}

// 初始化视图显示基础
// 注：天视图、工作周视图，由于执行速度问题，已不再通过JS拼接基础HTML。
function initDisplayBasicHtml(formId, displayType){
    $('#'+formId).find("#itemContainer").html("");
    var html = '';
    if(displayType == 'day'){
        //html = createDisplayBasicHtml_day();
    }else if(displayType == 'workweek'){
        //html = createDisplayBasicHtml_workweek();
    }else if(displayType == 'week'){
        html = createDisplayBasicHtml_week();
    }else if(displayType == 'month'){
        html = createDisplayBasicHtml_month();
    }
    $('#'+formId).find('#itemContainer').append(html);
    return true;
}

function resetDisplayForm(formId, displayType, rowsMax, colsMax){
    
     if(displayType == 'month'){        
        $('#'+formId).find('.curDate').removeClass('curDate');       
        $('#'+formId).find('.notCurMonth').removeClass('notCurMonth');
        
        // 周视图、月视图
        for(var vi=0; vi<rowsMax; vi++){
            for(var vj=0; vj<colsMax; vj++){
                var vc = 0;
                vc = (vi*colsMax+vj);
                $('#'+formId).find('div[name="container"]').eq(vc).attr("date", '');
                $('#'+formId).find('div[name="container"]').eq(vc).attr("id", "container_"+(vi+1) +"_"+(vj+1));
                $('#'+formId).find('div[name="container"]').eq(vc).html('');
            }
        }

        if(displayType == 'month'){
            if(rowsMax > 5){
                $('tr[name="monthRow_6"]').show();
            }else{
                $('tr[name="monthRow_6"]').hide();
            }
        }
        return true;
    }
}

// 
function changeTheZIndex(logBoxId, val){
    if(val == '99'){
        //alert('logBoxId=[' + logBoxId + ']');
    }
    $('#'+logBoxId).css("z-index", val);
}

// 修改之前添加的 LogBox 
function changeOldLogBox(logBoxId){
    var logBoxIdArr = logBoxId.split(",");
    //alert('logBoxIdArr.length=[' + logBoxIdArr.length + ']');
    for(var vi=0; vi<logBoxIdArr.length; vi++){
        if(logBoxIdArr[vi]!=''){
            //alert($('#' + logBoxIdArr[vi]).html());
            //alert('logBoxIdArr[vi]=[' + logBoxIdArr[vi] + ']');
            var widthPx = $('#'+logBoxIdArr[vi]).css("width");
            //alert('widthPx=[' + widthPx + ']');
            widthPx = widthPx.replace("px", "");
            
            //var newWidth = Math.round(widthPx/(logBoxIdArr.length+1));
            var    newWidth = Math.round(widthPx-50);
            $('#'+logBoxIdArr[vi]).css("width", newWidth);
        }
    }
}

function setMinutesDivOccupyIds(logBoxId, dayNum, eventBeginTime, eventEndTime){
    var vHarfHourNumB = Math.round((eventBeginTime/1800));
    var vHarfHourNumE = Math.round((eventEndTime/1800));   
    for(var vi=vHarfHourNumB; vi<vHarfHourNumE; vi++){
        $('#occupy_'+dayNum+'_'+vi).attr("occupyId", $('#occupy_'+dayNum+'_'+vi).attr("occupyId")+','+logBoxId);
    }
    //alert('End of setMinutesDivOccupyIds. ');
    return true;
}

function getMinutesDivOccupyIds(dayNum, eventBeginTime, eventEndTime){
    var vHarfHourNumB = Math.round((eventBeginTime/1800));
    var vHarfHourNumE = Math.round((eventEndTime/1800));
    //alert('vHarfHourNumB=[' + vHarfHourNumB + ']');
    //alert('vHarfHourNumE=[' + vHarfHourNumE + ']');
    
    var logBoxIds = '';
    for(var vi=vHarfHourNumB; vi<vHarfHourNumE; vi++){
        logBoxIds += $('#occupy_'+dayNum+'_'+vi).attr("occupyId") + ',';
    }
    //alert('logBoxIds=[' + logBoxIds + ']');
    
    // 去掉重复的ID
    var logBoxIdsArr = logBoxIds.split(",");
    var _logBoxIds = '';
    for(var vi=0; vi<logBoxIdsArr.length; vi++){
        if(logBoxIdsArr[vi] != ''){
            if(_logBoxIds.indexOf(logBoxIdsArr[vi]+',')<0){
                _logBoxIds += logBoxIdsArr[vi] + ',';
            }
        }
    }
    if(_logBoxIds.length>1){
        _logBoxIds = _logBoxIds.substring(0, _logBoxIds.length-1);
    }
    return _logBoxIds;
}

function createSingleRecordHtml(recordID, verifyCode, recordLinkContent, recordHadRead, recordCanModify){
    var html = '';
    html += '<div style="word-break:break-all;">';
    html += '<a href="javascript:void(0);" title="'+Personalwork.view+'" name="record" ';
    html += ' recordID="' + recordID + '" ';
    html += ' verifyCode="' + verifyCode + '" ';
    html += ' recordHadRead="' + recordHadRead + '" ';
    html += ' recordCanModify="' + recordCanModify + '" ';
    html += '>'+recordLinkContent+'</a>';
    html += '</div>';
    html += '';
    return html;
}

// 要求：月页签，一条日志要求一行显示不换行，若日志内容过多，鼠标放置日志内容链接上，弹出日志全部内容卡片信息
function createSingleRecordHtml_month(recordID,recordLinkContent,recordCanModify,recordLinkTips,meetMode,eventDate){
    var menuType=$("#menuType").val();
	if(meetMode=="0"){
	  eventDate="";
	}
    var html = '';
    //html += '<div style="word-break:break-all;width:98%;height:18px;line-height:18px;overflow:hidden;">';
	html += '<div style="word-break:break-all;width:98%;line-height:18px;overflow:hidden;">';	
    html += '<a href="javascript:void(0);" onclick="viewLeaderEvent(\''+recordID+'\',\''+eventDate+'\');" name="record" ';
    html += ' title="' + recordLinkTips + '" ';
    html += ' recordID="' + recordID + '" ';
    html += ' recordCanModify="' + recordCanModify + '" ';
    html += '>'+recordLinkContent+'</a>';	
	if(menuType!="mine"){
	  if(recordCanModify == '1'){
		 html += '<a href="javascript:void(0);" onclick="modiLeaderEvent(\''+recordID+'\');"><img border="0" src="'+whirRootPath+'/images/modi.gif" title="'+Personalwork.agent_modify+'" ></a>';
		 html += '<a href="javascript:void(0);" onclick="delLeaderEvent(\''+recordID+'\', this);"><img border="0" src="'+whirRootPath+'/images/del.gif" title="'+Personalwork.agent_delete+'" ></a>';
	  }
	}	
    html += '</div>';
    html += '';
    return html;
}
 
function createSeeMoreRecordHtml(recordDate){
    var html = '';
    html += ' <div><a href="javascript:void(0);" name="more" recordDate="' + recordDate + '" onclick="changeToList(\''+recordDate+'\')">更多...</a></div>';
    //html += '">'+Personalwork.seeMoreRecord+'...</a>]</div>';
    html += '';
    return html;
}

function changeToList(recordDate){
   
    var vUrl=whirRootPath + '/LeaderAction!';
	var menuType=$('#menuType').val();
	vUrl +='displayByList.action?menuType='+menuType;
	vUrl += '&queryPeriodReferDate=' + recordDate;
	//vUrl += '&queryLeaderId=' + whirCombobox.getValue('queryLeaderId');
	//vUrl += '&leaderTag=' + $('#leaderTag').val();
	//vUrl += '&workCotent=' + $('#workCotent').val();	
    //alert("-----vUrl:"+vUrl)	
	location_href(vUrl);
}

// 创建 LogBox 的HTML
function createSingleLogBoxHtml(i, logBoxId, logBoxLink, logBoxContent, logBoxLeft, logBoxTop, logBoxWidth, logBoxHeight){
    var html = '';
    html += '<div name="logBox" class="logBox" id="'+logBoxId+'" onmouseover="changeTheZIndex(\''+logBoxId+'\', \''+(99+i)+'\');" onmouseout="changeTheZIndex(\''+logBoxId+'\', \''+(10+i)+'\')" style="margin-left:'+logBoxLeft+'%; margin-top:'+logBoxTop+'px; width:'+logBoxWidth+'%; z-index:'+(10+i)+'; " >';
    html += '<DIV><STRONG class="strong_t"><STRONG class="strong_t1"></STRONG><STRONG class="strong_t2"></STRONG></STRONG></DIV>';
    html += '<DIV class="div_title" title="'+Personalwork.view+'">'+logBoxLink+'</DIV>';
    html += '<DIV class="div_content" style="height:'+(logBoxHeight-23)+'px">'+logBoxContent+'</DIV>';
    html += '<DIV><STRONG class="strong_b"><STRONG class="strong_b1"></STRONG><STRONG class="strong_b2"></STRONG></STRONG></DIV>';
    html += '</div>';
    html += '';
    return html;
}
 
function addFullDayRecord(recordID, verifyCode, recordDate, recordContent, recordHadRead, recordCanModify){
    // 标记该日期是当前视图的第几天
    var dayNum = $('#date_'+recordDate).attr("daynum");
    //alert(dayNum);
    var html = createSingleRecordHtml(recordID, verifyCode, recordContent, recordHadRead, recordCanModify);
    //alert(html);
    $('#td_fullDay_'+dayNum).prepend(html);
}

// 
function addPartDayRecord(i, recordID, verifyCode, recordDate, recordContent, recordHadRead, recordBeginTime, recordEndTime, recordCanModify, recordTitle){
    //alert('recordBeginTime=[' + recordBeginTime + ']');
    //alert('recordEndTime=[' + recordEndTime + ']');
    if (recordBeginTime!='' && recordEndTime!='') {
        // 开始时间、结束时间 都有效

        // 标记该日期是当前视图的第几天
        var dayNum   = $('#date_'+recordDate).attr("daynum");
        var dayCount = $('div[name="date"]').size();
        //alert('dayNum=[' + dayNum + ']');
        //alert('dayCount=[' + dayCount + ']');
        
        /* Modified by Qian Min at 2013-08-24 for bug 7467 [BEGIN] */
        //var logBoxLeft = 5 + (19*(dayNum-1)); 
        //var logBoxLeft = 5; 
        /* Modified by Qian Min at 2013-08-24 for bug 7467 [END] */
        var logBoxLeft = 0;
        
        var logBoxWidth  = 95/dayCount;
        //alert(logBoxWidth);
        // 
        var logBoxTop  = 0;
        logBoxTop    = logBoxTop + Math.round((recordBeginTime/3600)*62);
        //alert(logBoxTop);
        
        var oldLogBoxIds = getMinutesDivOccupyIds(dayNum, recordBeginTime, recordEndTime);
        //alert('oldLogBoxIds=[' + oldLogBoxIds + ']');
        if(oldLogBoxIds != '' && oldLogBoxIds != 'undefined'){
            var arr = oldLogBoxIds.split(",");
            logBoxLeft  = logBoxLeft + 5*arr.length;
            logBoxWidth = logBoxWidth - 5*arr.length;
            
            /* Hiddened by Qian Min at 2013-08-24 for bug 7467 [BEGIN] */
            //changeOldLogBox(oldLogBoxIds);
            /* Hiddened by Qian Min at 2013-08-24 for bug 7467 [END] */
        }
        
        // 创建LogBox的HTML
        var logBoxId = 'logBox_' + recordID + '_' + recordDate + '_' + i;
        //alert('logBoxId=[' + logBoxId + ']');
        if(setMinutesDivOccupyIds(logBoxId, dayNum, recordBeginTime, recordEndTime)){
        	//由于日程天视图背景颜色区域和时间对不上  特加上31
            var logBoxHeight = Math.round((((recordEndTime) - recordBeginTime)/3600)*62)+31;
            
            /* Modified by Qian Min at 2013-08-29 for bug 7738 [BEGIN] */
            var logBoxLink = '['+formatTimeOfLongValue(recordBeginTime) + '-' + formatTimeOfLongValue(recordEndTime) + ']' + recordTitle;
            var logBoxContent = recordContent;
            if(logBoxHeight <= 31){
                //logBoxLink += recordContent;
                logBoxContent = '';
            }
            /* Modified by Qian Min at 2013-08-29 for bug 7738 [END] */
            
            //日程，天视图和工作周视图中，双击标题应该弹出查看页面      recordCanModify值改为0即可
            //logBoxLink = '<a href="javascript:void(0);" name="record" recordID="' + recordID + '" verifyCode="' + verifyCode + '" recordHadRead="' + recordHadRead + '" recordCanModify="' + recordCanModify + '"> ' + logBoxLink + '</a>';
            logBoxLink = '<a href="javascript:void(0);" name="record" recordID="' + recordID + '" verifyCode="' + verifyCode + '" recordHadRead="' + recordHadRead + '" recordCanModify="0"> ' + logBoxLink + '</a>';
            
            var logBoxHtml = createSingleLogBoxHtml(i, logBoxId, logBoxLink, logBoxContent, logBoxLeft, logBoxTop, logBoxWidth, logBoxHeight);
            //alert('logBoxHtml=[' + logBoxHtml + ']');
            //alert(html);
            $('#logBoxContainer_'+dayNum).append(logBoxHtml);
        }
    }
}

// 校准
// Modified by Qian Min for ezOFFICE 11.0.0.11
function ajustDayLogDivHeight(dType){
    //alert('dType=['+dType+']');
    var vBodyH = $('#logBoxBody').css("height");
    var vLogDivT = $('#dayLogDiv').css("top");
    vBodyH = vBodyH.replace("px", "");
    vLogDivT = vLogDivT.replace("px", "");
    if(vLogDivT == 'auto'){
        var vFullDayH = 0;
        if($('#tr_fullDay').css('display') != 'none'){
            vFullDayH = $('#tr_fullDay').css("height");
            vFullDayH = vFullDayH.replace("px", "");
        }
        vLogDivT = 123 + new Number(vFullDayH);
    }
    var vLogDivH = Math.floor(((vBodyH - vLogDivT)/vBodyH)*100);
    
    var vFulldayW = $('#table_fullday').css('width');
    vFulldayW = vFulldayW.replace("px", "");
    var vLogDivW = new Number(vFulldayW) + 3;
    
    if(isPad()){
        vLogDivH = vLogDivH - 5;
        
        if(dType=='workweek'){
            vLogDivW = vLogDivW - 15;
        }
    }
    $('#dayLogDiv').css("height", ""+vLogDivH+"%");
    $('#dayLogDiv').css("width", vLogDivW+"px");
}

// 控制"全天日志"部分的显示
function controlFullDayDisplay(){
    var vSize = $('td[name="td_fullDay"]').size();
    for(var vi=0; vi<vSize; vi++){
        //alert('[' + $('td[name="td_fullDay"]').eq(vi).html() + ']');
        if($('td[name="td_fullDay"]').eq(vi).html() != ''
            && $('td[name="td_fullDay"]').eq(vi).html() != '&nbsp;'){
            $('#tr_fullDay').css('display', '');
            return;
        }
    }
    $('#tr_fullDay').css('display', 'none');
    return;
}

function formatTimeOfLongValue(timeInLong){
    var m = (timeInLong%3600)/60;
    var h = (timeInLong-(timeInLong%3600))/3600;
    return (h<10?'0':'') + h + ':' + (m<10?'0':'') + m;
}


function checkBeforeRefreshListForm(){
    var menuType = $('#menuType').val();
    if(menuType == 'underling'){
        var queryUnderlingEmp = whirCombobox.getValue('queryUnderlingEmp');
        if(queryUnderlingEmp == ''){
            whir_alert(Personalwork.myworklog_selectemp, null, null);
            return false;
        }
    }else if(menuType == 'query'){ 
        var queryUnderlingEmp = whirCombobox.getValue('queryUnderlingEmp');
        var querySharedFromEmp = whirCombobox.getValue('querySharedFromEmp');
        if(queryUnderlingEmp == '' && querySharedFromEmp == ''){
            whir_alert(Personalwork.myworklog_selemp, null, null);
            return false;
        }
    }
    return true;
}

// 
function changeQueryByDateOffset(flag){
    $('#queryPeriodReferOffset').val(flag);
    //$("#queryForm").submit();
    refreshListForm('queryForm');
}

// 今日/本工作周/本周/本月
function changeQueryDate_toCur(){
	// 调用公共方法获取当前日期
    $('#queryPeriodReferDate').val(getSmpFormatNowDate(false));
    //$("#queryForm").submit();
    refreshListForm('queryForm');
}


function initDisplayFormToAjax(formJson){
    var formJson_ = eval(formJson);
    var formId = formJson_.formId;
    var displayType = formJson_.displayType;
    var menuType=$("#menuType").val();
    // 初始化视图显示基础
    initDisplayBasicHtml(formId, displayType);
    
    var jq_form = $('#'+formId);
    var menuType = jq_form.find('#menuType').val();
    jq_form.ajaxForm({
        beforeSend:function(){
            $.dialog.tips(comm.loadingdata,1000,'loading.gif',function(){});
        },
        success:function(responseText){
            $.dialog({id:"Tips"}).close();
            //解析服务器返回的json字符串
            var json = eval("("+responseText+")").data;
            
            // 查询的时间段
            var periodJson = json.periodJson;
            //alert("periods=[" + periods.length + "]");
            var periodShow = periodJson.periodShow;
            var newPeriodReferDate = periodJson.newPeriodReferDate;
            
            var rowsMax = periodJson.rowsMax; 
            var colsMax = periodJson.colsMax; 
            
            if(resetDisplayForm(formId, displayType, rowsMax, colsMax)){            
                var nowDate = new Date();
                var nowDateStr = format(nowDate, "yyyy-MM-dd");
                    // 周、月
                    var periods = periodJson.data;
                    var curMonthFlag = 0;
                    
                    for(var i=0; i<periods.length; i++){
                        // 
                        var period = periods[i];
                        //$('#'+formId).find('#date'+period.id).html(period.value);
                        var dateStr = period.value;
                        if(displayType == 'month'){
                            if((dateStr.substring(dateStr.lastIndexOf('-')+1) == '01')){
                                curMonthFlag += 1;
                            }
                            if(curMonthFlag == 0 || curMonthFlag == 2){
                                // 不是当前月份
                                jq_form.find('#date'+period.id).parent().addClass("notCurMonth");
                                jq_form.find('#container'+period.id).parent().addClass("notCurMonth");
                            }
                            
                            if(dateStr == nowDateStr){
                                jq_form.find('#date'+period.id).parent().addClass("curDate");
                            }
                        }
                        
                        var dateHtml = '<span name="dateLink" style="cursor:pointer;" >' + period.value + '</span>';
                        //var dateHtml = '<a href="javascript:void(0);" onclick="seeMoreEvent(\''+dateStr+'\');">' + dateStr + '</a>';
                        jq_form.find('#date'+period.id).html(dateHtml);                       
                        jq_form.find('#container'+period.id).attr("date", dateStr);
                        jq_form.find('#container'+period.id).attr("id", "container_" + dateStr);
                        
                    }
 
                jq_form.find('#periodsShow').html(periodShow);
                
                // 改变查询日期区间参考日期
                jq_form.find('#queryPeriodReferDate').val(newPeriodReferDate);
                
                // 改变查询日期区间参考偏移量为空
                jq_form.find('#queryPeriodReferOffset').val('');
                
                var data = json.data;
 
                // 注：为提高执行速度，将视图类别的判断，拎到循环外面了，代码上有些重复。
                var eventBeginDate = '';
                var eventEndDate = '';
                var eventDate = '';
                var eventBeginTime = '';
                var eventEndTime = '';
                
                    // 月视图 循环数据信息
                    for (var i=0; i<data.length; i++) {
                        var po = data[i];
                        var meetMode = po.meetMode;//模式
                        // 生成记录链接内容
                        var recordLinkContent = '';
						var recordLinkTips = '';
						//add by lifan 跨天日程时间显示问题修改
						eventBeginDate = po.leaderBeginDate.substr(0,10);
						eventEndDate = po.leaderEndDate.substr(0,10);
						eventBeginTime = po.leaderBeginTime;
						eventEndTime = po.leaderEndTime;
						eventDate = po.leaderBegin;
						//alert("leaderName:"+po.leaderName);
						var leaderName=po.leaderName;
						if(leaderName.indexOf(",")!=-1){//领导之间顿号显示
                	      leaderName=leaderName.replace(new RegExp(",","gm"),"、");
                         }
                        if(po.fullDayEvent == '1'){							 
							recordLinkContent = '<span class="week_time">#['+Personalwork.worklog_fullday+']</span>';
                            if(leaderName=="公司全体领导"){
							   var showTips2_hh="   "+leaderName+po.workCotent;						   
							   recordLinkTips=eventBeginDate+" 到 "+eventEndDate+"\r\n"+showTips2_hh;
							}else{							  
							   var showTips2_hh="   "+leaderName+"同志"+po.workCotent;							  
							   recordLinkTips=eventBeginDate+" 到 "+eventEndDate+"\r\n"+showTips2_hh;
							} 								
							
                        }else{
						    /**if(eventDate != eventEndDate && eventDate == eventBeginDate ){
								recordLinkContent = '['+formatTimeOfLongValue(eventBeginTime) + '-23:30]';
								eventEndTime = 23 * 60 * 60 + 30 * 60;
							}else if(eventDate != eventEndDate && eventDate != eventBeginDate ){
								recordLinkContent = '[00:00-23:30]';
								eventBeginTime = '0';
								eventEndTime = 23 * 60 * 60 + 30 * 60;
							}else if(eventDate == eventEndDate && eventDate != eventBeginDate ){
								eventBeginTime = '0';
								recordLinkContent = '[00:00-' + formatTimeOfLongValue(eventEndTime) + ']';
							}else{
								recordLinkContent = '['+formatTimeOfLongValue(eventBeginTime) + '-' + formatTimeOfLongValue(eventEndTime) + ']';
							}**/
							 
							recordLinkContent = "<span class='rc_span rc_span1'>秘书</span>";
							recordLinkContent += "<span class='week_time'>#"+formatTimeOfLongValue(eventBeginTime)+"</span>";
							recordLinkContent += "<div style='clear:both'></div>";
							if(leaderName=="公司全体领导"){
							   var showTips2_hh="   "+leaderName+po.workCotent;						    
							   recordLinkTips=eventBeginDate+" "+formatTimeOfLongValue(eventBeginTime)+" 到 "+eventEndDate+" "+formatTimeOfLongValue(eventEndTime)+"\r\n"+showTips2_hh;
							}else{
							   var showTips2_hh="   "+leaderName+"同志"+po.workCotent;							   
							   recordLinkTips=eventBeginDate+" "+formatTimeOfLongValue(eventBeginTime)+" 到 "+eventEndDate+" "+formatTimeOfLongValue(eventEndTime)+"\r\n"+showTips2_hh;
							} 								
							
                        }
                        if(eventBeginDate!=eventEndDate){						      
                              var eventBeginDate_S=	eventBeginDate.substring(5,7);
                              var eventEndDate_E =eventEndDate.substring(5,7);							  
							  recordLinkContent = "<span class='week_time'>#"+eventBeginDate.substr(8,10)+"日-"+eventEndDate.substr(8,10)+"日</span>";
                              if(eventBeginDate_S!=eventEndDate_E){							  
							  var eventBeginDate_Show=eventEndDate_E+"月"+eventEndDate.substr(8,10);
							  //alert("eventBeginDate_E2:"+eventBeginDate_Show);
							  recordLinkContent = "<span class='week_time'>#"+eventBeginDate.substr(8,10)+"日-"+eventBeginDate_Show+"日</span>";
                              }							  
							  
						}
						var wContent=po.workCotent;
	                    if(wContent.length>23){
	                     wContent=wContent.substring(0,23)+"...";
	                    }
                        if(leaderName=="公司全体领导"){
                           recordLinkContent += "<span style='color:#0000ff'>&nbsp;"+leaderName+"</span>"+wContent; 
                        }else{
                           recordLinkContent += "<span style='color:#0000ff'>&nbsp;"+leaderName+"</span>同志"+wContent; 
                        } 						
                                               						
                        var _location = 'container_' + eventDate;                       
                        var recordCount = jq_form.find("#"+_location).find('div').size();
                        if(recordCount <= 8){
                            var html = '';
                            if(recordCount < 8){                               
                                html = createSingleRecordHtml_month(po.cId,recordLinkContent, po.canModify,recordLinkTips,meetMode,eventDate);
                            } else {
                                html = createSeeMoreRecordHtml(eventDate,meetMode);
                            }
                            jq_form.find("#"+_location).append(html);
                        }
                    }
                                                                                         
                //如果没有查询到记录，给出提示
                if(data.length == 0){
                }
                
                //调用回调事件
                if(formJson_.onLoadSuccessAfter){
                    formJson_.onLoadSuccessAfter.call(this);
                }
            }
        },
        error:function(XMLHttpRequest, textStatus, errorThrown){
            $.dialog({id:"Tips"}).close();
            $.dialog.alert(comm.loadfailure,function(){});
        }
    }); 
    
    //初次提交表单获得数据
    $("#"+formId).submit();
}

// 改变展示方式
function changeDisplayType(displayType){
    var vUrl=whirRootPath + '/LeaderAction!';
	var menuType=$('#menuType').val();
    if(displayType=="list"){
	    vUrl +='displayByList.action?menuType='+menuType;
        //vUrl += '&queryPeriodReferDate=' + $('#queryPeriodReferDate').val();
		//vUrl += '&queryLeaderId=' + whirCombobox.getValue('queryLeaderId');
		vUrl += '&queryLeaderId=' + $('#queryLeaderId').val();//后来改动下拉框，不用easyui
		vUrl += '&leaderTag=' + whirCombobox.getValue('leaderTag');
		vUrl += '&workCotent=' + $('#workCotent').val();	  
	}else if(displayType=="week"){
		vUrl +='displayByWeek.action?menuType='+menuType;
		//vUrl += '&queryPeriodReferDate=' + $('#queryPeriodReferDate').val();
		//vUrl += '&queryLeaderId=' + whirCombobox.getValue('queryLeaderId');
		vUrl += '&queryLeaderId=' + $('#queryLeaderId').val();//后来改动下拉框，不用easyui
		vUrl += '&leaderTag=' + whirCombobox.getValue('leaderTag');
		vUrl += '&workCotent=' + $('#workCotent').val();	 
	}else{  
		vUrl += 'displayByMonth.action?menuType=' + menuType; 
		//vUrl += '&queryLeaderId=' + whirCombobox.getValue('queryLeaderId');
		vUrl += '&queryLeaderId=' + $('#queryLeaderId').val();//后来改动下拉框，不用easyui
		vUrl += '&leaderTag=' + whirCombobox.getValue('leaderTag');
		vUrl += '&workCotent=' + $('#workCotent').val();	 
	}
	 location_href(vUrl);
    //alert(vUrl);    
}

//写Cookie
function createCookie(name,value,days){
    if (days){
        var date = new Date();
        date.setTime(date.getTime()+(days*24*60*60*1000));
        var expires = "; expires="+date.toGMTString();
    }
    else var expires = "";
    document.cookie = name+"="+value+expires+"; path=/";
}
function seeMoreEvent(recordDate){
    var menuType = $('#menuType').val();
    if(menuType == 'mine' 
        || menuType == 'underling' 
        || menuType == 'query'){
        
        var vUrl = whirRootPath + '/EventAction!';
        vUrl += 'eventDisplay.action?menuType=' + menuType;
        vUrl += '&displayType=day';
        vUrl += '&queryPeriodReferDate=' + recordDate;
        if(menuType == 'underling' || menuType == 'query'){
            vUrl += '&queryUnderlingEmp=' + whirCombobox.getValue('queryUnderlingEmp');
            if(menuType == 'query'){
                vUrl += '&querySharedFromEmp=' + whirCombobox.getValue('querySharedFromEmp');
            }
        }
        location_href(vUrl);
    }
}
function initDisplaySearchForm(){
    var menuType = $('#menuType').val();
    //alert('menuType=[' + menuType + ']');
    if(menuType == 'underling' || menuType == 'query'){
        if($('#queryUnderlingEmpPara').val() != ''){
            whirCombobox.setValue('queryUnderlingEmp', $('#queryUnderlingEmpPara').val());
            $('#querySharedFromEmp').combobox('disable');
        } else {
            if(menuType == 'query'){
                if($('#querySharedFromEmpPara').val() != ''){
                    whirCombobox.setValue('querySharedFromEmp', $('#querySharedFromEmpPara').val());
                    $('#queryUnderlingEmp').combobox('disable');
                }
            }
        }
    }
    return true;
}

// 异步-静悄悄的操作
function ajaxOperateSilence(opeJson){
    jQuery.ajax({
        type : "POST",
        url  : opeJson.url || opeJson.urlWithData,
        data : opeJson.data || '',
        success: function(msg){
            var msg_json = eval("("+msg+")");
            if(msg_json.result == "success"){
                if(opeJson.callbackfunction!=null){
                    opeJson.callbackfunction.call(opeJson.callbackfunction, opeJson, msg_json);
                }
            }else{
                $.dialog.alert(msg_json.result,function(){}); 
            } 
        },
        error: function(XMLHttpRequest, textStatus, errorThrown){
            $.dialog.alert(opeJson.tip+comm.whir_failure,function(){}); 
        }
    });
}
function updateSilenceSuccess(msg_json){
    $('#queryForm').submit();
}
