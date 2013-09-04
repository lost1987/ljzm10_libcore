package ronco.base
{
	//! 这个类主要用来处理键盘控制的动作类游戏，要求能处理搓招
	
	public class CtrlKeyboard
	{
		public static const MAX_KEY_NUMS:int		=	256;		//! 最大的按键数
		public static const MAX_KEY_DELAY:int		=	500;		//! 按键最长延迟，0.5秒
		
		public static var singleton:CtrlKeyboard = new CtrlKeyboard();
		
		public var lstCtrl:Vector.<Object> = new Vector.<Object>();
		public var lstCtrlPool:Vector.<Object> = new Vector.<Object>();
		
		public var lstCurState:Vector.<Boolean> = new Vector.<Boolean>(MAX_KEY_NUMS, false);
		
		//! 组合键
		//! "id" 表示组合键的id，唯一标识
		//! "lst" 表示组合键，是一个 Vector.<Object>，其中 "keycode" 是按键，"isdown" 表示是否按下
		//! "time" 表示上一个合法按键按下的时间，判断时间间隔用
		//! "progress" 表示组合键合理的进度，0表示未触发
		//! "func" 表示这个组合键触发后调用的函数
		public var lstKeyCombo:Vector.<Object> = new Vector.<Object>();
		
		//! 单个按键
		//! "id" 表示按键的id，唯一标识
		//! "keycode" 表示按键
		//! "time" 表示按键按下的时间，判断按住用
		//! "isdown" 表示按键是否按下
		//! "ishold" 表示是否获取按键按住的消息
		//! "func" 表示按键触发后调用的函数 func(isdown, pushtime)
		public var lstKey:Vector.<Object> = new Vector.<Object>();
		
		public function CtrlKeyboard()
		{
		}
		
		public function addKey(id:int, keycode:int, ishold:Boolean, func:Function):void
		{
			var o:Object = new Object();
			
			o["id"] = id;
			o["keycode"] = keycode;
			o["time"] = 0;
			o["isdown"] = false;
			o["ishold"] = ishold;
			o["func"] = func;
			
			lstKey.push(o);
		}		
		
		public function addKeyCombo(id:int, lst:Vector.<Object>, func:Function):void
		{
			var o:Object = new Object();
			
			o["id"] = id;
			o["lst"] = lst;
			o["time"] = 0;
			o["progress"] = 0;
			o["func"] = func;
			
			lstKeyCombo.push(o);
		}
		
		private function _pushCtrl(keycode:int, isdown:Boolean, time:int):void
		{
			var c:Object;
			
			if(lstCtrlPool.length > 0)
				c = lstCtrlPool.pop();
			else
				c = new Object();
			
			c["keycode"] = keycode;
			c["isdown"] = isdown;
			c["time"] = time;
			
			lstCtrl.push(c);
		}
		
		private function _popCtrl():Object
		{
			if(lstCtrl.length == 0)
				return null;
			
			var c:Object = lstCtrl[0];
			lstCtrl.splice(0, 1);
			
			return c;
		}
		
		public function onKeyDown(keycode:int, time:int):void
		{
			if(!lstCurState[keycode])
			{
				lstCurState[keycode] = true;
				
				_pushCtrl(keycode, true, time);
			}
		}
		
		public function onKeyUp(keycode:int, time:int):void
		{
			if(lstCurState[keycode])
			{
				lstCurState[keycode] = false;
				
				_pushCtrl(keycode, false, time);
			}
		}
		
		public function onProcCtrl(curtime:int):void
		{
			var c:Object = _popCtrl();
			var i:int;
			var ko:Object;
			var kol:Vector.<Object>;
			
			if(c == null)
			{
				for(i = 0; i < lstKey.length; ++i)
				{
					ko = lstKey[i];
					
					if(ko == null)
						continue;
					
					if(ko["isdown"] && ko["ishold"])
					{	
						if(ko["func"] != null)
							ko["func"](ko["isdown"], curtime - ko["time"]);						
					}
				}
				
				for(i = 0; i < lstKeyCombo.length; ++i)
				{
					ko = lstKeyCombo[i];
					kol = ko["lst"] as Vector.<Object>;
					
					if(kol == null || kol.length == 0)
						continue;
					
					if(curtime - ko["time"] > MAX_KEY_DELAY)
					{
						//trace("key combo false!" + ko["progress"]);
						
						ko["progress"] = 0;
					}		
				}
			}
			
			while(c != null)
			{
				for(i = 0; i < lstKey.length; ++i)
				{
					ko = lstKey[i];
					
					if(ko == null)
						continue;
				
					if(c["keycode"] == ko["keycode"])
					{
						ko["isdown"] = c["isdown"];
						ko["time"] = c["time"];
						
						if(ko["func"] != null)
							ko["func"](ko["isdown"], curtime - ko["time"]);						
					}
				}
				
				for(i = 0; i < lstKeyCombo.length; ++i)
				{
					ko = lstKeyCombo[i];
					kol = ko["lst"] as Vector.<Object>; 
					
					if(kol == null || kol.length == 0)
						continue;
					
					if(ko["progress"] == 0)
					{
						if(kol[0]["keycode"] == c["keycode"] && kol[0]["isdown"] == c["isdown"])
						{
							//trace("key combo begin!" + ko["progress"]);
							
							ko["time"] = c["time"];
							
							ko["progress"] = ko["progress"] + 1;
						}
					}
					else if(ko["progress"] > 0 && ko["progress"] < kol.length)
					{
						if(kol[ko["progress"]]["keycode"] == c["keycode"] && 
							kol[ko["progress"]]["isdown"] == c["isdown"] && 
							c["time"] - ko["time"] < MAX_KEY_DELAY)
						{
							//trace("key combo continue..." + ko["progress"]);
							
							ko["time"] = c["time"];
							
							ko["progress"] = ko["progress"] + 1;
						}		
						else if(c["time"] - ko["time"] > MAX_KEY_DELAY)
						{
							//trace("key combo false!" + ko["progress"]);
							
							ko["progress"] = 0;
						}
					}
					
					
					if(ko["progress"] == kol.length)
					{
						if(ko["func"] != null)
							ko["func"]();
						
						//trace("key combo ok!");
						
						ko["progress"] = 0;
					}
				}
				
				lstCtrlPool.push(c);
				
				c = _popCtrl();
			} // for
		} // while
	}
}