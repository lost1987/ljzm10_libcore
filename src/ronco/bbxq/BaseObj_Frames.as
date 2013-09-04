package ronco.bbxq
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	
	// 帧动画对象
	public class BaseObj_Frames extends BaseObj
	{
		public var img:Bitmap;
		public var imgRect:Rectangle = new Rectangle;

		public var curAniIndex:int = 0;				//! 当前状态动画帧
		public var frameNums:int = 0;					//! 帧数
		public var frameTimer:int = 0;					//! 帧时间间隔
		public var curTime:int = 0;					//! 当前动画时间
		
		public function BaseObj_Frames(res:Class, _cx:int, _cy:int, _w:int, _h:int)
		{
			img = new res as Bitmap;
			
			addChild(img);
			
			super(_cx, _cy, _w, _h);
		}
		
		public function initFrames(frames:int, timer:int):void
		{
			frameNums = frames;
			frameTimer = timer;
			
			curTime = 0;
			curAniIndex = 0;
			
			imgRect.top = 0;
			imgRect.bottom = img.bitmapData.height;			
			imgRect.left = curAniIndex * int(img.bitmapData.width / frames);
			imgRect.right = imgRect.left + int(img.bitmapData.width / frames);
			
			img.scrollRect = imgRect;
		}
		
		public override function onUpdateAni(offTime:int):void
		{
			curTime += offTime;
			
			var curFrame:int = int(curTime / frameTimer); 
			if(curFrame >= frameNums)
			{
				curFrame = 0;
				curTime = 0;
			}
			
			if(curFrame != curAniIndex)
			{
				curAniIndex = curFrame;
				
				imgRect.left = curAniIndex * int(img.bitmapData.width / frameNums);
				imgRect.right = imgRect.left + int(img.bitmapData.width / frameNums);							
				
				img.scrollRect = imgRect;
			}
		}
		
		public override function isIn(_x:int, _y:int):Boolean
		{	
			if(super.isIn(_x, _y))
			{
				if(mirror)
					return ((img.bitmapData.getPixel32(lw - (_x - (x - lw)) + imgRect.left, _y - y + imgRect.top) >> 24) & 0xff) > 25;
				else
					return ((img.bitmapData.getPixel32(_x - x + imgRect.left, _y - y + imgRect.top) >> 24) & 0xff) > 25;
			}
			
			return false;
		}		
	}
}