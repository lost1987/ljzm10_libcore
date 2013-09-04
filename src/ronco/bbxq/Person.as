package ronco.bbxq
{
	import fl.controls.Label;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.*;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import ronco.base.AStar;
	import ronco.base.AStar_Node;
	import ronco.base.ResMgr;
	
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
		
//		public var beginFrame:Array = new Array(0, 1);			//! 每个状态的起始帧
//		public var endFrame:Array = new Array(0, 4);			//! 每个状态的终止帧
//		public var frameTimer:Array = new Array(100, 100);		//! 每个状态的帧时间间隔
		
		public var lstAvatar:Vector.<Object> = new Vector.<Object>;
		
//		public var lstAvatar:Vector.<int> = new Vector.<int>;
//		public var lstImg:Vector.<Bitmap> = new Vector.<Bitmap>;
//		public var lstRect:Vector.<Rectangle> = new Vector.<Rectangle>;
		public var imgRect:Rectangle = new Rectangle;
		
		public var ani:ObjAni;
		public var aniState:String;
//		public var resinfo:AvatarRes;
		
		public var curPersonState:int = STATE_NORMAL;		//! 当前状态
		
		public var curDir:int = DIR_UP_LEFT;				//! 当前方向
		public var curAniIndex:int = 0;					//! 当前状态动画帧
		public var curTime:int = 0;						//! 当前动画时间		
		
		public var destX:int = -1;
		public var destY:int = -1;
		
		public var tx:int;
		public var ty:int;
		
		//public var scene:ronco.bbxq.Scene;					//! 场景，用来判断是否可以位移
		
		public var astar:AStar = new AStar;
		
		public var isShowName:Boolean = false;
		private var labelName:fl.controls.Label;
		private var formatName:TextFormat;
		
		private var lstImg:Sprite = new Sprite;
		
		public function Person(_w:int, _h:int)
		{	
			super(_w / 2, _h, _w, _h);
			
			for(var i:int = 0; i < ronco.bbxq.BaseDef.AVATAR_LAYER_NUMS; ++i)
			{
				var obj:Object = new Object;
				
				obj["img"] = null;
				//obj["rect"] = new Rectangle;
				obj["avatar"] = 0;
				obj["resinfo"] = null;
				obj["old_avatar"] = 0;
				
				lstAvatar.push(obj);
			}
			
			addChild(lstImg);
		}
		
		public function showName(_name:String):void
		{
			if(labelName == null)
				labelName = new fl.controls.Label;
			
			if(formatName == null)
				formatName = new TextFormat(null, 12, 0xffffff);
			
			labelName.htmlText = _name;
			
			labelName.setStyle("textFormat", formatName);
			labelName.autoSize = flash.text.TextFieldAutoSize.CENTER;
			
			labelName.setSize(64, 16);
			
			labelName.x = 0;
			labelName.y = -3;
			
			var lst:Array;
			var gilter:DropShadowFilter
			
			lst = labelName.filters;
			if(lst == null)
			{
				lst = new Array;
				
				gilter = new DropShadowFilter(0, 0, 0x00000000, 1, 4, 4, 5);					
				
				lst.push(gilter);
			}
			else if(lst.length == 0)
			{
				gilter = new DropShadowFilter(0, 0, 0x00000000, 1, 4, 4, 5);					
				
				lst.push(gilter);					
			}
			else
			{
				lst[0].color = 0;
			}
			
			labelName.filters = lst;
			
			addChild(labelName);
		}
		
		private function _buildAniState(state:int, dir:int):void
		{
			if(state == STATE_NORMAL)
			{
				if(dir == DIR_UP_LEFT || dir == DIR_UP_RIGHT)
					aniState = "站立-背面";
				if(dir == DIR_DOWN_LEFT || dir == DIR_DOWN_RIGHT)
					aniState = "站立-正面";				
			}
			else if(state == STATE_WALK)
			{
				if(dir == DIR_UP_LEFT || dir == DIR_UP_RIGHT)
					aniState = "行走-背面";
				if(dir == DIR_DOWN_LEFT || dir == DIR_DOWN_RIGHT)
					aniState = "行走-正面";				
			}
		}
		
		public function init(body:int, clothes:int, hair:int, item:int):void
		{
			lstAvatar[ronco.bbxq.BaseDef.AVATAR_BODY]["old_avatar"] = 
				lstAvatar[ronco.bbxq.BaseDef.AVATAR_BODY]["avatar"];
			lstAvatar[ronco.bbxq.BaseDef.AVATAR_BODY]["avatar"] = body;

			lstAvatar[ronco.bbxq.BaseDef.AVATAR_CLOTHES]["old_avatar"] = 
				lstAvatar[ronco.bbxq.BaseDef.AVATAR_CLOTHES]["avatar"];			
			lstAvatar[ronco.bbxq.BaseDef.AVATAR_CLOTHES]["avatar"] = clothes;
			
			lstAvatar[ronco.bbxq.BaseDef.AVATAR_HAIR]["old_avatar"] = 
				lstAvatar[ronco.bbxq.BaseDef.AVATAR_HAIR]["avatar"];			
			lstAvatar[ronco.bbxq.BaseDef.AVATAR_HAIR]["avatar"] = hair;
			
			lstAvatar[ronco.bbxq.BaseDef.AVATAR_ITEM]["old_avatar"] = 
				lstAvatar[ronco.bbxq.BaseDef.AVATAR_ITEM]["avatar"];			
			lstAvatar[ronco.bbxq.BaseDef.AVATAR_ITEM]["avatar"] = item;
			
			while(lstImg.numChildren > 0)
				lstImg.removeChild(lstImg.getChildAt(0));			
			
			for(var i:int = 0; i < ronco.bbxq.BaseDef.AVATAR_LAYER_NUMS; ++i)
			{
				if(lstAvatar[i]["avatar"] != lstAvatar[i]["old_avatar"])
				{
//					if(lstAvatar[i]["img"] != null)
//						removeChild(lstAvatar[i]["img"]);
					
					lstAvatar[i]["img"] = null;
					
					if(lstAvatar[i]["avatar"] != 0)
					{
						lstAvatar[i]["img"] = new ronco.base.ResMgr.singleton.mapRes["avatar_" + lstAvatar[i]["avatar"]] as Bitmap;
					
						lstAvatar[i]["resinfo"] = AvatarMgr.singleton.getAvatarRes(lstAvatar[i]["avatar"]);
						
						//addChild(lstAvatar[i]["img"]);
					}
					else
						lstAvatar[i]["resinfo"] = null;
				}
			}

			curPersonState = STATE_NORMAL;
			curDir = DIR_UP_LEFT;
			curAniIndex = 0;
			curTime = 0;		
			
			_buildAniState(curPersonState, curDir);
			
			updateImg();
		}
		
		public function getNextPt():AStar_Node
		{
			var path:Array = astar.path;
			if(path.length > 0)
			{
				var node:AStar_Node = path.shift();
				var ox:int = tx - node.x;
				var oy:int = tx - node.y;
				
				for(var i:int = 0; i < path.length; )
				{
					if(ox == node.x - path[i].x && oy == node.y - path[i].y)
						node = path.shift();
					else
						return node;
				}
				
				return node;
			}
			
			return null;
		}
		
		public function moveTo(_x:int, _y:int):void
		{
			var dx:int = _x / 15;
			var dy:int = _y / 15;
			
			var path:Array = astar.path;
			if(path.length > 0)
			{
				if(path[path.length - 1].x >= dx - 2 && path[path.length - 1].x <= dx + 2 && 
						path[path.length - 1].y >= dy - 2 && path[path.length - 1].y <= dy + 2)
					return ;
			}
				
			astar.findPath(scene.grid, tx, ty, dx, dy);
			
			path = astar.path;
			if(path.length > 0)
			{
				var node:AStar_Node = getNextPt();
				
				destX = node.x * 15;
				destY = node.y * 15;
				
				curPersonState = STATE_WALK;
			}
		}
		
		public function stopMove():void
		{
			curAniIndex = -1;
			
			curPersonState = STATE_NORMAL;
			
			destX = -1;
			destY = -1;
			
			var path:Array = astar.path;
			if(path.length > 0)
				path.splice(0, path.length);
		}
		
		public override function onUpdateAni(offTime:int):void
		{	
			tx = lx / 15;
			ty = ly / 15;
			
			super.onUpdateAni(offTime);
			
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
							//if(scene.canWalk(lx - 4, ly))
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
							//if(scene.canWalk(lx + 4, ly))
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
							//if(scene.canWalk(lx, ly - 2))
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
							//if(scene.canWalk(lx, ly + 2))
								ly += 4;
							
							lup = false;
						}
						else
							ly = destY;
					}
				}
				
				if(ly == destY && lx == destX)
				{
					var path:Array = astar.path;
					if(path.length > 0)
					{
						var node:AStar_Node = getNextPt();
						
						destX = node.x * 15;
						destY = node.y * 15;
					}
				}
				
				if(bUpdate && ly == destY && lx == destX)
					stopMove();
				
				if(lleft)
				{
					lstImg.scaleX = -1;
					
					x = lx + lw - cx;
					
					if(labelName != null)
					{
						labelName.x = -64 + 16;
						labelName.y = -16;
					}
				}
				else
				{
					lstImg.scaleX = 1;
					
					x = lx - cx;
					
					if(labelName != null)
					{
						labelName.x = -32 + 16;
						labelName.y = -16;
					}
				}
				
				y = ly - cy;
				
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
				
				_buildAniState(curPersonState, curDir);
				
				var curFrame:int = ani.countFrame(aniState, curTime);
				
				if(curFrame == -1)
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
		}
		
		private function updateImg():void
		{
			var i:int;
			
			while(lstImg.numChildren > 0)
				lstImg.removeChild(lstImg.getChildAt(0));
			
			if(ani != null && ani.lst[aniState] != null)
			{
				if(curAniIndex >= 0 && curAniIndex < ani.lst[aniState]["frames"])
				{
					var frame:Object = (ani.lst[aniState]["lst"] as Array)[curAniIndex];
					
					for(i = 0; i < (frame["lst"] as Array).length; ++i)
					{
						var resinfo:Object = (frame["lst"] as Array)[i];
						var img:Bitmap = lstAvatar[resinfo["layer"]]["img"];
						var avatarres:AvatarRes = lstAvatar[resinfo["layer"]]["resinfo"]; 
						
						if(img == null)
							continue ;
						
						lstImg.addChild(img);
						
						imgRect.left = avatarres.lst[resinfo["resid"]]["x"];
						imgRect.top = avatarres.lst[resinfo["resid"]]["y"];
						imgRect.right = imgRect.left + avatarres.lst[resinfo["resid"]]["w"];
						imgRect.bottom = imgRect.top + avatarres.lst[resinfo["resid"]]["h"];
						
						img.scrollRect = imgRect;
						img.x = avatarres.lst[resinfo["resid"]]["xoff"] - 245;
						img.y = avatarres.lst[resinfo["resid"]]["yoff"] - 256 + 32;
					}
				}
			}
		}
	}
}