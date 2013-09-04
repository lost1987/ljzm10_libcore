package ronco.bbxq
{
	public class AvatarRes
	{	
		public var lst:Array = new Array;
		
		public function AvatarRes()
		{
		}
		
		public function addRes(xoff:int, yoff:int, x:int, y:int, w:int, h:int):void
		{
			var obj:Object = new Object;
			
			obj["xoff"] = xoff;
			obj["yoff"] = yoff;
			obj["x"] = x;
			obj["y"] = y;
			obj["w"] = w;
			obj["h"] = h;
			
			lst.push(obj);
		}
	}
}