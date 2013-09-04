package ronco.bbxq
{
	import flash.display.Bitmap;
	
	public class BaseObj_MapArea extends BaseObj
	{
		public var isPlayerIn:Boolean = false;
		
		public function BaseObj_MapArea(res:Class, _cx:int, _cy:int, _w:int, _h:int)
		{
			logicMask = new res as Bitmap;
			
			super(_cx, _cy, _w, _h);
		}
	}
}