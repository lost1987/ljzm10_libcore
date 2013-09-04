package ronco.bbxq
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.Rectangle;
	
	public class BaseObj_SWFState extends BaseObj
	{
		public var ani:MovieClip;
		
		//! "name","begin","end","loop"
		public var lstAniState:Object = new Object;				//! 状态表
		public var curAniState:String;
		
		public function BaseObj_SWFState(res:Class, _cx:int, _cy:int, _w:int, _h:int)
		{
			ani = new res as MovieClip;
			
			ani.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			addChild(ani);
			
			super(_cx, _cy, _w, _h);
		}
		
		public function addAniState(_name:String, _begin:int, _end:int, _loop:Boolean):void
		{
			var obj:Object = new Object;
			
			obj["name"] = _name;
			obj["begin"] = _begin;
			obj["end"] = _end;
			obj["loop"] = _loop;
			
			lstAniState[_name] = obj;
		}
		
		public function chgAniState(_name:String):void
		{
			curAniState = _name;
			
			if(curAniState != null && lstAniState[curAniState] != null)
				ani.gotoAndPlay(lstAniState[curAniState]["begin"]);
		}		
		
		public function onEnterFrame(e:Event):void
		{
			if(curAniState != null && lstAniState[curAniState] != null)
			{
				if(ani.currentFrame >= lstAniState[curAniState]["end"])
				{
					if(lstAniState[curAniState]["loop"])
						ani.gotoAndPlay(lstAniState[curAniState]["begin"]);
					else
						ani.stop();
				}
			}
		}		
	}
}