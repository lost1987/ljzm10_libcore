package ronco.ui
{
	import flash.display.*;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class CD extends UIElement
	{
		public var cd:Sprite = new Sprite;
//		public var time:Number;
//		public var timer:Timer;
		public var curTime:Number;
		public var maxTime:Number;
//		public var onTimer:Function;
		public var id:int;
		
		public function CD( _name:String, _parent:UIElement)
		{
			super(UIDef.UI_CD, _name, _parent);
			addChild(cd);
		}
		
		public function goCD(_num:Number):void
		{			
//			var _num:Number = _curTime / _maxTime;
			var r:Number = lw / 2 + 1;
			cd.graphics.clear();
			cd.graphics.beginFill(0, 0.8);
			cd.graphics.lineStyle(0.1, 0, 0.5);
			cd.graphics.moveTo(r,r);
			cd.graphics.lineTo(r,0);
			if(_num < 0.125)
			{
				cd.graphics.lineTo(0, 0);
				cd.graphics.lineTo(0, lh);
				cd.graphics.lineTo(lw, lh);
				cd.graphics.lineTo(lw, 0);
				cd.graphics.lineTo(Math.tan(Math.PI * _num * 2) * r + r, 0);
			}
			else if(_num < 0.25)
			{
				cd.graphics.lineTo(0, 0);
				cd.graphics.lineTo(0, lh);
				cd.graphics.lineTo(lw, lh);
				cd.graphics.lineTo(lw, r - r / Math.tan(Math.PI * _num * 2));
			}
			else if(_num < 0.375)
			{
				cd.graphics.lineTo(0, 0);
				cd.graphics.lineTo(0, lh);
				cd.graphics.lineTo(lw, lh);
				cd.graphics.lineTo(lw, r + r * Math.tan(Math.PI * (_num - 0.25) * 2));
			}	
			else if(_num < 0.5)
			{
				cd.graphics.lineTo(0, 0);
				cd.graphics.lineTo(0, lh);
				cd.graphics.lineTo(r + r / Math.tan(Math.PI * (_num - 0.25) * 2), lh);
			}
			else if(_num < 0.625)
			{
				cd.graphics.lineTo(0, 0);
				cd.graphics.lineTo(0, lh);
//				cd.graphics.lineTo(r, lh);
				cd.graphics.lineTo(r - r * Math.tan(Math.PI * (_num - 0.5) * 2), lh);
			}	
			else if(_num < 0.75)
			{
				cd.graphics.lineTo(0, 0);
				cd.graphics.lineTo(0, r + r / Math.tan(Math.PI * (_num - 0.5) * 2));
			}
			else if(_num < 0.875)
			{
				cd.graphics.lineTo(0, 0);
				cd.graphics.lineTo(0, r - r * Math.tan(Math.PI * (_num - 0.75) * 2));
			}
			else
			{
				cd.graphics.lineTo(r - r / Math.tan(Math.PI * (_num - 0.75) * 2), 0);
			}
			cd.graphics.lineTo(r, r);
			cd.graphics.endFill();		
		}
		
		public function setCD(_id:int, _curTime:Number, _maxTime:Number):void
		{	
			id = _id;
//			if(timer != null)
//			{
//				if(timer.running)
//				{
//					timer.stop();
////					onTimer();
//				}
//			}
			curTime = _curTime;
			maxTime = _maxTime;
//			timer = new Timer(_maxTime * 1000 / 100);
//			timer.addEventListener(TimerEvent.TIMER, _onTimer);
//			timer.start();
			
			goCD(_curTime / _maxTime);
			if(_curTime != _maxTime)
				this.visible = true;
			else
				this.visible = false;
		}
		
//		public function setFunction(_fun:Function):void
//		{
//			curTime = 0;
//			onTimer = _fun;
//		}
//		
//		public function _onTimer(e:TimerEvent):void
//		{
//			curTime += maxTime / 100;
//			if(curTime >= maxTime)
//			{
//				timer.stop();
////				onTimer();
//				this.visible = false;
//			}
//			else
//			{
//				goCD(curTime / maxTime);
//			}
//		}
	}
}