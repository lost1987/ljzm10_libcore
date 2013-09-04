package ronco.bbxq
{
	import flash.display.*;
	import flash.events.*;
	
	import ronco.base.*;
	
	///////////////////////////////////////////////////////////////
	// 基本对象类
	// 具有显示功能的对象的基类，对象池使用
	//////////////////////////////////////////////////////////////
	public class BaseObj extends Sprite
	{
		public var objName:String;				// 对象名
		
		public var cx:int;						// 质点坐标
		public var cy:int;						// 质点坐标
		public var lw:int;						// 逻辑W
		public var lh:int;						// 逻辑H
		public var lx:int;						// 逻辑X
		public var ly:int;						// 逻辑Y		
		
		public var curState:String;			// 当前State
		
		public var mirror:Boolean;				// 是否水平翻转，水平翻转以后，坐标需要变化
		
		public var clickNums:int;				// 被点击的次数
		
		public var logicMask:Bitmap;			// 选区的掩图
		
		public var bmpShadow:Bitmap;			// 影子
		
		public var chat:ObjChat;				// 对话
		public var mapChat:Object;				// 对话队列
		public var chatTime:int = 0;			// 对话显示剩余时间
		public var curChat:ObjChatInfo;		// 当前显示的对话名
		public var randomChat:Vector.<String>;
		
		public var tips:Tips_Normal;
		public var isShowTips:Boolean = true;		// 是否显示tpis
		
		public var isMouseIn:Boolean = false;		// 是否鼠标移入
		public var isPersonNear:Boolean = false;	// 是否角色靠近才触发事件
		
		public var listener:SceneLogicListener;	// 逻辑侦听器
		
		public var npcState:MovieClip;				//
		public var npcStateID:int = 0;
		
		public var scene:ronco.bbxq.Scene;			//! 场景
		
		public function BaseObj(_cx:int, _cy:int, _w:int, _h:int)
		{
			super();
			
			cx = _cx;
			cy = _cy;
			
			lw = _w;
			lh = _h;
			
			mirror = false;
			
			clickNums = 0;
			
			//addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function addRandomChat(chat:String):void
		{
			if(randomChat == null)
				randomChat = new Vector.<String>;
			
			randomChat.push(chat);
		}
		
		public function setNPCState(res:Class, _x:int, _y:int, npcstateid:int):void
		{
			if(npcState != null)
				removeChild(npcState);
			
			npcState = null;
			
			npcState = new res as MovieClip;
			
			npcState.x = _x;
			npcState.y = _y;
			
			addChild(npcState);
			
			npcStateID = npcstateid;
			
			if(mirror)
			{
				if(npcState != null)
					npcState.scaleX = -1;
			}
		}
		
		public function clearNPCState():void
		{
			if(npcState != null)
			{
				removeChild(npcState);
				
				npcState = null;
				npcStateID = 0;
			}
		}
		
		public function setShadow(_shadowLayer:Sprite, resname:String):void
		{
			bmpShadow = new ResMgr.singleton.mapRes[resname] as Bitmap;
			
			bmpShadow.x = lx - bmpShadow.width / 2;
			bmpShadow.y = ly - bmpShadow.height / 2;
			
			_shadowLayer.addChild(bmpShadow);
		}
		
		public function setXY(_x:int, _y:int):void
		{
			lx = _x;
			ly = _y;
			
			onUpdateXY();
		}
		
		public function onUpdateAni(offTime:int):void
		{
			if(chatTime <= 0 && randomChat != null && randomChat.length > 0)
			{
				if(chatTime <= -3000)
				{
					chatTime = 0;
					
					var num:int = Math.floor((Math.random() * 100));
					if(num > 70)
					{
						num = Math.floor((Math.random() * randomChat.length));
						
						chgChat(randomChat[num]);
					}
				}
				else
					chatTime -= offTime;
			}
			
			if(chatTime > 0)
			{
				if(chat != null && chat.visible && curChat != null)
				{
					chat.x = x + curChat.ox;
					chat.y = y + curChat.oy;
					
					chat.chat.text = curChat.info;
				}
				
				if(chatTime > offTime)
					chatTime -= offTime;
				else
				{
					chatTime = 0;
					
					chat.visible = false;
					
					curChat = null;
					
					//setShowTips(true);
				}
			}
		}
		
		public function setMirrorMode(bMirror:Boolean):void
		{
			mirror = bMirror;
			
			onUpdateXY();
		}
		
		public function onUpdateXY():void
		{
			if(mirror)
			{
				scaleX = -1;
				
				x = lx + lw - cx;
				
				if(npcState != null)
					npcState.scaleX = -1;
			}
			else
			{
				scaleX = 1;
				
				x = lx - cx;
			}
			
			y = ly - cy;
			
			if(bmpShadow != null)
			{
				bmpShadow.x = lx - bmpShadow.width / 2;
				bmpShadow.y = ly - bmpShadow.height / 2;
			}
		}
		
		public function chgState(name:String):void
		{
			curState = name;
		}
		
		public function isIn(_x:int, _y:int):Boolean
		{
			if(mirror)
			{
				if(_x >= (x - lw) && _y >= y && _x < (x - lw) + lw && _y < y + lh)
				{
					if(logicMask != null)
						return ((logicMask.bitmapData.getPixel32(lw - (_x - (x - lw)), _y - y) >> 24) & 0xff) > 25;
					
					return true;					
				}
			}
			else
			{
				if(_x >= x && _y >= y && _x < x + lw && _y < y + lh)
				{
					if(logicMask != null)
					{
						//MainLog.log.output("getPixel32 " + ((logicMask.bitmapData.getPixel32(_x - x, _y - y) >> 24) & 0xff));
						
						return ((logicMask.bitmapData.getPixel32(_x - x, _y - y) >> 24) & 0xff) > 25;
					}
					
					return true;					
				}
			}
			
			return false;
		}
		
		public function onMouseUp(e:MouseEvent):void
		{
			++clickNums;
			
			if(listener != null)
				listener.onClick(this, objName, clickNums);
		}
		
		public function onClick():void
		{
			++clickNums;
			
			if(listener != null)
				listener.onClick(this, objName, clickNums);			
		}
		
		public function isProcMouseInOut():Boolean
		{
			return tips != null || listener != null;
		}
		
		public function onMouseIn(e:MouseEvent):void
		{
			isMouseIn = true;
			
			if(isShowTips && tips != null)
				tips.visible = true;
			
			if(listener != null)
				listener.onMouseIn(this);			
		}
		
		public function onMouseOut(e:MouseEvent):void
		{
			isMouseIn = false;
			
			if(isShowTips && tips != null)
				tips.visible = false;
			
			if(listener != null)
				listener.onMouseOut(this);
		}		
		
//		public function initChat(_x:int, _y:int, _w:int, _h:int):void
//		{
//			chat = new ObjChat(_w, _h);
//			
//			addChild(chat);
//			
//			chat.x = _x;
//			chat.y = _y;
//			
//			chat.visible = false;
//		}
		
		public function addChat(name:String, chat:String, _x:int, _y:int, _w:int, _h:int):void
		{
			if(mapChat == null)
				mapChat = new Object;
			
			mapChat[name] = new ObjChatInfo;
			
			mapChat[name].info = chat;
			mapChat[name].ox = _x;
			mapChat[name].oy = _y;
			mapChat[name].w = _w;
			mapChat[name].h = _h;
			
			//mapChat.insert(name, chat);
		}
		
		public function chgChatEx(name:String, info:String):void
		{
			if(mapChat != null)
			{
				if(mapChat[name] != null)
				{
					//MainLog.singleton.output("chgChat " + name);
					
					if(chat == null)
						chat = new ObjChat((mapChat[name] as ObjChatInfo).w, (mapChat[name] as ObjChatInfo).h);
					
					scene.addChild(chat);
					//					chat.x = lx;
					//					chat.y = ly;
					
					curChat = mapChat[name] as ObjChatInfo;
					
					chat.x = x + curChat.ox;
					chat.y = y + curChat.oy;
					
					chat.chat.text = curChat.info = info;
					
					chat.visible = true;
					chatTime = 2 * 1000;
					
					setShowTips(false);
				}
			}
		}		
		
		public function chgChat(name:String):void
		{
			if(mapChat != null)
			{
				if(mapChat[name] != null)
				{
					//MainLog.singleton.output("chgChat " + name);
					
					if(chat == null)
						chat = new ObjChat((mapChat[name] as ObjChatInfo).w, (mapChat[name] as ObjChatInfo).h);
					
					scene.addChild(chat);
//					chat.x = lx;
//					chat.y = ly;
					
					curChat = mapChat[name] as ObjChatInfo;
					
					chat.x = x + curChat.ox;
					chat.y = y + curChat.oy;
					
					chat.chat.text = curChat.info;
					
					chat.visible = true;
					chatTime = 3 * 1000;
					
					setShowTips(false);
				}
			}
		}
		
		public function initTips(_info:String, _x:int, _y:int, _w:int, _h:int):void
		{
			tips = new Tips_Normal(_info, _w, _h);
			
			scene.addChild(tips);
			
			tips.x = x + _x;
			tips.y = y + _y;
			
			tips.visible = false;
		}
		
		public function setShowTips(_isShow:Boolean):void
		{
			isShowTips = _isShow;
			
			if(!isShowTips && tips != null)
				tips.visible = false;
		}

	}
}
