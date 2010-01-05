function cloneJson(jsonObj){
  var buf;  
  if (jsonObj instanceof Array) {  
    buf = [];  
    var i = jsonObj.length;  
    while (i--) {  
        buf[i] = cloneJson(jsonObj[i]); 
    }  
    return buf;  
  }else if (jsonObj instanceof Object){ 
    buf = {};  
    for (var k in jsonObj) {  
        buf[k] = cloneJson(jsonObj[k]); 
    }
    return buf;  
  }else{  
    return jsonObj;  
  }
}

var Make = {
  use_json : {},
  left_json : {},
  materials : {},
  max_amount : 50,
  now_amount : 0,
  left_header : '<thead><tr><th>名称</th><th>种类</th><th>等级</th><th>剩余</th><th>用量</th></tr></thead><tbody>',
  use_header : '<thead><tr><th>名称</th><th>种类</th><th>等级</th><th>用量</th></tr></thead><tbody>',
  init : function(items){
    this.materials = items;
    this.left_json = items;
    this.table_materials = $('#table_materials');
    this.table_use = $('#table_use');
    this.form_makes = $('#form_makes').get(0);
  },
  render : function(){
    this.render_left_list();
    if(this.now_amount > 0)
      this.render_use_list();
    if(this.now_amount >= 2 && this.now_amount <= 50)
      this.show_submit();
  },
  show_submit : function(){$('#start_makes').show()},
  render_use_list : function(){
    var tmp_html = this.use_header;
    var use_html = "";
    $.each(this.use_json,function(i,v){
      use_html += '<tr><td>' + v['name'] + '</td><td>' + v['class'] + '</td><td>' + v['level'] + '</td><td>' + v['amount'] + '</td></tr>';
    });
    if(use_html != ""){
      this.table_use.html(tmp_html + use_html + '</tbody>');
    }
  },
  render_left_list : function(){
    var tmp_html = this.left_header;
    $.each(this.left_json,function(k,v){
      tmp_html += '<tr><td>' + v['name'] + '</td><td>' + v['class'] + '</td><td>' + v['level'] + '</td><td>' + v['amount'] + '</td>';
      tmp_html += '<td><input type="text" id="item' + k + '_use" class="use_amount" name="' + k +'" /></td></tr>';
    });
    tmp_html += '</tbody>';
    this.table_materials.html(tmp_html);
  },
  select_material : function(player_item_id,amount){
    var left_amount = this.left_json[player_item_id]["amount"];
    if( left_amount >= amount && this.max_amount >= this.now_amount + amount){
      var use_player_item = this.use_json[player_item_id];
      if(undefined == use_player_item){
        use_player_item = this.use_json[player_item_id] = cloneJson(this.materials[player_item_id]);
        use_player_item["amount"] = 0;
      }
      use_player_item["amount"] += amount;
      this.left_json[player_item_id]["amount"] -= amount;
      this.now_amount += amount;
    }
  },
  select_materials : function(){
    var use_amounts = $('.use_amount');
    $.each(use_amounts,
      function(index,use_amount){
        var use = parseInt(use_amount.value);
        if(!isNaN(use)){
          Make.select_material(use_amount.name,use);
        }
      }
    )
    this.render();
  },
  submit : function(){
    this.build_form();
    this.form_makes.submit();
    $('#start_makes').disable();
  },
  build_hidden : function(id,name,value){
    var m = document.createElement('input');
    m.setAttribute('type', 'hidden');
    m.setAttribute('name', name);
    m.setAttribute('value', value);
    this.form_makes.appendChild(m);
  },
  build_form : function(){
    $.each(
        this.use_json,
        function(k,v){
          Make.build_hidden(k,'player_item_ids[]',k);
          Make.build_hidden(k,'amounts[]',v.amount);
        }
    )
  }
}

