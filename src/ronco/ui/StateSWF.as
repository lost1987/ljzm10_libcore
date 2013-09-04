package ronco.ui
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.Rectangle;
	
	public class StateSWF extends UIElement
	{
		public var ani:MovieClip;
		
		// "name", "begin", "end", "loop"
		public var lst:Object = new Object;
		
		public var curState:String;
		public var stateMouseOn:String;
		public var stateMouseOff:String;
		
		public function StateSWF(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_STATESWF, _name, _parent);
		}
		
		public function init(res:Class):void
		{
			ani = new res as MovieClip;
			
			ani.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			super.initEx(ani.width, ani.height);
			
			addChild(ani);
		}
		
		public function addState(_name:String, _begin:int, _end:int, _loop:Boolean):void
		{
			var state:Object = new Object;
			
			state["name"] = _name;
			state["begin"] = _begin;
			state["end"] = _end;
			state["loop"] = _loop;
			
			lst[_name] = state;
		}
		
		public function chgState(_name:String):void
		{
			curState = _name;
			
			if(curState != null && lst[curState] != null)
			{
				//ani.play();
				ani.gotoAndPlay(lst[curState]["begin"]);
			}
		}
		
		public function onEnterFrame(e:Event):void
		{
			if(curState != null && lst[curState] != null)
			{
				if(ani.currentFrame >= lst[curState]["end"])
				{
					if(lst[curState]["loop"])
						ani.gotoAndPlay(lst[curState]["begin"]);
					else
						ani.stop();
				}
			}
		}
		
		//! 处理操作，如果返回true，表示截获操作，不继续交给后面的控件处理，否则会交给后面的控件处理
		public override function onCtrl(ctrl:UICtrl):Boolean
		{
			if(stateMouseOn == null)
				return false;
			
			if(isIn(ctrl.mx, ctrl.my))
			{
				if(curState != stateMouseOn)
					chgState(stateMouseOn);
			}
			else
			{
				if(curState != stateMouseOff)
					chgState(stateMouseOff);
			}
			
			return false;
		}						
	}
}