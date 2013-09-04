package ronco.bbxq
{
	public interface SceneLogicListener
	{
		function onClick(obj:BaseObj, objName:String, click_nums:int):void;
		
		function onMouseIn(obj:BaseObj):void;
		
		function onMouseOut(obj:BaseObj):void;
		
		function onIMove(x:int, y:int):void;
		
		function onInMapArea(obj:BaseObj):void;
		
		function onUpdate(offtime:int):void;
	}
}