var Pet = {
  init : function(player_pets_json){
    this.player_pets = player_pets_json;
    this.render();
    if(this.total(this.player_pets) < 2){
      $("#player_pet_mix").hide();
      $("#player_pet_adopt").show();
    }
    else{
      $("#player_pet_mix").show();
      $("#player_pet_adopt").hide();
    }
  },
  change : function(player_pet_json){
    $.each(player_pet_json,
      function(k,v){
        Pet.player_pets[k] = v;
      }
    )
  },
  render : function(){
    var html = '';
    $.each(this.player_pets,function(k,v){
      html += render("player_pet",{player_pet:v})
    });
    $("#player_pets").html(html);
  },
  rerender_status: function(id){
    $("#player_pet_" + id +"_food").html(this.player_pets[id].food.toString() + "/" + this.player_pets[id].hp.toString());
    $("#player_pet_" + id +"_happy").html(this.player_pets[id].happy.toString() + "/" + this.player_pets[id].hp.toString());
  },
  mix : function(){
    var pets=[];
    $(".pets_selects:checked").each(function(){
      pets.push($(this).val())
    });
    if(pets.length<2)
    {
      alert("只有选择两个以上宠物才能融合");
      return
    }
    var datas = token;
    for(var i=0;i<pets.length;i++)
    {
      datas+="&ids[]="+encodeURIComponent(pets[i]);
    }
    $.ajax({data:datas, dataType:'script', type:'post', url:'/player_pets/mix'}); return false;
  },
  total : function(json){
  var prop;
  var propCount = 0;
  
  for (prop in json) {
      propCount++;
    }
  return propCount;
  }
}
;


