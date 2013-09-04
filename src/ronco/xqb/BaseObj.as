package ronco.xqb
{
	import flash.display.*;
	import flash.events.*;
	
	///////////////////////////////////////////////////////////////
	// 基本对象类
	// 具有显示功能的对象的基类，对象池使用
	//////////////////////////////////////////////////////////////
	public class BaseObj extends Sprite
	{
		public var objName:String;		// 对象名
		
		public var cx:int;				// 质点坐标
		public var cy:int;				// 质点坐标
		public var lw:int;				// 逻辑W
		public var lh:int;				// 逻辑H
		public var lx:int;				// 逻辑X
		public var ly:int;				// 逻辑Y		
		
		public var curState:String;	// 当前State
		
		public var mirror:Boolean;		// 是否水平翻转，水平翻转以后，坐标需要变化
		
		public var clickNums:int;		// 被点击的次数
		
		public var logicMask:Bitmap;	// 选区的掩图
		
		public var chat:ObjChat;		// 对话
		public var mapChat:Map;		// 对话队列
		
		public var listener:SceneLogicListener;	// 逻辑侦听器
		
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
		
		public function setXY(_x:int, _y:int):void
		{
			lx = _x;
			ly = _y;
			
			onUpdateXY();
		}
		
		public function onUpdateAni(offTime:int):void
		{
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
			}
			else
			{
				scaleX = 1;
				
				x = lx - cx;
			}
			
			y = ly - cy;			
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
		
		public function initChat(_x:int, _y:int, img:Bitmap, _cx:int, _cy:int, _cw:int, _ch:int):void
		{
			chat = new ObjChat(img, _cx, _cy, _cw, _ch);
			
			addChild(chat);
			
			chat.x = _x;
			chat.y = _y;
			
			chat.visible = false;
		}
		
		public function addChat(name:String, chat:String):void
		{
			if(mapChat == null)
				mapChat = new Map;
			
			mapChat.insert(name, chat);
		}
		
		public function chgChat(name:String):void
		{
			if(mapChat != null && chat != null)
			{
				if(mapChat.hasKey(name))
				{
					MainLog.log.output("chgChat " + name);
					
					chat.chat.text = mapChat.getValue(name) as String;
					
					chat.visible = true;
				}
			}
		}
		
	}
}
