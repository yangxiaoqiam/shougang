/*!
 * =====================================================
 * title:万户OA PC端 - 基于BootStrap深度定制
 * version: 0.1.4 *
 * author: shionphan@126.com, 541951523@qq.com *
 * =====================================================
 */
/*!

 @Name：layer v2.3 弹层组件
 @Author：贤心
 @Site：http://layer.layui.com
 @License：LGPL
    
 */

;!function(window, undefined){
"use strict";

var $, win, ready = {
  getPath: function(){
    var js = document.scripts, script = js[js.length - 1], jsPath = script.src;
    if(script.getAttribute('merge')) return;
    return jsPath.substring(0, jsPath.lastIndexOf("/") + 1);
  }(),
  
  //屏蔽Enter触发弹层
  enter: function(e){
    if(e.keyCode === 13) e.preventDefault();
  },
  config: {}, end: {},
  btn: ['&#x786E;&#x5B9A;','&#x53D6;&#x6D88;'],
  
  //五种原始层模式
  type: ['dialog', 'page', 'iframe', 'loading', 'tips']
};

//默认内置方法。
var layer = {
  v: '2.3',
  ie6: !!window.ActiveXObject&&!window.XMLHttpRequest,
  index: 0,
  path: ready.getPath,
  config: function(options, fn){
    var item = 0;
    options = options || {};
    layer.cache = ready.config = $.extend(ready.config, options);
    layer.path = ready.config.path || layer.path;
    typeof options.extend === 'string' && (options.extend = [options.extend]);
    layer.use('skin/layer.css', (options.extend && options.extend.length > 0) ? (function loop(){
      var ext = options.extend;
      layer.use(ext[ext[item] ? item : item-1], item < ext.length ? function(){
        ++item; 
        return loop;
      }() : fn);
    }()) : fn);
    return this;
  },
  
  //载入配件
  use: function(module, fn, readyMethod){
    var i = 0, head = $('head')[0];
    var module = module.replace(/\s/g, '');
    var iscss = /\.css$/.test(module);
    var node = document.createElement(iscss ? 'link' : 'script');
    var id = 'layui_layer_' + module.replace(/\.|\//g, '');
    if(!layer.path) return;
    if(iscss){
      node.rel = 'stylesheet';
    }
    node[iscss ? 'href' : 'src'] = /^http:\/\//.test(module) ? module : layer.path + module;
    node.id = id;
    if(!$('#'+ id)[0]){
      head.appendChild(node);
    }
    //轮询加载就绪
    ;(function poll() {
      ;(iscss ? parseInt($('#'+id).css('width')) === 1989 : layer[readyMethod||id]) ? function(){
        fn && fn();
        try { iscss || head.removeChild(node); } catch(e){};
      }() : setTimeout(poll, 100);
    }());
    return this;
  },
  
  ready: function(path, fn){
    var type = typeof path === 'function';
    if(type) fn = path;
    layer.config($.extend(ready.config, function(){
       return type ? {} : {path: path};
    }()), fn);
    return this;
  },
  
  //各种快捷引用
  alert: function(content, options, yes){
    var type = typeof options === 'function';
    if(type) yes = options;
    return layer.open($.extend({
      content: content,
      yes: yes
    }, type ? {} : options));
  }, 
  
  confirm: function(content, options, yes, cancel){ 
    var type = typeof options === 'function';
    if(type){
      cancel = yes;
      yes = options;
    }
    return layer.open($.extend({
      content: content,
      btn: ready.btn,
      yes: yes,
      btn2: cancel
    }, type ? {} : options));
  },
  
  msg: function(content, options, end){ //最常用提示层
    var type = typeof options === 'function', rskin = ready.config.skin;
    var skin = (rskin ? rskin + ' ' + rskin + '-msg' : '')||'layui-layer-msg';
    var shift = doms.anim.length - 1;
    if(type) end = options;
    return layer.open($.extend({
      content: content,
      time: 3000,
      shade: false,
      skin: skin,
      title: false,
      closeBtn: false,
      btn: false,
      end: end
    }, (type && !ready.config.skin) ? {
      skin: skin + ' layui-layer-hui',
      shift: shift
    } : function(){
       options = options || {};
       if(options.icon === -1 || options.icon === undefined && !ready.config.skin){
         options.skin = skin + ' ' + (options.skin||'layui-layer-hui');
       }
       return options;
    }()));  
  },
  
  load: function(icon, options){
    return layer.open($.extend({
      type: 3,
      icon: icon || 0,
      shade: 0.01
    }, options));
  }, 
  
  tips: function(content, follow, options){
    return layer.open($.extend({
      type: 4,
      content: [content, follow],
      closeBtn: false,
      time: 3000,
      shade: false,
      maxWidth: 210
    }, options));
  }
};

var Class = function(setings){  
  var that = this;
  that.index = ++layer.index;
  that.config = $.extend({}, that.config, ready.config, setings);
  that.creat();
};

Class.pt = Class.prototype;

//缓存常用字符
var doms = ['layui-layer', '.layui-layer-title', '.layui-layer-main', '.layui-layer-dialog', 'layui-layer-iframe', 'layui-layer-content', 'layui-layer-btn', 'layui-layer-close', 'btn'];
doms.anim = ['layer-anim', 'layer-anim-01', 'layer-anim-02', 'layer-anim-03', 'layer-anim-04', 'layer-anim-05', 'layer-anim-06'];

//默认配置
Class.pt.config = {
  type: 0,
  shade: 0.3,
  fix: true,
  move: doms[1],
  title: '&#x4FE1;&#x606F;',
  offset: 'auto',
  area: 'auto',
  closeBtn: 1,
  time: 0, //0表示不自动关闭
  zIndex: 19891014, 
  maxWidth: 360,
  shift: 0,
  icon: -1,
  scrollbar: true, //是否允许浏览器滚动条
  tips: 2
};

//容器
Class.pt.vessel = function(conType, callback){
  var that = this, times = that.index, config = that.config;
  var zIndex = config.zIndex + times, titype = typeof config.title === 'object';
  var ismax = config.maxmin && (config.type === 1 || config.type === 2);
  var titleHTML = (config.title ? '<div class="layui-layer-title" style="'+ (titype ? config.title[1] : '') +'">' 
    + (titype ? config.title[0] : config.title) 
  + '</div>' : '');
  
  config.zIndex = zIndex;
  callback([
    //遮罩
    //万户专用蒙板中增加了一个<iframe class="iframe-cover" src="about:blank"></iframe>作为解决IE8下object类控件的层级BUG
    config.shade ? ('<div class="layui-layer-shade" id="layui-layer-shade'+ times +'" times="'+ times +'" style="'+ ('z-index:'+ (zIndex-1) +'; background-color:'+ (config.shade[1]||'#000') +'; opacity:'+ (config.shade[0]||config.shade) +'; filter:alpha(opacity='+ (config.shade[0]*100||config.shade*100) +');') +'"></div>') : '',
    
    //主体
    '<div class="'+ doms[0] +' '+ (doms.anim[config.shift]||'') + (' layui-layer-'+ready.type[config.type]) + (((config.type == 0 || config.type == 2) && !config.shade) ? ' layui-layer-border' : '') + ' ' + (config.skin||'') +'" id="'+ doms[0] + times +'" type="'+ ready.type[config.type] +'" times="'+ times +'" showtime="'+ config.time +'" conType="'+ (conType ? 'object' : 'string') +'" style="z-index: '+ zIndex +'; width:'+ config.area[0] + ';height:' + config.area[1] + (config.fix ? '' : ';position:absolute;') +'">'
      + (conType && config.type != 2 ? '' : titleHTML)
      +'<div id="'+ (config.id||'') +'" class="layui-layer-content'+ ((config.type == 0 && config.icon !== -1) ? ' layui-layer-padding' :'') + (config.type == 3 ? ' layui-layer-loading'+config.icon : '') +'">'
        + (config.type == 0 && config.icon !== -1 ? '<i class="layui-layer-ico layui-layer-ico'+ config.icon +'"></i>' : '')
        + (config.type == 1 && conType ? '' : (config.content||''))
      +'</div>'
      + '<span class="layui-layer-setwin">'+ function(){
        var closebtn = ismax ? '<a class="layui-layer-min" href="javascript:;"><cite></cite></a><a class="layui-layer-ico layui-layer-max" href="javascript:;"></a>' : '';
        config.closeBtn && (closebtn += '<a class="layui-layer-ico '+ doms[7] +' '+ doms[7] + (config.title ? config.closeBtn : (config.type == 4 ? '1' : '2')) +'" href="javascript:;"></a>');
        return closebtn;
      }() + '</span>'
      + (config.btn ? function(){
        var button = '';
        typeof config.btn === 'string' && (config.btn = [config.btn]);
        //修改增加万户按钮专用样式
        for(var i = 0, len = config.btn.length; i < len; i++){
          if(i == 0){
            button += '<a class="'+ doms[6] +''+ i +' btn btn-wh">'+ config.btn[i] +'</a>'
          }
          else if(i == 1){
            button += '<a class="'+ doms[6] +''+ i +' btn btn-wh-line">'+ config.btn[i] +'</a>'
          }
          else{
            button += '<a class="'+ doms[6] +''+ i +' btn btn-default">'+ config.btn[i] +'</a>'            
          }
          //button += '<a class="'+ doms[8] +''+ i +'">'+ config.btn[i] +'</a>'
        }
        return '<div class="'+ doms[6] + ' form-btn">'+ button +'</div>'
      }() : '')
    +'<iframe class="iframe-cover" src="about:blank"></iframe></div>'
  ], titleHTML);
  return that;
};

//创建骨架
Class.pt.creat = function(){
  var that = this, config = that.config, times = that.index, nodeIndex;
  var content = config.content, conType = typeof content === 'object';
  
  if($('#'+config.id)[0])  return;
  
  if(typeof config.area === 'string'){
    config.area = config.area === 'auto' ? ['', ''] : [config.area, ''];
  }
  
  switch(config.type){
    case 0:
      config.btn = ('btn' in config) ? config.btn : ready.btn[0];
      layer.closeAll('dialog');
    break;
    case 2:
      var content = config.content = conType ? config.content : [config.content||'http://layer.layui.com', 'auto'];
      config.content = '<iframe scrolling="'+ (config.content[1]||'auto') +'" allowtransparency="true" id="'+ doms[4] +''+ times +'" name="'+ doms[4] +''+ times +'" onload="this.className=\'\';" class="layui-layer-load" frameborder="0" src="' + config.content[0] + '"></iframe>';
    break;
    case 3:
      config.title = false;
      config.closeBtn = false;
      config.icon === -1 && (config.icon === 0);
      layer.closeAll('loading');
    break;
    case 4:
      conType || (config.content = [config.content, 'body']);
      config.follow = config.content[1];
      config.content = config.content[0] + '<i class="layui-layer-TipsG"></i>';
      config.title = false;
      config.fix = false;
      config.tips = typeof config.tips === 'object' ? config.tips : [config.tips, true];
      config.tipsMore || layer.closeAll('tips');
    break;
  }
  
  //建立容器
  that.vessel(conType, function(html, titleHTML){
    $('body').append(html[0]);
    conType ? function(){
      (config.type == 2 || config.type == 4) ? function(){
        $('body').append(html[1]);
      }() : function(){
        if(!content.parents('.'+doms[0])[0]){
          content.show().addClass('layui-layer-wrap').wrap(html[1]);
          $('#'+ doms[0] + times).find('.'+doms[5]).before(titleHTML);
        }
      }();
    }() : $('body').append(html[1]);
    that.layero = $('#'+ doms[0] + times);
    config.scrollbar || doms.html.css('overflow', 'hidden').attr('layer-full', times);
  }).auto(times);

  config.type == 2 && layer.ie6 && that.layero.find('iframe').attr('src', content[0]);
  $(document).off('keydown', ready.enter).on('keydown', ready.enter);
  that.layero.on('keydown', function(e){
    $(document).off('keydown', ready.enter);
  });

  //坐标自适应浏览器窗口尺寸
  config.type == 4 ? that.tips() : that.offset();
  if(config.fix){
    win.on('resize', function(){
      that.offset();
      (/^\d+%$/.test(config.area[0]) || /^\d+%$/.test(config.area[1])) && that.auto(times);
      config.type == 4 && that.tips();
    });
  }
  
  config.time <= 0 || setTimeout(function(){
    layer.close(that.index)
  }, config.time);
  that.move().callback();
};

//自适应
Class.pt.auto = function(index){
  var that = this, config = that.config, layero = $('#'+ doms[0] + index);
  if(config.area[0] === '' && config.maxWidth > 0){
    //为了修复IE7下一个让人难以理解的bug
    if(/MSIE 7/.test(navigator.userAgent) && config.btn){
      layero.width(layero.innerWidth());
    }
    layero.outerWidth() > config.maxWidth && layero.width(config.maxWidth);
  }
  var area = [layero.innerWidth(), layero.innerHeight()];
  var titHeight = layero.find(doms[1]).outerHeight() || 0;
  var btnHeight = layero.find('.'+doms[6]).outerHeight() || 0;
  function setHeight(elem){
    elem = layero.find(elem);
    elem.height(area[1] - titHeight - btnHeight - 2*(parseFloat(elem.css('padding'))|0));
  }
  switch(config.type){
    case 2: 
      setHeight('iframe');
    break;
    default:
      if(config.area[1] === ''){
        if(config.fix && area[1] >= win.height()){
          area[1] = win.height();
          setHeight('.'+doms[5]);
        }
      } else {
        setHeight('.'+doms[5]);
      }
    break;
  }
  return that;
};

//计算坐标
Class.pt.offset = function(){
  var that = this, config = that.config, layero = that.layero;
  var area = [layero.outerWidth(), layero.outerHeight()];
  var type = typeof config.offset === 'object';
  that.offsetTop = (win.height() - area[1])/2;
  that.offsetLeft = (win.width() - area[0])/2;
  if(type){
    that.offsetTop = config.offset[0];
    that.offsetLeft = config.offset[1]||that.offsetLeft;
  } else if(config.offset !== 'auto'){
    that.offsetTop = config.offset;
    if(config.offset === 'rb'){ //右下角
      that.offsetTop = win.height() - area[1];
      that.offsetLeft = win.width() - area[0];
    }
  }
  if(!config.fix){
    that.offsetTop = /%$/.test(that.offsetTop) ? 
      win.height()*parseFloat(that.offsetTop)/100
    : parseFloat(that.offsetTop);
    that.offsetLeft = /%$/.test(that.offsetLeft) ? 
      win.width()*parseFloat(that.offsetLeft)/100
    : parseFloat(that.offsetLeft);
    that.offsetTop += win.scrollTop();
    that.offsetLeft += win.scrollLeft();
  }
  layero.css({top: that.offsetTop, left: that.offsetLeft});
};

//Tips
Class.pt.tips = function(){
  var that = this, config = that.config, layero = that.layero;
  var layArea = [layero.outerWidth(), layero.outerHeight()], follow = $(config.follow);
  if(!follow[0]) follow = $('body');
  var goal = {
    width: follow.outerWidth(),
    height: follow.outerHeight(),
    top: follow.offset().top,
    left: follow.offset().left
  }, tipsG = layero.find('.layui-layer-TipsG');
  
  var guide = config.tips[0];
  config.tips[1] || tipsG.remove();
  
  goal.autoLeft = function(){
    if(goal.left + layArea[0] - win.width() > 0){
      goal.tipLeft = goal.left + goal.width - layArea[0];
      tipsG.css({right: 12, left: 'auto'});
    } else {
      goal.tipLeft = goal.left;
    };
  };
  
  //辨别tips的方位
  goal.where = [function(){ //上        
    goal.autoLeft();
    goal.tipTop = goal.top - layArea[1] - 10;
    tipsG.removeClass('layui-layer-TipsB').addClass('layui-layer-TipsT').css('border-right-color', config.tips[1]);
  }, function(){ //右
    goal.tipLeft = goal.left + goal.width + 10;
    goal.tipTop = goal.top;
    tipsG.removeClass('layui-layer-TipsL').addClass('layui-layer-TipsR').css('border-bottom-color', config.tips[1]); 
  }, function(){ //下
    goal.autoLeft();
    goal.tipTop = goal.top + goal.height + 10;
    tipsG.removeClass('layui-layer-TipsT').addClass('layui-layer-TipsB').css('border-right-color', config.tips[1]);
  }, function(){ //左
    goal.tipLeft = goal.left - layArea[0] - 10;
    goal.tipTop = goal.top;
    tipsG.removeClass('layui-layer-TipsR').addClass('layui-layer-TipsL').css('border-bottom-color', config.tips[1]);
  }];
  goal.where[guide-1]();
  
  /* 8*2为小三角形占据的空间 */
  if(guide === 1){
    goal.top - (win.scrollTop() + layArea[1] + 8*2) < 0 && goal.where[2]();
  } else if(guide === 2){
    win.width() - (goal.left + goal.width + layArea[0] + 8*2) > 0 || goal.where[3]()
  } else if(guide === 3){
    (goal.top - win.scrollTop() + goal.height + layArea[1] + 8*2) - win.height() > 0 && goal.where[0]();
  } else if(guide === 4){
     layArea[0] + 8*2 - goal.left > 0 && goal.where[1]()
  }

  layero.find('.'+doms[5]).css({
    'background-color': config.tips[1], 
    'padding-right': (config.closeBtn ? '30px' : '')
  });
  layero.css({left: goal.tipLeft, top: goal.tipTop});
}

//拖拽层
Class.pt.move = function(){
  var that = this, config = that.config, conf = {
    setY: 0,
    moveLayer: function(){
      var layero = conf.layero, mgleft = parseInt(layero.css('margin-left'));
      var lefts = parseInt(conf.move.css('left'));
      mgleft === 0 || (lefts = lefts - mgleft);
      if(layero.css('position') !== 'fixed'){
        lefts = lefts - layero.parent().offset().left;
        conf.setY = 0;
      }
      layero.css({left: lefts, top: parseInt(conf.move.css('top')) - conf.setY});
    }
  };
  
  var movedom = that.layero.find(config.move);
  config.move && movedom.attr('move', 'ok');
  movedom.css({cursor: config.move ? 'move' : 'auto'});
  
  $(config.move).on('mousedown', function(M){  
    M.preventDefault();
    if($(this).attr('move') === 'ok'){
      conf.ismove = true;
      conf.layero = $(this).parents('.'+ doms[0]);
      var xx = conf.layero.offset().left, yy = conf.layero.offset().top, ww = conf.layero.outerWidth() - 6, hh = conf.layero.outerHeight() - 6;
      if(!$('#layui-layer-moves')[0]){
        $('body').append('<div id="layui-layer-moves" class="layui-layer-moves" style="left:'+ xx +'px; top:'+ yy +'px; width:'+ ww +'px; height:'+ hh +'px; z-index:2147483584"></div>');
      }
      conf.move = $('#layui-layer-moves');
      config.moveType && conf.move.css({visibility: 'hidden'});
       
      conf.moveX = M.pageX - conf.move.position().left;
      conf.moveY = M.pageY - conf.move.position().top;
      conf.layero.css('position') !== 'fixed' || (conf.setY = win.scrollTop());
    }
  });
  
  $(document).mousemove(function(M){
    if(conf.ismove){
      var offsetX = M.pageX - conf.moveX, offsetY = M.pageY - conf.moveY;
      M.preventDefault();

      //控制元素不被拖出窗口外
      if(!config.moveOut){
        conf.setY = win.scrollTop();
        var setRig = win.width() - conf.move.outerWidth(), setTop = conf.setY;         
        offsetX < 0 && (offsetX = 0);
        offsetX > setRig && (offsetX = setRig); 
        offsetY < setTop && (offsetY = setTop);
        offsetY > win.height() - conf.move.outerHeight() + conf.setY && (offsetY = win.height() - conf.move.outerHeight() + conf.setY);
      }
      
      conf.move.css({left: offsetX, top: offsetY});  
      config.moveType && conf.moveLayer();
      
      offsetX = offsetY = setRig = setTop = null;
    }                         
  }).mouseup(function(){
    try{
      if(conf.ismove){
        conf.moveLayer();
        conf.move.remove();
        config.moveEnd && config.moveEnd();
      }
      conf.ismove = false;
    }catch(e){
      conf.ismove = false;
    }
  });
  return that;
};

Class.pt.callback = function(){
  var that = this, layero = that.layero, config = that.config;
  that.openLayer();
  if(config.success){
    if(config.type == 2){
      layero.find('iframe').on('load', function(){
        config.success(layero, that.index);
      });
    } else {
      config.success(layero, that.index);
    }
  }
  layer.ie6 && that.IE6(layero);
  
  //按钮
  layero.find('.'+ doms[6]).children('a').on('click', function(){
    var index = $(this).index();
    if(index === 0){
      if(config.yes){
        config.yes(that.index, layero)
      } else if(config['btn1']){
        config['btn1'](that.index, layero)
      } else {
        layer.close(that.index);
      }
    } else {
      var close = config['btn'+(index+1)] && config['btn'+(index+1)](that.index, layero);
      close === false || layer.close(that.index);
    }
  });
  
  //取消
  function cancel(){
    var close = config.cancel && config.cancel(that.index, layero);
    close === false || layer.close(that.index);
  }
  
  //右上角关闭回调
  layero.find('.'+ doms[7]).on('click', cancel);
  
  //点遮罩关闭
  if(config.shadeClose){
    $('#layui-layer-shade'+ that.index).on('click', function(){
      layer.close(that.index);
    });
  } 
  
  //最小化
  layero.find('.layui-layer-min').on('click', function(){
    layer.min(that.index, config);
    config.min && config.min(layero);
  });
  
  //全屏/还原
  layero.find('.layui-layer-max').on('click', function(){
    if($(this).hasClass('layui-layer-maxmin')){
      layer.restore(that.index);
      config.restore && config.restore(layero);
    } else {
      layer.full(that.index, config);
      config.full && config.full(layero);
    }
  });

  config.end && (ready.end[that.index] = config.end);
};

//for ie6 恢复select
ready.reselect = function(){
  $.each($('select'), function(index , value){
    var sthis = $(this);
    if(!sthis.parents('.'+doms[0])[0]){
      (sthis.attr('layer') == 1 && $('.'+doms[0]).length < 1) && sthis.removeAttr('layer').show(); 
    }
    sthis = null;
  });
}; 

Class.pt.IE6 = function(layero){
  var that = this, _ieTop = layero.offset().top;
  
  //ie6的固定与相对定位
  function ie6Fix(){
    layero.css({top : _ieTop + (that.config.fix ? win.scrollTop() : 0)});
  };
  ie6Fix();
  win.scroll(ie6Fix);

  //隐藏select
  $('select').each(function(index , value){
    var sthis = $(this);
    if(!sthis.parents('.'+doms[0])[0]){
      sthis.css('display') === 'none' || sthis.attr({'layer' : '1'}).hide();
    }
    sthis = null;
  });
};

//需依赖原型的对外方法
Class.pt.openLayer = function(){
  var that = this;
  
  //置顶当前窗口
  layer.zIndex = that.config.zIndex;
  layer.setTop = function(layero){
    var setZindex = function(){
      layer.zIndex++;
      layero.css('z-index', layer.zIndex + 1);
    };
    layer.zIndex = parseInt(layero[0].style.zIndex);
    layero.on('mousedown', setZindex);
    return layer.zIndex;
  };
};

ready.record = function(layero){
  var area = [
    layero.outerWidth(),
    layero.outerHeight(),
    layero.position().top, 
    layero.position().left + parseFloat(layero.css('margin-left'))
  ];
  layero.find('.layui-layer-max').addClass('layui-layer-maxmin');
  layero.attr({area: area});
};

ready.rescollbar = function(index){
  if(doms.html.attr('layer-full') == index){
    if(doms.html[0].style.removeProperty){
      doms.html[0].style.removeProperty('overflow');
    } else {
      doms.html[0].style.removeAttribute('overflow');
    }
    doms.html.removeAttr('layer-full');
  }
};

/** 内置成员 */

window.layer = layer;

//获取子iframe的DOM
layer.getChildFrame = function(selector, index){
  index = index || $('.'+doms[4]).attr('times');
  return $('#'+ doms[0] + index).find('iframe').contents().find(selector);  
};

//得到当前iframe层的索引，子iframe时使用
layer.getFrameIndex = function(name){
  return $('#'+ name).parents('.'+doms[4]).attr('times');
};

//iframe层自适应宽高
layer.iframeAuto = function(index){
  if(!index) return;
  var heg = layer.getChildFrame('html', index).outerHeight();
  var layero = $('#'+ doms[0] + index);
  var titHeight = layero.find(doms[1]).outerHeight() || 0;
  var btnHeight = layero.find('.'+doms[6]).outerHeight() || 0;
  layero.css({height: heg + titHeight + btnHeight});
  layero.find('iframe').css({height: heg});
};

//重置iframe url
layer.iframeSrc = function(index, url){
  $('#'+ doms[0] + index).find('iframe').attr('src', url);
};

//设定层的样式
layer.style = function(index, options){
  var layero = $('#'+ doms[0] + index), type = layero.attr('type');
  var titHeight = layero.find(doms[1]).outerHeight() || 0;
  var btnHeight = layero.find('.'+doms[6]).outerHeight() || 0;
  if(type === ready.type[1] || type === ready.type[2]){
    layero.css(options);
    if(type === ready.type[2]){
      layero.find('iframe').css({
        height: parseFloat(options.height) - titHeight - btnHeight
      });
    }
  }
};

//最小化
layer.min = function(index, options){
  var layero = $('#'+ doms[0] + index);
  var titHeight = layero.find(doms[1]).outerHeight() || 0;
  ready.record(layero);
  layer.style(index, {width: 180, height: titHeight, overflow: 'hidden'});
  layero.find('.layui-layer-min').hide();
  layero.attr('type') === 'page' && layero.find(doms[4]).hide();
  ready.rescollbar(index);
};

//还原
layer.restore = function(index){
  var layero = $('#'+ doms[0] + index), area = layero.attr('area').split(',');
  var type = layero.attr('type');
  layer.style(index, {
    width: parseFloat(area[0]), 
    height: parseFloat(area[1]), 
    top: parseFloat(area[2]), 
    left: parseFloat(area[3]),
    overflow: 'visible'
  });
  layero.find('.layui-layer-max').removeClass('layui-layer-maxmin');
  layero.find('.layui-layer-min').show();
  layero.attr('type') === 'page' && layero.find(doms[4]).show();
  ready.rescollbar(index);
};

//全屏
layer.full = function(index){
  var layero = $('#'+ doms[0] + index), timer;
  ready.record(layero);
  if(!doms.html.attr('layer-full')){
    doms.html.css('overflow','hidden').attr('layer-full', index);
  }
  clearTimeout(timer);
  timer = setTimeout(function(){
    var isfix = layero.css('position') === 'fixed';
    layer.style(index, {
       top: isfix ? 0 : win.scrollTop(),
       left: isfix ? 0 : win.scrollLeft(),
       width: win.width(),
       height: win.height()
    });
    layero.find('.layui-layer-min').hide();
  }, 100);
};

//改变title
layer.title = function(name, index){
  var title = $('#'+ doms[0] + (index||layer.index)).find(doms[1]);
  title.html(name);
};

//关闭layer总方法
layer.close = function(index){
  var layero = $('#'+ doms[0] + index), type = layero.attr('type');
  if(!layero[0]) return;
  if(type === ready.type[1] && layero.attr('conType') === 'object'){
    layero.children(':not(.'+ doms[5] +')').remove();
    for(var i = 0; i < 2; i++){
      layero.find('.layui-layer-wrap').unwrap().hide();
    }
  } else {
    //低版本IE 回收 iframe
    if(type === ready.type[2]){
      try {
        var iframe = $('#'+doms[4]+index)[0];
        iframe.contentWindow.document.write('');
        iframe.contentWindow.close();
        layero.find('.'+doms[5])[0].removeChild(iframe);
      } catch(e){}
    }
    layero[0].innerHTML = '';
    layero.remove();
  }
  $('#layui-layer-moves, #layui-layer-shade' + index).remove();
  layer.ie6 && ready.reselect();
  ready.rescollbar(index);
  $(document).off('keydown', ready.enter);
  typeof ready.end[index] === 'function' && ready.end[index]();
  delete ready.end[index]; 
};

//关闭所有层
layer.closeAll = function(type){
  $.each($('.'+doms[0]), function(){
    var othis = $(this);
    var is = type ? (othis.attr('type') === type) : 1;
    is && layer.close(othis.attr('times'));
    is = null;
  });
};

/** 

  拓展模块，layui开始合并在一起

 */

var cache = layer.cache||{}, skin = function(type){
  return (cache.skin ? (' ' + cache.skin + ' ' + cache.skin + '-'+type) : '');
}; 
 
//仿系统prompt
layer.prompt = function(options, yes){
  options = options || {};
  if(typeof options === 'function') yes = options;
  var prompt, content = options.formType == 2 ? '<textarea class="layui-layer-input">'+ (options.value||'') +'</textarea>' : function(){
    return '<input type="'+ (options.formType == 1 ? 'password' : 'text') +'" class="layui-layer-input" value="'+ (options.value||'') +'">';
  }();
  return layer.open($.extend({
    btn: ['&#x786E;&#x5B9A;','&#x53D6;&#x6D88;'],
    content: content,
    skin: 'layui-layer-prompt' + skin('prompt'),
    success: function(layero){
      prompt = layero.find('.layui-layer-input');
      prompt.focus();
    }, yes: function(index){
      var value = prompt.val();
      if(value === ''){
        prompt.focus();
      } else if(value.length > (options.maxlength||500)) {
        layer.tips('&#x6700;&#x591A;&#x8F93;&#x5165;'+ (options.maxlength || 500) +'&#x4E2A;&#x5B57;&#x6570;', prompt, {tips: 1});
      } else {
        yes && yes(value, index, prompt);
      }
    }
  }, options));
};

//tab层
layer.tab = function(options){
  options = options || {};
  var tab = options.tab || {};
  return layer.open($.extend({
    type: 1,
    skin: 'layui-layer-tab' + skin('tab'),
    title: function(){
      var len = tab.length, ii = 1, str = '';
      if(len > 0){
        str = '<span class="layui-layer-tabnow">'+ tab[0].title +'</span>';
        for(; ii < len; ii++){
          str += '<span>'+ tab[ii].title +'</span>';
        }
      }
      return str;
    }(),
    content: '<ul class="layui-layer-tabmain">'+ function(){
      var len = tab.length, ii = 1, str = '';
      if(len > 0){
        str = '<li class="layui-layer-tabli xubox_tab_layer">'+ (tab[0].content || 'no content') +'</li>';
        for(; ii < len; ii++){
          str += '<li class="layui-layer-tabli">'+ (tab[ii].content || 'no  content') +'</li>';
        }
      }
      return str;
    }() +'</ul>',
    success: function(layero){
      var btn = layero.find('.layui-layer-title').children();
      var main = layero.find('.layui-layer-tabmain').children();
      btn.on('mousedown', function(e){
        e.stopPropagation ? e.stopPropagation() : e.cancelBubble = true;
        var othis = $(this), index = othis.index();
        othis.addClass('layui-layer-tabnow').siblings().removeClass('layui-layer-tabnow');
        main.eq(index).show().siblings().hide();
        typeof options.change === 'function' && options.change(index);
      });
    }
  }, options));
};

//相册层
layer.photos = function(options, loop, key){
  var dict = {};
  options = options || {};
  if(!options.photos) return;
  var type = options.photos.constructor === Object;
  var photos = type ? options.photos : {}, data = photos.data || [];
  var start = photos.start || 0;
  dict.imgIndex = (start|0) + 1;
  
  options.img = options.img || 'img';

  if(!type){ //页面直接获取
    var parent = $(options.photos), pushData = function(){
      data = [];
      parent.find(options.img).each(function(index){
        var othis = $(this);
        othis.attr('layer-index', index);
        data.push({
          alt: othis.attr('alt'),
          pid: othis.attr('layer-pid'),
          src: othis.attr('layer-src') || othis.attr('src'),
          thumb: othis.attr('src')
        });
      })
    };
    
    pushData();
    
    if (data.length === 0) return;
    
    loop || parent.on('click', options.img, function(){
      var othis = $(this), index = othis.attr('layer-index'); 
      layer.photos($.extend(options, {
        photos: {
          start: index,
          data: data,
          tab: options.tab
        },
        full: options.full
      }), true);
      pushData();
    })
    
    //不直接弹出
    if(!loop) return;
    
  } else if (data.length === 0){
    return layer.msg('&#x6CA1;&#x6709;&#x56FE;&#x7247;');
  }
  
  //上一张
  dict.imgprev = function(key){
    dict.imgIndex--;
    if(dict.imgIndex < 1){
      dict.imgIndex = data.length;
    }
    dict.tabimg(key);
  };
  
  //下一张
  dict.imgnext = function(key,errorMsg){
    dict.imgIndex++;
    if(dict.imgIndex > data.length){
      dict.imgIndex = 1;
      if (errorMsg) {return};
    }
    dict.tabimg(key)
  };
  
  //方向键
  dict.keyup = function(event){
    if(!dict.end){
      var code = event.keyCode;
      event.preventDefault();
      if(code === 37){
        dict.imgprev(true);
      } else if(code === 39) {
        dict.imgnext(true);
      } else if(code === 27) {
        layer.close(dict.index);
      }
    }
  }
  
  //切换
  dict.tabimg = function(key){
    if(data.length <= 1) return;
    photos.start = dict.imgIndex - 1;
    layer.close(dict.index);
    layer.photos(options, true, key);
  }
  
  //一些动作
  dict.event = function(){
    dict.bigimg.hover(function(){
      dict.imgsee.show();
    }, function(){
      dict.imgsee.hide();
    });
    
    dict.bigimg.find('.layui-layer-imgprev').on('click', function(event){
      event.preventDefault();
      dict.imgprev();
    });  
    
    dict.bigimg.find('.layui-layer-imgnext').on('click', function(event){     
      event.preventDefault();
      dict.imgnext();
    });
    
    $(document).on('keyup', dict.keyup);
  };
  
  //图片预加载
  function loadImage(url, callback, error) {   
    var img = new Image();
    img.src = url; 
    if(img.complete){
      return callback(img);
    }
    img.onload = function(){
      img.onload = null;
      callback(img);
    };
    img.onerror = function(e){
      img.onerror = null;
      error(e);
    };  
  };
  
  dict.loadi = layer.load(1, {
    shade: 'shade' in options ? false : 0.9,
    scrollbar: false
  });
  loadImage(data[start].src, function(img){
    layer.close(dict.loadi);
    dict.index = layer.open($.extend({
      type: 1,
      area: function(){
         var imgarea = [img.width, img.height];
         var winarea = [$(window).width() - 50, $(window).height() - 50];
         if(!options.full && imgarea[0] > winarea[0]){
           imgarea[0] = winarea[0];
           imgarea[1] = imgarea[0]*img.height/img.width;
         }
         return [imgarea[0]+'px', imgarea[1]+'px']; 
      }(),
      title: false,
      shade: 0.9,
      shadeClose: true,
      closeBtn: false,
      move: '.layui-layer-phimg img',
      moveType: 1,
      scrollbar: false,
      moveOut: true,
      shift: Math.random()*5|0,
      skin: 'layui-layer-photos' + skin('photos'),
      content: '<div class="layui-layer-phimg">'
        +'<img src="'+ data[start].src +'" alt="'+ (data[start].alt||'') +'" layer-pid="'+ data[start].pid +'">'
        +'<div class="layui-layer-imgsee">'
          +(data.length > 1 ? '<span class="layui-layer-imguide"><a href="javascript:;" class="layui-layer-iconext layui-layer-imgprev"></a><a href="javascript:;" class="layui-layer-iconext layui-layer-imgnext"></a></span>' : '')
          +'<div class="layui-layer-imgbar" style="display:'+ (key ? 'block' : '') +'"><span class="layui-layer-imgtit"><a href="javascript:;">'+ (data[start].alt||'') +'</a><em>'+ dict.imgIndex +'/'+ data.length +'</em></span></div>'
        +'</div>'
      +'</div>',
      success: function(layero, index){
        dict.bigimg = layero.find('.layui-layer-phimg');
        dict.imgsee = layero.find('.layui-layer-imguide,.layui-layer-imgbar');
        dict.event(layero);
        options.tab && options.tab(data[start], layero);
      }, end: function(){
        dict.end = true;
        $(document).off('keyup', dict.keyup);
      }
    }, options));
  }, function(){
    layer.close(dict.loadi);
    layer.msg('&#x5F53;&#x524D;&#x56FE;&#x7247;&#x5730;&#x5740;&#x5F02;&#x5E38;<br>&#x662F;&#x5426;&#x7EE7;&#x7EED;&#x67E5;&#x770B;&#x4E0B;&#x4E00;&#x5F20;&#xFF1F;', {
      time: 30000, 
      btn: ['&#x4E0B;&#x4E00;&#x5F20;', '&#x4E0D;&#x770B;&#x4E86;'], 
      yes: function(){
        data.length > 1 && dict.imgnext(true,true);
      }
    });
  });
};

//主入口
ready.run = function(){
  $ = jQuery; 
  win = $(window);
  doms.html = $('html');
  layer.open = function(deliver){
    var o = new Class(deliver);
    return o.index;
  };
};

'function' === typeof define ? define(function(){
  ready.run();
  return layer;
}) : function(){
   ready.run();
   //layer.use('skin/layer.css');
}();

}(window);
/**
 
 @Name : layDate v1.1 日期控件
 @Author: 贤心
 @Date: 2014-06-25
 @QQ群：176047195
 @Site：http://sentsin.com/layui/laydate
 
 */

+function(win){

//全局配置，如果采用默认均不需要改动
var config =  {
    path: '', //laydate所在路径
    skin: 'default', //初始化皮肤
    format: 'YYYY-MM-DD', //日期格式
    min: '1900-01-01 00:00:00', //最小日期
    max: '2099-12-31 23:59:59', //最大日期
    isv: false,
    init: true
};

var Dates = {}, doc = document, creat = 'createElement', byid = 'getElementById', tags = 'getElementsByTagName';
var as = ['laydate_box', 'laydate_void', 'laydate_click', 'LayDateSkin', 'skins/', '/laydate.css'];


//主接口
win.laydate = function(options){
    options = options || {};
    try{
        as.event = win.event ? win.event : laydate.caller.arguments[0];
    } catch(e){};
    Dates.run(options);
    return laydate;
};

laydate.v = '1.1';

//获取组件存放路径
Dates.getPath = (function(){
    var js = document.scripts, jsPath = js[js.length - 1].src;
    return config.path ? config.path : jsPath.substring(0, jsPath.lastIndexOf("/") + 1);
}());

Dates.use = function(lib, id){
    var link = doc[creat]('link');
    link.type = 'text/css';
    link.rel = 'stylesheet';
    link.href = Dates.getPath + lib + as[5];
    id && (link.id = id);
    doc[tags]('head')[0].appendChild(link);
    link = null;
};

Dates.trim = function(str){
    str = str || '';
    return str.replace(/^\s|\s$/g, '').replace(/\s+/g, ' ');
};

//补齐数位
Dates.digit = function(num){
    return num < 10 ? '0' + (num|0) : num;
};

Dates.stopmp = function(e){
    e = e || win.event;
    e.stopPropagation ? e.stopPropagation() : e.cancelBubble = true;
    return this;
};

Dates.each = function(arr, fn){
    var i = 0, len = arr.length;
    for(; i < len; i++){
        if(fn(i, arr[i]) === false){
            break
        }
    }
};

Dates.hasClass = function(elem, cls){
    elem = elem || {};
    return new RegExp('\\b' + cls +'\\b').test(elem.className);
};

Dates.addClass = function(elem, cls){
    elem = elem || {};
    Dates.hasClass(elem, cls) || (elem.className += ' ' + cls);
    elem.className = Dates.trim(elem.className);
    return this;
};

Dates.removeClass = function(elem, cls) {
    elem = elem || {};
    if (Dates.hasClass(elem, cls)) {
        var reg = new RegExp('\\b' + cls +'\\b');
        elem.className = elem.className.replace(reg, '');
    }
    return this;
};

//清除css属性
Dates.removeCssAttr = function(elem, attr){
    var s = elem.style;
    if(s.removeProperty){
        s.removeProperty(attr);
    } else {
        s.removeAttribute(attr);
    }
};

//显示隐藏
Dates.shde = function(elem, type){
    elem.style.display = type ? 'none' : 'block';
};

//简易选择器
Dates.query = function(node){
    if(node && node.nodeType === 1){
        if(node.tagName.toLowerCase() !== 'input'){
            throw new Error('选择器elem错误');
        }
        return node;
    }

    var node = (Dates.trim(node)).split(' '), elemId = doc[byid](node[0].substr(1)), arr;
    if(!elemId){
        return;
    } else if(!node[1]){
        return elemId;
    } else if(/^\./.test(node[1])){
        var find, child = node[1].substr(1), exp = new RegExp('\\b' + child +'\\b');
        arr = []
        find = doc.getElementsByClassName ? elemId.getElementsByClassName(child) : elemId[tags]('*');
        Dates.each(find, function(ii, that){
            exp.test(that.className) && arr.push(that); 
        });
        return arr[0] ? arr : '';
    } else {
        arr = elemId[tags](node[1]);
        return arr[0] ? elemId[tags](node[1]) : '';
    }
};

//事件监听器
Dates.on = function(elem, even, fn){
    elem.attachEvent ? elem.attachEvent('on'+ even, function(){
        fn.call(elem, win.even);
    }) : elem.addEventListener(even, fn, false);
    return Dates;
};

//阻断mouseup
Dates.stopMosup = function(evt, elem){
    if(evt !== 'mouseup'){
        Dates.on(elem, 'mouseup', function(ev){
            Dates.stopmp(ev);
        });
    }
};

Dates.run = function(options){
    var S = Dates.query, elem, devt, even = as.event, target;
    try {
        target = even.target || even.srcElement || {};
    } catch(e){
        target = {};
    }
    elem = options.elem ? S(options.elem) : target;

    as.elemv = /textarea|input/.test(elem.tagName.toLocaleLowerCase()) ? 'value' : 'innerHTML';
    if (('init' in options ? options.init : config.init) && (!elem[as.elemv])) elem[as.elemv] = laydate.now(null, options.format || config.format);

    if(even && target.tagName){
        if(!elem || elem === Dates.elem){
            return;
        }
        Dates.stopMosup(even.type, elem);
        Dates.stopmp(even);
        Dates.view(elem, options);
        Dates.reshow();
    } else {
        devt = options.event || 'click';
        Dates.each((elem.length|0) > 0 ? elem : [elem], function(ii, that){
            Dates.stopMosup(devt, that);
            Dates.on(that, devt, function(ev){
                Dates.stopmp(ev);
                if(that !== Dates.elem){
                    Dates.view(that, options);
                    Dates.reshow();
                }
            });
        });
    }

    //chgSkin(options.skin || config.skin)
};

Dates.scroll = function(type){
    type = type ? 'scrollLeft' : 'scrollTop';
    return doc.body[type] | doc.documentElement[type];
};

Dates.winarea = function(type){
    return document.documentElement[type ? 'clientWidth' : 'clientHeight']
};

//判断闰年
Dates.isleap = function(year){
    return (year%4 === 0 && year%100 !== 0) || year%400 === 0;
};

//检测是否在有效期
Dates.checkVoid = function(YY, MM, DD){
    var back = [];
    YY = YY|0;
    MM = MM|0;
    DD = DD|0;
    if(YY < Dates.mins[0]){
        back = ['y'];
    } else if(YY > Dates.maxs[0]){
        back = ['y', 1];
    } else if(YY >= Dates.mins[0] && YY <= Dates.maxs[0]){
        if(YY == Dates.mins[0]){
            if(MM < Dates.mins[1]){
                back = ['m'];
            } else if(MM == Dates.mins[1]){
                if(DD < Dates.mins[2]){
                    back = ['d'];
                }
            }
        }
        if(YY == Dates.maxs[0]){
            if(MM > Dates.maxs[1]){
                back = ['m', 1];
            } else if(MM == Dates.maxs[1]){
                if(DD > Dates.maxs[2]){
                    back = ['d', 1];
                }
            }
        }
    }
    return back;
};

//时分秒的有效检测
Dates.timeVoid = function(times, index){
    if(Dates.ymd[1]+1 == Dates.mins[1] && Dates.ymd[2] == Dates.mins[2]){
        if(index === 0 && (times < Dates.mins[3])){
            return 1;
        } else if(index === 1 && times < Dates.mins[4]){
            return 1;
        } else if(index === 2 && times < Dates.mins[5]){
            return 1;
        }
    } else if(Dates.ymd[1]+1 == Dates.maxs[1] && Dates.ymd[2] == Dates.maxs[2]){
        if(index === 0 && times > Dates.maxs[3]){
            return 1;
        } else if(index === 1 && times > Dates.maxs[4]){
            return 1;
        } else if(index === 2 && times > Dates.maxs[5]){
            return 1;
        }
    }
    if(times > (index ? 59 : 23)){
        return 1;
    }
};

//检测日期是否合法
Dates.check = function(){
    var reg = Dates.options.format.replace(/YYYY|MM|DD|hh|mm|ss/g,'\\d+\\').replace(/\\$/g, '');
    var exp = new RegExp(reg), value = Dates.elem[as.elemv];
    var arr = value.match(/\d+/g) || [], isvoid = Dates.checkVoid(arr[0], arr[1], arr[2]);
    if(value.replace(/\s/g, '') !== ''){
        if(!exp.test(value)){
            Dates.elem[as.elemv] = '';
            Dates.msg('日期不符合格式，请重新选择。');
            return 1;
        } else if(isvoid[0]){
            Dates.elem[as.elemv] = '';
            Dates.msg('日期不在有效期内，请重新选择。');
            return 1;
        } else {
            isvoid.value = Dates.elem[as.elemv].match(exp).join();
            arr = isvoid.value.match(/\d+/g);
            if(arr[1] < 1){
                arr[1] = 1;
                isvoid.auto = 1;
            } else if(arr[1] > 12){
                arr[1] = 12;
                isvoid.auto = 1;
            } else if(arr[1].length < 2){
                isvoid.auto = 1;
            }
            if(arr[2] < 1){
                arr[2] = 1;
                isvoid.auto = 1;
            } else if(arr[2] > Dates.months[(arr[1]|0)-1]){
                arr[2] = 31;
                isvoid.auto = 1;
            } else if(arr[2].length < 2){
                isvoid.auto = 1;
            }
            if(arr.length > 3){
                if(Dates.timeVoid(arr[3], 0)){
                    isvoid.auto = 1;
                };
                if(Dates.timeVoid(arr[4], 1)){
                    isvoid.auto = 1;
                };
                if(Dates.timeVoid(arr[5], 2)){
                    isvoid.auto = 1;
                };
            }
            if(isvoid.auto){
                Dates.creation([arr[0], arr[1]|0, arr[2]|0], 1);
            } else if(isvoid.value !== Dates.elem[as.elemv]){
                Dates.elem[as.elemv] = isvoid.value;
            }
        }
    }
};

//生成日期
Dates.months = [31, null, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
Dates.viewDate = function(Y, M, D){
    var S = Dates.query, log = {}, De = new Date();
    Y < (Dates.mins[0]|0) && (Y = (Dates.mins[0]|0));
    Y > (Dates.maxs[0]|0) && (Y = (Dates.maxs[0]|0));
    
    De.setFullYear(Y, M, D);
    log.ymd = [De.getFullYear(), De.getMonth(), De.getDate()];
    
    Dates.months[1] = Dates.isleap(log.ymd[0]) ? 29 : 28;
    
    De.setFullYear(log.ymd[0], log.ymd[1], 1);
    log.FDay = De.getDay();
    
    log.PDay = Dates.months[M === 0 ? 11 : M - 1] - log.FDay + 1;
    log.NDay = 1;
    
    //渲染日
    Dates.each(as.tds, function(i, elem){
        var YY = log.ymd[0], MM = log.ymd[1] + 1, DD;
        elem.className = '';
        if(i < log.FDay){
            elem.innerHTML = DD = i + log.PDay;
            Dates.addClass(elem, 'laydate_nothis');
            MM === 1 && (YY -= 1);
            MM = MM === 1 ? 12 : MM - 1; 
        } else if(i >= log.FDay && i < log.FDay + Dates.months[log.ymd[1]]){
            elem.innerHTML = DD = i  - log.FDay + 1;
            if(i - log.FDay + 1 === log.ymd[2]){
                Dates.addClass(elem, as[2]);
                log.thisDay = elem;
            }
        } else {
            elem.innerHTML = DD = log.NDay++;
            Dates.addClass(elem, 'laydate_nothis');
            MM === 12 && (YY += 1);
            MM = MM === 12 ? 1 : MM + 1; 
        }
       
        if(Dates.checkVoid(YY, MM, DD)[0]){
            Dates.addClass(elem, as[1]);
        }
        
        Dates.options.festival && Dates.festival(elem, MM + '.' + DD);
        elem.setAttribute('y', YY);
        elem.setAttribute('m', MM);
        elem.setAttribute('d', DD);
        YY = MM = DD = null;
    });
    
    Dates.valid = !Dates.hasClass(log.thisDay, as[1]);
    Dates.ymd = log.ymd;
    
    //锁定年月
    as.year.value = Dates.ymd[0] + '年';
    as.month.value = Dates.digit(Dates.ymd[1] + 1) + '月';
    
    //定位月
    Dates.each(as.mms, function(i, elem){
        var getCheck = Dates.checkVoid(Dates.ymd[0], (elem.getAttribute('m')|0) + 1);
        if(getCheck[0] === 'y' || getCheck[0] === 'm'){
            Dates.addClass(elem, as[1]);
        } else {
            Dates.removeClass(elem, as[1]);
        }
        Dates.removeClass(elem, as[2]);
        getCheck = null
    });
    Dates.addClass(as.mms[Dates.ymd[1]], as[2]);
    
    //定位时分秒
    log.times = [
        Dates.inymd[3]|0 || 0, 
        Dates.inymd[4]|0 || 0, 
        Dates.inymd[5]|0 || 0
    ];
    Dates.each(new Array(3), function(i){
        Dates.hmsin[i].value = Dates.digit(Dates.timeVoid(log.times[i], i) ? Dates.mins[i+3]|0 : log.times[i]|0);
    });
    
    //确定按钮状态
    Dates[Dates.valid ? 'removeClass' : 'addClass'](as.ok, as[1]);
};

//节日
Dates.festival = function(td, md){
    var str;
    switch(md){
        case '1.1':
            str = '元旦';
        break;
        case '3.8':
            str = '妇女';
        break;
        case '4.5':
            str = '清明';
        break;
        case '5.1':
            str = '劳动';
        break;
        case '6.1':
            str = '儿童';
        break;
        case '9.10':
            str = '教师';
        break;
        case '10.1':
            str = '国庆';
        break;
    };
    str && (td.innerHTML = str);
    str = null;
};

//生成年列表
Dates.viewYears = function(YY){
    var S = Dates.query, str = '';
    Dates.each(new Array(14), function(i){
        if(i === 7) {
            str += '<li '+ (parseInt(as.year.value) === YY ? 'class="'+ as[2] +'"' : '') +' y="'+ YY +'">'+ YY +'年</li>';
        } else {
            str += '<li y="'+ (YY-7+i) +'">'+ (YY-7+i) +'年</li>';
        }
    }); 
    S('#laydate_ys').innerHTML = str;
    Dates.each(S('#laydate_ys li'), function(i, elem){
        if(Dates.checkVoid(elem.getAttribute('y'))[0] === 'y'){
            Dates.addClass(elem, as[1]);
        } else {
            Dates.on(elem, 'click', function(ev){
                Dates.stopmp(ev).reshow();
                Dates.viewDate(this.getAttribute('y')|0, Dates.ymd[1], Dates.ymd[2]);
            });
        }
    });
};

//初始化面板数据
Dates.initDate = function(){
    var S = Dates.query, log = {}, De = new Date();
    var ymd = Dates.elem[as.elemv].match(/\d+/g) || [];
    if(ymd.length < 3){
        ymd = Dates.options.start.match(/\d+/g) || [];
        if(ymd.length < 3){
            ymd = [De.getFullYear(), De.getMonth()+1, De.getDate()];
        }
    }
    Dates.inymd = ymd;
    Dates.viewDate(ymd[0], ymd[1]-1, ymd[2]);
};

//是否显示零件
Dates.iswrite = function(){
    var S = Dates.query, log = {
        time: S('#laydate_hms')
    };
    Dates.shde(log.time, !Dates.options.istime);
    Dates.shde(as.oclear, !('isclear' in Dates.options ? Dates.options.isclear : 1));
    Dates.shde(as.otoday, !('istoday' in Dates.options ? Dates.options.istoday : 1));
    Dates.shde(as.ok, !('issure' in Dates.options ? Dates.options.issure : 1));
};

//方位辨别
Dates.orien = function(obj, pos){
    var tops, rect = Dates.elem.getBoundingClientRect();
    obj.style.left = rect.left + (pos ? 0 : Dates.scroll(1)) + 'px';
    if(rect.bottom + obj.offsetHeight/1.5 <= Dates.winarea()){
        tops = rect.bottom + 5;         
    } else {
        tops = rect.top > obj.offsetHeight/1.5 ? rect.top - obj.offsetHeight - 5 : Dates.winarea() - obj.offsetHeight;
    }
    obj.style.top = Math.max(tops + (pos ? 0 : Dates.scroll()),1) + 'px';
};

//吸附定位
Dates.follow = function(obj){
    if(Dates.options.fixed){
        obj.style.position = 'fixed';
        Dates.orien(obj, 1);
    } else {
        obj.style.position = 'absolute';
        Dates.orien(obj);
    }
};

//生成表格
Dates.viewtb = (function(){
    var tr, view = [], weeks = [ '日', '一', '二', '三', '四', '五', '六'];
    var log = {}, table = doc[creat]('table'), thead = doc[creat]('thead');
    thead.appendChild(doc[creat]('tr'));
    log.creath = function(i){
        var th = doc[creat]('th');
        th.innerHTML = weeks[i];
        thead[tags]('tr')[0].appendChild(th);
        th = null;
    };
    
    Dates.each(new Array(6), function(i){
        view.push([]);
        tr = table.insertRow(0);
        Dates.each(new Array(7), function(j){
            view[i][j] = 0;
            i === 0 && log.creath(j);
            tr.insertCell(j);
        });
    });
    
    table.insertBefore(thead, table.children[0]); 
    table.id = table.className = 'laydate_table';
    tr = view = null;
    return table.outerHTML.toLowerCase();
}());

//渲染控件骨架
Dates.view = function(elem, options){
    var S = Dates.query, div, log = {};
    options = options || elem;

    Dates.elem = elem;
    Dates.options = options;
    Dates.options.format || (Dates.options.format = config.format);
    Dates.options.start = Dates.options.start || '';
    Dates.mm = log.mm = [Dates.options.min || config.min, Dates.options.max || config.max];
    Dates.mins = log.mm[0].match(/\d+/g);
    Dates.maxs = log.mm[1].match(/\d+/g);
    
    if(!Dates.box){
        div = doc[creat]('div');
        div.id = as[0];
        div.className = as[0];
        div.style.cssText = 'position: absolute;';
        div.setAttribute('name', 'laydate-v'+ laydate.v);
        
        div.innerHTML =  log.html = '<div class="laydate_top">'
          +'<div class="laydate_ym laydate_y" id="laydate_YY">'
            +'<a class="laydate_choose laydate_chprev laydate_tab"><cite></cite></a>'
            +'<input id="laydate_y" readonly><label></label>'
            +'<a class="laydate_choose laydate_chnext laydate_tab"><cite></cite></a>'
            +'<div class="laydate_yms">'
              +'<a class="laydate_tab laydate_chtop"><cite></cite></a>'
              +'<ul id="laydate_ys"></ul>'
              +'<a class="laydate_tab laydate_chdown"><cite></cite></a>'
            +'</div>'
          +'</div>'
          +'<div class="laydate_ym laydate_m" id="laydate_MM">'
            +'<a class="laydate_choose laydate_chprev laydate_tab"><cite></cite></a>'
            +'<input id="laydate_m" readonly><label></label>'
            +'<a class="laydate_choose laydate_chnext laydate_tab"><cite></cite></a>'
            +'<div class="laydate_yms" id="laydate_ms">'+ function(){
                var str = '';
                Dates.each(new Array(12), function(i){
                    str += '<span m="'+ i +'">'+ Dates.digit(i+1) +'月</span>';
                });
                return str;
            }() +'</div>'
          +'</div>'
        +'</div>'
        
        + Dates.viewtb
        
        +'<div class="laydate_bottom">'
          +'<ul id="laydate_hms">'
            +'<li class="laydate_sj">时间</li>'
            +'<li><input readonly>:</li>'
            +'<li><input readonly>:</li>'
            +'<li><input readonly></li>'
          +'</ul>'
          +'<div class="laydate_time" id="laydate_time"></div>'
          +'<div class="laydate_btn">'
            +'<a id="laydate_clear">清空</a>'
            +'<a id="laydate_today">今天</a>'
            +'<a id="laydate_ok">确认</a>'
          +'</div>'
          +(config.isv ? '<a href="http://sentsin.com/layui/laydate/" class="laydate_v" target="_blank">laydate-v'+ laydate.v +'</a>' : '')
        +'</div>';
        doc.body.appendChild(div); 
        Dates.box = S('#'+as[0]);        
        Dates.events();
        div = null;
    } else {
        Dates.shde(Dates.box);
    }
    Dates.follow(Dates.box);
    options.zIndex ? Dates.box.style.zIndex = options.zIndex : Dates.removeCssAttr(Dates.box, 'z-index');
    Dates.stopMosup('click', Dates.box);
    
    Dates.initDate();
    Dates.iswrite();
    Dates.check();
};

//隐藏内部弹出元素
Dates.reshow = function(){
    Dates.each(Dates.query('#'+ as[0] +' .laydate_show'), function(i, elem){
        Dates.removeClass(elem, 'laydate_show');
    });
    return this;
};

//关闭控件
Dates.close = function(){
    Dates.reshow();
    Dates.shde(Dates.query('#'+ as[0]), 1);
    Dates.elem = null;
};

//转换日期格式
Dates.parse = function(ymd, hms, format){
    ymd = ymd.concat(hms);
    format = format || (Dates.options ? Dates.options.format : config.format);
    return format.replace(/YYYY|MM|DD|hh|mm|ss/g, function(str, index){
        ymd.index = ++ymd.index|0;
        return Dates.digit(ymd[ymd.index]);
    });     
};

//返回最终日期
Dates.creation = function(ymd, hide){
    var S = Dates.query, hms = Dates.hmsin;
    var getDates = Dates.parse(ymd, [hms[0].value, hms[1].value, hms[2].value]);
    Dates.elem[as.elemv] = getDates;
    if(!hide){
        Dates.close();
        typeof Dates.options.choose === 'function' && Dates.options.choose(getDates); 
    }
};

//事件
Dates.events = function(){
    var S = Dates.query, log = {
        box: '#'+as[0]
    };
    
    //Dates.addClass(doc.body, 'laydate_body');
    
    as.tds = S('#laydate_table td');
    as.mms = S('#laydate_ms span');
    as.year = S('#laydate_y');
    as.month = S('#laydate_m');

    //显示更多年月
    Dates.each(S(log.box + ' .laydate_ym'), function(i, elem){
        Dates.on(elem, 'click', function(ev){
            Dates.stopmp(ev).reshow();
            Dates.addClass(this[tags]('div')[0], 'laydate_show');
            if(!i){
                log.YY = parseInt(as.year.value);
                Dates.viewYears(log.YY);
            }
        });
    });
    
    Dates.on(S(log.box), 'click', function(){
        Dates.reshow();
    });
    
    //切换年
    log.tabYear = function(type){  
        if(type === 0){
            Dates.ymd[0]--;
        } else if(type === 1) {
            Dates.ymd[0]++;
        } else if(type === 2) {
            log.YY -= 14;
        } else {
            log.YY += 14;
        }
        if(type < 2){
            Dates.viewDate(Dates.ymd[0], Dates.ymd[1], Dates.ymd[2]);
            Dates.reshow();
        } else {
            Dates.viewYears(log.YY);
        }
    };
    Dates.each(S('#laydate_YY .laydate_tab'), function(i, elem){
        Dates.on(elem, 'click', function(ev){
            Dates.stopmp(ev);
            log.tabYear(i);
        });
    });
    
    
    //切换月
    log.tabMonth = function(type){
        if(type){
            Dates.ymd[1]++;
            if(Dates.ymd[1] === 12){
                Dates.ymd[0]++;
                Dates.ymd[1] = 0;
            }            
        } else {
            Dates.ymd[1]--;
            if(Dates.ymd[1] === -1){
                Dates.ymd[0]--;
                Dates.ymd[1] = 11;
            }
        }
        Dates.viewDate(Dates.ymd[0], Dates.ymd[1], Dates.ymd[2]);
    };
    Dates.each(S('#laydate_MM .laydate_tab'), function(i, elem){
        Dates.on(elem, 'click', function(ev){
            Dates.stopmp(ev).reshow();
            log.tabMonth(i);
        });
    });
    
    //选择月
    Dates.each(S('#laydate_ms span'), function(i, elem){
        Dates.on(elem, 'click', function(ev){
            Dates.stopmp(ev).reshow();
            if(!Dates.hasClass(this, as[1])){
                Dates.viewDate(Dates.ymd[0], this.getAttribute('m')|0, Dates.ymd[2]);
            }
        });
    });
    
    //选择日
    Dates.each(S('#laydate_table td'), function(i, elem){
        Dates.on(elem, 'click', function(ev){
            if(!Dates.hasClass(this, as[1])){
                Dates.stopmp(ev);
                Dates.creation([this.getAttribute('y')|0, this.getAttribute('m')|0, this.getAttribute('d')|0]);
            }
        });
    });
    
    //清空
    as.oclear = S('#laydate_clear');
    Dates.on(as.oclear, 'click', function(){
        Dates.elem[as.elemv] = '';
        Dates.close();
    });
    
    //今天
    as.otoday = S('#laydate_today');
    Dates.on(as.otoday, 'click', function(){
        var now = new Date();
        Dates.creation([now.getFullYear(), now.getMonth() + 1, now.getDate()]);
    });
    
    //确认
    as.ok = S('#laydate_ok');
    Dates.on(as.ok, 'click', function(){
        if(Dates.valid){
            Dates.creation([Dates.ymd[0], Dates.ymd[1]+1, Dates.ymd[2]]);
        }
    });
    
    //选择时分秒
    log.times = S('#laydate_time');
    Dates.hmsin = log.hmsin = S('#laydate_hms input');
    log.hmss = ['小时', '分钟', '秒数'];
    log.hmsarr = [];
    
    //生成时分秒或警告信息
    Dates.msg = function(i, title){
        var str = '<div class="laydte_hsmtex">'+ (title || '提示') +'<span>×</span></div>';
        if(typeof i === 'string'){
            str += '<p>'+ i +'</p>';
            Dates.shde(S('#'+as[0]));
            Dates.removeClass(log.times, 'laydate_time1').addClass(log.times, 'laydate_msg');
        } else {
            if(!log.hmsarr[i]){
                str += '<div id="laydate_hmsno" class="laydate_hmsno">';
                Dates.each(new Array(i === 0 ? 24 : 60), function(i){
                    str += '<span>'+ i +'</span>';
                });
                str += '</div>'
                log.hmsarr[i] = str;
            } else {
                str = log.hmsarr[i];
            }
            Dates.removeClass(log.times, 'laydate_msg');
            Dates[i=== 0 ? 'removeClass' : 'addClass'](log.times, 'laydate_time1');
        }
        Dates.addClass(log.times, 'laydate_show');
        log.times.innerHTML = str;
    };
    
    log.hmson = function(input, index){
        var span = S('#laydate_hmsno span'), set = Dates.valid ? null : 1;
        Dates.each(span, function(i, elem){
            if(set){
                Dates.addClass(elem, as[1]);
            } else if(Dates.timeVoid(i, index)){
                Dates.addClass(elem, as[1]);
            } else {
                Dates.on(elem, 'click', function(ev){
                    if(!Dates.hasClass(this, as[1])){
                        input.value = Dates.digit(this.innerHTML|0);
                    }
                });
            } 
        });
        Dates.addClass(span[input.value|0], 'laydate_click');
    };
    
    //展开选择
    Dates.each(log.hmsin, function(i, elem){
        Dates.on(elem, 'click', function(ev){
            Dates.stopmp(ev).reshow();
            Dates.msg(i, log.hmss[i]);
            log.hmson(this, i);
        });
    });
    
    Dates.on(doc, 'mouseup', function(){
        var box = S('#'+as[0]);
        if(box && box.style.display !== 'none'){
            Dates.check() || Dates.close();
        }
    }).on(doc, 'keydown', function(event){
        event = event || win.event;
        var codes = event.keyCode;

        //如果在日期显示的时候按回车
        if(codes === 13 && Dates.elem){
            Dates.creation([Dates.ymd[0], Dates.ymd[1]+1, Dates.ymd[2]]);
        }
    });
};

Dates.init = (function(){
    //Dates.use('need');
    //Dates.use(as[4] + config.skin, as[3]);
    //Dates.skinLink = Dates.query('#'+as[3]);
}());

//重置定位
laydate.reset = function(){
    (Dates.box && Dates.elem) && Dates.follow(Dates.box);
};

//返回指定日期
laydate.now = function(timestamp, format){
    var De = new Date((timestamp|0) ? function(tamp){
        return tamp < 86400000 ? (+new Date + tamp*86400000) : tamp;
    }(parseInt(timestamp)) : +new Date);
    return Dates.parse(
        [De.getFullYear(), De.getMonth()+1, De.getDate()],
        [De.getHours(), De.getMinutes(), De.getSeconds()],
        format
    );
};

//皮肤选择
// laydate.skin = chgSkin;

// //内部函数
// function chgSkin(lib) {
//     Dates.skinLink.href = Dates.getPath + as[4] + lib + as[5];
// };

}(window);

// Chosen, a Select Box Enhancer for jQuery and Prototype
// by Patrick Filler for Harvest, http://getharvest.com
//
// Version 0.14.0
// Full source at https://github.com/harvesthq/chosen
// Copyright (c) 2011 Harvest http://getharvest.com

// MIT License, https://github.com/harvesthq/chosen/blob/master/LICENSE.md
// This file is generated by `grunt build`, do not edit it by hand.

//
// Modified for Joomla! UI:
// - fix zero width, based on https://github.com/harvesthq/chosen/pull/1439
// - allow to add a custom value on fly, based on https://github.com/harvesthq/chosen/pull/749
//

+(function($) {
  'use strict';
  var $, AbstractChosen, Chosen, SelectParser, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  SelectParser = (function() {
    function SelectParser() {
      this.options_index = 0;
      this.parsed = [];
    }

    SelectParser.prototype.add_node = function(child) {
      if (child.nodeName.toUpperCase() === "OPTGROUP") {
        return this.add_group(child);
      } else {
        return this.add_option(child);
      }
    };

    SelectParser.prototype.add_group = function(group) {
      var group_position, option, _i, _len, _ref, _results;

      group_position = this.parsed.length;
      this.parsed.push({
        array_index: group_position,
        group: true,
        label: this.escapeExpression(group.label),
        children: 0,
        disabled: group.disabled
      });
      _ref = group.childNodes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        option = _ref[_i];
        _results.push(this.add_option(option, group_position, group.disabled));
      }
      return _results;
    };

    SelectParser.prototype.add_option = function(option, group_position, group_disabled) {
      if (option.nodeName.toUpperCase() === "OPTION") {
        if (option.text !== "") {
          if (group_position != null) {
            this.parsed[group_position].children += 1;
          }
          this.parsed.push({
            array_index: this.parsed.length,
            options_index: this.options_index,
            value: option.value,
            text: option.text,
            html: option.innerHTML,
            selected: option.selected,
            disabled: group_disabled === true ? group_disabled : option.disabled,
            group_array_index: group_position,
            classes: option.className,
            style: option.style.cssText
          });
        } else {
          this.parsed.push({
            array_index: this.parsed.length,
            options_index: this.options_index,
            empty: true
          });
        }
        return this.options_index += 1;
      }
    };

    SelectParser.prototype.escapeExpression = function(text) {
      var map, unsafe_chars;

      if ((text == null) || text === false) {
        return "";
      }
      if (!/[\&\<\>\"\'\`]/.test(text)) {
        return text;
      }
      map = {
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "'": "&#x27;",
        "`": "&#x60;"
      };
      unsafe_chars = /&(?!\w+;)|[\<\>\"\'\`]/g;
      return text.replace(unsafe_chars, function(chr) {
        return map[chr] || "&amp;";
      });
    };

    return SelectParser;

  })();

  SelectParser.select_to_array = function(select) {
    var child, parser, _i, _len, _ref;

    parser = new SelectParser();
    _ref = select.childNodes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      child = _ref[_i];
      parser.add_node(child);
    }
    return parser.parsed;
  };

  AbstractChosen = (function() {
    function AbstractChosen(form_field, options) {
      this.form_field = form_field;
      this.options = options != null ? options : {};
      if (!AbstractChosen.browser_is_supported()) {
        return;
      }
      this.is_multiple = this.form_field.multiple;
      this.set_default_text();
      this.set_default_values();
      this.setup();
      this.set_up_html();
      this.register_observers();
      this.finish_setup();
    }

    AbstractChosen.prototype.set_default_values = function() {
      var _this = this;

      this.click_test_action = function(evt) {
        return _this.test_active_click(evt);
      };
      this.activate_action = function(evt) {
        return _this.activate_field(evt);
      };
      this.active_field = false;
      this.mouse_on_container = false;
      this.results_showing = false;
      this.result_highlighted = null;
      this.result_single_selected = null;
      /*<JUI>*/
      /* Original: not exist */
      this.allow_custom_value = false;
      /*</JUI>*/
      this.allow_single_deselect = (this.options.allow_single_deselect != null) && (this.form_field.options[0] != null) && this.form_field.options[0].text === "" ? this.options.allow_single_deselect : false;
      this.disable_search_threshold = this.options.disable_search_threshold || 0;
      this.disable_search = this.options.disable_search || false;
      this.enable_split_word_search = this.options.enable_split_word_search != null ? this.options.enable_split_word_search : true;
      this.group_search = this.options.group_search != null ? this.options.group_search : true;
      this.search_contains = this.options.search_contains || false;
      this.single_backstroke_delete = this.options.single_backstroke_delete != null ? this.options.single_backstroke_delete : true;
      this.max_selected_options = this.options.max_selected_options || Infinity;
      this.inherit_select_classes = this.options.inherit_select_classes || false;
      this.display_selected_options = this.options.display_selected_options != null ? this.options.display_selected_options : true;
      return this.display_disabled_options = this.options.display_disabled_options != null ? this.options.display_disabled_options : true;
    };

    AbstractChosen.prototype.set_default_text = function() {
      if (this.form_field.getAttribute("data-placeholder")) {
        this.default_text = this.form_field.getAttribute("data-placeholder");
      } else if (this.is_multiple) {
        this.default_text = this.options.placeholder_text_multiple || this.options.placeholder_text || AbstractChosen.default_multiple_text;
      } else {
        this.default_text = this.options.placeholder_text_single || this.options.placeholder_text || AbstractChosen.default_single_text;
      }
      /*<JUI>*/
      /* Original: not exist */
      this.custom_group_text = this.form_field.getAttribute("data-custom_group_text") || this.options.custom_group_text || "Custom Value";
      /*</JUI>*/
      return this.results_none_found = this.form_field.getAttribute("data-no_results_text") || this.options.no_results_text || AbstractChosen.default_no_result_text;
    };

    AbstractChosen.prototype.mouse_enter = function() {
      return this.mouse_on_container = true;
    };

    AbstractChosen.prototype.mouse_leave = function() {
      return this.mouse_on_container = false;
    };

    AbstractChosen.prototype.input_focus = function(evt) {
      var _this = this;

      if (this.is_multiple) {
        if (!this.active_field) {
          return setTimeout((function() {
            return _this.container_mousedown();
          }), 50);
        }
      } else {
        if (!this.active_field) {
          return this.activate_field();
        }
      }
    };

    AbstractChosen.prototype.input_blur = function(evt) {
      var _this = this;

      if (!this.mouse_on_container) {
        this.active_field = false;
        return setTimeout((function() {
          return _this.blur_test();
        }), 100);
      }
    };

    AbstractChosen.prototype.results_option_build = function(options) {
      var content, data, _i, _len, _ref;

      content = '';
      _ref = this.results_data;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        data = _ref[_i];
        if (data.group) {
          content += this.result_add_group(data);
        } else {
          content += this.result_add_option(data);
        }
        if (options != null ? options.first : void 0) {
          if (data.selected && this.is_multiple) {
            this.choice_build(data);
          } else if (data.selected && !this.is_multiple) {
            this.single_set_selected_text(data.text);
          }
        }
      }
      return content;
    };

    AbstractChosen.prototype.result_add_option = function(option) {
      var classes, style;

      if (!option.search_match) {
        return '';
      }
      if (!this.include_option_in_results(option)) {
        return '';
      }
      classes = [];
      if (!option.disabled && !(option.selected && this.is_multiple)) {
        classes.push("active-result");
      }
      if (option.disabled && !(option.selected && this.is_multiple)) {
        classes.push("disabled-result");
      }
      if (option.selected) {
        classes.push("result-selected");
      }
      if (option.group_array_index != null) {
        classes.push("group-option");
      }
      if (option.classes !== "") {
        classes.push(option.classes);
      }
      style = option.style.cssText !== "" ? " style=\"" + option.style + "\"" : "";
      return "<li class=\"" + (classes.join(' ')) + "\"" + style + " data-option-array-index=\"" + option.array_index + "\">" + option.search_text + "</li>";
    };

    AbstractChosen.prototype.result_add_group = function(group) {
      if (!(group.search_match || group.group_match)) {
        return '';
      }
      if (!(group.active_options > 0)) {
        return '';
      }
      return "<li class=\"group-result\">" + group.search_text + "</li>";
    };

    AbstractChosen.prototype.results_update_field = function() {
      this.set_default_text();
      if (!this.is_multiple) {
        this.results_reset_cleanup();
      }
      this.result_clear_highlight();
      this.result_single_selected = null;
      this.results_build();
      if (this.results_showing) {
        return this.winnow_results();
      }
    };

    AbstractChosen.prototype.results_toggle = function() {
      if (this.results_showing) {
        return this.results_hide();
      } else {
        return this.results_show();
      }
    };

    AbstractChosen.prototype.results_search = function(evt) {
      if (this.results_showing) {
        return this.winnow_results();
      } else {
        return this.results_show();
      }
    };

    AbstractChosen.prototype.winnow_results = function() {
      var escapedSearchText, option, regex, regexAnchor, results, results_group, searchText, startpos, text, zregex, _i, _len, _ref;

      this.no_results_clear();
      results = 0;
      searchText = this.get_search_text();
      escapedSearchText = searchText.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
      regexAnchor = this.search_contains ? "" : "^";
      regex = new RegExp(regexAnchor + escapedSearchText, 'i');
      zregex = new RegExp(escapedSearchText, 'i');
      _ref = this.results_data;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        option = _ref[_i];
        option.search_match = false;
        results_group = null;
        if (this.include_option_in_results(option)) {
          if (option.group) {
            option.group_match = false;
            option.active_options = 0;
          }
          if ((option.group_array_index != null) && this.results_data[option.group_array_index]) {
            results_group = this.results_data[option.group_array_index];
            if (results_group.active_options === 0 && results_group.search_match) {
              results += 1;
            }
            results_group.active_options += 1;
          }
          if (!(option.group && !this.group_search)) {
            option.search_text = option.group ? option.label : option.html;
            option.search_match = this.search_string_match(option.search_text, regex);
            if (option.search_match && !option.group) {
              results += 1;
            }
            if (option.search_match) {
              if (searchText.length) {
                startpos = option.search_text.search(zregex);
                text = option.search_text.substr(0, startpos + searchText.length) + '</em>' + option.search_text.substr(startpos + searchText.length);
                option.search_text = text.substr(0, startpos) + '<em>' + text.substr(startpos);
              }
              if (results_group != null) {
                results_group.group_match = true;
              }
            } else if ((option.group_array_index != null) && this.results_data[option.group_array_index].search_match) {
              option.search_match = true;
            }
          }
        }
      }
      this.result_clear_highlight();
      if (results < 1 && searchText.length) {
        this.update_results_content("");
        return this.no_results(searchText);
      } else {
        this.update_results_content(this.results_option_build());
        return this.winnow_results_set_highlight();
      }
    };

    AbstractChosen.prototype.search_string_match = function(search_string, regex) {
      var part, parts, _i, _len;

      if (regex.test(search_string)) {
        return true;
      } else if (this.enable_split_word_search && (search_string.indexOf(" ") >= 0 || search_string.indexOf("[") === 0)) {
        parts = search_string.replace(/\[|\]/g, "").split(" ");
        if (parts.length) {
          for (_i = 0, _len = parts.length; _i < _len; _i++) {
            part = parts[_i];
            if (regex.test(part)) {
              return true;
            }
          }
        }
      }
    };

    AbstractChosen.prototype.choices_count = function() {
      var option, _i, _len, _ref;

      if (this.selected_option_count != null) {
        return this.selected_option_count;
      }
      this.selected_option_count = 0;
      _ref = this.form_field.options;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        option = _ref[_i];
        if (option.selected) {
          this.selected_option_count += 1;
        }
      }
      return this.selected_option_count;
    };

    AbstractChosen.prototype.choices_click = function(evt) {
      evt.preventDefault();
      if (!(this.results_showing || this.is_disabled)) {
        return this.results_show();
      }
    };

    AbstractChosen.prototype.keyup_checker = function(evt) {
      var stroke, _ref;

      stroke = (_ref = evt.which) != null ? _ref : evt.keyCode;
      this.search_field_scale();
      switch (stroke) {
        case 8:
          if (this.is_multiple && this.backstroke_length < 1 && this.choices_count() > 0) {
            return this.keydown_backstroke();
          } else if (!this.pending_backstroke) {
            this.result_clear_highlight();
            return this.results_search();
          }
          break;
        case 13:
          evt.preventDefault();
          if (this.results_showing) {
            return this.result_select(evt);
          }
          break;
        case 27:
          if (this.results_showing) {
            this.results_hide();
          }
          return true;
        case 9:
        case 38:
        case 40:
        case 16:
        case 91:
        case 17:
          break;
        default:
          return this.results_search();
      }
    };

    AbstractChosen.prototype.container_width = function() {
      if (this.options.width != null) {
        return this.options.width;
      } else {
        /*<JUI>*/
        /* Original:
        return "" + this.form_field.offsetWidth + "px";
        */
        return this.form_field_jq.css("width") || "" + this.form_field.offsetWidth + "px";
        /*</JUI>*/
      }
    };

    AbstractChosen.prototype.include_option_in_results = function(option) {
      if (this.is_multiple && (!this.display_selected_options && option.selected)) {
        return false;
      }
      if (!this.display_disabled_options && option.disabled) {
        return false;
      }
      if (option.empty) {
        return false;
      }
      return true;
    };

    AbstractChosen.browser_is_supported = function() {
      if (window.navigator.appName === "Microsoft Internet Explorer") {
        return document.documentMode >= 8;
      }
      if (/iP(od|hone)/i.test(window.navigator.userAgent)) {
        return false;
      }
      if (/Android/i.test(window.navigator.userAgent)) {
        if (/Mobile/i.test(window.navigator.userAgent)) {
          return false;
        }
      }
      return true;
    };

    AbstractChosen.default_multiple_text = "Select Some Options";

    AbstractChosen.default_single_text = "Select an Option";

    AbstractChosen.default_no_result_text = "No results match";

    return AbstractChosen;

  })();

  $ = jQuery;

  $.fn.extend({
    chosen: function(options) {
      if (!AbstractChosen.browser_is_supported()) {
        return this;
      }
      return this.each(function(input_field) {
        var $this, chosen;

        $this = $(this);
        chosen = $this.data('chosen');
        if (options === 'destroy' && chosen) {
          chosen.destroy();
        } else if (!chosen) {
          $this.data('chosen', new Chosen(this, options));
        }
      });
    }
  });

  Chosen = (function(_super) {
    __extends(Chosen, _super);

    function Chosen() {
      _ref = Chosen.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Chosen.prototype.setup = function() {
      this.form_field_jq = $(this.form_field);
      this.current_selectedIndex = this.form_field.selectedIndex;
      /*<JUI>*/
      /* Original: not exist */
      this.allow_custom_value = this.form_field_jq.hasClass("chzn-custom-value") || this.options.allow_custom_value;
      /*</JUI>*/
      return this.is_rtl = this.form_field_jq.hasClass("chzn-rtl");
    };

    Chosen.prototype.finish_setup = function() {
      return this.form_field_jq.addClass("chzn-done");
    };

    Chosen.prototype.set_up_html = function() {
      var container_classes, container_props;

      container_classes = ["chzn-container"];
      container_classes.push("chzn-container-" + (this.is_multiple ? "multi" : "single"));
      if (this.inherit_select_classes && this.form_field.className) {
        container_classes.push(this.form_field.className);
      }
      if (this.is_rtl) {
        container_classes.push("chzn-rtl");
      }
      container_props = {
        'class': container_classes.join(' '),
        'style': "width: " + (this.container_width()) + ";",
        'title': this.form_field.title
      };
      if (this.form_field.id.length) {
        container_props.id = this.form_field.id.replace(/[^\w]/g, '_') + "_chzn";
      }
      this.container = $("<div />", container_props);
      if (this.is_multiple) {
        this.container.html('<ul class="chzn-choices"><li class="search-field"><input type="text" value="' + this.default_text + '" class="default" autocomplete="off" style="width:25px;" /></li></ul><div class="chzn-drop"><ul class="chzn-results"></ul></div>');
      } else {
        this.container.html('<a class="chzn-single chzn-default" tabindex="-1"><span>' + this.default_text + '</span><div><b></b></div></a><div class="chzn-drop"><div class="chzn-search"><input type="text" autocomplete="off" /></div><ul class="chzn-results"></ul></div>');
      }
      this.form_field_jq.hide().after(this.container);
      this.dropdown = this.container.find('div.chzn-drop').first();
      this.search_field = this.container.find('input').first();
      this.search_results = this.container.find('ul.chzn-results').first();
      this.search_field_scale();
      this.search_no_results = this.container.find('li.no-results').first();
      if (this.is_multiple) {
        this.search_choices = this.container.find('ul.chzn-choices').first();
        this.search_container = this.container.find('li.search-field').first();
      } else {
        this.search_container = this.container.find('div.chzn-search').first();
        this.selected_item = this.container.find('.chzn-single').first();
      }
      this.results_build();
      this.set_tab_index();
      this.set_label_behavior();
      return this.form_field_jq.trigger("liszt:ready", {
        chosen: this
      });
    };

    Chosen.prototype.register_observers = function() {
      var _this = this;

      this.container.bind('mousedown.chosen', function(evt) {
        _this.container_mousedown(evt);
      });
      this.container.bind('mouseup.chosen', function(evt) {
        _this.container_mouseup(evt);
      });
      this.container.bind('mouseenter.chosen', function(evt) {
        _this.mouse_enter(evt);
      });
      this.container.bind('mouseleave.chosen', function(evt) {
        _this.mouse_leave(evt);
      });
      this.search_results.bind('mouseup.chosen', function(evt) {
        _this.search_results_mouseup(evt);
      });
      this.search_results.bind('mouseover.chosen', function(evt) {
        _this.search_results_mouseover(evt);
      });
      this.search_results.bind('mouseout.chosen', function(evt) {
        _this.search_results_mouseout(evt);
      });
      this.search_results.bind('mousewheel.chosen DOMMouseScroll.chosen', function(evt) {
        _this.search_results_mousewheel(evt);
      });
      this.form_field_jq.bind("liszt:updated.chosen", function(evt) {
        _this.results_update_field(evt);
      });
      this.form_field_jq.bind("liszt:activate.chosen", function(evt) {
        _this.activate_field(evt);
      });
      this.form_field_jq.bind("liszt:open.chosen", function(evt) {
        _this.container_mousedown(evt);
      });
      this.search_field.bind('blur.chosen', function(evt) {
        _this.input_blur(evt);
      });
      this.search_field.bind('keyup.chosen', function(evt) {
        _this.keyup_checker(evt);
      });
      this.search_field.bind('keydown.chosen', function(evt) {
        _this.keydown_checker(evt);
      });
      this.search_field.bind('focus.chosen', function(evt) {
        _this.input_focus(evt);
      });
      if (this.is_multiple) {
        return this.search_choices.bind('click.chosen', function(evt) {
          _this.choices_click(evt);
        });
      } else {
        return this.container.bind('click.chosen', function(evt) {
          evt.preventDefault();
        });
      }
    };

    Chosen.prototype.destroy = function() {
      $(document).unbind("click.chosen", this.click_test_action);
      if (this.search_field[0].tabIndex) {
        this.form_field_jq[0].tabIndex = this.search_field[0].tabIndex;
      }
      this.container.remove();
      this.form_field_jq.removeData('chosen');
      return this.form_field_jq.show();
    };

    Chosen.prototype.search_field_disabled = function() {
      this.is_disabled = this.form_field_jq[0].disabled;
      if (this.is_disabled) {
        this.container.addClass('chzn-disabled');
        this.search_field[0].disabled = true;
        if (!this.is_multiple) {
          this.selected_item.unbind("focus.chosen", this.activate_action);
        }
        return this.close_field();
      } else {
        this.container.removeClass('chzn-disabled');
        this.search_field[0].disabled = false;
        if (!this.is_multiple) {
          return this.selected_item.bind("focus.chosen", this.activate_action);
        }
      }
    };

    Chosen.prototype.container_mousedown = function(evt) {
      if (!this.is_disabled) {
        if (evt && evt.type === "mousedown" && !this.results_showing) {
          evt.preventDefault();
        }
        if (!((evt != null) && ($(evt.target)).hasClass("search-choice-close"))) {
          if (!this.active_field) {
            if (this.is_multiple) {
              this.search_field.val("");
            }
            $(document).bind('click.chosen', this.click_test_action);
            this.results_show();
          } else if (!this.is_multiple && evt && (($(evt.target)[0] === this.selected_item[0]) || $(evt.target).parents("a.chzn-single").length)) {
            evt.preventDefault();
            this.results_toggle();
          }
          return this.activate_field();
        }
      }
    };

    Chosen.prototype.container_mouseup = function(evt) {
      if (evt.target.nodeName === "ABBR" && !this.is_disabled) {
        return this.results_reset(evt);
      }
    };

    Chosen.prototype.search_results_mousewheel = function(evt) {
      var delta, _ref1, _ref2;

      delta = -((_ref1 = evt.originalEvent) != null ? _ref1.wheelDelta : void 0) || ((_ref2 = evt.originialEvent) != null ? _ref2.detail : void 0);
      if (delta != null) {
        evt.preventDefault();
        if (evt.type === 'DOMMouseScroll') {
          delta = delta * 40;
        }
        return this.search_results.scrollTop(delta + this.search_results.scrollTop());
      }
    };

    Chosen.prototype.blur_test = function(evt) {
      if (!this.active_field && this.container.hasClass("chzn-container-active")) {
        return this.close_field();
      }
    };

    Chosen.prototype.close_field = function() {
      $(document).unbind("click.chosen", this.click_test_action);
      this.active_field = false;
      this.results_hide();
      this.container.removeClass("chzn-container-active");
      this.clear_backstroke();
      this.show_search_field_default();
      return this.search_field_scale();
    };

    Chosen.prototype.activate_field = function() {
      this.container.addClass("chzn-container-active");
      this.active_field = true;
      this.search_field.val(this.search_field.val());
      return this.search_field.focus();
    };

    Chosen.prototype.test_active_click = function(evt) {
      if (this.container.is($(evt.target).closest('.chzn-container'))) {
        return this.active_field = true;
      } else {
        return this.close_field();
      }
    };

    Chosen.prototype.results_build = function() {
      this.parsing = true;
      this.selected_option_count = null;
      this.results_data = SelectParser.select_to_array(this.form_field);
      if (this.is_multiple) {
        this.search_choices.find("li.search-choice").remove();
      } else if (!this.is_multiple) {
        this.single_set_selected_text();
        if (this.disable_search || this.form_field.options.length <= this.disable_search_threshold) {
          this.search_field[0].readOnly = true;
          this.container.addClass("chzn-container-single-nosearch");
        } else {
          this.search_field[0].readOnly = false;
          this.container.removeClass("chzn-container-single-nosearch");
        }
      }
      this.update_results_content(this.results_option_build({
        first: true
      }));
      this.search_field_disabled();
      this.show_search_field_default();
      this.search_field_scale();
      return this.parsing = false;
    };

    Chosen.prototype.result_do_highlight = function(el) {
      var high_bottom, high_top, maxHeight, visible_bottom, visible_top;

      if (el.length) {
        this.result_clear_highlight();
        this.result_highlight = el;
        this.result_highlight.addClass("highlighted");
        maxHeight = parseInt(this.search_results.css("maxHeight"), 10);
        visible_top = this.search_results.scrollTop();
        visible_bottom = maxHeight + visible_top;
        high_top = this.result_highlight.position().top + this.search_results.scrollTop();
        high_bottom = high_top + this.result_highlight.outerHeight();
        if (high_bottom >= visible_bottom) {
          return this.search_results.scrollTop((high_bottom - maxHeight) > 0 ? high_bottom - maxHeight : 0);
        } else if (high_top < visible_top) {
          return this.search_results.scrollTop(high_top);
        }
      }
    };

    Chosen.prototype.result_clear_highlight = function() {
      if (this.result_highlight) {
        this.result_highlight.removeClass("highlighted");
      }
      return this.result_highlight = null;
    };

    Chosen.prototype.results_show = function() {
      if (this.is_multiple && this.max_selected_options <= this.choices_count()) {
        this.form_field_jq.trigger("liszt:maxselected", {
          chosen: this
        });
        return false;
      }
      this.container.addClass("chzn-with-drop");
      this.form_field_jq.trigger("liszt:showing_dropdown", {
        chosen: this
      });
      this.results_showing = true;
      this.search_field.focus();
      this.search_field.val(this.search_field.val());
      return this.winnow_results();
    };

    Chosen.prototype.update_results_content = function(content) {
      return this.search_results.html(content);
    };

    Chosen.prototype.results_hide = function() {
      if (this.results_showing) {
        this.result_clear_highlight();
        this.container.removeClass("chzn-with-drop");
        this.form_field_jq.trigger("liszt:hiding_dropdown", {
          chosen: this
        });
      }
      return this.results_showing = false;
    };

    Chosen.prototype.set_tab_index = function(el) {
      var ti;

      if (this.form_field.tabIndex) {
        ti = this.form_field.tabIndex;
        this.form_field.tabIndex = -1;
        return this.search_field[0].tabIndex = ti;
      }
    };

    Chosen.prototype.set_label_behavior = function() {
      var _this = this;

      this.form_field_label = this.form_field_jq.parents("label");
      if (!this.form_field_label.length && this.form_field.id.length) {
        this.form_field_label = $("label[for='" + this.form_field.id + "']");
      }
      if (this.form_field_label.length > 0) {
        return this.form_field_label.bind('click.chosen', function(evt) {
          if (_this.is_multiple) {
            return _this.container_mousedown(evt);
          } else {
            return _this.activate_field();
          }
        });
      }
    };

    Chosen.prototype.show_search_field_default = function() {
      if (this.is_multiple && this.choices_count() < 1 && !this.active_field) {
        this.search_field.val(this.default_text);
        return this.search_field.addClass("default");
      } else {
        this.search_field.val("");
        return this.search_field.removeClass("default");
      }
    };

    Chosen.prototype.search_results_mouseup = function(evt) {
      var target;

      target = $(evt.target).hasClass("active-result") ? $(evt.target) : $(evt.target).parents(".active-result").first();
      if (target.length) {
        this.result_highlight = target;
        this.result_select(evt);
        return this.search_field.focus();
      }
    };

    Chosen.prototype.search_results_mouseover = function(evt) {
      var target;

      target = $(evt.target).hasClass("active-result") ? $(evt.target) : $(evt.target).parents(".active-result").first();
      if (target) {
        return this.result_do_highlight(target);
      }
    };

    Chosen.prototype.search_results_mouseout = function(evt) {
      if ($(evt.target).hasClass("active-result" || $(evt.target).parents('.active-result').first())) {
        return this.result_clear_highlight();
      }
    };

    Chosen.prototype.choice_build = function(item) {
      var choice, close_link,
        _this = this;

      choice = $('<li />', {
        "class": "search-choice"
      }).html("<span>" + item.html + "</span>");
      if (item.disabled) {
        choice.addClass('search-choice-disabled');
      } else {
        close_link = $('<a />', {
          "class": 'search-choice-close',
          'data-option-array-index': item.array_index
        });
        close_link.bind('click.chosen', function(evt) {
          return _this.choice_destroy_link_click(evt);
        });
        choice.append(close_link);
      }
      return this.search_container.before(choice);
    };

    Chosen.prototype.choice_destroy_link_click = function(evt) {
      evt.preventDefault();
      evt.stopPropagation();
      if (!this.is_disabled) {
        return this.choice_destroy($(evt.target));
      }
    };

    Chosen.prototype.choice_destroy = function(link) {
      if (this.result_deselect(link[0].getAttribute("data-option-array-index"))) {
        this.show_search_field_default();
        if (this.is_multiple && this.choices_count() > 0 && this.search_field.val().length < 1) {
          this.results_hide();
        }
        link.parents('li').first().remove();
        return this.search_field_scale();
      }
    };

    Chosen.prototype.results_reset = function() {
      this.form_field.options[0].selected = true;
      this.selected_option_count = null;
      this.single_set_selected_text();
      this.show_search_field_default();
      this.results_reset_cleanup();
      this.form_field_jq.trigger("change");
      if (this.active_field) {
        return this.results_hide();
      }
    };

    Chosen.prototype.results_reset_cleanup = function() {
      this.current_selectedIndex = this.form_field.selectedIndex;
      return this.selected_item.find("abbr").remove();
    };

    Chosen.prototype.result_select = function(evt) {
      /*<JUI>*/
      /* Original:
      var high, item, selected_index;
      */
      var group, high, high_id, item, option, position, value;
      /*</JUI>*/

      if (this.result_highlight) {
        high = this.result_highlight;
        this.result_clear_highlight();
        if (this.is_multiple && this.max_selected_options <= this.choices_count()) {
          this.form_field_jq.trigger("liszt:maxselected", {
            chosen: this
          });
          return false;
        }
        if (this.is_multiple) {
          high.removeClass("active-result");
        } else {
          if (this.result_single_selected) {
            this.result_single_selected.removeClass("result-selected");
            selected_index = this.result_single_selected[0].getAttribute('data-option-array-index');
            this.results_data[selected_index].selected = false;
          }
          this.result_single_selected = high;
        }
        high.addClass("result-selected");
        item = this.results_data[high[0].getAttribute("data-option-array-index")];
        item.selected = true;
        this.form_field.options[item.options_index].selected = true;
        this.selected_option_count = null;
        if (this.is_multiple) {
          this.choice_build(item);
        } else {
          this.single_set_selected_text(item.text);
        }
        if (!((evt.metaKey || evt.ctrlKey) && this.is_multiple)) {
          this.results_hide();
        }
        this.search_field.val("");
        if (this.is_multiple || this.form_field.selectedIndex !== this.current_selectedIndex) {
          this.form_field_jq.trigger("change", {
            'selected': this.form_field.options[item.options_index].value
          });
        }
        this.current_selectedIndex = this.form_field.selectedIndex;
        return this.search_field_scale();
      }
      /*<JUI>*/
      /* Original: not exist */
      else if ((!this.is_multiple) && this.allow_custom_value) {
          value = this.search_field.val();
          group = this.add_unique_custom_group();
          option = $('<option value="' + value + '">' + value + '</option>');
          group.append(option);
          this.form_field_jq.append(group);
          this.form_field.options[this.form_field.options.length - 1].selected = true;
          if (!evt.metaKey) {
            this.results_hide();
          }
          return this.results_build();
      }
      /*</JUI>*/
    };

    /*<JUI>*/
    /* Original: not exist */
    Chosen.prototype.find_custom_group = function() {
        var found, group, _i, _len, _ref;
        _ref = $('optgroup', this.form_field);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          group = _ref[_i];
          if (group.getAttribute('label') === this.custom_group_text) {
            found = group;
          }
        }
        return found;
    };

    Chosen.prototype.add_unique_custom_group = function() {
        var group;
        group = this.find_custom_group();
        if (!group) {
          group = $('<optgroup label="' + this.custom_group_text + '"></optgroup>');
        }
        return $(group);
    };
    /*</JUI>*/

    Chosen.prototype.single_set_selected_text = function(text) {
      if (text == null) {
        text = this.default_text;
      }
      if (text === this.default_text) {
        this.selected_item.addClass("chzn-default");
      } else {
        this.single_deselect_control_build();
        this.selected_item.removeClass("chzn-default");
      }
      return this.selected_item.find("span").text(text);
    };

    Chosen.prototype.result_deselect = function(pos) {
      var result_data;

      result_data = this.results_data[pos];
      if (!this.form_field.options[result_data.options_index].disabled) {
        result_data.selected = false;
        this.form_field.options[result_data.options_index].selected = false;
        this.selected_option_count = null;
        this.result_clear_highlight();
        if (this.results_showing) {
          this.winnow_results();
        }
        this.form_field_jq.trigger("change", {
          deselected: this.form_field.options[result_data.options_index].value
        });
        this.search_field_scale();
        return true;
      } else {
        return false;
      }
    };

    Chosen.prototype.single_deselect_control_build = function() {
      if (!this.allow_single_deselect) {
        return;
      }
      if (!this.selected_item.find("abbr").length) {
        this.selected_item.find("span").first().after("<abbr class=\"search-choice-close\"></abbr>");
      }
      return this.selected_item.addClass("chzn-single-with-deselect");
    };

    Chosen.prototype.get_search_text = function() {
      if (this.search_field.val() === this.default_text) {
        return "";
      } else {
        return $('<div/>').text($.trim(this.search_field.val())).html();
      }
    };

    Chosen.prototype.winnow_results_set_highlight = function() {
      var do_high, selected_results;

      selected_results = !this.is_multiple ? this.search_results.find(".result-selected.active-result") : [];
      do_high = selected_results.length ? selected_results.first() : this.search_results.find(".active-result").first();
      if (do_high != null) {
        return this.result_do_highlight(do_high);
      }
    };

    Chosen.prototype.no_results = function(terms) {
      var no_results_html;

      no_results_html = $('<li class="no-results">' + this.results_none_found + ' "<span></span>"</li>');
      no_results_html.find("span").first().html(terms);
      return this.search_results.append(no_results_html);
    };

    Chosen.prototype.no_results_clear = function() {
      return this.search_results.find(".no-results").remove();
    };

    Chosen.prototype.keydown_arrow = function() {
      var next_sib;

      if (this.results_showing && this.result_highlight) {
        next_sib = this.result_highlight.nextAll("li.active-result").first();
        if (next_sib) {
          return this.result_do_highlight(next_sib);
        }
      } else {
        return this.results_show();
      }
    };

    Chosen.prototype.keyup_arrow = function() {
      var prev_sibs;

      if (!this.results_showing && !this.is_multiple) {
        return this.results_show();
      } else if (this.result_highlight) {
        prev_sibs = this.result_highlight.prevAll("li.active-result");
        if (prev_sibs.length) {
          return this.result_do_highlight(prev_sibs.first());
        } else {
          if (this.choices_count() > 0) {
            this.results_hide();
          }
          return this.result_clear_highlight();
        }
      }
    };

    Chosen.prototype.keydown_backstroke = function() {
      var next_available_destroy;

      if (this.pending_backstroke) {
        this.choice_destroy(this.pending_backstroke.find("a").first());
        return this.clear_backstroke();
      } else {
        next_available_destroy = this.search_container.siblings("li.search-choice").last();
        if (next_available_destroy.length && !next_available_destroy.hasClass("search-choice-disabled")) {
          this.pending_backstroke = next_available_destroy;
          if (this.single_backstroke_delete) {
            return this.keydown_backstroke();
          } else {
            return this.pending_backstroke.addClass("search-choice-focus");
          }
        }
      }
    };

    Chosen.prototype.clear_backstroke = function() {
      if (this.pending_backstroke) {
        this.pending_backstroke.removeClass("search-choice-focus");
      }
      return this.pending_backstroke = null;
    };

    Chosen.prototype.keydown_checker = function(evt) {
      var stroke, _ref1;

      stroke = (_ref1 = evt.which) != null ? _ref1 : evt.keyCode;
      this.search_field_scale();
      if (stroke !== 8 && this.pending_backstroke) {
        this.clear_backstroke();
      }
      switch (stroke) {
        case 8:
          this.backstroke_length = this.search_field.val().length;
          break;
        case 9:
          if (this.results_showing && !this.is_multiple) {
            this.result_select(evt);
          }
          this.mouse_on_container = false;
          break;
        case 13:
          evt.preventDefault();
          break;
        case 38:
          evt.preventDefault();
          this.keyup_arrow();
          break;
        case 40:
          evt.preventDefault();
          this.keydown_arrow();
          break;
      }
    };

    Chosen.prototype.search_field_scale = function() {
      var div, f_width, h, style, style_block, styles, w, _i, _len;

      if (this.is_multiple) {
        h = 0;
        w = 0;
        style_block = "position:absolute; left: -1000px; top: -1000px; display:none;";
        styles = ['font-size', 'font-style', 'font-weight', 'font-family', 'line-height', 'text-transform', 'letter-spacing'];
        for (_i = 0, _len = styles.length; _i < _len; _i++) {
          style = styles[_i];
          style_block += style + ":" + this.search_field.css(style) + ";";
        }
        div = $('<div />', {
          'style': style_block
        });
        div.text(this.search_field.val());
        $('body').append(div);
        w = div.width() + 25;
        div.remove();
        f_width = this.container.outerWidth();
        if (w > f_width - 10) {
          w = f_width - 10;
        }
        return this.search_field.css({
          'width': w + 'px'
        });
      }
    };

    return Chosen;

  })(AbstractChosen);

}).call(this);

