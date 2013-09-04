package ronco.ui.chat
{
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextLineCreationResult;
	import flash.text.engine.TextLineMirrorRegion;
	
	import ronco.ui.UIDef;
	import ronco.ui.UIElement;
	
	/**
	 *  @author:Gaara
	 *  2012-7-11
	 *  图文混排
	 *   
	 * 
	 **/
	public class RichTextArea extends UIElement
	{
		/** 记录初始位置 **/
		public var offsetY:int = 0;
		
		/** 行距 **/
		public var space:int = 8;
		
		/** 行高 **/
		public var rowHeight:int = 0;
		
		/** 保存上个显示内容的引用**/
		private var preTextLine:TextLine;
		private var fontSize:int = 12;
		
		public var lst:Vector.<TextBlock> = new Vector.<TextBlock>;
		
		public function RichTextArea(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_BUTTON, _name, _parent);		
		
			this.mouseEnabled = false;
		}
		
		public function getHeight():Number
		{
			if(preTextLine != null )
			{
				var _h:Number = preTextLine.height + 3;
				
				if(preTextLine.hasGraphicElement)
					_h = 32;
				
				return _h + offsetY + space ;
			}
			
			return offsetY;
		}
		
		public function appendRichText(str:String):void
		{
			var data:String =  "";//兼容FireFox, php输出的xml
			
			data += "<font>";
			data += str;
			data += "</font>";
			
			appendGroupE(ronco.ui.chat.RichTextAreaUtil.getContentArr(data),true);
		}
		
		/**
		 *  功能:添加内容组
		 *  参数:
		 **/
		public function appendGroupE(groupE:GroupElement,newLine:Boolean=false):void
		{
			if(lst.length > 50)
				clearFirstLine();
			
			var textBlock:TextBlock = new TextBlock;
			textBlock.baselineZero =  TextBaseline.ASCENT;
			textBlock.content = groupE;
			lst.push(textBlock);
						
			//第一次创建减去前辍宽度
			var textLine:TextLine;
			var preRight:int;
			
			var levPixel:int = width;
			if(!newLine){
				if(preTextLine){
					//前面有内容
					preRight = preTextLine.x + preTextLine.width;
					levPixel	-= preRight;
				}
			}
			else 	if(preTextLine){
				offsetY += rowHeight?rowHeight:preTextLine.height+space;
			}
			
			textLine = textBlock.createTextLine (null,levPixel);
			if(!textLine && isNewLine(textBlock)){
				//指定的宽度无法创建
				preRight = 0;
				offsetY += rowHeight?rowHeight:preTextLine.height+space;
				textLine = textBlock.createTextLine(null, width);				
			}
			while (textLine)
			{
				textLine.filters =  [new GlowFilter(0,1,2,2,16)];
				for each (var tlm:TextLineMirrorRegion in textLine.mirrorRegions) 
				{
					//用此变量来作为下划线标志
					if(tlm.element.userData){
						var shape:Shape = new Shape();
						var g:Graphics = shape.graphics;
						g.lineStyle(1,tlm.element.elementFormat.color);
						g.moveTo(tlm.bounds.left, tlm.bounds.bottom+1);
						g.lineTo(tlm.bounds.left+tlm.bounds.width, tlm.bounds.bottom+1);
						textLine.addChild(shape);
					}			
				}			
				
				textLine.x = preRight;
				
				addChild(textLine);
				preTextLine = textLine;
				textLine.y = offsetY + space;
				trace("h:"+textLine.height +" y:"+textLine.y)
//				height = textLine.y + textLine.height  +rowHeight;
				
				preRight = preTextLine.x + preTextLine.width;
				levPixel = width - preRight;
				textLine = textBlock.createTextLine(preTextLine, levPixel);
				if(!textLine && (levPixel==0 || isNewLine(textBlock))){
					//指定的宽度无法创建
					textLine = textBlock.createTextLine(preTextLine, width);
					if(textLine){
						preRight = 0;
						offsetY += rowHeight?rowHeight:preTextLine.height+space;
					}
				}
			}
			
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function clearFirstLine():void
		{
			if(numChildren)
			{				
				for(var p:TextLine = lst[0].firstLine; p != null; p = p.nextLine)
				{
					removeChild(p);
				}
				lst[0].releaseLines(lst[0].firstLine,lst[0].lastLine);
				
				lst.splice(0,1);
				
				if(lst.length)
				{
					var _h:int = lst[0].firstLine.y;
					
					offsetY -= _h;
					if(offsetY < 0)
						offsetY = 0;
					
					for(var i:int = 0; i < lst.length; ++i)
					for(p = lst[i].firstLine; p != null; p = p.nextLine)
					{
						p.y -= _h;
					}
				}
				
				
			}			
		}
		
		/**
		 *  功能:是否需要换行
		 *  参数:
		 **/
		public function isNewLine(textBlock:TextBlock):Boolean
		{
			return textBlock.textLineCreationResult == TextLineCreationResult.EMERGENCY || 
				textBlock.textLineCreationResult == TextLineCreationResult.INSUFFICIENT_WIDTH;
		}
		
		/**
		 *  功能:清除内容
		 *  参数:
		 **/
		public function clear():void
		{
			while(numChildren > 1){
				var tl:TextLine = removeChildAt(numChildren - 1) as TextLine;
			}
			lst = new Vector.<TextBlock>;
			offsetY = 0;
			preTextLine = null;
			ChatTextAreaUtil.stopAndClearFaces();
			
			this.dispatchEvent(new Event(Event.CHANGE));
		}
	}
}