package ronco.ui
{
	import fl.controls.Label;
	
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	public class ScrollLabel extends UIElement
	{
		private var timer:Timer = new Timer(10);
		private var label:fl.controls.Label = new fl.controls.Label();
		private var format:TextFormat = new TextFormat(null, 12, 0xffffff);
		private var vector:Vector.<String> = new Vector.<String>;// 文本容器
		private var filterDropShadow:DropShadowFilter; //字体描边对象
		
		private var scrollY:Number = 0.2;
		private static const SIZE_CENTER:String = flash.text.TextFieldAutoSize.CENTER;
		private static const SIZE_LEFT:String = flash.text.TextFieldAutoSize.LEFT;
		
		public static const TYPE_UP_ALWAY:int = 0; // 仅仅向上移动
		public static const TYPE_UP_SHADE:int = 1; // 向上渐隐移动
		public var curScrollType:int = TYPE_UP_ALWAY; // 滚动类型
		
		public function ScrollLabel(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_SCROLLLABEL, _name, _parent);
		}
		
		public function init(_w:int,_h:int,_fontsize:int = 12,type:int = TYPE_UP_ALWAY):void
		{
			this.scrollRect = new Rectangle(0,0,_w,_h);
			this.graphics.beginFill(0xffffff,0);
			this.graphics.drawRect(0,0,_w,_h);
			this.graphics.endFill();
			
			curScrollType = type;
			
			format.size = _fontsize;
			label.text = "";
			label.setSize(_w,_h);
			label.setStyle("textFormat",format);
			//label.autoSize = flash.text.TextFieldAutoSize.CENTER;
			
			addChild(label);
						
			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = _w;
			lh = _h;
			
			timer.addEventListener(TimerEvent.TIMER,onTimer);

		}
		
		public function showMessage(_str:String,_autosize:String = flash.text.TextFieldAutoSize.CENTER):void
		{
			if(_str != "")
			{
				vector.push(_str);
				
				if(!timer.running)
					begine();
				
				timer.start();
			}
			
//			label.htmlText = _str;
//			label.autoSize = _autosize;
			
			//重置坐标
//			label.y = this.height;
			
//			label.wordWrap = (label.textField.textWidth > lw);	
	
		}
		
		public function begine():void
		{
			if(vector.length > 0)
			{
				label.alpha = 1;
				label.htmlText = vector[0];
				label.y = this.height-label.textField.textHeight;
				
				label.autoSize = SIZE_CENTER;
				
				label.wordWrap = (label.textField.textWidth > lw-16);
				if(label.text.length>26)
				{
					label.wordWrap = true;
				}
				
			}
		}
		
		public function endScroll():void
		{
			vector.shift();
			
			if(vector.length > 0)
				begine();
			else
				timer.stop();
		}
		
		private function onTimer(evt:TimerEvent):void
		{
			if(vector.length > 0)
			{
				label.y-=scrollY;

				if(curScrollType == TYPE_UP_ALWAY)
				{
					if(label.y<-label.textField.textHeight)
						endScroll();
				}
				else if(curScrollType == TYPE_UP_SHADE)
				{
					if(label.alpha<=0)
					{
						endScroll();
						return ;
					}
					if(label.y < lh-14)
						label.alpha-=(Number)(1/((lh-12)/scrollY));
				}
			}
		}
		
		public function getTextFormat():TextFormat
		{
			return format;
		}
		
		public function getInstance():fl.controls.Label
		{
			return label;
		}
		
		public function setFontColor(_color:uint):void
		{
			format.color = _color;
			label.setStyle("textFormat",format);
		}
		
		public function setFlushTime(_time:int):void
		{
			timer.delay = _time;
		}
		
		public function setScrollSizeY(_size:Number):void
		{
			scrollY = _size;
		}
		
		// 字体描边设置
		public function setBorder(_hasBorder:Boolean,_color:int):void
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
		}
	}
}