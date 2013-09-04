package ronco.xqb
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	
	///////////////////////////////////////////////////////////////
	// 基本角色类
	// 角色是可以行走的对象
	//////////////////////////////////////////////////////////////	
	public class Person extends BaseObj
	{
		public static const STATE_NORMAL:int = 0;			//! 静止状态
		public static const STATE_WALK:int = 1;			//! 行走状态
		
		public static const DIR_UP_LEFT:int = 0;			//! 上左
		public static const DIR_UP_RIGHT:int = 1;			//! 上右
		public static const DIR_DOWN_LEFT:int = 2;		//! 下左
		public static const DIR_DOWN_RIGHT:int = 3;		//! 下右
		
		public var beginFrame:Array = new Array(4, 0);			//! 每个状态的起始帧
		public var endFrame:Array = new Array(4, 3);			//! 每个状态的终止帧
		public var frameTimer:Array = new Array(100, 100);		//! 每个状态的帧时间间隔
		
		public var img:Bitmap;
		public var imgRect:Rectangle = new Rectangle;
		
		public var curPersonState:int = STATE_NORMAL;		//! 当前状态
		
		public var curDir:int = DIR_UP_LEFT;				//! 当前方向
		public var curAniIndex:int = 0;					//! 当前状态动画帧
		public var curTime:int = 0;						//! 当前动画时间		
		
		public var destX:int = -1;
		public var destY:int = -1;
		
		public var scene:ronco.xqb.Scene;					//! 场景，用来判断是否可以位移
		
		public function Person(_w:int, _h:int, resImg:Class)
		{	
			super(_w / 2, _h, _w, _h);
			
			img = new resImg as Bitmap;
			
			addChild(img);
			
			updateImg();
		}
		
		public function moveTo(_x:int, _y:int):void
		{
			destX = _x;
			destY = _y;
			
			curPersonState = STATE_WALK;
		}
		
		public override function onUpdateAni(offTime:int):void
		{	
			if(curPersonState >= STATE_NORMAL && curPersonState <= STATE_WALK)
			{
				var bUpdate:Boolean = false;
				
				var lup:Boolean = (curDir == DIR_UP_RIGHT || curDir == DIR_UP_LEFT);
				var lleft:Boolean = (curDir == DIR_UP_LEFT || curDir == DIR_DOWN_LEFT);
				
				if(ly != destY || lx != destX)
					bUpdate = true;
				
				if(destX > 0 || destY > 0)
				{
					if(lx > destX)
					{
						if(lx > destX + 4)
						{
							if(scene.canWalk(lx - 4, ly))
								lx -= 4;
							
							lleft = false;
						}
						else
							lx = destX;
					}
					else if(lx < destX)
					{
						if(lx < destX - 4)
						{
							if(scene.canWalk(lx + 4, ly))
								lx += 4;
							
							lleft = true;
						}
						else
							lx = destX;
					}
					
					if(ly > destY)
					{
						if(ly > destY + 4)
						{
							if(scene.canWalk(lx, ly - 4))
								ly -= 4;
							
							lup = true;
						}
						else
							ly = destY;
					}
					else if(ly < destY)
					{
						if(ly < destY - 4)
						{
							if(scene.canWalk(lx, ly + 4))
								ly += 4;
							
							lup = false;
						}
						else
							ly = destY;
					}
				}
				
				if(bUpdate && ly == destY && lx == destX)
				{
					curAniIndex = -1;
					
					curPersonState = STATE_NORMAL;
				}
				
				mirror = lleft;
				
				onUpdateXY();
				
//				if(!lleft)
//				{
//					x = lx - lw + cx;
//					
//					scaleX = 1.0;
//				}
//				else
//				{
//					x = lx + cx;
//					
//					scaleX = -1.0;
//				}
//				
//				y = ly - cy;
				
				if(lleft)
				{
					if(lup)
					{
						curDir = DIR_UP_LEFT;
					}
					else
					{
						curDir = DIR_DOWN_LEFT;
					}
				}
				else
				{
					if(lup)
					{
						curDir = DIR_UP_RIGHT;
					}
					else
					{
						curDir = DIR_DOWN_RIGHT;
					}					
				}
				
				curTime += offTime;
				
				var curFrame:int = int(curTime / frameTimer[curPersonState]);
				
				if(curFrame > endFrame[curPersonState] - beginFrame[curPersonState])
				{
					curFrame = 0;
					curTime = 0;
				}
				
				if(curFrame != curAniIndex)
				{
					curAniIndex = curFrame;
					
					updateImg();
				}
			}
			
			//updateImg();
			
//			if(curState == STATE_WALK)
//			{
//				if(destX > 0 || destY > 0)
//				{
//					if(x > destX + 8)
//						x -= 8;
//					if(x < destX - 8)
//						x += 8;
//					
//					if(y > destY + 8)
//					{
//						y -= 8;
//						
//						curDir = DIR_DOWN;
//					}
//					if(y < destY - 8)
//					{
//						y += 8;
//						
//						curDir = DIR_UP;
//					}
//				}
//				
//				if(curAniIndex >= 5)
//					curAniIndex = 0;
//				else
//					++curAniIndex;
//				
//				updateImg();
//			}
		}
		
		private function updateImg():void
		{
			var llx:int = 0;				// 当前选择帧的逻辑x
			var lly:int = 0;				// 当前选择帧的逻辑y
			var bFZ:Boolean = false;	// 是否需要翻转图片
			
			//! 首先根据方向判断是否需要翻转
			if(curDir == DIR_UP_RIGHT || curDir == DIR_DOWN_RIGHT)
				bFZ = false;
			else if(curDir == DIR_UP_LEFT || curDir == DIR_DOWN_LEFT)
				bFZ = true;
			
			//! 根据方向判断逻辑y值
			if(curDir == DIR_UP_RIGHT || curDir == DIR_UP_LEFT)
				lly = 0;
			else if(curDir == DIR_DOWN_RIGHT || curDir == DIR_DOWN_LEFT)
				lly = 1;
			
			if(curPersonState >= STATE_NORMAL && curPersonState <= STATE_WALK)
			{
				if(curAniIndex >= 0 && curAniIndex <= endFrame[curPersonState] - beginFrame[curPersonState])
					llx = beginFrame[curPersonState] + curAniIndex;
				else
					llx = beginFrame[curPersonState];
			}
			
			//MainLog.log.output("updateImg " + lx + " " + ly);
			
			imgRect.left = llx * lw;
			imgRect.right = imgRect.left + lw;
			imgRect.top = lly * lh;
			imgRect.bottom = imgRect.top + lh;
			
			img.scrollRect = imgRect;
			
//			if(bFZ)
//				scaleX = -1.0;
//			else
//				scaleX = 1.0;
			
//			if(bFZ)
//				x = lx - lw;
//			else
//				x = lx;				
//			
//			y = ly;
			
			
//			if(curState == STATE_NORMAL)
//			{
//				imgRect.left = 0;
//				
//				if(curDir == DIR_UP)
//					imgRect.top = 0;
//				else
//					imgRect.top = 128 / 2;					
//				
//				imgRect.right = imgRect.left + 144 / 3;
//				imgRect.bottom = imgRect.top + 128 / 2;				
//			}
//			else
//			{
//				imgRect.left = (int(curAniIndex / 3) + 1) * 144 / 3;
//				
//				if(curDir == DIR_UP)
//					imgRect.top = 0;
//				else
//					imgRect.top = 128 / 2;					
//				
//				imgRect.right = imgRect.left + 144 / 3;
//				imgRect.bottom = imgRect.top + 128 / 2;				
//			}
//			
//			var scale:Number = y / (560 - 150);
//			scale += 0.5;
//			if(scale > 1.0)
//				scale = 1.0;
//			
//			scaleX = scaleY = scaleZ = scale;
//			
//			img.scrollRect = imgRect;
		}
	}
}