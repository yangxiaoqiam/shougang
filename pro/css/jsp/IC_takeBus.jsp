<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/public/include/init.jsp"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="zh-cn" class="theme-blue theme-blue-pure size-big">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <base url="defaultroot">
    <title>信息详情页</title>
    <link rel="stylesheet" href="template/css/template_system/template.fa.min.css" />
    <link rel="stylesheet" href="template/css/template_system/template.reset.min.css" />
    <link rel="stylesheet" href="template/css/template.bootstrap.min.css" />
    <link rel="stylesheet" href="template/css/template_default/template.media.min.css" />
    <link rel="stylesheet" href="template/css/template_default/themes/2016/template.theme.media.min.css" />
    <script type="text/javascript" src="scripts/plugins/jquery/jquery.min.js"></script>
    <script type="text/javascript" src="scripts/static/template.js"></script>
    <script type="text/javascript" src="scripts/static/template.custom.js"></script>
    <script type="text/javascript" src="scripts/static/template.extend.js"></script>
    <script type="text/javascript" src="scripts/plugins/zTree_v3/jquery.ztree.core-3.5.js"></script>
    <script type="text/javascript" src="scripts/pagejs/view-frame.js?v=20160307"></script>
    <!--add  css  -->
    <link rel="stylesheet" type="text/css" href="pro/css/onecard.css">
</head>
<%
String nowDay=request.getAttribute("nowDay")==null?"":request.getAttribute("nowDay").toString();
String previousDay = request.getAttribute("previousDay")==null?"":request.getAttribute("previousDay").toString();
String nextDay = request.getAttribute("nextDay")==null?"":request.getAttribute("nextDay").toString();
%>
<body>
 <form name="dataForm" id="dataForm" action="/defaultroot/ICCardAction!getCarInfo.action" method="post" >
