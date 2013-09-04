package ronco.bbxq
{
	import flash.display.*;
	
	// flash对象
	public class BaseObj_SWF extends BaseObj
	{
		public var ani:MovieClip;
		
		public function BaseObj_SWF(res:Class, _cx:int, _cy:int, _w:int, _h:int)
		{
			ani = new res as MovieClip;
			
			addChild(ani);
			
			super(_cx, _cy, _w, _h);
		}
		
//		public override function isIn(_x:int, _y:int):Boolean
//		{	
//			if(super.isIn(_x, _y))
//			{
//				MainLog.log.output("BaseObj_SWF isIn ");
//				
//				if(ani.hitTestPoint(_x - x, _y - y))
//					MainLog.log.output("BaseObj_SWF isIn ok.");
//				
//				if(mirror)
//					return ani.hitTestPoint(lw - (_x - (x - lw)), _y - y);
//				else
//					return ani.hitTestPoint(_x - x, _y - y);
//			}
//			
//			return false;
//		}			
	}
}