/*!
 * Bootstrap-select v1.10.0 (http://silviomoreto.github.io/bootstrap-select)
 *
 * Copyright 2013-2016 bootstrap-select
 * Licensed under MIT (https://github.com/silviomoreto/bootstrap-select/blob/master/LICENSE)
 */

+(function (root, factory) {
  if (typeof define === 'function' && define.amd) {
    // AMD. Register as an anonymous module unless amdModuleId is set
    define(["jquery"], function (a0) {
      return (factory(a0));
    });
  } else if (typeof exports === 'object') {
    // Node. Does not work with strict CommonJS, but
    // only CommonJS-like environments that support module.exports,
    // like Node.
    module.exports = factory(require("jquery"));
  } else {
    factory(jQuery);
  }
}

(this, function (jQuery) {

  (function ($) {
    'use strict';

    //<editor-fold desc="Shims">
    if (!String.prototype.includes) {
      (function () {
        'use strict'; // needed to support `apply`/`call` with `undefined`/`null`
        var toString = {}.toString;
        var defineProperty = (function () {
          // IE 8 only supports `Object.defineProperty` on DOM elements
          try {
            var object = {};
            var $defineProperty = Object.defineProperty;
            var result = $defineProperty(object, object, object) && $defineProperty;
          } catch (error) {
          }
          return result;
        }());
        var indexOf = ''.indexOf;
        var includes = function (search) {
          if (this == null) {
            throw new TypeError();
          }
          var string = String(this);
          if (search && toString.call(search) == '[object RegExp]') {
            throw new TypeError();
          }
          var stringLength = string.length;
          var searchString = String(search);
          var searchLength = searchString.length;
          var position = arguments.length > 1 ? arguments[1] : undefined;
          // `ToInteger`
          var pos = position ? Number(position) : 0;
          if (pos != pos) { // better `isNaN`
            pos = 0;
          }
          var start = Math.min(Math.max(pos, 0), stringLength);
          // Avoid the `indexOf` call if no match is possible
          if (searchLength + start > stringLength) {
            return false;
          }
          return indexOf.call(string, searchString, pos) != -1;
        };
        if (defineProperty) {
          defineProperty(String.prototype, 'includes', {
            'value': includes,
            'configurable': true,
            'writable': true
          });
        } else {
          String.prototype.includes = includes;
        }
      }());
    }

    if (!String.prototype.startsWith) {
      (function () {
        'use strict'; // needed to support `apply`/`call` with `undefined`/`null`
        var defineProperty = (function () {
          // IE 8 only supports `Object.defineProperty` on DOM elements
          try {
            var object = {};
            var $defineProperty = Object.defineProperty;
            var result = $defineProperty(object, object, object) && $defineProperty;
          } catch (error) {
          }
          return result;
        }());
        var toString = {}.toString;
        var startsWith = function (search) {
          if (this == null) {
            throw new TypeError();
          }
          var string = String(this);
          if (search && toString.call(search) == '[object RegExp]') {
            throw new TypeError();
          }
          var stringLength = string.length;
          var searchString = String(search);
          var searchLength = searchString.length;
          var position = arguments.length > 1 ? arguments[1] : undefined;
          // `ToInteger`
          var pos = position ? Number(position) : 0;
          if (pos != pos) { // better `isNaN`
            pos = 0;
          }
          var start = Math.min(Math.max(pos, 0), stringLength);
          // Avoid the `indexOf` call if no match is possible
          if (searchLength + start > stringLength) {
            return false;
          }
          var index = -1;
          while (++index < searchLength) {
            if (string.charCodeAt(start + index) != searchString.charCodeAt(index)) {
              return false;
            }
          }
          return true;
        };
        if (defineProperty) {
          defineProperty(String.prototype, 'startsWith', {
            'value': startsWith,
            'configurable': true,
            'writable': true
          });
        } else {
          String.prototype.startsWith = startsWith;
        }
      }());
    }

    if (!Object.keys) {
      Object.keys = function (
        o, // object
        k, // key
        r  // result array
        ){
        // initialize object and result
        r=[];
        // iterate over object keys
        for (k in o)
            // fill result array with non-prototypical keys
          r.hasOwnProperty.call(o, k) && r.push(k);
        // return result
        return r;
      };
    }

    $.fn.triggerNative = function (eventName) {
      var el = this[0],
          event;

      if (el.dispatchEvent) {
        if (typeof Event === 'function') {
          // For modern browsers
          event = new Event(eventName, {
            bubbles: true
          });
        } else {
          // For IE since it doesn't support Event constructor
          event = document.createEvent('Event');
          event.initEvent(eventName, true, false);
        }

        el.dispatchEvent(event);
      } else {
        if (el.fireEvent) {
          event = document.createEventObject();
          event.eventType = eventName;
          el.fireEvent('on' + eventName, event);
        }

        this.trigger(eventName);
      }
    };
    //</editor-fold>

    // Case insensitive contains search
    $.expr[':'].icontains = function (obj, index, meta) {
      var $obj = $(obj);
      var haystack = ($obj.data('tokens') || $obj.text()).toUpperCase();
      return haystack.includes(meta[3].toUpperCase());
    };

    // Case insensitive begins search
    $.expr[':'].ibegins = function (obj, index, meta) {
      var $obj = $(obj);
      var haystack = ($obj.data('tokens') || $obj.text()).toUpperCase();
      return haystack.startsWith(meta[3].toUpperCase());
    };

    // Case and accent insensitive contains search
    $.expr[':'].aicontains = function (obj, index, meta) {
      var $obj = $(obj);
      var haystack = ($obj.data('tokens') || $obj.data('normalizedText') || $obj.text()).toUpperCase();
      return haystack.includes(meta[3].toUpperCase());
    };

    // Case and accent insensitive begins search
    $.expr[':'].aibegins = function (obj, index, meta) {
      var $obj = $(obj);
      var haystack = ($obj.data('tokens') || $obj.data('normalizedText') || $obj.text()).toUpperCase();
      return haystack.startsWith(meta[3].toUpperCase());
    };

    /**
     * Remove all diatrics from the given text.
     * @access private
     * @param {String} text
     * @returns {String}
     */
    function normalizeToBase(text) {
      var rExps = [
        {re: /[\xC0-\xC6]/g, ch: "A"},
        {re: /[\xE0-\xE6]/g, ch: "a"},
        {re: /[\xC8-\xCB]/g, ch: "E"},
        {re: /[\xE8-\xEB]/g, ch: "e"},
        {re: /[\xCC-\xCF]/g, ch: "I"},
        {re: /[\xEC-\xEF]/g, ch: "i"},
        {re: /[\xD2-\xD6]/g, ch: "O"},
        {re: /[\xF2-\xF6]/g, ch: "o"},
        {re: /[\xD9-\xDC]/g, ch: "U"},
        {re: /[\xF9-\xFC]/g, ch: "u"},
        {re: /[\xC7-\xE7]/g, ch: "c"},
        {re: /[\xD1]/g, ch: "N"},
        {re: /[\xF1]/g, ch: "n"}
      ];
      $.each(rExps, function () {
        text = text.replace(this.re, this.ch);
      });
      return text;
    }


    function htmlEscape(html) {
      var escapeMap = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#x27;',
        '`': '&#x60;'
      };
      var source = '(?:' + Object.keys(escapeMap).join('|') + ')',
          testRegexp = new RegExp(source),
          replaceRegexp = new RegExp(source, 'g'),
          string = html == null ? '' : '' + html;
      return testRegexp.test(string) ? string.replace(replaceRegexp, function (match) {
        return escapeMap[match];
      }) : string;
    }

    var Selectpicker = function (element, options, e) {
      if (e) {
        e.stopPropagation();
        e.preventDefault();
      }

      this.$element = $(element);
      this.$newElement = null;
      this.$button = null;
      this.$menu = null;
      this.$lis = null;
      this.options = options;

      // If we have no title yet, try to pull it from the html title attribute (jQuery doesnt' pick it up as it's not a
      // data-attribute)
      if (this.options.title === null) {
        this.options.title = this.$element.attr('title');
      }

      //Expose public methods
      this.val = Selectpicker.prototype.val;
      this.render = Selectpicker.prototype.render;
      this.refresh = Selectpicker.prototype.refresh;
      this.setStyle = Selectpicker.prototype.setStyle;
      this.selectAll = Selectpicker.prototype.selectAll;
      this.deselectAll = Selectpicker.prototype.deselectAll;
      this.destroy = Selectpicker.prototype.destroy;
      this.remove = Selectpicker.prototype.remove;
      this.show = Selectpicker.prototype.show;
      this.hide = Selectpicker.prototype.hide;

      this.init();
    };

    Selectpicker.VERSION = '1.10.0';

    // part of this is duplicated in i18n/defaults-en_US.js. Make sure to update both.
    Selectpicker.DEFAULTS = {
      noneSelectedText: 'Nothing selected',
      noneResultsText: 'No results matched {0}',
      countSelectedText: function (numSelected, numTotal) {
        return (numSelected == 1) ? "{0} item selected" : "{0} items selected";
      },
      maxOptionsText: function (numAll, numGroup) {
        return [
          (numAll == 1) ? 'Limit reached ({n} item max)' : 'Limit reached ({n} items max)',
          (numGroup == 1) ? 'Group limit reached ({n} item max)' : 'Group limit reached ({n} items max)'
        ];
      },
      selectAllText: 'Select All',
      deselectAllText: 'Deselect All',
      doneButton: false,
      doneButtonText: 'Close',
      multipleSeparator: ', ',
      styleBase: 'btn',
      style: 'btn-default',
      size: 'auto',
      title: null,
      selectedTextFormat: 'values',
      width: false,
      container: false,
      hideDisabled: false,
      showSubtext: false,
      showIcon: true,
      showContent: true,
      dropupAuto: true,
      header: false,
      liveSearch: false,
      liveSearchPlaceholder: null,
      liveSearchNormalize: false,
      liveSearchStyle: 'contains',
      actionsBox: false,
      iconBase: 'glyphicon',
      tickIcon: 'glyphicon-ok',
      showTick: false,
      template: {
        caret: '<span class="caret"></span>'
      },
      maxOptions: false,
      mobile: false,
      selectOnTab: false,
      dropdownAlignRight: false
    };

    Selectpicker.prototype = {

      constructor: Selectpicker,

      init: function () {
        var that = this,
            id = this.$element.attr('id');

        this.$element.addClass('bs-select-hidden');

        // store originalIndex (key) and newIndex (value) in this.liObj for fast accessibility
        // allows us to do this.$lis.eq(that.liObj[index]) instead of this.$lis.filter('[data-original-index="' + index + '"]')
        this.liObj = {};
        this.multiple = this.$element.prop('multiple');
        this.autofocus = this.$element.prop('autofocus');
        this.$newElement = this.createView();
        this.$element
          .after(this.$newElement)
          .appendTo(this.$newElement);
        this.$button = this.$newElement.children('button');
        this.$menu = this.$newElement.children('.dropdown-menu');
        this.$menuInner = this.$menu.children('.inner');
        this.$searchbox = this.$menu.find('input');

        this.$element.removeClass('bs-select-hidden');

        if (this.options.dropdownAlignRight === true) this.$menu.addClass('dropdown-menu-right');

        if (typeof id !== 'undefined') {
          this.$button.attr('data-id', id);
          $('label[for="' + id + '"]').click(function (e) {
            e.preventDefault();
            that.$button.focus();
          });
        }

        this.checkDisabled();
        this.clickListener();
        if (this.options.liveSearch) this.liveSearchListener();
        this.render();
        this.setStyle();
        this.setWidth();
        if (this.options.container) this.selectPosition();
        this.$menu.data('this', this);
        this.$newElement.data('this', this);
        if (this.options.mobile) this.mobile();

        this.$newElement.on({
          'hide.bs.dropdown': function (e) {
            that.$element.trigger('hide.bs.select', e);
          },
          'hidden.bs.dropdown': function (e) {
            that.$element.trigger('hidden.bs.select', e);
          },
          'show.bs.dropdown': function (e) {
            that.$element.trigger('show.bs.select', e);
          },
          'shown.bs.dropdown': function (e) {
            that.$element.trigger('shown.bs.select', e);
          }
        });

        if (that.$element[0].hasAttribute('required')) {
          this.$element.on('invalid', function () {
            that.$button
              .addClass('bs-invalid')
              .focus();
            
            that.$element.on({
              'focus.bs.select': function () {
                that.$button.focus();
                that.$element.off('focus.bs.select');
              },
              'shown.bs.select': function () {
                that.$element
                  .val(that.$element.val()) // set the value to hide the validation message in Chrome when menu is opened
                  .off('shown.bs.select');
              },
              'rendered.bs.select': function () {
                // if select is no longer invalid, remove the bs-invalid class
                if (this.validity.valid) that.$button.removeClass('bs-invalid');
                that.$element.off('rendered.bs.select');
              }
            });
            
          });
        }

        setTimeout(function () {
          that.$element.trigger('loaded.bs.select');
        });
      },

      createDropdown: function () {
        // Options
        // If we are multiple or showTick option is set, then add the show-tick class
        var showTick = (this.multiple || this.options.showTick) ? ' show-tick' : '',
            inputGroup = this.$element.parent().hasClass('input-group') ? ' input-group-btn' : '',
            autofocus = this.autofocus ? ' autofocus' : '';
        // Elements
        var header = this.options.header ? '<div class="popover-title"><button type="button" class="close" aria-hidden="true">&times;</button>' + this.options.header + '</div>' : '';
        var searchbox = this.options.liveSearch ?
        '<div class="bs-searchbox">' +
        '<input type="text" class="form-control" autocomplete="off"' +
        (null === this.options.liveSearchPlaceholder ? '' : ' placeholder="' + htmlEscape(this.options.liveSearchPlaceholder) + '"') + '>' +
        '</div>'
            : '';
        var actionsbox = this.multiple && this.options.actionsBox ?
        '<div class="bs-actionsbox">' +
        '<div class="btn-group btn-group-sm btn-block">' +
        '<button type="button" class="actions-btn bs-select-all btn btn-default">' +
        this.options.selectAllText +
        '</button>' +
        '<button type="button" class="actions-btn bs-deselect-all btn btn-default">' +
        this.options.deselectAllText +
        '</button>' +
        '</div>' +
        '</div>'
            : '';
        var donebutton = this.multiple && this.options.doneButton ?
        '<div class="bs-donebutton">' +
        '<div class="btn-group btn-block">' +
        '<button type="button" class="btn btn-sm btn-default">' +
        this.options.doneButtonText +
        '</button>' +
        '</div>' +
        '</div>'
            : '';
        var drop =
            '<div class="btn-group bootstrap-select' + showTick + inputGroup + '">' +
            '<button type="button" class="' + this.options.styleBase + ' dropdown-toggle" data-toggle="dropdown"' + autofocus + '>' +
            '<span class="filter-option pull-left"></span>&nbsp;' +
            '<span class="bs-caret">' +
            this.options.template.caret +
            '</span>' +
            '</button>' +
            '<div class="dropdown-menu open">' +
            header +
            searchbox +
            actionsbox +
            '<ul class="dropdown-menu inner" role="menu">' +
            '</ul>' +
            donebutton +
            '</div>' +
            '</div>';

        return $(drop);
      },

      createView: function () {
        var $drop = this.createDropdown(),
            li = this.createLi();

        $drop.find('ul')[0].innerHTML = li;
        return $drop;
      },

      reloadLi: function () {
        //Remove all children.
        this.destroyLi();
        //Re build
        var li = this.createLi();
        this.$menuInner[0].innerHTML = li;
      },

      destroyLi: function () {
        this.$menu.find('li').remove();
      },

      createLi: function () {
        var that = this,
            _li = [],
            optID = 0,
            titleOption = document.createElement('option'),
            liIndex = -1; // increment liIndex whenever a new <li> element is created to ensure liObj is correct

        // Helper functions
        /**
         * @param content
         * @param [index]
         * @param [classes]
         * @param [optgroup]
         * @returns {string}
         */
        var generateLI = function (content, index, classes, optgroup) {
          return '<li' +
              ((typeof classes !== 'undefined' & '' !== classes) ? ' class="' + classes + '"' : '') +
              ((typeof index !== 'undefined' & null !== index) ? ' data-original-index="' + index + '"' : '') +
              ((typeof optgroup !== 'undefined' & null !== optgroup) ? 'data-optgroup="' + optgroup + '"' : '') +
              '>' + content + '</li>';
        };

        /**
         * @param text
         * @param [classes]
         * @param [inline]
         * @param [tokens]
         * @returns {string}
         */
        var generateA = function (text, classes, inline, tokens) {
          return '<a tabindex="0"' +
              (typeof classes !== 'undefined' ? ' class="' + classes + '"' : '') +
              (typeof inline !== 'undefined' ? ' style="' + inline + '"' : '') +
              (that.options.liveSearchNormalize ? ' data-normalized-text="' + normalizeToBase(htmlEscape(text)) + '"' : '') +
              (typeof tokens !== 'undefined' || tokens !== null ? ' data-tokens="' + tokens + '"' : '') +
              '>' + text +
              '<span class="' + that.options.iconBase + ' ' + that.options.tickIcon + ' check-mark"></span>' +
              '</a>';
        };

        if (this.options.title && !this.multiple) {
          // this option doesn't create a new <li> element, but does add a new option, so liIndex is decreased
          // since liObj is recalculated on every refresh, liIndex needs to be decreased even if the titleOption is already appended
          liIndex--;

          if (!this.$element.find('.bs-title-option').length) {
            // Use native JS to prepend option (faster)
            var element = this.$element[0];
            titleOption.className = 'bs-title-option';
            titleOption.appendChild(document.createTextNode(this.options.title));
            titleOption.value = '';
            element.insertBefore(titleOption, element.firstChild);
            // Check if selected attribute is already set on an option. If not, select the titleOption option.
            // attr gets the 'default' selected option (from markup), prop gets the 'current' selected option
            // the selected item may have been changed by user or programmatically before the bootstrap select plugin runs
            var $opt = $(element.options[element.selectedIndex]);
            if ($opt.attr('selected') === undefined && $opt.prop('selected') === false) {
              titleOption.selected = true;
            }
          }
        }

        this.$element.find('option').each(function (index) {
          var $this = $(this);

          liIndex++;

          if ($this.hasClass('bs-title-option')) return;

          // Get the class and text for the option
          var optionClass = this.className || '',
              inline = this.style.cssText,
              text = $this.data('content') ? $this.data('content') : $this.html(),
              tokens = $this.data('tokens') ? $this.data('tokens') : null,
              subtext = typeof $this.data('subtext') !== 'undefined' ? '<small class="text-muted">' + $this.data('subtext') + '</small>' : '',
              icon = typeof $this.data('icon') !== 'undefined' ? '<span class="' + that.options.iconBase + ' ' + $this.data('icon') + '"></span> ' : '',
              isOptgroup = this.parentNode.tagName === 'OPTGROUP',
              isDisabled = this.disabled || (isOptgroup && this.parentNode.disabled);

          if (icon !== '' && isDisabled) {
            icon = '<span>' + icon + '</span>';
          }

          if (that.options.hideDisabled && isDisabled && !isOptgroup) {
            liIndex--;
            return;
          }

          if (!$this.data('content')) {
            // Prepend any icon and append any subtext to the main text.
            text = icon + '<span class="text">' + text + subtext + '</span>';
          }

          if (isOptgroup && $this.data('divider') !== true) {
            var optGroupClass = ' ' + this.parentNode.className || '';

            if ($this.index() === 0) { // Is it the first option of the optgroup?
              optID += 1;

              // Get the opt group label
              var label = this.parentNode.label,
                  labelSubtext = typeof $this.parent().data('subtext') !== 'undefined' ? '<small class="text-muted">' + $this.parent().data('subtext') + '</small>' : '',
                  labelIcon = $this.parent().data('icon') ? '<span class="' + that.options.iconBase + ' ' + $this.parent().data('icon') + '"></span> ' : '';

              label = labelIcon + '<span class="text">' + label + labelSubtext + '</span>';

              if (index !== 0 && _li.length > 0) { // Is it NOT the first option of the select && are there elements in the dropdown?
                liIndex++;
                _li.push(generateLI('', null, 'divider', optID + 'div'));
              }
              liIndex++;
              _li.push(generateLI(label, null, 'dropdown-header' + optGroupClass, optID));
            }

            if (that.options.hideDisabled && isDisabled) {
              liIndex--;
              return;
            }

            _li.push(generateLI(generateA(text, 'opt ' + optionClass + optGroupClass, inline, tokens), index, '', optID));
          } else if ($this.data('divider') === true) {
            _li.push(generateLI('', index, 'divider'));
          } else if ($this.data('hidden') === true) {
            _li.push(generateLI(generateA(text, optionClass, inline, tokens), index, 'hidden is-hidden'));
          } else {
            if (this.previousElementSibling && this.previousElementSibling.tagName === 'OPTGROUP') {
              liIndex++;
              _li.push(generateLI('', null, 'divider', optID + 'div'));
            }
            _li.push(generateLI(generateA(text, optionClass, inline, tokens), index));
          }

          that.liObj[index] = liIndex;
        });

        //If we are not multiple, we don't have a selected item, and we don't have a title, select the first element so something is set in the button
        if (!this.multiple && this.$element.find('option:selected').length === 0 && !this.options.title) {
          this.$element.find('option').eq(0).prop('selected', true).attr('selected', 'selected');
        }

        return _li.join('');
      },

      findLis: function () {
        if (this.$lis == null) this.$lis = this.$menu.find('li');
        return this.$lis;
      },

      /**
       * @param [updateLi] defaults to true
       */
      render: function (updateLi) {
        var that = this,
            notDisabled;

        //Update the LI to match the SELECT
        if (updateLi !== false) {
          this.$element.find('option').each(function (index) {
            var $lis = that.findLis().eq(that.liObj[index]);

            that.setDisabled(index, this.disabled || this.parentNode.tagName === 'OPTGROUP' && this.parentNode.disabled, $lis);
            that.setSelected(index, this.selected, $lis);
          });

          this.togglePlaceholder();
        }

        this.tabIndex();

        var selectedItems = this.$element.find('option').map(function () {
          if (this.selected) {
            if (that.options.hideDisabled && (this.disabled || this.parentNode.tagName === 'OPTGROUP' && this.parentNode.disabled)) return;

            var $this = $(this),
                icon = $this.data('icon') && that.options.showIcon ? '<i class="' + that.options.iconBase + ' ' + $this.data('icon') + '"></i> ' : '',
                subtext;

            if (that.options.showSubtext && $this.data('subtext') && !that.multiple) {
              subtext = ' <small class="text-muted">' + $this.data('subtext') + '</small>';
            } else {
              subtext = '';
            }
            if (typeof $this.attr('title') !== 'undefined') {
              return $this.attr('title');
            } else if ($this.data('content') && that.options.showContent) {
              return $this.data('content');
            } else {
              return icon + $this.html() + subtext;
            }
          }
        }).toArray();

        //Fixes issue in IE10 occurring when no default option is selected and at least one option is disabled
        //Convert all the values into a comma delimited string
        var title = !this.multiple ? selectedItems[0] : selectedItems.join(this.options.multipleSeparator);

        //If this is multi select, and the selectText type is count, the show 1 of 2 selected etc..
        if (this.multiple && this.options.selectedTextFormat.indexOf('count') > -1) {
          var max = this.options.selectedTextFormat.split('>');
          if ((max.length > 1 && selectedItems.length > max[1]) || (max.length == 1 && selectedItems.length >= 2)) {
            notDisabled = this.options.hideDisabled ? ', [disabled]' : '';
            var totalCount = this.$element.find('option').not('[data-divider="true"], [data-hidden="true"]' + notDisabled).length,
                tr8nText = (typeof this.options.countSelectedText === 'function') ? this.options.countSelectedText(selectedItems.length, totalCount) : this.options.countSelectedText;
            title = tr8nText.replace('{0}', selectedItems.length.toString()).replace('{1}', totalCount.toString());
          }
        }

        if (this.options.title == undefined) {
          this.options.title = this.$element.attr('title');
        }

        if (this.options.selectedTextFormat == 'static') {
          title = this.options.title;
        }

        //If we dont have a title, then use the default, or if nothing is set at all, use the not selected text
        if (!title) {
          title = typeof this.options.title !== 'undefined' ? this.options.title : this.options.noneSelectedText;
        }

        //strip all html-tags and trim the result
        this.$button.attr('title', $.trim(title.replace(/<[^>]*>?/g, '')));
        this.$button.children('.filter-option').html(title);

        this.$element.trigger('rendered.bs.select');
      },

      /**
       * @param [style]
       * @param [status]
       */
      setStyle: function (style, status) {
        if (this.$element.attr('class')) {
          this.$newElement.addClass(this.$element.attr('class').replace(/selectpicker|mobile-device|bs-select-hidden|validate\[.*\]/gi, ''));
        }

        var buttonClass = style ? style : this.options.style;

        if (status == 'add') {
          this.$button.addClass(buttonClass);
        } else if (status == 'remove') {
          this.$button.removeClass(buttonClass);
        } else {
          this.$button.removeClass(this.options.style);
          this.$button.addClass(buttonClass);
        }
      },

      liHeight: function (refresh) {
        if (!refresh && (this.options.size === false || this.sizeInfo)) return;

        var newElement = document.createElement('div'),
            menu = document.createElement('div'),
            menuInner = document.createElement('ul'),
            divider = document.createElement('li'),
            li = document.createElement('li'),
            a = document.createElement('a'),
            text = document.createElement('span'),
            header = this.options.header && this.$menu.find('.popover-title').length > 0 ? this.$menu.find('.popover-title')[0].cloneNode(true) : null,
            search = this.options.liveSearch ? document.createElement('div') : null,
            actions = this.options.actionsBox && this.multiple && this.$menu.find('.bs-actionsbox').length > 0 ? this.$menu.find('.bs-actionsbox')[0].cloneNode(true) : null,
            doneButton = this.options.doneButton && this.multiple && this.$menu.find('.bs-donebutton').length > 0 ? this.$menu.find('.bs-donebutton')[0].cloneNode(true) : null;

        text.className = 'text';
        newElement.className = this.$menu[0].parentNode.className + ' open';
        menu.className = 'dropdown-menu open';
        menuInner.className = 'dropdown-menu inner';
        divider.className = 'divider';

        text.appendChild(document.createTextNode('Inner text'));
        a.appendChild(text);
        li.appendChild(a);
        menuInner.appendChild(li);
        menuInner.appendChild(divider);
        if (header) menu.appendChild(header);
        if (search) {
          // create a span instead of input as creating an input element is slower
          var input = document.createElement('span');
          search.className = 'bs-searchbox';
          input.className = 'form-control';
          search.appendChild(input);
          menu.appendChild(search);
        }
        if (actions) menu.appendChild(actions);
        menu.appendChild(menuInner);
        if (doneButton) menu.appendChild(doneButton);
        newElement.appendChild(menu);

        document.body.appendChild(newElement);

        var liHeight = a.offsetHeight,
            headerHeight = header ? header.offsetHeight : 0,
            searchHeight = search ? search.offsetHeight : 0,
            actionsHeight = actions ? actions.offsetHeight : 0,
            doneButtonHeight = doneButton ? doneButton.offsetHeight : 0,
            dividerHeight = $(divider).outerHeight(true),
            // fall back to jQuery if getComputedStyle is not supported
            menuStyle = typeof getComputedStyle === 'function' ? getComputedStyle(menu) : false,
            $menu = menuStyle ? null : $(menu),
            menuPadding = {
              vert: parseInt(menuStyle ? menuStyle.paddingTop : $menu.css('paddingTop')) +
                    parseInt(menuStyle ? menuStyle.paddingBottom : $menu.css('paddingBottom')) +
                    parseInt(menuStyle ? menuStyle.borderTopWidth : $menu.css('borderTopWidth')) +
                    parseInt(menuStyle ? menuStyle.borderBottomWidth : $menu.css('borderBottomWidth')),
              horiz: parseInt(menuStyle ? menuStyle.paddingLeft : $menu.css('paddingLeft')) +
                    parseInt(menuStyle ? menuStyle.paddingRight : $menu.css('paddingRight')) +
                    parseInt(menuStyle ? menuStyle.borderLeftWidth : $menu.css('borderLeftWidth')) +
                    parseInt(menuStyle ? menuStyle.borderRightWidth : $menu.css('borderRightWidth'))
            },
            menuExtras =  {
              vert: menuPadding.vert +
                          parseInt(menuStyle ? menuStyle.marginTop : $menu.css('marginTop')) +
                          parseInt(menuStyle ? menuStyle.marginBottom : $menu.css('marginBottom')) + 2,
              horiz: menuPadding.horiz +
                          parseInt(menuStyle ? menuStyle.marginLeft : $menu.css('marginLeft')) +
                          parseInt(menuStyle ? menuStyle.marginRight : $menu.css('marginRight')) + 2
            }

        document.body.removeChild(newElement);

        this.sizeInfo = {
          liHeight: liHeight,
          headerHeight: headerHeight,
          searchHeight: searchHeight,
          actionsHeight: actionsHeight,
          doneButtonHeight: doneButtonHeight,
          dividerHeight: dividerHeight,
          menuPadding: menuPadding,
          menuExtras: menuExtras
        };
      },

      setSize: function () {
        this.findLis();
        this.liHeight();

        if (this.options.header) this.$menu.css('padding-top', 0);
        if (this.options.size === false) return;

        var that = this,
            $menu = this.$menu,
            $menuInner = this.$menuInner,
            $window = $(window),
            selectHeight = this.$newElement[0].offsetHeight,
            selectWidth = this.$newElement[0].offsetWidth,
            liHeight = this.sizeInfo['liHeight'],
            headerHeight = this.sizeInfo['headerHeight'],
            searchHeight = this.sizeInfo['searchHeight'],
            actionsHeight = this.sizeInfo['actionsHeight'],
            doneButtonHeight = this.sizeInfo['doneButtonHeight'],
            divHeight = this.sizeInfo['dividerHeight'],
            menuPadding = this.sizeInfo['menuPadding'],
            menuExtras = this.sizeInfo['menuExtras'],
            notDisabled = this.options.hideDisabled ? '.disabled' : '',
            menuHeight,
            menuWidth,
            getHeight,
            getWidth,
            selectOffsetTop,
            selectOffsetBot,
            selectOffsetLeft,
            selectOffsetRight,
            getPos = function() {
              var pos = that.$newElement.offset();
              selectOffsetTop = pos.top - $window.scrollTop();
              selectOffsetBot = $window.height() - selectOffsetTop - selectHeight;
              selectOffsetLeft = pos.left - $window.scrollLeft();
              selectOffsetRight = $window.width() - selectOffsetLeft - selectWidth;
            };

        getPos();

        if (this.options.size === 'auto') {
          var getSize = function () {
            var minHeight,
                hasClass = function (className, include) {
                  return function (element) {
                      if (include) {
                          return (element.classList ? element.classList.contains(className) : $(element).hasClass(className));
                      } else {
                          return !(element.classList ? element.classList.contains(className) : $(element).hasClass(className));
                      }
                  };
                },
                lis = that.$menuInner[0].getElementsByTagName('li'),
                lisVisible = Array.prototype.filter ? Array.prototype.filter.call(lis, hasClass('hidden', false)) : that.$lis.not('.hidden'),
                optGroup = Array.prototype.filter ? Array.prototype.filter.call(lisVisible, hasClass('dropdown-header', true)) : lisVisible.filter('.dropdown-header');

            getPos();
            menuHeight = selectOffsetBot - menuExtras.vert;
            menuWidth = selectOffsetRight - menuExtras.horiz;

            if (that.options.container) {
              if (!$menu.data('height')) $menu.data('height', $menu.height());
              getHeight = $menu.data('height');
              
              if (!$menu.data('width')) $menu.data('width', $menu.width());
              getWidth = $menu.data('width');
            } else {
              getHeight = $menu.height();
              getWidth = $menu.width();
            }

            if (that.options.dropupAuto) {
              that.$newElement.toggleClass('dropup', selectOffsetTop > selectOffsetBot && (menuHeight - menuExtras.vert) < getHeight);
            }

            if (that.$newElement.hasClass('dropup')) {
              menuHeight = selectOffsetTop - menuExtras.vert;
            }

            if (that.options.dropdownAlignRight === 'auto') {
              $menu.toggleClass('dropdown-menu-right', selectOffsetLeft > selectOffsetRight && (menuWidth - menuExtras.horiz) < (getWidth - selectWidth));
            }

            if ((lisVisible.length + optGroup.length) > 3) {
              minHeight = liHeight * 3 + menuExtras.vert - 2;
            } else {
              minHeight = 0;
            }

            $menu.css({
              'max-height': menuHeight + 'px',
              'overflow': 'hidden',
              'min-height': minHeight + headerHeight + searchHeight + actionsHeight + doneButtonHeight + 'px'
            });
            $menuInner.css({
              'max-height': menuHeight - headerHeight - searchHeight - actionsHeight - doneButtonHeight - menuPadding.vert + 'px',
              'overflow-y': 'auto',
              'min-height': Math.max(minHeight - menuPadding.vert, 0) + 'px'
            });
          };
          getSize();
          this.$searchbox.off('input.getSize propertychange.getSize').on('input.getSize propertychange.getSize', getSize);
          $window.off('resize.getSize scroll.getSize').on('resize.getSize scroll.getSize', getSize);
        } else if (this.options.size && this.options.size != 'auto' && this.$lis.not(notDisabled).length > this.options.size) {
          var optIndex = this.$lis.not('.divider').not(notDisabled).children().slice(0, this.options.size).last().parent().index(),
              divLength = this.$lis.slice(0, optIndex + 1).filter('.divider').length;
          menuHeight = liHeight * this.options.size + divLength * divHeight + menuPadding.vert;

          if (that.options.container) {
            if (!$menu.data('height')) $menu.data('height', $menu.height());
            getHeight = $menu.data('height');
          } else {
            getHeight = $menu.height();
          }

          if (that.options.dropupAuto) {
            //noinspection JSUnusedAssignment
            this.$newElement.toggleClass('dropup', selectOffsetTop > selectOffsetBot && (menuHeight - menuExtras.vert) < getHeight);
          }
          $menu.css({
            'max-height': menuHeight + headerHeight + searchHeight + actionsHeight + doneButtonHeight + 'px',
            'overflow': 'hidden',
            'min-height': ''
          });
          $menuInner.css({
            'max-height': menuHeight - menuPadding.vert + 'px',
            'overflow-y': 'auto',
            'min-height': ''
          });
        }
      },

      setWidth: function () {
        if (this.options.width === 'auto') {
          this.$menu.css('min-width', '0');

          // Get correct width if element is hidden
          var $selectClone = this.$menu.parent().clone().appendTo('body'),
              $selectClone2 = this.options.container ? this.$newElement.clone().appendTo('body') : $selectClone,
              ulWidth = $selectClone.children('.dropdown-menu').outerWidth(),
              btnWidth = $selectClone2.css('width', 'auto').children('button').outerWidth();

          $selectClone.remove();
          $selectClone2.remove();

          // Set width to whatever's larger, button title or longest option
          this.$newElement.css('width', Math.max(ulWidth, btnWidth) + 'px');
        } else if (this.options.width === 'fit') {
          // Remove inline min-width so width can be changed from 'auto'
          this.$menu.css('min-width', '');
          this.$newElement.css('width', '').addClass('fit-width');
        } else if (this.options.width) {
          // Remove inline min-width so width can be changed from 'auto'
          this.$menu.css('min-width', '');
          this.$newElement.css('width', this.options.width);
        } else {
          // Remove inline min-width/width so width can be changed
          this.$menu.css('min-width', '');
          this.$newElement.css('width', '');
        }
        // Remove fit-width class if width is changed programmatically
        if (this.$newElement.hasClass('fit-width') && this.options.width !== 'fit') {
          this.$newElement.removeClass('fit-width');
        }
      },

      selectPosition: function () {
        this.$bsContainer = $('<div class="bs-container" />');

        var that = this,
            pos,
            actualHeight,
            getPlacement = function ($element) {
              that.$bsContainer.addClass($element.attr('class').replace(/form-control|fit-width/gi, '')).toggleClass('dropup', $element.hasClass('dropup'));
              pos = $element.offset();
              actualHeight = $element.hasClass('dropup') ? 0 : $element[0].offsetHeight;
              that.$bsContainer.css({
                'top': pos.top + actualHeight,
                'left': pos.left,
                'width': $element[0].offsetWidth
              });
            };

        this.$button.on('click', function () {
          var $this = $(this);

          if (that.isDisabled()) {
            return;
          }

          getPlacement(that.$newElement);

          that.$bsContainer
            .appendTo(that.options.container)
            .toggleClass('open', !$this.hasClass('open'))
            .append(that.$menu);
        });

        $(window).on('resize scroll', function () {
          getPlacement(that.$newElement);
        });

        this.$element.on('hide.bs.select', function () {
          that.$menu.data('height', that.$menu.height());
          that.$bsContainer.detach();
        });
      },

      /**
       * @param {number} index - the index of the option that is being changed
       * @param {boolean} selected - true if the option is being selected, false if being deselected
       * @param {JQuery} $lis - the 'li' element that is being modified
       */
      setSelected: function (index, selected, $lis) {
        if (!$lis) {
          this.togglePlaceholder(); // check if setSelected is being called by changing the value of the select
          $lis = this.findLis().eq(this.liObj[index]);
        }

        $lis.toggleClass('selected', selected);
      },

      /**
       * @param {number} index - the index of the option that is being disabled
       * @param {boolean} disabled - true if the option is being disabled, false if being enabled
       * @param {JQuery} $lis - the 'li' element that is being modified
       */
      setDisabled: function (index, disabled, $lis) {
        if (!$lis) {
          $lis = this.findLis().eq(this.liObj[index]);
        }

        if (disabled) {
          $lis.addClass('disabled').children('a').attr('href', '#').attr('tabindex', -1);
        } else {
          $lis.removeClass('disabled').children('a').removeAttr('href').attr('tabindex', 0);
        }
      },

      isDisabled: function () {
        return this.$element[0].disabled;
      },

      checkDisabled: function () {
        var that = this;

        if (this.isDisabled()) {
          this.$newElement.addClass('disabled');
          this.$button.addClass('disabled').attr('tabindex', -1);
        } else {
          if (this.$button.hasClass('disabled')) {
            this.$newElement.removeClass('disabled');
            this.$button.removeClass('disabled');
          }

          if (this.$button.attr('tabindex') == -1 && !this.$element.data('tabindex')) {
            this.$button.removeAttr('tabindex');
          }
        }

        this.$button.click(function () {
          return !that.isDisabled();
        });
      },

      togglePlaceholder: function () {
        var value = this.$element.val();
        this.$button.toggleClass('bs-placeholder', value === null || value === '');
      },

      tabIndex: function () {
        if (this.$element.data('tabindex') !== this.$element.attr('tabindex') && 
          (this.$element.attr('tabindex') !== -98 && this.$element.attr('tabindex') !== '-98')) {
          this.$element.data('tabindex', this.$element.attr('tabindex'));
          this.$button.attr('tabindex', this.$element.data('tabindex'));
        }
        
        this.$element.attr('tabindex', -98);
      },

      clickListener: function () {
        var that = this,
            $document = $(document);

        this.$newElement.on('touchstart.dropdown', '.dropdown-menu', function (e) {
          e.stopPropagation();
        });

        $document.data('spaceSelect', false);

        this.$button.on('keyup', function (e) {
          if (/(32)/.test(e.keyCode.toString(10)) && $document.data('spaceSelect')) {
              e.preventDefault();
              $document.data('spaceSelect', false);
          }
        });

        this.$button.on('click', function () {
          that.setSize();
        });

        this.$element.on('shown.bs.select', function () {
          if (!that.options.liveSearch && !that.multiple) {
            that.$menuInner.find('.selected a').focus();
          } else if (!that.multiple) {
            var selectedIndex = that.liObj[that.$element[0].selectedIndex];

            if (typeof selectedIndex !== 'number' || that.options.size === false) return;

            // scroll to selected option
            var offset = that.$lis.eq(selectedIndex)[0].offsetTop - that.$menuInner[0].offsetTop;
            offset = offset - that.$menuInner[0].offsetHeight/2 + that.sizeInfo.liHeight/2;
            that.$menuInner[0].scrollTop = offset;
          }
        });

        this.$menuInner.on('click', 'li a', function (e) {
          var $this = $(this),
              clickedIndex = $this.parent().data('originalIndex'),
              prevValue = that.$element.val(),
              prevIndex = that.$element.prop('selectedIndex'),
              triggerChange = true;

          // Don't close on multi choice menu
          if (that.multiple && that.options.maxOptions !== 1) {
            e.stopPropagation();
          }

          e.preventDefault();

          //Don't run if we have been disabled
          if (!that.isDisabled() && !$this.parent().hasClass('disabled')) {
            var $options = that.$element.find('option'),
                $option = $options.eq(clickedIndex),
                state = $option.prop('selected'),
                $optgroup = $option.parent('optgroup'),
                maxOptions = that.options.maxOptions,
                maxOptionsGrp = $optgroup.data('maxOptions') || false;

            if (!that.multiple) { // Deselect all others if not multi select box
              $options.prop('selected', false);
              $option.prop('selected', true);
              that.$menuInner.find('.selected').removeClass('selected');
              that.setSelected(clickedIndex, true);
            } else { // Toggle the one we have chosen if we are multi select.
              $option.prop('selected', !state);
              that.setSelected(clickedIndex, !state);
              $this.blur();

              if (maxOptions !== false || maxOptionsGrp !== false) {
                var maxReached = maxOptions < $options.filter(':selected').length,
                    maxReachedGrp = maxOptionsGrp < $optgroup.find('option:selected').length;

                if ((maxOptions && maxReached) || (maxOptionsGrp && maxReachedGrp)) {
                  if (maxOptions && maxOptions == 1) {
                    $options.prop('selected', false);
                    $option.prop('selected', true);
                    that.$menuInner.find('.selected').removeClass('selected');
                    that.setSelected(clickedIndex, true);
                  } else if (maxOptionsGrp && maxOptionsGrp == 1) {
                    $optgroup.find('option:selected').prop('selected', false);
                    $option.prop('selected', true);
                    var optgroupID = $this.parent().data('optgroup');
                    that.$menuInner.find('[data-optgroup="' + optgroupID + '"]').removeClass('selected');
                    that.setSelected(clickedIndex, true);
                  } else {
                    var maxOptionsArr = (typeof that.options.maxOptionsText === 'function') ?
                            that.options.maxOptionsText(maxOptions, maxOptionsGrp) : that.options.maxOptionsText,
                        maxTxt = maxOptionsArr[0].replace('{n}', maxOptions),
                        maxTxtGrp = maxOptionsArr[1].replace('{n}', maxOptionsGrp),
                        $notify = $('<div class="notify"></div>');
                    // If {var} is set in array, replace it
                    /** @deprecated */
                    if (maxOptionsArr[2]) {
                      maxTxt = maxTxt.replace('{var}', maxOptionsArr[2][maxOptions > 1 ? 0 : 1]);
                      maxTxtGrp = maxTxtGrp.replace('{var}', maxOptionsArr[2][maxOptionsGrp > 1 ? 0 : 1]);
                    }

                    $option.prop('selected', false);

                    that.$menu.append($notify);

                    if (maxOptions && maxReached) {
                      $notify.append($('<div>' + maxTxt + '</div>'));
                      triggerChange = false;
                      that.$element.trigger('maxReached.bs.select');
                    }

                    if (maxOptionsGrp && maxReachedGrp) {
                      $notify.append($('<div>' + maxTxtGrp + '</div>'));
                      triggerChange = false;
                      that.$element.trigger('maxReachedGrp.bs.select');
                    }

                    setTimeout(function () {
                      that.setSelected(clickedIndex, false);
                    }, 10);

                    $notify.delay(750).fadeOut(300, function () {
                      $(this).remove();
                    });
                  }
                }
              }
            }

            if (!that.multiple || (that.multiple && that.options.maxOptions === 1)) {
              that.$button.focus();
            } else if (that.options.liveSearch) {
              that.$searchbox.focus();
            }

            // Trigger select 'change'
            if (triggerChange) {
              if ((prevValue != that.$element.val() && that.multiple) || (prevIndex != that.$element.prop('selectedIndex') && !that.multiple)) {
                // $option.prop('selected') is current option state (selected/unselected). state is previous option state.
                that.$element
                  .trigger('changed.bs.select', [clickedIndex, $option.prop('selected'), state])
                  .triggerNative('change');
              }
            }
          }
        });

        this.$menu.on('click', 'li.disabled a, .popover-title, .popover-title :not(.close)', function (e) {
          if (e.currentTarget == this) {
            e.preventDefault();
            e.stopPropagation();
            if (that.options.liveSearch && !$(e.target).hasClass('close')) {
              that.$searchbox.focus();
            } else {
              that.$button.focus();
            }
          }
        });

        this.$menuInner.on('click', '.divider, .dropdown-header', function (e) {
          e.preventDefault();
          e.stopPropagation();
          if (that.options.liveSearch) {
            that.$searchbox.focus();
          } else {
            that.$button.focus();
          }
        });

        this.$menu.on('click', '.popover-title .close', function () {
          that.$button.click();
        });

        this.$searchbox.on('click', function (e) {
          e.stopPropagation();
        });

        this.$menu.on('click', '.actions-btn', function (e) {
          if (that.options.liveSearch) {
            that.$searchbox.focus();
          } else {
            that.$button.focus();
          }

          e.preventDefault();
          e.stopPropagation();

          if ($(this).hasClass('bs-select-all')) {
            that.selectAll();
          } else {
            that.deselectAll();
          }
        });

        this.$element.change(function () {
          that.render(false);
        });
      },

      liveSearchListener: function () {
        var that = this,
            $no_results = $('<li class="no-results"></li>');

        this.$button.on('click.dropdown.data-api touchstart.dropdown.data-api', function () {
          that.$menuInner.find('.active').removeClass('active');
          if (!!that.$searchbox.val()) {
            that.$searchbox.val('');
            that.$lis.not('.is-hidden').removeClass('hidden');
            if (!!$no_results.parent().length) $no_results.remove();
          }
          if (!that.multiple) that.$menuInner.find('.selected').addClass('active');
          setTimeout(function () {
            that.$searchbox.focus();
          }, 10);
        });

        this.$searchbox.on('click.dropdown.data-api focus.dropdown.data-api touchend.dropdown.data-api', function (e) {
          e.stopPropagation();
        });

        this.$searchbox.on('input propertychange', function () {
          if (that.$searchbox.val()) {
            var $searchBase = that.$lis.not('.is-hidden').removeClass('hidden').children('a');
            if (that.options.liveSearchNormalize) {
              $searchBase = $searchBase.not(':a' + that._searchStyle() + '("' + normalizeToBase(that.$searchbox.val()) + '")');
            } else {
              $searchBase = $searchBase.not(':' + that._searchStyle() + '("' + that.$searchbox.val() + '")');
            }
            $searchBase.parent().addClass('hidden');

            that.$lis.filter('.dropdown-header').each(function () {
              var $this = $(this),
                  optgroup = $this.data('optgroup');

              if (that.$lis.filter('[data-optgroup=' + optgroup + ']').not($this).not('.hidden').length === 0) {
                $this.addClass('hidden');
                that.$lis.filter('[data-optgroup=' + optgroup + 'div]').addClass('hidden');
              }
            });

            var $lisVisible = that.$lis.not('.hidden');

            // hide divider if first or last visible, or if followed by another divider
            $lisVisible.each(function (index) {
              var $this = $(this);

              if ($this.hasClass('divider') && (
                $this.index() === $lisVisible.first().index() ||
                $this.index() === $lisVisible.last().index() ||
                $lisVisible.eq(index + 1).hasClass('divider'))) {
                $this.addClass('hidden');
              }
            });

            if (!that.$lis.not('.hidden, .no-results').length) {
              if (!!$no_results.parent().length) {
                $no_results.remove();
              }
              $no_results.html(that.options.noneResultsText.replace('{0}', '"' + htmlEscape(that.$searchbox.val()) + '"')).show();
              that.$menuInner.append($no_results);
            } else if (!!$no_results.parent().length) {
              $no_results.remove();
            }
          } else {
            that.$lis.not('.is-hidden').removeClass('hidden');
            if (!!$no_results.parent().length) {
              $no_results.remove();
            }
          }

          that.$lis.filter('.active').removeClass('active');
          if (that.$searchbox.val()) that.$lis.not('.hidden, .divider, .dropdown-header').eq(0).addClass('active').children('a').focus();
          $(this).focus();
        });
      },

      _searchStyle: function () {
        var styles = {
          begins: 'ibegins',
          startsWith: 'ibegins'
        };

        return styles[this.options.liveSearchStyle] || 'icontains';
      },

      val: function (value) {
        if (typeof value !== 'undefined') {
          this.$element.val(value);
          this.render();

          return this.$element;
        } else {
          return this.$element.val();
        }
      },

      changeAll: function (status) {
        if (typeof status === 'undefined') status = true;

        this.findLis();

        var $options = this.$element.find('option'),
            $lisVisible = this.$lis.not('.divider, .dropdown-header, .disabled, .hidden'),
            lisVisLen = $lisVisible.length,
            selectedOptions = [];
            
        if (status) {
          if ($lisVisible.filter('.selected').length === $lisVisible.length) return;
        } else {
          if ($lisVisible.filter('.selected').length === 0) return;
        }
            
        $lisVisible.toggleClass('selected', status);

        for (var i = 0; i < lisVisLen; i++) {
          var origIndex = $lisVisible[i].getAttribute('data-original-index');
          selectedOptions[selectedOptions.length] = $options.eq(origIndex)[0];
        }

        $(selectedOptions).prop('selected', status);

        this.render(false);

        this.togglePlaceholder();

        this.$element
          .trigger('changed.bs.select')
          .triggerNative('change');
      },

      selectAll: function () {
        return this.changeAll(true);
      },

      deselectAll: function () {
        return this.changeAll(false);
      },

      toggle: function (e) {
        e = e || window.event;
        
        if (e) e.stopPropagation();

        this.$button.trigger('click');
      },

      keydown: function (e) {
        var $this = $(this),
            $parent = $this.is('input') ? $this.parent().parent() : $this.parent(),
            $items,
            that = $parent.data('this'),
            index,
            next,
            first,
            last,
            prev,
            nextPrev,
            prevIndex,
            isActive,
            selector = ':not(.disabled, .hidden, .dropdown-header, .divider)',
            keyCodeMap = {
              32: ' ',
              48: '0',
              49: '1',
              50: '2',
              51: '3',
              52: '4',
              53: '5',
              54: '6',
              55: '7',
              56: '8',
              57: '9',
              59: ';',
              65: 'a',
              66: 'b',
              67: 'c',
              68: 'd',
              69: 'e',
              70: 'f',
              71: 'g',
              72: 'h',
              73: 'i',
              74: 'j',
              75: 'k',
              76: 'l',
              77: 'm',
              78: 'n',
              79: 'o',
              80: 'p',
              81: 'q',
              82: 'r',
              83: 's',
              84: 't',
              85: 'u',
              86: 'v',
              87: 'w',
              88: 'x',
              89: 'y',
              90: 'z',
              96: '0',
              97: '1',
              98: '2',
              99: '3',
              100: '4',
              101: '5',
              102: '6',
              103: '7',
              104: '8',
              105: '9'
            };

        if (that.options.liveSearch) $parent = $this.parent().parent();

        if (that.options.container) $parent = that.$menu;

        $items = $('[role=menu] li', $parent);

        isActive = that.$newElement.hasClass('open');

        if (!isActive && (e.keyCode >= 48 && e.keyCode <= 57 || e.keyCode >= 96 && e.keyCode <= 105 || e.keyCode >= 65 && e.keyCode <= 90)) {
          if (!that.options.container) {
            that.setSize();
            that.$menu.parent().addClass('open');
            isActive = true;
          } else {
            that.$button.trigger('click');
          }
          that.$searchbox.focus();
          return;
        }

        if (that.options.liveSearch) {
          if (/(^9$|27)/.test(e.keyCode.toString(10)) && isActive && that.$menu.find('.active').length === 0) {
            e.preventDefault();
            that.$menu.parent().removeClass('open');
            if (that.options.container) that.$newElement.removeClass('open');
            that.$button.focus();
          }
          // $items contains li elements when liveSearch is enabled
          $items = $('[role=menu] li' + selector, $parent);
          if (!$this.val() && !/(38|40)/.test(e.keyCode.toString(10))) {
            if ($items.filter('.active').length === 0) {
              $items = that.$menuInner.find('li');
              if (that.options.liveSearchNormalize) {
                $items = $items.filter(':a' + that._searchStyle() + '(' + normalizeToBase(keyCodeMap[e.keyCode]) + ')');
              } else {
                $items = $items.filter(':' + that._searchStyle() + '(' + keyCodeMap[e.keyCode] + ')');
              }
            }
          }
        }

        if (!$items.length) return;

        if (/(38|40)/.test(e.keyCode.toString(10))) {
          index = $items.index($items.find('a').filter(':focus').parent());
          first = $items.filter(selector).first().index();
          last = $items.filter(selector).last().index();
          next = $items.eq(index).nextAll(selector).eq(0).index();
          prev = $items.eq(index).prevAll(selector).eq(0).index();
          nextPrev = $items.eq(next).prevAll(selector).eq(0).index();

          if (that.options.liveSearch) {
            $items.each(function (i) {
              if (!$(this).hasClass('disabled')) {
                $(this).data('index', i);
              }
            });
            index = $items.index($items.filter('.active'));
            first = $items.first().data('index');
            last = $items.last().data('index');
            next = $items.eq(index).nextAll().eq(0).data('index');
            prev = $items.eq(index).prevAll().eq(0).data('index');
            nextPrev = $items.eq(next).prevAll().eq(0).data('index');
          }

          prevIndex = $this.data('prevIndex');

          if (e.keyCode == 38) {
            if (that.options.liveSearch) index--;
            if (index != nextPrev && index > prev) index = prev;
            if (index < first) index = first;
            if (index == prevIndex) index = last;
          } else if (e.keyCode == 40) {
            if (that.options.liveSearch) index++;
            if (index == -1) index = 0;
            if (index != nextPrev && index < next) index = next;
            if (index > last) index = last;
            if (index == prevIndex) index = first;
          }

          $this.data('prevIndex', index);

          if (!that.options.liveSearch) {
            $items.eq(index).children('a').focus();
          } else {
            e.preventDefault();
            if (!$this.hasClass('dropdown-toggle')) {
              $items.removeClass('active').eq(index).addClass('active').children('a').focus();
              $this.focus();
            }
          }

        } else if (!$this.is('input')) {
          var keyIndex = [],
              count,
              prevKey;

          $items.each(function () {
            if (!$(this).hasClass('disabled')) {
              if ($.trim($(this).children('a').text().toLowerCase()).substring(0, 1) == keyCodeMap[e.keyCode]) {
                keyIndex.push($(this).index());
              }
            }
          });

          count = $(document).data('keycount');
          count++;
          $(document).data('keycount', count);

          prevKey = $.trim($(':focus').text().toLowerCase()).substring(0, 1);

          if (prevKey != keyCodeMap[e.keyCode]) {
            count = 1;
            $(document).data('keycount', count);
          } else if (count >= keyIndex.length) {
            $(document).data('keycount', 0);
            if (count > keyIndex.length) count = 1;
          }

          $items.eq(keyIndex[count - 1]).children('a').focus();
        }

        // Select focused option if "Enter", "Spacebar" or "Tab" (when selectOnTab is true) are pressed inside the menu.
        if ((/(13|32)/.test(e.keyCode.toString(10)) || (/(^9$)/.test(e.keyCode.toString(10)) && that.options.selectOnTab)) && isActive) {
          if (!/(32)/.test(e.keyCode.toString(10))) e.preventDefault();
          if (!that.options.liveSearch) {
            var elem = $(':focus');
            elem.click();
            // Bring back focus for multiselects
            elem.focus();
            // Prevent screen from scrolling if the user hit the spacebar
            e.preventDefault();
            // Fixes spacebar selection of dropdown items in FF & IE
            $(document).data('spaceSelect', true);
          } else if (!/(32)/.test(e.keyCode.toString(10))) {
            that.$menuInner.find('.active a').click();
            $this.focus();
          }
          $(document).data('keycount', 0);
        }

        if ((/(^9$|27)/.test(e.keyCode.toString(10)) && isActive && (that.multiple || that.options.liveSearch)) || (/(27)/.test(e.keyCode.toString(10)) && !isActive)) {
          that.$menu.parent().removeClass('open');
          if (that.options.container) that.$newElement.removeClass('open');
          that.$button.focus();
        }
      },

      mobile: function () {
        this.$element.addClass('mobile-device');
      },

      refresh: function () {
        this.$lis = null;
        this.liObj = {};
        this.reloadLi();
        this.render();
        this.checkDisabled();
        this.liHeight(true);
        this.setStyle();
        this.setWidth();
        if (this.$lis) this.$searchbox.trigger('propertychange');

        this.$element.trigger('refreshed.bs.select');
      },

      hide: function () {
        this.$newElement.hide();
      },

      show: function () {
        this.$newElement.show();
      },

      remove: function () {
        this.$newElement.remove();
        this.$element.remove();
      },

      destroy: function () {
          this.$newElement.before(this.$element).remove();

          if (this.$bsContainer) {
              this.$bsContainer.remove();
          } else {
              this.$menu.remove();
          }

          this.$element
            .off('.bs.select')
            .removeData('selectpicker')
            .removeClass('bs-select-hidden selectpicker');
      }
    };

    // SELECTPICKER PLUGIN DEFINITION
    // ==============================
    function Plugin(option, event) {
      // get the args of the outer function..
      var args = arguments;
      // The arguments of the function are explicitly re-defined from the argument list, because the shift causes them
      // to get lost/corrupted in android 2.3 and IE9 #715 #775
      var _option = option,
          _event = event;
      [].shift.apply(args);

      var value;
      var chain = this.each(function () {
        var $this = $(this);
        if ($this.is('select')) {
          var data = $this.data('selectpicker'),
              options = typeof _option == 'object' && _option;

          if (!data) {
            var config = $.extend({}, Selectpicker.DEFAULTS, $.fn.selectpicker.defaults || {}, $this.data(), options);
            config.template = $.extend({}, Selectpicker.DEFAULTS.template, ($.fn.selectpicker.defaults ? $.fn.selectpicker.defaults.template : {}), $this.data().template, options.template);
            $this.data('selectpicker', (data = new Selectpicker(this, config, _event)));
          } else if (options) {
            for (var i in options) {
              if (options.hasOwnProperty(i)) {
                data.options[i] = options[i];
              }
            }
          }

          if (typeof _option == 'string') {
            if (data[_option] instanceof Function) {
              value = data[_option].apply(data, args);
            } else {
              value = data.options[_option];
            }
          }
        }
      });

      if (typeof value !== 'undefined') {
        //noinspection JSUnusedAssignment
        return value;
      } else {
        return chain;
      }
    }

    var old = $.fn.selectpicker;
    $.fn.selectpicker = Plugin;
    $.fn.selectpicker.Constructor = Selectpicker;

    // SELECTPICKER NO CONFLICT
    // ========================
    $.fn.selectpicker.noConflict = function () {
      $.fn.selectpicker = old;
      return this;
    };

    $(document)
        .data('keycount', 0)
        .on('keydown.bs.select', '.bootstrap-select [data-toggle=dropdown], .bootstrap-select [role="menu"], .bs-searchbox input', Selectpicker.prototype.keydown)
        .on('focusin.modal', '.bootstrap-select [data-toggle=dropdown], .bootstrap-select [role="menu"], .bs-searchbox input', function (e) {
          e.stopPropagation();
        });

    // SELECTPICKER DATA-API
    // =====================
    $(window).on('load.bs.select.data-api', function () {
      $('.selectpicker').each(function () {
        var $selectpicker = $(this);
        Plugin.call($selectpicker, $selectpicker.data());
      })
    });
  })(jQuery);


}));

