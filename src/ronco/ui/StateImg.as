package ronco.ui
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.Rectangle;
	
	public class StateImg extends UIElement
	{
		public var lst:Object = new Object;
		public var curState:String;
		
		public function StateImg(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_STATEIMG, _name, _parent);
		}
		
		public function addState(_state:String, _img:Class):void
		{
			lst[_state] = new _img as Bitmap;
			
			addChild(lst[_state]);
			
			lst[_state].visible = false;
		}
		
		public function chgState(_state:String):void
		{
			if(curState != null && lst[curState] != null)
				lst[curState].visible = false;
			
			curState = _state;
			
			lst[curState].visible = true;
		}
	}
}