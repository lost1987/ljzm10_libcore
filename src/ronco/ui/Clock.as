package ronco.ui
{
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.*;
	
	import ronco.base.*;
	
	public class Clock extends UIElement
	{
		private var back:Bitmap;					//! 底图
		private var backRect:Rectangle = new Rectangle();			//! 底图的矩形位置
		
		private var imgNum:Bitmap;					//! 数字图片
		private var numRect:Rectangle = new Rectangle();				//！数字图片的临时矩形位置
		private var numArray:Array = new Array	;	//! 数组
		
		private var beginNum_X:int;				//! 开始画数字的x坐标
		private var beginNum_Y:int;				//!	开始画数字的y坐标
		
		private var timer:Timer = new Timer(1000);

		private var _time_id:int =0;
			
		private var maxState:int;					//! 最大的状态数
		public var state:int;						//! 当前状态 决定使用哪个底图
		public var Num:int;						//!	当前需要显示的数字(当前时间)
		public var UserdNums:int;					//! 使用过的时间（秒）
		public var strNum:String;					//! 数字的字符串（方便操作）
		
		public function Clock(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_STATE_NUM, _name, _parent);
			timer.addEventListener(TimerEvent.TIMER, _onTimer);
		}
		
		public function init(res_back:Class, res_num:Class, max_state:int):void
		{
			back = new res_back as Bitmap;
			maxState = max_state;
			state = 0;
			
//			backRect.top = 0;
//			backRect.left = state * (back.bitmapData.width / maxState);
//			backRect.bottom = back.bitmapData.height;
//			backRect.right = (state + 1) * (back.bitmapData.width/maxState);
			_getRect(back, maxState, state, backRect);
			back.scrollRect = backRect;	
			back.visible = false;
			addChild(back);
			
			imgNum = new res_num as Bitmap;
			Num = 0;
			strNum = Num + "";
			for(var i:int = 0; i < numArray.length; ++i)
				numArray[i].visible = false;
		}
		
		public function SetTime(_time:int):void
		{
			Num = _time;
			UserdNums = 0;
			strNum = Num + "";
			//_time_id = setTimeout(_onTimer, 1000);
			//timer.start();
			
			_changeNumXY();
			
			_updateTime();
			
			timer.start();
		}
		
		public function _onTimer(event:TimerEvent):void
		{
			var bstrNum:String = Num + "";
			
			Num--;
			UserdNums++;
			strNum = Num + "";
			
			if(bstrNum.length > strNum.length)
				_changeNumXY();
			
			if(Num == 0)
				procUINotify(this, UIDef.NOTIFY_CLOCK_OVER);
			
			_updateTime();
		}
		
		public function _updateTime():void
		{
			if(Num >= 0)
			{
				_getRect(back, maxState, state, backRect);
				back.scrollRect = backRect;	
				back.visible = true;
				
				strNum = Num + "";
				
				for(var i:int = 0; i < strNum.length; ++i)
				{
					if(i >= numArray.length)
					{
						_showNum(i, Number(strNum.charAt(i)));
					}
					else
					{	
						_getRect(imgNum, 10, Number(strNum.charAt(i)), numRect);
						
						numArray[i].scrollRect = numRect;
						numArray[i].x = beginNum_X + i * numRect.width;
						numArray[i].y = beginNum_Y;
						numArray[i].visible = true;
					}
				}				
			}
			else
			{
				back.visible = false;
				for(var j:int = 0; j < numArray.length; ++j)
					numArray[j].visible = false;
			}
			

		}
		
		public function _showNum(pos:int , num:int):void
		{
			var tmp_img:Bitmap = new Bitmap(imgNum.bitmapData);

			_getRect(imgNum, 10, num, numRect);
			
			tmp_img.scrollRect = numRect;
			
			tmp_img.x = beginNum_X + pos * imgNum.bitmapData.width / 10;
			tmp_img.y = beginNum_Y;
			
			addChild(tmp_img);
			numArray.push(tmp_img);	
		}
		
		public function _changeNumXY():void
		{
			var i:int = 0;
			beginNum_X = ((back.bitmapData.width / maxState) - (strNum.length * (imgNum.bitmapData.width / 10))) / 2;
			beginNum_Y = (back.bitmapData.height - imgNum.bitmapData.height) / 2;
			for(; i < numArray.length; ++i)
				numArray[i].visible = false;
		}
		
		public function _getRect(img:Bitmap, max:int, cur:int, rect:Rectangle):void
		{
			rect.left = img.bitmapData.width / max * cur;
			rect.top = 0;
			rect.width = img.bitmapData.width / max;
			rect.height = img.bitmapData.height;
		}
		
		
	}
}