/*!
 * Mricode Pagination Plugin
 * Github: https://github.com/mricle/Mricode.Pagination
 * Version: 1.4.2
 * 
 * Required jQuery
 * 
 * Copyright 2016 Mricle
 * Released under the MIT license
 */

(function (factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD
        define(['jquery'], factory);
    } else if (typeof exports === 'object') {
        // Node / CommonJS
        factory(require('jquery'));
    } else {
        // Globals
        factory(jQuery);
    }
})(function ($) {
    "use strict";

    var Page = function (element, options) {
        var defaultOption = {
            pageIndex: 0,
            pageSize: 10,
            total: 0,
            pageBtnCount: 11,
            showFirstLastBtn: true,
            firstBtnText: null,
            lastBtnText: null,
            prevBtnText: "&laquo;",
            nextBtnText: "&raquo;",
            loadFirstPage: true,
            remote: {
                url: null,
                params: null,
                pageParams: null,
                success: null,
                beforeSend: null,
                complete: null,
                pageIndexName: 'pageIndex',
                pageSizeName: 'pageSize',
                totalName: 'total',
                traditional: false
            },
            pageElementSort: ['$page', '$size', '$jump', '$info'],
            showInfo: false,
            infoFormat: '{start} ~ {end} of {total} entires',
            noInfoText: '0 entires',
            showJump: false,
            jumpBtnText: 'Go',
            showPageSizes: false,
            pageSizeItems: [5, 10, 15, 20],
            debug: false
        }
        this.$element = $(element);
        this.$page = $('<ul class="m-pagination-page"></ul>').hide();
        this.$size = $('<div class="m-pagination-size"></div>').hide();
        this.$jump = $('<div class="m-pagination-jump"></div>').hide();
        this.$info = $('<div class="m-pagination-info"></div>').hide();
        this.options = $.extend(true, {}, defaultOption, $.fn.pagination.defaults, options);
        this.options.pageElementSort = options.pageElementSort || ($.fn.pagination.defaults && $.fn.pagination.defaults.pageElementSort) ? $.fn.pagination.defaults.pageElementSort : defaultOption.pageElementSort;
        this.options.pageSizeItems = options.pageSizeItems || ($.fn.pagination.defaults && $.fn.pagination.defaults.pageSizeItems) ? $.fn.pagination.defaults.pageSizeItems : defaultOption.pageSizeItems;
        this.total = this.options.total;
        this.currentUrl = this.options.remote.url;
        this.currentPageIndex = utility.convertInt(this.options.pageIndex);
        this.currentPageSize = utility.convertInt(this.options.pageSize);
        this.currentParams = utility.deserializeParams(this.options.remote.params) || {};
        this.getLastPageNum = function () {
            return pagination.core.calLastPageNum(this.total, this.currentPageSize);
        }
        if (this.options.remote.success === null) {
            this.options.remote.success = this.options.remote.callback;
        }
        this.init();
    }

    Page.prototype = {
        getPageIndex: function () {
            return this.currentPageIndex;
        },
        getPageSize: function () {
            return this.currentPageSize;
        },
        getParams: function () {
            return this.currentParams;
        },
        setPageIndex: function (pageIndex) {
            if (pageIndex !== undefined && pageIndex !== null) {
                this.currentPageIndex = utility.convertInt(pageIndex);
            }
        },
        setPageSize: function (pageSize) {
            if (pageSize !== undefined && pageSize !== null) {
                this.currentPageSize = utility.convertInt(pageSize);
            }
        },
        setRemoteUrl: function (url) {
            if (url) {
                this.currentUrl = url;
            }
        },
        setParams: function (params) {
            if (params) {
                this.currentParams = utility.deserializeParams(params);
            }
        },
        render: function (total) {
            if (total !== undefined && total !== null) {
                this.total = utility.convertInt(total);
            }
            this.renderPagination();
            this.debug('pagination rendered');
        },
        init: function () {
            this.initHtml();
            this.initEvent();
            if (this.currentUrl && this.options.loadFirstPage) {
                this.remote();
            } else {
                this.renderPagination();
            }
            this.debug('pagination inited');
        },
        initHtml: function () {
            //init size module
            var sizeHtml = $('<select data-page-btn="size"></select>');
            for (var i = 0; i < this.options.pageSizeItems.length; i++) {
                sizeHtml.append('<option value="' + this.options.pageSizeItems[i] + '" ' + (this.currentPageSize == this.options.pageSizeItems[i] ? "selected" : "") + ' >' + this.options.pageSizeItems[i] + '</option>')
            }
            sizeHtml.val(this.currentPageSize);
            this.$size.append(sizeHtml);

            //init jump module
            var jumpHtml = '<div class="m-pagination-group"><input data-page-btn="jump" type="text"><button data-page-btn="jump" type="button">' + this.options.jumpBtnText + '</button></div>';
            this.$jump.append(jumpHtml);

            for (var i = 0; i < this.options.pageElementSort.length; i++) {
                this.$element.append(this[this.options.pageElementSort[i]]);
            }
        },
        initEvent: function () {
            this.$element
            .on('click', { page: this }, function (event) {
                if ($(event.target).is('button')) {
                    if ($(event.target).data('pageBtn') == 'jump') {
                        var $input = event.data.page.$element.find('input[data-page-btn=jump]');
                        event.data.page.jumpEventHandler($input.val(), event);
                    }
                } else {
                    if ($(event.target).data('pageIndex') !== undefined)
                        eventHandler.call(event.data.page, event);
                }
            }).on('change', { page: this }, function (event) {
                var $this = $(event.target);
                if ($this.data('pageBtn') == 'jump') {
                    event.data.page.jumpEventHandler($this.val(), event);
                }
                if ($this.data('pageBtn') == 'size') {
                    eventHandler.call(event.data.page, event);
                }
            }).on('keypress', { page: this }, function (event) {
                if (event.keyCode == "13") {
                    var $input = event.data.page.$element.find('input[data-page-btn=jump]')
                    event.data.page.jumpEventHandler($input.val(), event);
                }
            });
        },
        jumpEventHandler: function (inputValue, event) {
            if (!inputValue) {
                this.$jump.removeClass('error');
            } else if (!pagination.check.checkJumpPage(inputValue)) {
                this.$jump.addClass('error');
            }
            else if (utility.convertInt(inputValue) > this.getLastPageNum()) {
                this.$jump.addClass('error');
            }
            else {
                this.$jump.removeClass('error');
                eventHandler.call(this, event);
            }
        },

        doPagination: function () {
            if (this.currentUrl) {
                this.remote();
            } else {
                this.renderPagination();
            }
        },
        remote: function () {
            if (typeof this.options.remote.pageParams === 'function') {
                var pageParams = this.options.remote.pageParams.call(this, { pageIndex: this.currentPageIndex, pageSize: this.currentPageSize });
                this.currentParams = $.extend({}, this.currentParams, pageParams);
            } else {
                this.currentParams[this.options.remote.pageIndexName] = this.currentPageIndex;
                this.currentParams[this.options.remote.pageSizeName] = this.currentPageSize;
            }
            pagination.remote.getAjax(this, this.currentUrl, this.currentParams, this.ajaxCallBack, this.options.remote.beforeSend, this.options.remote.complete);
        },

        ajaxCallBack: function (result) {
            result=eval("("+result+")");
            var total = utility.mapObjectNameRecursion(result, this.options.remote.totalName);
            if (total == null || total == undefined)
                throw new Error("the response of totalName :  '" + this.options.remote.totalName + "'  not found.");
            total = utility.convertInt(total);
            this.total = total;
            var lastPageNum = this.getLastPageNum();
            if (this.currentPageIndex > 0 && lastPageNum - 1 < this.currentPageIndex) {
                this.setPageIndex(lastPageNum - 1);
                this.remote();
            } else {
                if (typeof this.options.remote.success === 'function') this.options.remote.success(result);
                this.renderPagination();
            }
        },

        onEvent: function (eventName, pageIndex, pageSize) {
            if (pageIndex != null) this.currentPageIndex = utility.convertInt(pageIndex);
            if (pageSize != null) this.currentPageSize = utility.convertInt(pageSize);
            this.doPagination();
            this.$element.trigger(eventName, {
                pageIndex: this.currentPageIndex, pageSize: this.currentPageSize
            });
            this.debug('pagination ' + eventName);
        },
        //生成分页
        renderPagination: function () {
            var option = {
                showFirstLastBtn: this.options.showFirstLastBtn,
                firstBtnText: this.options.firstBtnText,
                prevBtnText: this.options.prevBtnText,
                nextBtnText: this.options.nextBtnText,
                lastBtnText: this.options.lastBtnText
            }
            var lastPageNum = this.getLastPageNum();
            this.currentPageIndex = lastPageNum > 0 && this.currentPageIndex > lastPageNum - 1 ? lastPageNum - 1 : this.currentPageIndex;
            this.$page.empty().append(pagination.core.renderPages(this.currentPageIndex, this.currentPageSize, this.total, this.options.pageBtnCount, option)).show();
            if (this.options.showPageSizes && lastPageNum !== 0) this.$size.show(); else this.$size.hide();
            if (this.options.showJump && lastPageNum !== 0) this.$jump.show(); else this.$jump.hide();
            this.$info.text(pagination.core.renderInfo(this.currentPageIndex, this.currentPageSize, this.total, this.options.infoFormat, this.options.noInfoText));
            if (this.options.showInfo) this.$info.show(); else this.$info.hide();
        },
        //销毁分页
        destroy: function () {
            this.$element.unbind().data("pagination", null).empty();
            this.debug('pagination destroyed');
        },
        debug: function (message, data) {
            if (this.options.debug && console) {
                message && console.info(message + ' : pageIndex = ' + this.currentPageIndex + ' , pageSize = ' + this.currentPageSize + ' , total = ' + this.total);
                data && console.info(data);
            }
        }
    }

    var eventHandler = function (event) {
        var that = event.data.page;
        var $target = $(event.target);

        if (event.type === 'click' && $target.data('pageIndex') !== undefined && !$target.parent().hasClass('active')) {
            that.onEvent(pagination.event.pageClicked, $target.data("pageIndex"), null);
        }
        else if ((event.type === 'click' || event.type === 'keypress') && $target.data('pageBtn') === 'jump') {
            var pageIndexStr = that.$jump.find('input').val();
            if (utility.convertInt(pageIndexStr) <= that.getLastPageNum()) {
                that.onEvent(pagination.event.jumpClicked, pageIndexStr - 1, null);
                that.$jump.find('input').val(pageIndexStr);
            }
        }
        else if (event.type === 'change' && $target.data('pageBtn') === 'size') {
            var newPageSize = that.$size.find('select').val();
            var lastPageNum = pagination.core.calLastPageNum(that.total, newPageSize);
            if (lastPageNum > 0 && that.currentPageIndex > lastPageNum - 1) {
                that.currentPageIndex = lastPageNum - 1;
            }
            that.onEvent(pagination.event.pageSizeChanged, that.currentPageIndex, newPageSize);
        }
    };

    var pagination = {};
    pagination.event = {
        pageClicked: 'pageClicked',
        jumpClicked: 'jumpClicked',
        pageSizeChanged: 'pageSizeChanged'
    };
    pagination.remote = {
        getAjax: function (pagination, url, data, success, beforeSend, complate) {
            $.ajax({
                url: url,
			    type: "POST",
                dataType: 'json',
                data: data,
                cache: false,
                beforeSend: function (XMLHttpRequest) {
                    if (typeof beforeSend === 'function') beforeSend.call(this, XMLHttpRequest);
                },
                complete: function (XMLHttpRequest, textStatue) {
                    if (typeof complate === 'function') complate.call(this, XMLHttpRequest, textStatue);
                },
                success: function (result) {
                    success.call(pagination, result);
                }
            })
        }
    };
    pagination.core = {
        /*
        options : {
            showFirstLastBtn
            firstBtnText:
        }
        */
        renderPages: function (pageIndex, pageSize, total, pageBtnCount, options) {
            options = options || {};
            var pageNumber = pageIndex + 1;
            var lastPageNumber = this.calLastPageNum(total, pageSize);
            var html = [];

            if (lastPageNumber <= pageBtnCount) {
                html = this.renderGroupPages(1, lastPageNumber, pageNumber);
            }
            else {
                var firstPage = this.renderPerPage(options.firstBtnText || 1, 0);
                var lastPage = this.renderPerPage(options.lastBtnText || lastPageNumber, lastPageNumber - 1);


                //button count of  both sides
                var symmetryBtnCount = (pageBtnCount - 1 - 4) / 2;
                if (!options.showFirstLastBtn)
                    symmetryBtnCount = symmetryBtnCount + 1;
                var frontBtnNum = (pageBtnCount + 1) / 2;
                var behindBtnNum = lastPageNumber - ((pageBtnCount + 1) / 2);

                var prevPage = this.renderPerPage(options.prevBtnText, pageIndex - 1);
                var nextPage = this.renderPerPage(options.nextBtnText, pageIndex + 1);

                symmetryBtnCount = symmetryBtnCount.toString().indexOf('.') == -1 ? symmetryBtnCount : symmetryBtnCount + 0.5;
                frontBtnNum = frontBtnNum.toString().indexOf('.') == -1 ? frontBtnNum : frontBtnNum + 0.5;
                behindBtnNum = behindBtnNum.toString().indexOf('.') == -1 ? behindBtnNum : behindBtnNum + 0.5;
                if (pageNumber < frontBtnNum) {
                    if (options.showFirstLastBtn) {
                        html = this.renderGroupPages(1, pageBtnCount - 2, pageNumber);
                        html.push(nextPage);
                        html.push(lastPage);
                    } else {
                        html = this.renderGroupPages(1, pageBtnCount - 1, pageNumber);
                        html.push(nextPage);
                    }
                }
                else if (pageNumber > behindBtnNum) {
                    if (options.showFirstLastBtn) {
                        html = this.renderGroupPages(lastPageNumber - pageBtnCount + 3, pageBtnCount - 2, pageNumber);
                        html.unshift(prevPage);
                        html.unshift(firstPage);
                    } else {
                        html = this.renderGroupPages(lastPageNumber - pageBtnCount + 2, pageBtnCount - 1, pageNumber);
                        html.unshift(prevPage);
                    }
                }
                else {
                    if (options.showFirstLastBtn) {
                        html = this.renderGroupPages(pageNumber - symmetryBtnCount, pageBtnCount - 4, pageNumber);
                        html.unshift(prevPage);
                        html.push(nextPage);
                        html.unshift(firstPage);
                        html.push(lastPage);
                    } else {
                        html = this.renderGroupPages(pageNumber - symmetryBtnCount, pageBtnCount - 2, pageNumber);
                        html.unshift(prevPage);
                        html.push(nextPage);
                    }
                }
            }
            return html;
        },
        renderGroupPages: function (beginPageNum, count, currentPage) {
            var html = [];
            for (var i = 0; i < count; i++) {
                var page = this.renderPerPage(beginPageNum, beginPageNum - 1);
                if (beginPageNum === currentPage)
                    page.addClass("active");
                html.push(page);
                beginPageNum++;
            }
            return html;
        },
        renderPerPage: function (text, value) {
            return $("<li><a data-page-index='" + value + "'>" + text + "</a></li>");
        },
        renderInfo: function (currentPageIndex, currentPageSize, total, infoFormat, noInfoText) {
            if (total <= 0) {
                return noInfoText;
            } else {
                var startNum = (currentPageIndex * currentPageSize) + 1;
                var endNum = (currentPageIndex + 1) * currentPageSize;
                endNum = endNum >= total ? total : endNum;
                return infoFormat.replace('{start}', startNum).replace('{end}', endNum).replace('{total}', total);
            }
        },
        //计算最大分页数
        calLastPageNum: function (total, pageSize) {
            total = utility.convertInt(total);
            pageSize = utility.convertInt(pageSize);
            var i = total / pageSize;
            return utility.isDecimal(i) ? parseInt(i) + 1 : i;
        }
    };
    pagination.check = {
        //校验跳转页数有效性
        checkJumpPage: function (pageIndex) {
            var reg = /^\+?[1-9][0-9]*$/;
            return reg.test(pageIndex);
        }
    };

    var utility = {
        //转换为int
        convertInt: function (i) {
            if (typeof i === 'number') {
                return i;
            } else {
                var j = parseInt(i);
                if (!isNaN(j)) {
                    return j;
                } else {
                    throw new Error("convertInt Type Error.  Type is " + typeof i + ', value = ' + i);
                }
            }
        },
        //返回是否小数
        isDecimal: function (i) {
            return parseInt(i) !== i;
        },
        //匹配对象名称（递归）
        mapObjectNameRecursion: function (object, name) {
            var obj = object;
            var arr = name.split('.');
            for (var i = 0; i < arr.length; i++) {
                obj = utility.mapObjectName(obj, arr[i]);
            }
            return obj;
        },
        //匹配对象名称
        mapObjectName: function (object, name) {
            var value = null;
            for (var i in object) {
                //过滤原型属性
                if (object.hasOwnProperty(i)) {
                    if (i == name) {
                        value = object[i];
                        break;
                    }
                }
            }
            return value;
        },
        deserializeParams: function (params) {
            var newParams = {};
            if (typeof params === 'string') {
                var arr = params.split('&');
                for (var i = 0; i < arr.length; i++) {
                    var a = arr[i].split('=');
                    newParams[a[0]] = decodeURIComponent(a[1]);
                }
            }
            else if (params instanceof Array) {
                for (var i = 0; i < params.length; i++) {
                    newParams[params[i].name] = decodeURIComponent(params[i].value);
                }
            }
            else if (typeof params === 'object') {
                newParams = params;
            }
            return newParams;
        }
    }

    $.fn.pagination = function (option) {
        if (typeof option === 'undefined') {
            return $(this).data('pagination') || false;
        } else {
            var result;
            var args = arguments;
            this.each(function () {
                var $this = $(this);
                var data = $this.data('pagination');
                if (!data && typeof option === 'string') {
                    throw new Error('MricodePagination is uninitialized.');
                }
                else if (data && typeof option === 'object') {
                    throw new Error('MricodePagination is initialized.');
                }
                    //初始化
                else if (!data && typeof option === 'object') {
                    var options = typeof option == 'object' && option;
                    var data_api_options = $this.data();
                    options = $.extend(options, data_api_options);
                    $this.data('pagination', (data = new Page(this, options)));
                }
                else if (data && typeof option === 'string') {
                    result = data[option].apply(data, Array.prototype.slice.call(args, 1));
                }
            });
            return typeof result === 'undefined' ? this : result;
        }
    }
});
