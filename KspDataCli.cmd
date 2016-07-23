0</* ::
@echo off
rem Polyglot from https://gist.github.com/yaauie/959862
title Kerbal Data Command Line Interface
echo Starting Kerbal Data Command Line Interface ...
jjs -scripting "%~f0" -- %*
exit/b
*/0;
var alphaNum='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890';
var fieldDelim=' = ';
function loadDataFile(file){
	var node=new Object();
	node.fields=new Array();
	node.nodes=new Array();
	var line='',nodeStack=new Array();
	var lines=readFully(file).replace(/\t+/g,'').replace(/\r\n{/g,'').split('\r\n');
	for(var l in lines){
		line=lines[l];
		if(line.isEmpty())continue;
		if(line.contains('='))node.fields.push(line);
		else if(line=='}'){
			var prev=nodeStack.pop();
			prev.nodes.push(node);
			node=prev;
		}else{
			nodeStack.push(node);
			node=new Object();
			node.label=line;
			node.fields=new Array();
			node.nodes=new Array();
		}
	}
	return node;
}
function getIndex(node,args){
	for(var n in node.nodes)if(node.nodes[n].fields.contains(args.join(' ')))return n;
}
function select(rootObj,args){
	if(args.length==0)print(cnp.join('.'));
	else{
		var path=args[0];
		if(path=="..")cnp.pop();
		else if(path!=="."){
			var nodes=path.split('.');
			for(var n in nodes)cnp.push(nodes[n]);
		}
	}
	var n=rootObj;
	var pathArray=cnp;
	for(var x in pathArray){
		var id=pathArray[x];
		if(id<0)id=n.nodes.length+id;
		if(n.nodes.length>id)n=n.nodes[id];
	}
	return n;
}
function list(obj,args){
	listFields(obj);
	listNodes(obj);
}
function listFields(node){
	print(" Fields:${node.fields.length}");
	for(var f in node.fields)print("  ${f}:${node.fields[f]}");
}
function listNodes(node){
	print(" Nodes:${node.nodes.length}");
	for(var x in node.nodes){
		var n=node.nodes[x];
		var display=n.label;
		var f=getFieldIndex(n,'name');
		if(f>-1)display=display+" (${n.fields[f].substring(7)})";
		print("  ${x}:${display}");
	}
}
function getFieldIndex(node,name){
	for(var f in node.fields)if(node.fields[f].indexOf(name)==0)return f;
	return -1;
}
function getFieldName(node,index){
	var f=node.fields[index];
	return f.substring(0,f.indexOf(fieldDelim));
}
function getFieldValue(node,index){
	var f=node.fields[index];
	return f.substring(f.indexOf(fieldDelim)+fieldDelim.length);
}
function setFieldValue(node,index,newValue){
	node.fields[index]=getFieldName+fieldDelim+newValue;
}
function saveFile(obj,args){}
function unknownCmd(cmd){
	print("Unkown command:${cmd};");
}
var obj=loadDataFile($ARG[0]),node=obj;
var cmds=['exit','help','select','list','set','save','eval'];
var cnp=new Array(); //current node path
while(cmd!=="exit"){
	var rawInput=readLine("${cnp.join('.')}>");
	var cmd='',args='';
	for(var x=0;x<rawInput.length;x++){
		if(!alphaNum.contains(rawInput[x])){
			cmd=rawInput.substring(0,x);
			args=rawInput.substring(x).split(' ');
			break;
		}
	}
	if(args.length>0&&args[0]=='')args.splice(0,1);
	if(cmd=='')cmd=rawInput;
	switch(cmds.indexOf(cmd)){
		case 0: //exit
			break;
		case 1: //help
			for(var c in cmds)print(cmds[c]);
			break;
		case 2: //select
			node=select(obj,args);
			break;
		case 3: //list
			list(node,args);
			break;
		case 4: //set
			setFieldValue(node,args[0],args[1]);
			break;
		case 5: //save
			save(obj,args);
			break;
		case 6: //eval
			eval(args.join(' '));
			break;
		default: //unknown
			unknownCmd(cmd);
	}
}
