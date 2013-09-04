package ronco.ui
{
	import fl.controls.Label;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	// 标题栏 水平滚动	
	public class ScrollLabel2 extends UIElement
	{
		private var type:int=0; //滚动类型
		private var timer:Timer = new Timer(10); //时间监听
		private var label:fl.controls.Label = new fl.controls.Label();//文本
		private var format:TextFormat = new TextFormat(null, 12, 0xffffff,true);//字体样式		
		private var vector:Vector.<String> = new Vector.<String>;// 文本容器
		
		private var filterDropShadow:DropShadowFilter;
		private var speed:Number=1; // 背景移动速度
		public var state:int=0;//当前状态
		private var sprite:Sprite = new Sprite();//背景遮隐
		
		public static const STATE_NORMAL:int = 0; // 普通状态
		public static const STATE_END:int	= 1;		 // 结束状态
		
		public function ScrollLabel2(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_SCROLLLABEL2, _name, _parent);
		}
		
		// 初始化
		public function init(_fontSize:int,_color:int,_w:int,_h:int):void
		{			
			this.scrollRect = new Rectangle(0,0,_w,_h);
			this.graphics.beginFill(0xffffff,0);
			this.graphics.drawRect(0,0,_w,_h);
			this.graphics.endFill();
			
			// 背景
			setBackGroundColor(0,_w,_h);
			sprite.y = -sprite.height;
			addChild(sprite);
			
			format.color = _color;
			format.size = _fontSize;
			
			label.x = _w;
			label.setSize(_w,_h);
			label.textField.autoSize = flash.text.TextFieldAutoSize.LEFT;
			label.setStyle("textFormat",format);

			addChild(label);
			
			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = _w;
			lh = _h;
			
			timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		
		// 设置刷新时间
		public function setFlushTime(_value:int):void
		{
			timer.delay = _value;
		}
		
		// 设置背景移动速度
		public function setSpeed(_sp:Number):void
		{
			speed = _sp;
		}
		
		//设置字体样式
		public function setTextFormat(_format:TextFormat):void
		{
			format = _format;
			label.setStyle("textFormat",format);
		}
		
		// 设置字体颜色
		public function setColor(_color:int):void
		{
			format.color = _color;
			label.setStyle("textFormat",format);
		}
		
		// 设置背景遮隐色
		private function setBackGroundColor(_color:int,_w:int,_h:int,_alpha:Number=0.7):void
		{
			sprite.graphics.beginFill(_color,_alpha);
			sprite.graphics.drawRect(0,0,_w,_h);
			sprite.graphics.endFill();
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
		
		// 将数据添加到列表
		public function addScrollLabe(_str:String):void
		{
			if(_str != null || _str != "")			
				vector.push(_str);
		}
		
		// 启动滚动事件
		public function beginScroll():void
		{
			if(vector != null)
			{
				if(vector.length > 0)
				{
					label.text = vector[0];
					label.width = label.textField.textWidth+10;
					
					timer.start();
				}
			}
		}
		
		public function endScroll():void
		{
			if(vector != null)
			{
				vector.shift();
				
				if(vector.length > 0)
					beginScroll();
				else
					state = STATE_END;
			}
		}
		
		// 逻辑处理
		public function onTimer(evt:TimerEvent):void
		{
			if(state == STATE_NORMAL)
			{
				if(sprite.y>=0)
				{
					label.x -=speed;
					
					if(label.x<-label.textField.textWidth)
					{
						//timer.stop();
						label.x = lw;
						endScroll();
					}
					return;
				}
				sprite.y+=0.5;
			}
			else if(state == STATE_END)
			{
				sprite.alpha-=0.02;
				if(sprite.alpha <=0)
				{
					timer.stop();
					state = STATE_NORMAL;
					sprite.y = -sprite.height;
					sprite.alpha=1;
				}
			}
		}
		
	}
}