<input name="nowDay" id="nowDay" type="hidden" value="<%=nowDay%>"/>
<input name="previousDay" id="previousDay" type="hidden" value="<%=previousDay%>"/>
<input name="nextDay" id="nextDay" type="hidden" value="<%=nextDay%>"/>
    
   <!-- 考勤信息表 -->
   <div class="by-car by-car-aa">
          <h3>乘车</h3>
          <div class="car-b colorbg" id="applyBus">
                <strong>乘车：</strong>
               <p>发车前3小时可取消乘车</p>
               <div class="apply">
                   点击申请乘车<i class="fa fa-angle-right"></i>
               </div>
          </div>
          
          <h2>长途通勤车</h2>
            <ul class="car-line">
                <li>
                    <div class="city">
                         <i class="fa"></i>  迁安 <img src="images/ver113/shougang/jiantou.png"> 北京
                    </div>
                    <div class="dropdown" id="hj" ></div>
                </li>
                
                    <li>
                    <div class="city">
                         <i class="fa"></i> 北京 <img src="images/ver113/shougang/jiantou.png"> 迁安
                    </div>
                    <div class="dropdown" id="hq" ></div>
                </li>
            </ul>
             <h2>迁安短途通勤车</h2>
            <ul class="car-line">
                <li>
                    <div class="city">
                         <i class="fa"></i>  小区 <img src="images/ver113/shougang/jiantou.png">厂区
                    </div>
                    <div class="dropdown">
					<h2>1号线 &nbsp;&nbsp;始发站：迁钢小区西门&nbsp;&nbsp;终点站：热轧综合楼站
					</h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>06:00</span>
						<span>06:15</span>
						<span>06:30</span>
						<span>06:35</span>
						<span>06:45</span>
						<span>07:00</span>
						<span>07:10</span>
						<span>18:15</span>
						<span>18:40</span>
						</strong>
                        <p>迁钢小区西门<img src="images/ver113/shougang/jiantou.png">五号门<img src="images/ver113/shougang/jiantou.png">
						 综合水处理中心<img src="images/ver113/shougang/jiantou.png">能源中心站(临时)<img src="images/ver113/shougang/jiantou.png">
						 办公中心站<img src="images/ver113/shougang/jiantou.png">炼钢综合楼站<img src="images/ver113/shougang/jiantou.png">
						 二高炉东站<img src="images/ver113/shougang/jiantou.png">化验楼站<img src="images/ver113/shougang/jiantou.png">
						 炼钢点检站<img src="images/ver113/shougang/jiantou.png">物资驻派站<img src="images/ver113/shougang/jiantou.png">
						 热轧综合楼站
						</p>
                     </div>
					 <h2>2号线 &nbsp;&nbsp;始发站：迁钢小区南门&nbsp;&nbsp;终点站：综合水处理中心站
					</h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>06:30</span>
						<span>06:40</span>
						<span>06:50</span>
						<span>18:40</span>
						</strong>
                        <p>迁钢小区南门<img src="images/ver113/shougang/jiantou.png">合力楼站<img src="images/ver113/shougang/jiantou.png">
						 套筒窑站<img src="images/ver113/shougang/jiantou.png">二炼钢主控楼站<img src="images/ver113/shougang/jiantou.png">
						 三高炉东站<img src="images/ver113/shougang/jiantou.png">二炼钢钢坯作业区站<img src="images/ver113/shougang/jiantou.png">
						 综合水处理中心站
						</p>
                     </div>
					 <h2>热轧专线1号线 &nbsp;&nbsp;始发站：迁钢小区西北门&nbsp;&nbsp;终点站：热轧水处理站
					</h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>06:30</span>
						<span>07:00</span>
						<span>18:50(安全学习：18:30)</span>
						</strong>
                        <p>迁钢小区西北门<img src="images/ver113/shougang/jiantou.png">综合水处理中心站<img src="images/ver113/shougang/jiantou.png">
						 二炼钢钢坯作业区站<img src="images/ver113/shougang/jiantou.png">炼钢综合楼站<img src="images/ver113/shougang/jiantou.png">
						 办公中心站<img src="images/ver113/shougang/jiantou.png">热轧综合楼站<img src="images/ver113/shougang/jiantou.png">
						 热轧水处理站
						</p>
                     </div>
					<h2>热轧专线2号线 &nbsp;&nbsp;始发站：迁钢小区西北门&nbsp;&nbsp;终点站：套筒套站
					</h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>06:30</span>
						<span>07:00</span>
						<span>18:50(安全学习：18:30)</span>
						</strong>
                        <p>迁钢小区西北门<img src="images/ver113/shougang/jiantou.png">五号门(临时)<img src="images/ver113/shougang/jiantou.png">
						 套筒套站
						</p>
                     </div>
					 <h2>炼铁线 &nbsp;&nbsp;始发站：迁钢小区西门&nbsp;&nbsp;终点站：三高炉西站
					</h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>06:20</span>
						<span>04:40</span>
						<span>07:00</span>
						<span>18:40(安全学习：18:30)</span>
						</strong>
                        <p>迁钢小区西北门<img src="images/ver113/shougang/jiantou.png">一高炉西站<img src="images/ver113/shougang/jiantou.png">
						 二高炉西站<img src="images/ver113/shougang/jiantou.png">三高炉西站
						</p>
                     </div>
					  <h2>电力线 &nbsp;&nbsp;始发站：迁钢小区西门&nbsp;&nbsp;终点站：二废钢作业区站
					  </h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>06:35</span>
						<span>18:40</span>
						</strong>
                        <p>迁钢小区西门<img src="images/ver113/shougang/jiantou.png">电力综合楼站<img src="images/ver113/shougang/jiantou.png">
						 板坯精整作业区站<img src="images/ver113/shougang/jiantou.png">2号门站(临时)<img src="images/ver113/shougang/jiantou.png">
						二废钢作业区站
						</p>
                     </div>
					   <h2>冷轧线 &nbsp;&nbsp;始发站：迁钢小区宾馆南门&nbsp;&nbsp;终点站：冷轧办公楼站
					  </h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>06:30</span>
						<span>06:50</span>
						<span>18:50(安全学习：18:30)</span>
						</strong>
                        <p>迁钢小区宾馆南门<img src="images/ver113/shougang/jiantou.png">一冷轧办公楼站<img src="images/ver113/shougang/jiantou.png">
						 冷轧能源中心站(临时)<img src="images/ver113/shougang/jiantou.png">精整西路站<img src="images/ver113/shougang/jiantou.png">
						冷轧南路站<img src="images/ver113/shougang/jiantou.png">冷轧东站(临时)<img src="images/ver113/shougang/jiantou.png">
						冷轧办公楼站
						</p>
                     </div>
					 <h2>钢加线 &nbsp;&nbsp;始发站：迁钢小区南门&nbsp;&nbsp;终点站：合力楼站
					  </h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>06:30</span>
						<span>06:50</span>
						<span>18:40</span>
						</strong>
                        <p>迁钢小区南门<img src="images/ver113/shougang/jiantou.png">合力楼站
						</p>
                     </div>
					 <h2>钢渣线 &nbsp;&nbsp;始发站：迁钢小区西门&nbsp;&nbsp;终点站：钢渣作业区
					  </h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>06:40</span>
						<span>18:40</span>
						</strong>
                        <p>迁钢小区西门<img src="images/ver113/shougang/jiantou.png">钢渣作业区
						</p>
                     </div>
					 <h2>加车线 &nbsp;&nbsp;始发站：迁钢小区西门&nbsp;&nbsp;终点站：热轧综合楼站
					  </h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>10:00</span>
						<span>13:00</span>
						</strong>
                        <p>迁钢小区西门<img src="images/ver113/shougang/jiantou.png">一冷轧办公楼站<img src="images/ver113/shougang/jiantou.png">
						冷轧能源中心站(临时)<img src="images/ver113/shougang/jiantou.png">合力楼站<img src="images/ver113/shougang/jiantou.png">
						套筒窑站<img src="images/ver113/shougang/jiantou.png">二炼钢主控楼站<img src="images/ver113/shougang/jiantou.png">
						三高炉东站<img src="images/ver113/shougang/jiantou.png">二炼钢钢坯作业区站<img src="images/ver113/shougang/jiantou.png">
						综合水处理中心站<img src="images/ver113/shougang/jiantou.png">办公中心站<img src="images/ver113/shougang/jiantou.png">
						炼钢综合楼站<img src="images/ver113/shougang/jiantou.png">二高炉东站<img src="images/ver113/shougang/jiantou.png">
						化验楼站<img src="images/ver113/shougang/jiantou.png">炼钢点检站<img src="images/ver113/shougang/jiantou.png">
						物资驻派站<img src="images/ver113/shougang/jiantou.png">热轧综合楼站
						</p>
                     </div>
              </div>
                </li>
                    <li>
                    <div class="city">
                         <i class="fa"></i> 厂区 <img src="images/ver113/shougang/jiantou.png">小区
                    </div>
                    <div class="dropdown">  
						<h2>1号线 &nbsp;&nbsp;始发站：热轧综合楼站&nbsp;&nbsp;终点站：迁钢小区
					</h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>08:20</span>
						<span>08:30</span>
						<span>09:00</span>
						<span>17:10</span>
						<span>17:30</span>
						<span>18:00</span>
						<span>18:30</span>
						<span>20:20(能源中心发车)</span>
						<span>20:30</span>
						<span>20:50</span>
						</strong>
						<p>办公中心站<img src="images/ver113/shougang/jiantou.png">炼钢综合楼站<img src="images/ver113/shougang/jiantou.png">
						 二高炉东站<img src="images/ver113/shougang/jiantou.png">化验楼站<img src="images/ver113/shougang/jiantou.png">
						 炼钢点检站<img src="images/ver113/shougang/jiantou.png">物资驻派站<img src="images/ver113/shougang/jiantou.png">
						 热轧综合楼站<img src="images/ver113/shougang/jiantou.png">能源中心站(临时)<img src="images/ver113/shougang/jiantou.png">
						综合水处理中心<img src="images/ver113/shougang/jiantou.png">五号门<img src="images/ver113/shougang/jiantou.png">
                        迁钢小区
						</p>
                     </div>
					 <h2>2号线 &nbsp;&nbsp;始发站：合力楼站&nbsp;&nbsp;终点站：迁钢小区
					</h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>08:15</span>
						<span>17:15</span>
						<span>17:30</span>
						<span>20:15</span>
						</strong>
                        <p>合力楼站<img src="images/ver113/shougang/jiantou.png">套筒窑站<img src="images/ver113/shougang/jiantou.png">
						 二炼钢主控楼站<img src="images/ver113/shougang/jiantou.png">三高炉东站<img src="images/ver113/shougang/jiantou.png">
						 二炼钢钢坯作业区站<img src="images/ver113/shougang/jiantou.png">综合水处理中心站<img src="images/ver113/shougang/jiantou.png">
						 迁钢小区
						</p>
                     </div>
					 <h2>热轧专线1号线 &nbsp;&nbsp;始发站：综合水处理中心站&nbsp;&nbsp;终点站：迁钢小区
					</h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>08:15</span>
						<span>17:15</span>
						<span>17:30</span>
						<span>20:15</span>
						</strong>
                        <p>综合水处理中心站<img src="images/ver113/shougang/jiantou.png">热轧综合楼站<img src="images/ver113/shougang/jiantou.png">
						 迁钢小区
						</p>
                     </div>
					 <h2>热轧专线2号线 &nbsp;&nbsp;始发站：套筒套站&nbsp;&nbsp;终点站：迁钢小区
					</h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>08:15</span>
						<span>17:15</span>
						<span>17:30</span>
						<span>20:15</span>
						</strong>
                        <p>套筒套站<img src="images/ver113/shougang/jiantou.png">五号门(临时)<img src="images/ver113/shougang/jiantou.png">
						 迁钢小区
						</p>
                     </div>
					 <h2>炼铁线 &nbsp;&nbsp;始发站：三高炉西站&nbsp;&nbsp;终点站：迁钢小区
					</h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>08:30</span>
						<span>17:30</span>
						<span>20:30</span>
						</strong>
                        <p>三高炉西站<img src="images/ver113/shougang/jiantou.png">二高炉西站<img src="images/ver113/shougang/jiantou.png">
						高炉西站<img src="images/ver113/shougang/jiantou.png">迁钢小区
						</p>
                     </div>
					 <h2>电力线 &nbsp;&nbsp;始发站：二废钢作业区站&nbsp;&nbsp;终点站：迁钢小区
					  </h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>06:35</span>
						<span>18:40</span>
						</strong>
                        <p>二废钢作业区站<img src="images/ver113/shougang/jiantou.png">2号门站(临时)<img src="images/ver113/shougang/jiantou.png">
						 板坯精整作业区站<img src="images/ver113/shougang/jiantou.png">电力综合楼站<img src="images/ver113/shougang/jiantou.png">
						迁钢小区
						</p>
                     </div>
					  <h2>冷轧线 &nbsp;&nbsp;始发站：冷轧办公楼站&nbsp;&nbsp;终点站：迁钢小区
					  </h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>08:20</span>
						<span>17:20</span>
						<span>17:40</span>
						<span>18:10</span>
						<span>20:30</span>
						</strong>
                        <p>冷轧办公楼站<img src="images/ver113/shougang/jiantou.png">冷轧东站(临时)<img src="images/ver113/shougang/jiantou.png">
						 冷轧南路站 <img src="images/ver113/shougang/jiantou.png">精整西路站<img src="images/ver113/shougang/jiantou.png">
						冷轧能源中心站(临时)<img src="images/ver113/shougang/jiantou.png">冷轧办公楼站<img src="images/ver113/shougang/jiantou.png">
						迁钢小区
						</p>
                     </div>
					 <h2>钢加线 &nbsp;&nbsp;始发站：合力楼站&nbsp;&nbsp;终点站：迁钢小区
					  </h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>08:15</span>
						<span>17:10</span>
						<span>17:30</span>
						<span>18:00</span>
						<span>20:15</span>
						</strong>
                        <p>合力楼站<img src="images/ver113/shougang/jiantou.png">迁钢小区
						</p>
                     </div>
					 <h2>钢渣线 &nbsp;&nbsp;始发站：钢渣作业区&nbsp;&nbsp;终点站：迁钢小区
					  </h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>08:30</span>
						<span>17:30</span>
						<span>20:30</span>
						</strong>
                        <p>钢渣作业区<img src="images/ver113/shougang/jiantou.png">迁钢小区
						</p>
                     </div>
					 <h2>加车线 &nbsp;&nbsp;始发站：迁钢小区西门&nbsp;&nbsp;终点站：热轧综合楼站
					  </h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>10:45</span>
						<span>14:20</span>
						</strong>
                        <p>
						办公中心站<img src="images/ver113/shougang/jiantou.png">
						炼钢综合楼站<img src="images/ver113/shougang/jiantou.png">二高炉东站<img src="images/ver113/shougang/jiantou.png">
						化验楼站<img src="images/ver113/shougang/jiantou.png">炼钢点检站<img src="images/ver113/shougang/jiantou.png">
						物资驻派站<img src="images/ver113/shougang/jiantou.png">热轧综合楼站<img src="images/ver113/shougang/jiantou.png">
						综合水处理中心站<img src="images/ver113/shougang/jiantou.png">二炼钢钢坯作业区站<img src="images/ver113/shougang/jiantou.png">
						三高炉东站<img src="images/ver113/shougang/jiantou.png">二炼钢主控楼站<img src="images/ver113/shougang/jiantou.png">
						套筒窑站<img src="images/ver113/shougang/jiantou.png">合力楼站<img src="images/ver113/shougang/jiantou.png">
						冷轧能源中心站(临时)<img src="images/ver113/shougang/jiantou.png">一冷轧办公楼站<img src="images/ver113/shougang/jiantou.png">
						迁钢小区
						</p>
                     </div>
					</div>
                </li>
				<li>
				<div class="city">
                    <i class="fa"></i> 环厂班车
                    </div>
                    <div class="dropdown"> 
					 <h2>环厂南行线 &nbsp;&nbsp;始发站：炼钢综合楼站&nbsp;&nbsp;终点站：炼钢综合楼站
					  </h2>
                        <div class="part">
                        <strong>
						<span>始发时间</span>
						<span>首班车:08:30</span>
						<span>每间隔一个小时环厂一周</span>
						<span>末班车:1530</span>
						</strong>
                        <p>
						炼钢综合楼站<img src="images/ver113/shougang/jiantou.png">办公中心站<img src="images/ver113/shougang/jiantou.png">
						热轧综合楼站<img src="images/ver113/shougang/jiantou.png">物资驻派站<img src="images/ver113/shougang/jiantou.png">
						炼钢点检站<img src="images/ver113/shougang/jiantou.png">化验楼站<img src="images/ver113/shougang/jiantou.png">
						三高炉东站<img src="images/ver113/shougang/jiantou.png">二炼钢主控楼站<img src="images/ver113/shougang/jiantou.png">
						套筒套站<img src="images/ver113/shougang/jiantou.png">合力楼站<img src="images/ver113/shougang/jiantou.png">
						五号门站<img src="images/ver113/shougang/jiantou.png">综合水处理中心站<img src="images/ver113/shougang/jiantou.png">
						二炼钢钢坯作业区站<img src="images/ver113/shougang/jiantou.png">炼钢综合楼站
						</p>
                     </div>
					</div>
				</li>
            </ul>
			 <h2>迁安市区通勤车</h2>
            <ul class="car-line">
                <li>
                    <div class="city">
                         <i class="fa"></i>  迁安市区 <img src="images/ver113/shougang/jiantou.png"> 厂区
                    </div>
                    <div class="dropdown" >
					 <h2>始发时间：06:20</h2>
                        <div class="part">
                        <strong>
						<span>西环线</span>
						</strong>
                        <p>
						乐购<img src="images/ver113/shougang/jiantou.png">
						东岗<img src="images/ver113/shougang/jiantou.png">水务局<img src="images/ver113/shougang/jiantou.png">
						科技大楼<img src="images/ver113/shougang/jiantou.png">凯源花苑<img src="images/ver113/shougang/jiantou.png">
						青杨小区<img src="images/ver113/shougang/jiantou.png">北方家具城(绿色家园)<img src="images/ver113/shougang/jiantou.png">
						金水豪庭<img src="images/ver113/shougang/jiantou.png">颐秀园<img src="images/ver113/shougang/jiantou.png">
						二镇中<img src="images/ver113/shougang/jiantou.png">西湖宾馆<img src="images/ver113/shougang/jiantou.png">
						迁钢厂区
						</p>
                     </div>
					  <div class="part">
                        <strong>
						<span>南环线</span>
						</strong>
                        <p>
						四实小<img src="images/ver113/shougang/jiantou.png">
						明珠花园<img src="images/ver113/shougang/jiantou.png">广场鑫园<img src="images/ver113/shougang/jiantou.png">
						帝景豪庭(传世家)<img src="images/ver113/shougang/jiantou.png">迁钢厂区
						</p>
                     </div>
					<div class="part">
                        <strong>
						<span>燕山线</span>
						</strong>
                        <p>
						毛纺厂<img src="images/ver113/shougang/jiantou.png">
						河畔人家<img src="images/ver113/shougang/jiantou.png">北环路<img src="images/ver113/shougang/jiantou.png">
						常青小区<img src="images/ver113/shougang/jiantou.png">建设银行<img src="images/ver113/shougang/jiantou.png">
						邮政局<img src="images/ver113/shougang/jiantou.png">金三元<img src="images/ver113/shougang/jiantou.png">
						锦江饭店<img src="images/ver113/shougang/jiantou.png">二水厂<img src="images/ver113/shougang/jiantou.png">
						西湖宾馆<img src="images/ver113/shougang/jiantou.png">迁钢厂区
						</p>
                     </div>
					 <div class="part">
                        <strong>
						<span>厂区内站点</span>
						</strong>
                        <p>
						冷轧东门进入厂区<img src="images/ver113/shougang/jiantou.png">
						一冷轧办公楼站<img src="images/ver113/shougang/jiantou.png">合力楼站<img src="images/ver113/shougang/jiantou.png">
						套筒套站<img src="images/ver113/shougang/jiantou.png">二炼钢主控楼站<img src="images/ver113/shougang/jiantou.png">
						电力综合楼站<img src="images/ver113/shougang/jiantou.png">三高炉西站<img src="images/ver113/shougang/jiantou.png">
						二高炉西站<img src="images/ver113/shougang/jiantou.png">炼钢点检站<img src="images/ver113/shougang/jiantou.png">
						热轧综合楼站<img src="images/ver113/shougang/jiantou.png">办公中心站<img src="images/ver113/shougang/jiantou.png">
						炼钢综合楼站<img src="images/ver113/shougang/jiantou.png">二炼钢钢坯作业区站
						</p>
                     </div>
					 <h2>始发时间：06:50</h2>
					  <div class="part">
                        <strong>
						<span>燕山线(周六，日没有)</span>
						</strong>
                        <p>
						毛纺厂<img src="images/ver113/shougang/jiantou.png">
						河畔人家<img src="images/ver113/shougang/jiantou.png">北环路<img src="images/ver113/shougang/jiantou.png">
						常青小区<img src="images/ver113/shougang/jiantou.png">建设银行<img src="images/ver113/shougang/jiantou.png">
						邮政局<img src="images/ver113/shougang/jiantou.png">金三元<img src="images/ver113/shougang/jiantou.png">
						锦江饭店<img src="images/ver113/shougang/jiantou.png">二水厂<img src="images/ver113/shougang/jiantou.png">
						西湖宾馆<img src="images/ver113/shougang/jiantou.png">迁钢厂区
						</p>
                     </div>
					  <div class="part">
                        <strong>
						<span>厂区内站点</span>
						</strong>
                        <p>
						冷轧东门进入厂区<img src="images/ver113/shougang/jiantou.png">
						一冷轧办公楼站<img src="images/ver113/shougang/jiantou.png">合力楼站<img src="images/ver113/shougang/jiantou.png">
						套筒套站<img src="images/ver113/shougang/jiantou.png">二炼钢主控楼站<img src="images/ver113/shougang/jiantou.png">
						电力综合楼站<img src="images/ver113/shougang/jiantou.png">三高炉西站<img src="images/ver113/shougang/jiantou.png">
						二高炉西站<img src="images/ver113/shougang/jiantou.png">炼钢点检站<img src="images/ver113/shougang/jiantou.png">
						热轧综合楼站<img src="images/ver113/shougang/jiantou.png">办公中心站<img src="images/ver113/shougang/jiantou.png">
						炼钢综合楼站<img src="images/ver113/shougang/jiantou.png">二炼钢钢坯作业区站
						</p>
                     </div>
					 <h2>始发时间：18:20</h2>
					  <div class="part">
                        <strong>
						<span>西环线</span>
						</strong>
                        <p>
						乐购<img src="images/ver113/shougang/jiantou.png">
						东岗<img src="images/ver113/shougang/jiantou.png">水务局<img src="images/ver113/shougang/jiantou.png">
						科技大楼<img src="images/ver113/shougang/jiantou.png">凯源花苑<img src="images/ver113/shougang/jiantou.png">
						青杨小区<img src="images/ver113/shougang/jiantou.png">北方家具城(绿色家园)<img src="images/ver113/shougang/jiantou.png">
						金水豪庭<img src="images/ver113/shougang/jiantou.png">颐秀园<img src="images/ver113/shougang/jiantou.png">
						二镇中<img src="images/ver113/shougang/jiantou.png">西湖宾馆<img src="images/ver113/shougang/jiantou.png">
						迁钢厂区
						</p>
                     </div>
					 <div class="part">
                        <strong>
						<span>南环线最新调整</span>
						</strong>
                        <p>
						四实小<img src="images/ver113/shougang/jiantou.png">
						明珠花园<img src="images/ver113/shougang/jiantou.png">广场鑫园<img src="images/ver113/shougang/jiantou.png">
						帝景豪庭(传世家)<img src="images/ver113/shougang/jiantou.png">天洋城<img src="images/ver113/shougang/jiantou.png">迁钢厂区
						</p>
                     </div>
					 <div class="part">
                        <strong>
						<span>燕山线</span>
						</strong>
                        <p>
						毛纺厂<img src="images/ver113/shougang/jiantou.png">
						河畔人家<img src="images/ver113/shougang/jiantou.png">北环路<img src="images/ver113/shougang/jiantou.png">
						常青小区<img src="images/ver113/shougang/jiantou.png">建设银行<img src="images/ver113/shougang/jiantou.png">
						邮政局<img src="images/ver113/shougang/jiantou.png">金三元<img src="images/ver113/shougang/jiantou.png">
						锦江饭店<img src="images/ver113/shougang/jiantou.png">二水厂<img src="images/ver113/shougang/jiantou.png">
						西湖宾馆<img src="images/ver113/shougang/jiantou.png">迁钢厂区
						</p>
                     </div>
					  <div class="part">
                        <strong>
						<span>厂区内站点</span>
						</strong>
                        <p>
						冷轧东门进入厂区<img src="images/ver113/shougang/jiantou.png">
						一冷轧办公楼站<img src="images/ver113/shougang/jiantou.png">合力楼站<img src="images/ver113/shougang/jiantou.png">
						套筒套站<img src="images/ver113/shougang/jiantou.png">二炼钢主控楼站<img src="images/ver113/shougang/jiantou.png">
						电力综合楼站<img src="images/ver113/shougang/jiantou.png">三高炉西站<img src="images/ver113/shougang/jiantou.png">
						二高炉西站<img src="images/ver113/shougang/jiantou.png">炼钢点检站<img src="images/ver113/shougang/jiantou.png">
						热轧综合楼站<img src="images/ver113/shougang/jiantou.png">办公中心站<img src="images/ver113/shougang/jiantou.png">
						炼钢综合楼站<img src="images/ver113/shougang/jiantou.png">二炼钢钢坯作业区站
						</p>
                     </div>
					</div>
                </li>
                
                    <li>
                    <div class="city">
                         <i class="fa"></i> 厂区 <img src="images/ver113/shougang/jiantou.png"> 迁安市区
                    </div>
                    <div class="dropdown" >
					 <h2>始发时间：8:30，17:20，20:30</h2>
					 <div class="part">
                        <strong>
						<span>厂区内站点</span>
						</strong>
                        <p>
						二炼钢钢坯作业区站<img src="images/ver113/shougang/jiantou.png">炼钢综合楼站
						<img src="images/ver113/shougang/jiantou.png">办公中心站<img src="images/ver113/shougang/jiantou.png">
						热轧综合楼站<img src="images/ver113/shougang/jiantou.png">炼钢点检站<img src="images/ver113/shougang/jiantou.png">
						二高炉西站<img src="images/ver113/shougang/jiantou.png">三高炉西站<img src="images/ver113/shougang/jiantou.png">
						电力综合楼站<img src="images/ver113/shougang/jiantou.png">二炼钢主控楼站<img src="images/ver113/shougang/jiantou.png">
						套筒套站<img src="images/ver113/shougang/jiantou.png">合力楼站<img src="images/ver113/shougang/jiantou.png">
						一冷轧办公楼站<img src="images/ver113/shougang/jiantou.png">冷轧东门离开厂区
						</p>
                     </div>
					  <div class="part">
                        <strong>
						<span>西环线</span>
						</strong>
                        <p>
						迁钢厂区<img src="images/ver113/shougang/jiantou.png">
						西湖宾馆<img src="images/ver113/shougang/jiantou.png">二镇中<img src="images/ver113/shougang/jiantou.png">
						颐秀园<img src="images/ver113/shougang/jiantou.png">金水豪庭<img src="images/ver113/shougang/jiantou.png">
						北方家具城(绿色家园)<img src="images/ver113/shougang/jiantou.png">青杨小区<img src="images/ver113/shougang/jiantou.png">
						凯源花苑<img src="images/ver113/shougang/jiantou.png">科技大楼<img src="images/ver113/shougang/jiantou.png">
						水务局<img src="images/ver113/shougang/jiantou.png">东岗<img src="images/ver113/shougang/jiantou.png">
						乐购
						</p>
                     </div>
					 <div class="part">
                        <strong>
						<span>南环线最新调整</span>
						</strong>
                        <p>
						迁钢厂区<img src="images/ver113/shougang/jiantou.png">天洋城<img src="images/ver113/shougang/jiantou.png">
						帝景豪庭(传世家)<img src="images/ver113/shougang/jiantou.png">广场鑫园<img src="images/ver113/shougang/jiantou.png">
						明珠花园<img src="images/ver113/shougang/jiantou.png">四实小
						</p>
                     </div>
					 <div class="part">
                        <strong>
						<span>燕山线</span>
						</strong>
                        <p>
						迁钢厂区<img src="images/ver113/shougang/jiantou.png">
						西湖宾馆<img src="images/ver113/shougang/jiantou.png">二水厂<img src="images/ver113/shougang/jiantou.png">
						锦江饭店<img src="images/ver113/shougang/jiantou.png">金三元<img src="images/ver113/shougang/jiantou.png">
						邮政局<img src="images/ver113/shougang/jiantou.png">建设银行<img src="images/ver113/shougang/jiantou.png">
						常青小区<img src="images/ver113/shougang/jiantou.png">北环路<img src="images/ver113/shougang/jiantou.png">
						河畔人家<img src="images/ver113/shougang/jiantou.png">毛纺厂
						</p>
                     </div>


					</div>
                </li>
            </ul>

    </div>
