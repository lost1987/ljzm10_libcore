package ronco.ui
{
	import fl.controls.Label;
	import fl.controls.TextArea;
	
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	// 停顿性 滚屏类
	public class ScrollLabelV extends UIElement
	{
		public  var state:int=0;//当前状态
		private var type:int=0; //滚动类型
		private var timer:Timer = new Timer(10); //时间监听
		private var label:fl.controls.Label = new fl.controls.Label();//文本
		private var label2:fl.controls.Label = new fl.controls.Label();//补充部分Label
		private var format:TextFormat = new TextFormat(null, 12, 0xffffff,true);//字体样式		
		public  var  vector:Vector.<String> = new Vector.<String>;// 文本容器			
		private var filterDropShadow:DropShadowFilter; //字体描边对象
		private var timeid:int=0;
		public var charCodeNum:int = 28; //一行文本显示长度
		
		public static const STATE_INSIDE:int = 0;  //底部移出效果
		public static const STATE_STOP:int = 1;		//中间暂停效果	
		public static const STATE_OUTSIDE:int = 2;//顶部移出效果
		
		public function ScrollLabelV(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_SCROLLLABELV, _name, _parent);
		}
		
		// 初始化
		public function init(_fontSize:int,_color:int,_w:int,_h:int):void
		{
			// 设置画面 矩形范围
			this.scrollRect = new Rectangle(0,0,_w,_h);
			this.graphics.beginFill(0xffffff,0);
			this.graphics.drawRect(0,0,_w,_h);
			this.graphics.endFill();
			
			format.color = _color;
			format.size = _fontSize;
			
			label.y = _h;
			label.setSize(_w,_h);
			format.align = flash.text.TextFieldAutoSize.CENTER;
			label.setStyle("textFormat",format);
			
			label2.y = label.y+label.textField.textHeight;
			label2.setSize(_w,_h);
			label2.setStyle("textFormat",format);

			addChild(label);
			addChild(label2);
			
			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = _w;
			lh = _h;
			
			timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		
		public function onTimer(evt:TimerEvent):void
		{
			var i:int = 0;
			if(state == STATE_INSIDE)
			{
				for(i=0;i<this.numChildren;i++)
				{
					this.getChildAt(i).y -= 0.5;				
				}
				if(label.y<=0)
				{
					state = STATE_STOP;
					flash.utils.clearTimeout(timeid);
					timeid = flash.utils.setTimeout(chgState,3000);
				}
			}
			else if(state == STATE_STOP)
			{
			}
			else if(state == STATE_OUTSIDE)
			{
				for(i=0;i<this.numChildren;i++)				
					this.getChildAt(i).y -= 0.5;

				if(label.y<=-label.height-10)
				{
					timer.stop();
					label.y = lh;
					state = STATE_INSIDE;
					
					endScroll();
				}
			}
		}
		
		private function chgState():void		
		{
			state = STATE_OUTSIDE;
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
		
		// 设置刷新时间
		public function setFlushTime(_value:int):void
		{
			timer.delay = _value;
		}
		
		// 将数据添加到列表
		public function addScrollLabel(_str:String):void
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
					showString(vector[0],true);
					
					timer.start();
				}
			}
		}
		
		// 暂停滚动事件
		public function stopScroll():void
		{
			if(timer.running)
			{
				timer.stop();
			}
		}
		
		// 重新启动线程
		public function restart():void
		{
			timer.start();
		}
			
		// 滚动结束事件
		public function endScroll():void
		{
			if(vector != null)
			{
				vector.shift();
				
				if(vector.length > 0)
					beginScroll();
			}
		}
		
		// 获取并设置显示内容
		private function showString(str:String,_wrap:Boolean = false):void
		{			
			if(str != null && str != "")
			{
				label2.text = "";
				label.text = str.slice(0,charCodeNum);
				
				if(_wrap && str.length > charCodeNum)
				{
					label2.text = str.slice(charCodeNum,str.length);
					label2.y = label.y+label.textField.textHeight;
				}				
			}
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
				label2.filters = lst;
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
				label2.filters = lst;
			}
		}
	}
}