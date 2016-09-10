0</* ::
@echo off
rem Polyglot from https://gist.github.com/yaauie/959862
set "arg1=%~1"
if "%arg1:~0,1%"=="-" call KspProfiles %1 &exit/b
title Kerbal Data Command Line Interface
where jjs >nul 2>&1 && jjs -scripting "%~f0" -- %* || echo Please install the Java Runtime Environment
exit/b
*/0;
var BufferedWriter=Java.type('java.io.BufferedWriter');
var FileWriter=Java.type('java.io.FileWriter');
var System=Java.type('java.lang.System');
var alphaNum='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890';
var fieldDelim=' = ';
function initDataObject(){
	var dataObject=new Object();
	dataObject.fields=new Array();
	dataObject.nodes=new Array();
	return dataObject;
}
function loadDataFile(file){
	var node=initDataObject();
	var line='',nodeStack=new Array();
	System.gc();
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
function list(node,args){
	listFields(node);
	listNodes(node);
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
function setFieldValue(node,args){
	var i=(args.splice(0,1))[0];
	node.fields[i]=getFieldName(node,i)+fieldDelim+args.join(' ');
}
function saveFile(args){
	var now=new Date().toISOString();
	var s=dataFile,i=s.lastIndexOf('.'),type='backup';
	if(args.length>0)if(args[0].indexOf('clip')>-1)type='clipboard';
	var backupFileName=s.substring(0,i)+'-'+type+now.substring(0,10).replace(/-/g,'')+now.substring(11,19).replace(/:/g,'')+s.substring(i);
	if(type=='backup')$EXEC("cmd /c \"ren ${dataFile} ${backupFileName}\"");
	print("Saving...");
	if(type=='clipboard')s=backupFileName;
	var bw=new BufferedWriter(new FileWriter(s));
	var sNode=obj,numTabs=0;
	if(type=='clipboard')sNode=clipboardData;
	saveNode(sNode);
	bw.close();
	print("Done!");
	function getIndent(){return Array(numTabs+1).join('\t')}
	function printToFile(s){
		bw.write(s+'\r\n');
		bw.flush();
	}
	function saveNode(n){
		if(typeof n.label=='undefined'||n.label=='undefined'){
			saveNode(n.nodes[0]);
			return;
		}
		printToFile("${getIndent()}${n.label}");
		printToFile("${getIndent()}{");
		numTabs++;
		for(var x in n.fields){printToFile("${getIndent()}${n.fields[x]}")}
		for(var x in n.nodes){saveNode(n.nodes[x])}
		numTabs--;
		printToFile("${getIndent()}}");
	}
}
function reload(msgs){
	if(msgs==undefined||typeof msgs=='undefined') msgs=true
	if(msgs)print("Reloading data from file...");
	obj=undefined;
	obj=loadDataFile(dataFile);
	cnp=new Array();
	if(msgs)print("Reload complete.");
}
function clipboard(operation,args){
	function copy(start,count){eval("for(var x=${start};x<${start+count};x++)clipboardData.${trueType}s.push(node.${trueType}s[x])");}
	function paste(start,count){eval("for(var x=${start};x<${start+count};x++)node.${trueType}s[${to}]=clipboardData.${trueType}s[x]");}
	function listOptions(options){return "should be one of: '${options.split(';').join(', ')}'."}
	var availOps='copy;paste',errorType='',availTypes='f;field;n;node',trueType='node',endTypeOptions='c;e;i',c=1;
	if(availOps.indexOf(operation)==-1){
		print("Error: Unkown operation '${operation}' given, ${listOptions(availOps)}");
		return;
	}
	if(args.length<2)errorType='few';
	if(args.length>operation.length)errorType='many';
	if(errorType.length>0){
		print("Error: Too ${errorType} arguments, should be 2-${operation.length} for '${operation}'.");
		return;
	}
	if(type.indexOf('f')==type.indexOf('n')){
		print("Error: Unable to parse '${type}', ${listOptions(availTypes)}");
		return;
	}
	var type=args[0],to=args[1];
	var la=args.length,lo=operation.length,dOp=lo-4,i=args[1+dOp],j=la<3+dOp?1:args[2+dOp],k=la==lo?'c':args[3+dOp];
	if(endTypeOptions.indexOf(k)==-1){
		print("Error: Unkown argument '${k}' given, ${listOptions(endTypeOptions)}");
		return;
	}
	if(type.indexOf('f')>-1)trueType='field';
	c=j-(k=='c'?0:i)+(k=='i'?1:0);
	eval("${operation}(i,c)");
}
function unknownCmd(cmd){
	print("Unkown command:${cmd};");
}
var obj,cnp /* current node path */,clipboardData=initDataObject(),dataFile=$ARG[0];
print("Loading data...");
reload(false);
print("For a list of commands, type 'help'");
var node=obj;
var cmds=['exit','help','select','list','set','save','reload','copy','paste','eval'];
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
			var s='';
			if(args[0]!==undefined||typeof args[0]!=='undefined')s=args[0];
			if(s.indexOf('clip')>-1){
				print('Clipboard data:');
				list(clipboardData,args.splice(0,1));
			}
			else list(node,args);
			break;
		case 4: //set
			setFieldValue(node,args);
			break;
		case 5: //save
			saveFile(args);
			break;
		case 6: //reload
			if((args[0]!==undefined||typeof args[0]!=='undefined')&&(args[0].indexOf('clip')>-1))clipboardData=loadDataFile(args[0]);
			else reload();
			break;
		case 7: //copy
			clipboard('copy',args);
			break;
		case 8: //paste
			clipboard('paste',args);
			break;
		case 9: //eval
			eval(args.join(' '));
			break;
		default: //unknown
			unknownCmd(cmd);
	}
}