</form>
   
</body>
<script type="text/javascript">
$(document).ready(function(){
			var hjHtml="";
			var hqHtml="";
			var temporaryHtml="";
			var url = "/defaultroot/ICCardAction!getTakeBusData.action?randomid=" + (new Date()).getTime();
					$.ajax({
						url: url,
						type: "post",
						async: false,
						success: function (data) {
						data = data.replace(/(^\s*)|(\s*$)/g, '');
						if(data != ''){
							data = eval('('+data+')');
							var assignJson = data.data.assignJson;
							if(assignJson != '' && assignJson.length >0){
							for(var i=0;i<assignJson.length;i++){
								if(assignJson[i].hj != ''){
									hjHtml += '<div class="part"><strong><span>'+assignJson[i].date+'</span><span>'+assignJson[i].week+'</span><span>10:00</span></strong><p>'+assignJson[i].hj+'</p></div>';
								}
								if(assignJson[i].hq != ''){
									hqHtml += '<div class="part"><strong><span>'+assignJson[i].date+'</span><span>'+assignJson[i].week+'</span><span>15:00</span></strong><p>'+assignJson[i].hq+'</p></div>';
								}
							}
								$("#hj").html(hjHtml);
								$("#hq").html(hqHtml);
								}
							var temporaryJson = data.data.temporaryJson;
							if(temporaryJson != '' && temporaryJson.length >0){
							for(var i=0;i<temporaryJson.length;i++){
									 //1已经申请等待审批2审批完毕3审批未通过4乘车已安排6车已满员，无座位10已乘车11已申请取消乘车12乘车已取消13取消乘车申请已撤销
									 var status = temporaryJson[i].status;
									 var statusStr = "";
									 var busDate = "";
									 if(status == '1'){
										 statusStr='已经申请等待审批';
									 }else if(status == '2'){
										 statusStr='审批完毕';
									 }else if(status == '3'){
										 statusStr='审批未通过';
									 }else if(status == '4'){
										 statusStr='乘车已安排';
									 }else if(status == '6'){
										 statusStr='车已满员，无座位';
									 }else if(status == '10'){
										 statusStr='已乘车';
									 }else if(status == '11'){
										 statusStr='已申请取消乘车';
									 }else if(status == '12'){
										 statusStr='乘车已取消';
									 }else if(status == '13'){
										 statusStr='取消乘车申请已撤销';
									 }
									 busDate = temporaryJson[i].busDate;
									 if(busDate.length > 11){
										 busDate = busDate.substring(0,10);
									 }
									 temporaryHtml += '<div class="set clearfix">'+'<div class="fl">'+busDate +'&nbsp;'+ temporaryJson[i].busTime+'<br>'+temporaryJson[i].assignName+'</div>'+'<a class="btn btn-wh-line fr">'+temporaryJson[i].busNumber+'车<br>'+temporaryJson[i].seatNumber+'号座<br>'+statusStr+'</a></div>';
								}
							}else{
								temporaryHtml = '<div class="set">没有未完成的临时乘车</div>';
							}
							$("#applyBus").after(temporaryHtml);
							}
						},
						error: function (XMLHttpRequest, textStatus, errorThrown) {
							alert(XMLHttpRequest);
							alert(textStatus);
							alert(errorThrown);
						}
					});

});

$(".car-line li").click(function(){
  
  if($(this).hasClass("open")){
  	     $(this).removeClass("open");
    }
    else{
    	 $(this).addClass("open").siblings().removeClass("open");
    }

     
})


</script>

</html>
