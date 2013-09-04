package ronco.ui.chat
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mx.utils.StringUtil;
	
	
	/**
	 *  @author:Gaara
	 *  2012-10-10
	 *  富文本转换工具
	 **/
	public class RichTextAreaUtil
	{
		/** 图片标签 **/
		private static const IMG:String = "img";
		
		/** 文本标签 **/
		private static const FONT:String = "font";
		
		/** 连接标签 **/
		private static const A:String = "a";
		
		/** 表情数组 **/
		public static var faceVec:Vector.<FaceLoader> = new Vector.<FaceLoader>;
		
		public static var onLink:Function;
		
		/**
		 *  功能:html转换成xml
		 *  参数:
		 **/
		private static function htmlToXml(content:String,txtColor:String,size:int):XML
		{
			
			var fontTxt:String = "<font color='{0}' size='{1}'>{2}</font>"
			var splitArr:Array = content.split(/(<.*?\/.*?>$)/);
			var xml:XML = <body/>;
			for each (var str:String  in splitArr) 
			{
				if(str == ""){
					continue;
				}
				
				if(str.indexOf("<") != -1){
					xml.appendChild(new XML(str));
				}
				else {
					xml.appendChild(new XML(StringUtil.substitute(fontTxt,txtColor,size,str)));
				}
			}
			
			return xml;
		}
		
		/**
		 * 分解字符串
		 * */
		public static function mySplit(str:String):Array
		{
			var arr:Array = new Array;
			
			var counter1:int = 0;
			var counter2:int = 0;
			var curIndex:int = 0;
			var temp:String = new String;
			
			for(var i:int = 0; i < str.length; ++i)
			{
				
				var c:String = str.charAt(i);
				if(c == "<")
				{
					
					
					if(temp.length && counter1 == 0 && counter2 == 0)
					{
						arr[curIndex] = temp;
						temp = new String;
						curIndex++;
					}
					temp += c;
					
					if(i+1 < str.length)
					{
						if(str.charAt(i+1) == "/")
							counter2--;
						else
							counter2++;
					}
					
					counter1++;
				}else if(c == ">")
				{
					counter1--;
					temp += c;
					
					if(counter1 == 0 && counter2 == 0)
					{
						arr[curIndex] = temp;
						temp = new String;
						curIndex++;
					}
				}
				else
				{
					temp += c;
				}
				
			}
			if(temp.length)
				arr[curIndex] = temp;
			
			var ret:Array = new Array;
			
			for(i = 0; i < arr.length; ++i)
			{				
				if(arr[i].length)
				{
					if(str.charAt(0) == "<")
						ret[i] = new XML(arr[i]);
					else
						ret[i] = new XML("<font>" + arr[i] + "</font>");
				}
			}
			
			return ret;
		}
		
		/**
		 *  功能:把一串HTML变成一个个的HTML
		 *  参数:
		 **/
		public static function htmlToArray(conten:String,color:String="#ffffff",size:int=12):Array
		{
			var xml:XML = htmlToXml(conten,color,size);
			var newXml:XML;
			var itemStr:String;
			var arr:Array = [];
			var attr:XMLList;
			for each(var item:XML in xml.children()){
				itemStr = item.text();
				if(item.name() == "font"){
					for(var i:int = 0;i < itemStr.length;i++){
						newXml = new XML(item);
						newXml.setChildren(itemStr.charAt(i));
						newXml.@bold = "true";
						arr.push(newXml.toXMLString());
					}
				}
				else if(item.name() == "img"){
					arr.push(item.toXMLString());
				}
			}
			return arr;
		}
		
		public static  function getContentArr2(toXml:XML,txtColor:String="#d8e5c6",size:int=12,hasa:String = ""):Vector.<ContentElement>
		{
			var groupVector:Vector.<ContentElement> = new Vector.<ContentElement>();
			
			var tagName:String;
			
			for each (var xml:XML in toXml.children()) 
			{				
				tagName = xml.name();	
				var temp:String = "";
				var tempColor:String = "";
				if(tagName == "a")
					temp = xml.@href;
				else if(tagName == FONT)
				{
					if(xml.attribute("color").length() > 0)
					{
						tempColor = xml.@color ;
					}
				}
				if(temp.length == 0 && hasa.length)
					temp = hasa;
				
				if(tempColor.length == 0)
					tempColor = txtColor;
				
				if(xml.children().length())
				{
					var lst:Vector.<ContentElement> = getContentArr2(xml,tempColor,size,temp);
					for(var i:int = 0; i < lst.length; ++i)
						groupVector.push(lst[i]); 
					
				}else
				{
					if(tagName == null)
					{
						var txml:XML = new XML(toXml);
						var num:int = txml.children().length();
						for(var j:int = 0; j < num;j++)
						{
							delete  txml.children()[0];
						}
						txml.appendChild(xml);
						xml = txml;
						
					}
					var ce:ContentElement = contentTextLine(xml,tempColor,size,temp);
					if(ce != null)
						groupVector.push(ce);
				}				
				
			}		
			return groupVector;
		}
		
		/**
		 *  功能:光标
		 *  参数:
		 **/
		private static function onMouseOverHandler(event:Event):void
		{
			if(!(event.target is TextLine) || (event.target as TextLine).mirrorRegions.length == 0){
				return;
			}
			
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		/**
		 *  功能:光标
		 *  参数:
		 **/
		private static function onMouseOutHandler(event:Event):void
		{
			if(!(event.target is TextLine) || (event.target as TextLine).mirrorRegions.length == 0){
				return;
			}
			
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		private static function onClk(event:Event):void
		{
			for(var i:int = 0; i < event.currentTarget.mirrorRegions.length; ++i)
			{
				var r:Rectangle = event.currentTarget.mirrorRegions[i].bounds;
				if(event.currentTarget.mouseX > r.left && event.currentTarget.mouseX < r.right
				&& event.currentTarget.mouseY > r.top && event.currentTarget.mouseY < r.bottom)
				{
					var str:String = event.currentTarget.mirrorRegions[i].element.userData;
					//var arr:Array = str.split(":");
					str = str.substr(str.indexOf(":")+1);
					var textEvent:TextEvent = new TextEvent(str);		
					textEvent.text = str;
					
					if(onLink != null)
						onLink(textEvent);
					break;
				}
				
			}
			
		}
		
		public static function contentTextLine(xml:XML,txtColor:String="#d8e5c6",size:int=12,hasa:String = ""):ContentElement
		{			
			
			var tagName:String = xml.name();			
			
			if(tagName == IMG){
				//表情
				var iconSprite:FaceLoader = new FaceLoader(32,32);
				iconSprite.load(xml.@src);
				faceVec.push(iconSprite);
				var format:ElementFormat = new ElementFormat();
				format.dominantBaseline = TextBaseline.ASCENT;
				var face:GraphicElement = new GraphicElement(iconSprite,32,20,format);				
				return face;
			}
			else if(tagName == FONT){
				//文本
				var color:int;
				var bold:Boolean;
				if(xml.attribute("color").length() > 0){
					color =  HtmlUtil.colorStrToInt(xml.@color)
				}
				else {
					color =  HtmlUtil.colorStrToInt(txtColor);
				}
				
				if(xml.attribute("bold").length() > 0){
					bold =  Boolean(xml.@bold);
				}
				var fmt:ElementFormat = ChatTextAreaUtil.createFormat(color,size,bold);
				var contentTE2:TextElement = new TextElement(xml.toString(),fmt);

				if(hasa.length)
				{
					var href:String = hasa;			
					
					var eventDP:EventDispatcher = new EventDispatcher;
					eventDP.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler,false,0,true);
					eventDP.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler,false,0,true);
					eventDP.addEventListener(MouseEvent.CLICK,onClk,false,0,true);
					
					contentTE2.eventMirror = eventDP;
					contentTE2.userData = href;
				}
				return contentTE2;
			}
			else if(tagName == A){
				var href:String = xml.@href;			
				var color:int;
				var bold:Boolean;
				if(xml.attribute("color").length() > 0){
					color =  HtmlUtil.colorStrToInt(xml.@color)
				}
				else {
					color =  HtmlUtil.colorStrToInt(txtColor);
				}
				
				if(xml.attribute("bold").length() > 0){
					bold =  Boolean(xml.@bold);
				}
				var fmt:ElementFormat = ChatTextAreaUtil.createFormat(color,size,bold);
				var contentTE2:TextElement = new TextElement(xml.toString(),fmt);
				
				var eventDP:EventDispatcher = new EventDispatcher;
				eventDP.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler,false,0,true);
				eventDP.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler,false,0,true);
				eventDP.addEventListener(MouseEvent.CLICK,onClk,false,0,true);
				
				contentTE2.eventMirror = eventDP;
				contentTE2.userData = href;
				return contentTE2;
			}
			else if(tagName == "br"){
				
			}else
			{			
				color =  HtmlUtil.colorStrToInt(txtColor);
				var fmt:ElementFormat = ChatTextAreaUtil.createFormat(color,size,false);
				var contentTE2:TextElement = new TextElement(xml.toString(),fmt);
				return contentTE2;
			}
			return null;
		}
		
		/**
		 *  功能:返回内容
		 *  参数:
		 **/
		public static function getContentArr(content:String,txtColor:String="#d8e5c6",size:int=12):GroupElement
		{
			var groupVector:Vector.<ContentElement> = new Vector.<ContentElement>();
			
			//将内容转成xml
			var toXml:XML = new XML(content);//htmlToXml(content,txtColor,size);
			var tagName:String;
			groupVector = getContentArr2(toXml,txtColor,size);			
			
			return new GroupElement(groupVector);
			
			for each (var xml:XML in toXml.children()) 
			{
				tagName = xml.name();
				if(tagName == IMG){
					//表情
					var iconSprite:FaceLoader = new FaceLoader(52,52);
					iconSprite.load(xml.@src);
					faceVec.push(iconSprite);
					var format:ElementFormat = new ElementFormat();
					format.dominantBaseline = TextBaseline.ASCENT;
					iconSprite.width = 52;
					iconSprite.height = 52;
					var face:GraphicElement = new GraphicElement(iconSprite,52,52);
					face.elementWidth = 52;
					face.elementHeight = 52;
					groupVector.push(face);
				}
				else if(tagName == FONT){
					//文本
					var color:int;
					var bold:Boolean;
					if(xml.attribute("color").length() > 0){
						color =  HtmlUtil.colorStrToInt(xml.@color)
					}
					else {
						color =  HtmlUtil.colorStrToInt(txtColor);
					}
					
					if(xml.attribute("bold").length() > 0){
						bold =  Boolean(xml.@bold);
					}
					var fmt:ElementFormat = ChatTextAreaUtil.createFormat(color,size,bold);
					var contentTE2:TextElement = new TextElement(xml.toString(),fmt);
					groupVector.push(contentTE2);
				}
				else if(tagName == A){
					var test:String = xml.@href;
					var t:int =0;
				}
				else if(tagName == "br"){
					
				}			
			}		
			
			/*		var splitArr:Array = content.split(/(\[[f,i,vip,c][^\[]+?\])/);
			
			for(var i:int=0; i < splitArr.length; i++){
			var item:String = splitArr[i];
			if (iconReg.test(item)){
			var iconId:int = int(item.slice(2, item.length - 1));
			if( iconId > FacePanel.FACE_NUM){
			continue;
			}
			var url:String = UrlManager.getUrl(StringUtil.substitute("resource/face/f{0}.swf",iconId));
			var format:ElementFormat = new ElementFormat();
			format.fontSize = size;
			
			var iconSprite:ChatFaceIcon = new ChatFaceIcon;
			iconSprite.y = 6;
			iconSprite.url = url;
			faceVec.push(iconSprite);
			var face:GraphicElement = new GraphicElement(iconSprite,25,24,format);
			groupVector.push(face);
			}
			else if(itemReg.test(item)){
			var textArr:Array = item.split("|");
			var color:int =  HtmlUtil.colorStrToInt(textArr[1]);
			var text:String =  textArr[2];
			
			var contentTE2:TextElement = new TextElement(text.substr(0,text.length-1),ChatTextAreaUtil.createFormat(color,size));
			groupVector.push(contentTE2);
			}else{
			if(item == ""){
			continue;
			}
			
			var contentTE:TextElement = new TextElement(item,ChatTextAreaUtil.createFormat(0xd8e5c6,size));
			groupVector.push(contentTE);
			}
			}*/
			
			return new GroupElement(groupVector);
		}
	}
}