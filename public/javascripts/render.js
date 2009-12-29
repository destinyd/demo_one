// Simple JavaScript Templating
// John Resig - http://ejohn.org/ - MIT Licensed
// adapted from: http://ejohn.org/blog/javascript-micro-templating/
// modified by Zhang Jinzhu (wosmvp@gmail.com)
var _js_template_cache = [];

function render(name,data,fun) {
  if(data instanceof Function){ fun = data ; data = false };

  template = document.getElementById(name).value;

  if(_js_template_cache[name]){
    fn = _js_template_cache[name];
  }else{
    fn = new Function("obj",
        "var p=[],print=function(){p.push.apply(p,arguments);};" +

        // Introduce the data as local variables using with(){}
        "with(obj){p.push(\"" +

        // Convert the template into pure JavaScript
        template
        .replace(/[\r\t\n]/g, " ")
        .replace(/\"/g, '\\"')
        .split("{{").join("\t")
        .replace(/((^|}})[^\t]*)/g, "$1\r")
        .replace(/\t=(.*?)(;+\s*)?}}/g, "\",function(){ try { return $1 }catch(err){ return '$1 undefined'} }.apply(this),\"")
        .split("\t").join("\");")
        .split("}}").join(";p.push(\"")
        .split("\r").join("")
        + "\");};return p.join('');");
    _js_template_cache[name] = fn;
  };


  result = fn.call(this,data || '');
  return (fun instanceof Function) ? fun.call(this,result) : result ;
};
