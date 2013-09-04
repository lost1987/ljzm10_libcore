package ronco.xqb
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	
	public class BaseObj_FrameState extends BaseObj
	{
		public var img:Bitmap;
		public var imgRect:Rectangle = new Rectangle;
		
		public var mapState:Map = new Map;				//! 状态表
		
		public var curAniIndex:int = 0;				//! 当前状态动画帧
		public var curTime:int = 0;					//! 当前动画时间
		
		public var curStateNode:BOFrameStateNode;		//! 当前的状态节点
		
		public var maxFrames:int = 0;					//! 帧总数
		
		public function BaseObj_FrameState(res:Class, _cx:int, _cy:int, _w:int, _h:int)
		{
			img = new res as Bitmap;
			
			addChild(img);
			
			super(_cx, _cy, _w, _h);
		}
		
		// 增加State
		public function addState(name:String, begin:int, end:int, time:int, bLoop:Boolean):void
		{
			var node:BOFrameStateNode = new BOFrameStateNode;
			
			node.beginFrame = begin;
			node.endFrame = end;
			node.frameTimer = time;
			node.bLoop = bLoop;
			
			mapState.insert(name, node);
		}
		
		public override function chgState(name:String):void
		{
			if(mapState.hasKey(name))
			{
				curStateNode = (mapState.getValue(name) as BOFrameStateNode);
				
				imgRect.top = 0;
				imgRect.bottom = img.bitmapData.height;			
				imgRect.left = curStateNode.beginFrame * int(img.bitmapData.width / maxFrames);
				imgRect.right = imgRect.left + int(img.bitmapData.width / maxFrames);
				
				img.scrollRect = imgRect;
				
				curTime = 0;
			}
			
			super.chgState(name);
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
		
		public override function onUpdateAni(offTime:int):void
		{
			if(curStateNode != null && curStateNode.endFrame > curStateNode.beginFrame)
			{
				curTime += offTime;
				
				var frameNums:int = curStateNode.endFrame - curStateNode.beginFrame + 1;
				var curFrame:int = int(curTime / curStateNode.frameTimer); 
				if(curFrame >= frameNums)
				{
					if(curStateNode.bLoop)
					{
						curFrame = 0;
						curTime = 0;						
					}
					else
					{
						curFrame = frameNums - 1;
					}
				}
				
				if(curFrame != curAniIndex)
				{
					curAniIndex = curFrame;
					
					imgRect.left = (curAniIndex + curStateNode.beginFrame) * int(img.bitmapData.width / maxFrames);
					imgRect.right = imgRect.left + int(img.bitmapData.width / maxFrames);							
					
					img.scrollRect = imgRect;
				}				
			}
		}		
		
	}
}