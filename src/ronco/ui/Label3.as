package ronco.ui
{
	import flash.text.TextField;
	import flash.filters.*;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.*;

	public class Label3 extends UIElement
	{
		public var label:TextField = new TextField;

		private var format:TextFormat = new TextFormat("宋体", 13);
		
		public var isCtrl:Boolean = false;
		
		public var filterDropShadow:DropShadowFilter;
		public var filterGrow:GlowFilter;
		
		public var bChgColor:Boolean = false;
		public var colorHeightLight:uint = 0xffffff;
		public var color:uint = 0xffffff;
		
		public var yoff:int = 0;
		
		public var ishandcur:Boolean = false;
		
		public function Label3(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_LABEL2, _name, _parent);
		}
		
		//! 设置字体和大小
		public function setFont(_font:String, _fontsize:int):void
		{
			format.font = _font;
			format.size = _fontsize;
			
			label.setTextFormat(format);
			
			//label.setStyle("textFormat", format);
		}
		
		//! 设置下划线
		public function setUnderLine(bUseUnderLine:Boolean):void
		{
			format.underline = bUseUnderLine;
			
			label.setTextFormat(format);
			//label.setStyle("textFormat", format);			
		}
		
		//! 设置粗体
		public function setBold(bBold:Boolean):void
		{
			format.bold = bBold;
			
			label.setTextFormat(format);
			//label.setStyle("textFormat", format);
		}		
		
		//! 设置对齐方式
		public function setAlign(_autosize:String):void
		{
			label.autoSize = _autosize;
		}		
		
		// 初始化接口   文本超链接："<u><a href=' 地址 ' target=' blank '> 显示内容 </a></u>"
		public function init(_s:String, _fontsize:int = 13, _autosize:String = flash.text.TextFieldAutoSize.LEFT):void
		{
			label.htmlText = _s;
			
			format.font = "宋体";
			format.size = _fontsize;
			format.kerning = true;
			format.leading = 2;
			format.letterSpacing = 1;
			label.setTextFormat(format);
			//label.setStyle("textFormat", format);
			label.autoSize = _autosize;
			
			//! 这里通过修改 label 的坐标来控制偏移，这样本元素的坐标可以直接控制
			label.x = 0;
			label.y = yoff - 3;
			
			//			x = _x;
			//			y = _y - 3;
			
			addChild(label);
			
			//setBorder(true, 0);
		}		
		
		//		// zhs007 @ 2010.12.22 不建议使用该接口
		//		// 绘制纯文本. / html 文本
		//		public function drawString(_s:String, _x:int=0, _y:int=0, _format:TextFormat=null):void
		//		{
		//			label.htmlText = _s;
		//			
		//			if(_format != null)
		//				format = _format;
		//			
		//			label.setStyle("textFormat",format);
		//			label.autoSize = flash.text.TextFieldAutoSize.LEFT;//左对齐
		//
		//			this.x = _x;	
		//			this.y = _y-3;
		//			
		//			addChild(label);
		//		}
		
		// 设置行距
		public function setLeading(arg0:int):void
		{
			format.leading = arg0;
			
			label.setTextFormat(format);
		}
		
		// 设置内容
		public function setText(arg0:String):void
		{
			if(arg0 == null)
				label.htmlText = "";
			else
				label.htmlText = arg0;
			//			
			//			if(label.height < lh)
			//				label.y = (lh - label.height) / 2; 
		}
		
		/**
		 * 取回内容
		 **/ 
		public function getText():String
		{
			return label.htmlText;
		}		
		
		// 获取字体样式设置对象
		public function getTextFormat():TextFormat
		{
			return format;
		}
		
		// 获取文本输入和显示对象
		public function getTextField():TextField
		{
			return label;
		}
		
//		// 获取实例对象
//		public function getInstance():fl.controls.Label
//		{
//			return label;
//		}
		
		// 设置大小
		public function setSize(_w:int,_h:int):void
		{
			label.width = _w;
			label.height = _h;
			//label.setSize(_w, _h);//自动识别显示全部文本
			
			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = _w;
			lh = _h;			
			
			if(!label.multiline)
			{
				yoff = (_h - int(format.size)) / 2;
				
				label.y = yoff - 3;
			}
		}
		
		// 设置字体颜色
		public function setFontColor(_color:uint):void
		{
			color = _color;
			
			format.color = _color;
			
			label.setTextFormat(format);
			
			label.textColor = color;
			//label.setStyle("textFormat", format);
		}
		
		// 设置字体颜色
		public function setHeightLightColor(_color:uint):void
		{
			bChgColor = true;
			
			colorHeightLight = _color;
		}		
		
		//! 处理操作，如果返回true，表示截获操作，不继续交给后面的控件处理，否则会交给后面的控件处理
		public override function onCtrl(ctrl:UICtrl):Boolean
		{
			if(isCtrl && isIn(ctrl.mx, ctrl.my))
			{
				if(ishandcur)
					Mouse.cursor = MouseCursor.BUTTON;
				
				if(bChgColor && format.color != colorHeightLight)
				{
					Mouse.cursor = MouseCursor.BUTTON;
					
					format.color = colorHeightLight;
					
					label.setTextFormat(format);
					//label.setStyle("textFormat", format);
				}
				
				if(ctrl.lBtn == UICtrl.KEY_STATE_UP)
				{
					procUINotify(this, UIDef.NOTIFY_CLICK_LABEL);
					
					return true;
				}
				
				if(ctrl.lBtn != UICtrl.KEY_STATE_NORMAL)
					return true;
			}
			else if(format.color != color)
			{
				//Mouse.cursor = MouseCursor.AUTO;
				
				format.color = color;
				
				label.setTextFormat(format);
				//label.setStyle("textFormat", format);				
			}
			
			return false;
		}
		
		// 设置是否有描边
		public function setBorder(_hasBorder:Boolean, _color:uint):void
		{
			var lst:Array;
			
			if(_hasBorder)
			{
				lst = label.filters;
				if(lst == null)
					lst = new Array;
				
				if(filterDropShadow != null)
					filterDropShadow.color = _color;
				else
					filterDropShadow = new DropShadowFilter(0, 0, _color, 1, 2, 2, 255);					
				
				lst.push(filterDropShadow);
				
				label.filters = lst;
			}
			else
			{
				lst = label.filters;
				if(lst != null)	
				{
					for(var i:int = 0; i < lst.length; ++i)
					{
						if(lst[i] == filterDropShadow)
						{
							lst.splice(i, 1);
							
							break;
						}
					}
				}
				
				label.filters = lst;
			}
			
			//			var lst:Array;
			//			var gilter:GlowFilter
			//			
			//			if(_hasBorder)
			//			{
			//				lst = label.filters;
			//				if(lst == null)
			//				{
			//					lst = new Array;
			//					
			//					gilter = new GlowFilter(_color, 1, 2, 2, 8, 50);
			//					
			//					lst.push(gilter);
			//				}
			//				else if(lst.length == 0)
			//				{
			//					gilter = new GlowFilter(_color, 1, 2, 2, 8, 50);
			//					
			//					lst.push(gilter);					
			//				}
			//				else
			//				{
			//					lst[0].color = _color;
			//				}
			//				
			//				label.filters = lst;
			//			}
			//			else
			//			{
			//				lst = label.filters;
			//				if(lst != null)	
			//					lst.splice(0);
			//
			//				label.filters = lst;
			//			}
		}
		
		// 自定义设置字体
		public function setGlow(_color:uint, _blurX:Number = 2, _blurY:Number = 2, _strength:Number = 16, _quality:int = 1):void
		{
			var lst:Array;
			
			//if(_hasBorder)
			//{
			lst = label.filters;
			if(lst == null)
				lst = new Array;
			
			if(filterGrow != null)
			{
				filterGrow.color = _color;
				filterGrow.blurX = _blurX;
				filterGrow.blurY = _blurY;
				filterGrow.strength = _strength;
				filterGrow.quality = _quality;
			}
			else
				filterGrow = new GlowFilter(_color,1,_blurX,_blurY,_strength,_quality);
			
			lst.push(filterGrow);
			
			label.filters = lst;
			//}
			//			else
			//			{
			//				lst = label.filters;
			//				if(lst != null)	
			//				{
			//					for(var i:int = 0; i < lst.length; ++i)
			//					{
			//						if(lst[i] == filterGrow)
			//						{
			//							lst.splice(i, 1);
			//							
			//							break;
			//						}
			//					}
			//				}
			//				
			//				label.filters = lst;
			//			}
			
			//			var glow:GlowFilter =new GlowFilter(0x004C04,1,_blurX,_blurY,_strength,_quality);
			//			var array:Array = new Array();
			//			array.push(glow);
			//			label.filters = array;
		}
		
		public function setMulLine():void
		{
			label.wordWrap = true;
			label.multiline = true;
			
			yoff = 0;
			
			label.y = yoff - 3;
		}
		
		//! 判断是否在控件区域内
		public override function isIn(_x:int, _y:int):Boolean
		{
			if(_x > x && _x < x + lw && _y > y && _y < y + lh)
			{
				if(label.autoSize == "right")
				{
					if(_x > x + lw - label.width && _x < x + lw && 
						_y > y && _y < y + label.height)
						return true;
				}
				else if(label.autoSize == "center")
				{
					if(_x > x + (lw - label.width) / 2 && _x < x + lw / 2 + label.width / 2 && 
						_y > y && _y < y + label.height)
						return true;
				}
				else
				{
					if(_x > x && _x < x + label.width && 
						_y > y && _y < y + label.height)
						return true;
				}				
			}
			
			return false;
		}						
	}
}