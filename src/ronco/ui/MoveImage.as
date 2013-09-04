package ronco.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class MoveImage extends UIElement
	{
		public var strom:Vector.<Object> = new Vector.<Object>;	//! 所有需要移动图片的仓库
		private var timer:Timer = new Timer(24);	//! 计时器
		private var AniFrames:int = 30;			//! 动画固定帧数
		private var AniCurFrames:int = 0;		//! 动画当前帧数
		private var stromSize:int = 0;
		private var callback:Function = null;
		
		public function MoveImage(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_MOVEIMAGE, _name, _parent);
			timer.addEventListener(TimerEvent.TIMER, _onTimer);
		}
		
		public function clean():void
		{
			var i:int = 0;
			var len:int = strom.length;
			
			for(i = 0; i < len; ++i)
			{
				if(strom[i] != null)
				{
					removeChild(strom[i]["图片"]);
				}
			}
			
			len = strom.length;
			i = 0;
			
			while(i < len)
			{
				strom.pop();
				
				++i;
			}
			
			//strom.splice(0, len);
		}
		
		public function init(_callback:Function):void
		{
			callback = _callback;
		}
		
		public function add(res:BitmapData, begin_x:int, begin_y:int, end_x:int, end_y:int):void
		{
			var obj:Object = new Object();
			
			var bmp:Bitmap = new Bitmap(res);
			bmp.x = begin_x;
			bmp.y = begin_y;
			
			obj["图片"] = bmp;
			addChild(bmp);
			obj["x位移"] = (end_x - begin_x) / AniFrames;
			obj["y位移"] = (end_y - begin_y) / AniFrames;
			
			strom.push(obj);
		}
		
		public function start():void
		{
			AniCurFrames = 0;
			timer.start();
		}
		
		public function _onTimer(e:TimerEvent):void
		{
			if(AniCurFrames >= AniFrames)
			{
				AniCurFrames = 0;
				clean();
				callback();
				timer.stop();
			}
			else
			{
				AniCurFrames++;
				AniUpdate();
				if(AniCurFrames == AniFrames)
				{
					AniCurFrames = 0;
					clean();
					callback();
					timer.stop();
				}
			}
		}
		
		public function AniUpdate():void
		{
			var len:int = strom.length;
			var i:int = 0;
			for(i = 0; i < len; ++i)
			{
				strom[i]["图片"].x += strom[i]["x位移"];
				strom[i]["图片"].y += strom[i]["y位移"];
			}
		}
		
	}
}