(function($){$.jGrowl=function(m,o){if($("#jGrowl").size()==0){$("<div id=\"jGrowl\"></div>").addClass($.jGrowl.defaults.position).appendTo("body");}
 $("#jGrowl").jGrowl(m,o);};$.fn.jGrowl=function(m,o){if($.isFunction(this.each)){var _6=arguments;return this.each(function(){var _7=this;if($(this).data("jGrowl.instance")==undefined){$(this).data("jGrowl.instance",new $.fn.jGrowl());$(this).data("jGrowl.instance").startup(this);}
   if($.isFunction($(this).data("jGrowl.instance")[m])){$(this).data("jGrowl.instance")[m].apply($(this).data("jGrowl.instance"),$.makeArray(_6).slice(1));}else{$(this).data("jGrowl.instance").create(m,o);}});}};$.extend($.fn.jGrowl.prototype,{defaults:{pool:0,header:"",group:"",sticky:false,position:"top-right",glue:"after",theme:"default",corners:"10px",check:250,life:3000,speed:"normal",easing:"swing",closer:true,closeTemplate:"&times;",closerTemplate:"<div>[ close all ]</div>",log:function(e,m,o){},beforeOpen:function(e,m,o){},open:function(e,m,o){},beforeClose:function(e,m,o){},close:function(e,m,o){},animateOpen:{opacity:"show"},animateClose:{opacity:"hide"}},notifications:[],element:null,interval:null,create:function(_17,o){var o=$.extend({},this.defaults,o);this.notifications[this.notifications.length]={message:_17,options:o};o.log.apply(this.element,[this.element,_17,o]);},render:function(_19){var _1a=this;var _1b=_19.message;var o=_19.options;var _19=$("<div class=\"jGrowl-notification"+((o.group!=undefined&&o.group!="")?" "+o.group:"")+"\"><div class=\"close\">"+o.closeTemplate+"</div><div class=\"notification-header\">"+o.header+"</div><div class=\"notification-message\">"+_1b+"</div></div>").data("jGrowl",o).addClass(o.theme).children("div.close").bind("click.jGrowl",function(){$(this).parent().trigger("jGrowl.close");}).parent();(o.glue=="after")?$("div.jGrowl-notification:last",this.element).after(_19):$("div.jGrowl-notification:first",this.element).before(_19);$(_19).bind("mouseover.jGrowl",function(){$(this).data("jGrowl").pause=true;}).bind("mouseout.jGrowl",function(){$(this).data("jGrowl").pause=false;}).bind("jGrowl.beforeOpen",function(){o.beforeOpen.apply(_1a.element,[_1a.element,_1b,o]);}).bind("jGrowl.open",function(){o.open.apply(_1a.element,[_1a.element,_1b,o]);}).bind("jGrowl.beforeClose",function(){o.beforeClose.apply(_1a.element,[_1a.element,_1b,o]);}).bind("jGrowl.close",function(){$(this).trigger("jGrowl.beforeClose").animate(o.animateClose,o.speed,o.easing,function(){$(this).remove();o.close.apply(_1a.element,[_1a.element,_1b,o]);});}).trigger("jGrowl.beforeOpen").animate(o.animateOpen,o.speed,o.easing,function(){$(this).data("jGrowl").created=new Date();}).trigger("jGrowl.open");if($.fn.corner!=undefined){$(_19).corner(o.corners);}
   if($("div.jGrowl-notification:parent",this.element).size()>1&&$("div.jGrowl-closer",this.element).size()==0&&this.defaults.closer!=false){$(this.defaults.closerTemplate).addClass("jGrowl-closer").addClass(this.defaults.theme).appendTo(this.element).animate(this.defaults.animateOpen,this.defaults.speed,this.defaults.easing).bind("click.jGrowl",function(){$(this).siblings().children("div.close").trigger("click.jGrowl");if($.isFunction(_1a.defaults.closer)){_1a.defaults.closer.apply($(this).parent()[0],[$(this).parent()[0]]);}});}},update:function(){$(this.element).find("div.jGrowl-notification:parent").each(function(){if($(this).data("jGrowl")!=undefined&&$(this).data("jGrowl").created!=undefined&&($(this).data("jGrowl").created.getTime()+$(this).data("jGrowl").life)<(new Date()).getTime()&&$(this).data("jGrowl").sticky!=true&&($(this).data("jGrowl").pause==undefined||$(this).data("jGrowl").pause!=true)){$(this).trigger("jGrowl.close");}});if(this.notifications.length>0&&(this.defaults.pool==0||$(this.element).find("div.jGrowl-notification:parent").size()<this.defaults.pool)){this.render(this.notifications.shift());}
   if($(this.element).find("div.jGrowl-notification:parent").size()<2){$(this.element).find("div.jGrowl-closer").animate(this.defaults.animateClose,this.defaults.speed,this.defaults.easing,function(){$(this).remove();});}},startup:function(e){this.element=$(e).addClass("jGrowl").append("<div class=\"jGrowl-notification\"></div>");this.interval=setInterval(function(){jQuery(e).data("jGrowl.instance").update();},this.defaults.check);if($.browser.msie&&parseInt($.browser.version)<7&&!window["XMLHttpRequest"]){$(this.element).addClass("ie6");}},shutdown:function(){$(this.element).removeClass("jGrowl").find("div.jGrowl-notification").remove();clearInterval(this.interval);}});$.jGrowl.defaults=$.fn.jGrowl.prototype.defaults;})(jQuery);

$.fn.ajaxRequest=function(){$(this).unbind('click').click(function(){if($(this).attr('confirm_message')?confirm($(this).attr('confirm_message')):(($(this).attr('ajaxmethod')=='GET' || $(this).attr('ajaxmethod')== 'POST' || undefined== $(this).attr('ajaxmethod')) ?true:confirm('are your sure'))){$.ajax({url:$(this).attr('href'),type:$(this).attr('ajaxmethod')||"GET",dataType:'script'});}
    return false;});};

function ajaxComplete(){$('#content a.ajaxlink').ajaxRequest();return false}

jQuery.ajaxSetup({
      beforeSend:function(xhr){
        xhr.setRequestHeader("Accept","text/javascript");},
      complete:function(e){
        ajaxComplete();}
});

$(document).ready(function(){
    $.notice=$.jGrowl;
    $('a.ajaxlink').ajaxRequest();
    }
);

