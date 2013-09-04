package ronco.ui
{
	import flash.display.*;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	public class ImageChange extends UIElement
	{
		private var bitmap:Bitmap;
		private var rect:Rectangle;//切割矩形
		private var frame:int = 0;//帧数
		
		private var row:int = 1;//行
		private var vol:int = 1;//列
		
		private var _lw:int;
		private var _lh:int;
		
		private var timer:Timer = new Timer(200);
		
		public function ImageChange( _name:String, _parent:UIElement)
		{
			super(UIDef.UI_IMAGECHANGE, _name, _parent);
		}
		
		public function init2(_res:BitmapData,_row:int=1,_vol:int=1):void
		{
			row = _row;
			vol = _vol;
			
			bitmap = new Bitmap(_res);
			rect = new Rectangle(0,0,bitmap.width/_vol,bitmap.height/_row);
			bitmap.scrollRect = rect;
			
			addChild(bitmap);
			
			_lw = bitmap.bitmapData.width/_vol;
			_lh = bitmap.bitmapData.height/_row;
			
			timer.addEventListener(TimerEvent.TIMER,onTimer);
		}		
		
		public function init(_res:Class,_row:int=1,_vol:int=1):void
		{
			row = _row;
			vol = _vol;
			
			bitmap = new _res as Bitmap;
			rect = new Rectangle(0,0,bitmap.width/_vol,bitmap.height/_row);
			bitmap.scrollRect = rect;
			
			addChild(bitmap);
			
			_lw = bitmap.bitmapData.width/_vol;
			_lh = bitmap.bitmapData.height/_row;
			
			timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		
		public function onTimer(evt:TimerEvent):void
		{
			frame++;
			
			rect.top = frame%row*_lh;
			rect.bottom = rect.top + _lh;
			rect.left = frame%vol*_lw;
			rect.right = rect.left + _lw;
			bitmap.scrollRect = rect;
		}
		
		public function change(rect:Rectangle):void
		{
			bitmap.scrollRect = rect;
		}
		
		public function change2(row:int, vol:int):void
		{
			rect.top = row*_lh;
			rect.left = vol*_lw;
			rect.right = rect.left + _lw;
			rect.bottom = rect.top + _lh;
			bitmap.scrollRect = rect;
		}
		
		public function setflushTime(_delay:Number):void
		{
			timer.delay = _delay;
		}
		
		public function start():void
		{
			timer.start();
		}
		
		public function stop():void
		{
			timer.reset();
			timer.stop();
		}
	}
}