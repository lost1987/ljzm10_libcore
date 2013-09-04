package ronco.base
{
	import flash.events.*;
	
	public interface ListenerCtrl
	{
		function onMouseOver(e:MouseEvent):Boolean;
		
		function onMouseOut(e:MouseEvent):Boolean;
		
		function onMouseDown(e:MouseEvent):Boolean;
		
		function onMouseUp(e:MouseEvent):Boolean;
		
		function onKeyDown(e:KeyboardEvent):Boolean;
		
		function onMouseWheel(e:MouseEvent):Boolean;
		
		function onDoubleClick(e:MouseEvent):Boolean;
	}
}