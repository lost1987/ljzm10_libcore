package ronco.base
{
	import flash.display.*;
	
	public class AStar_Grid
	{
		public var w:int;
		public var h:int;
		public var lst:Vector.<AStar_Node> = new Vector.<AStar_Node>;
		
		public function AStar_Grid()
		{
		}
		
		public function makeWithBitmap(bmp:BitmapData):void
		{
			w = bmp.width;
			h = bmp.height;
			
			lst.splice(0, lst.length);
			
			var x:int;
			var y:int;
			
			for(y = 0; y < h; ++y)
			{
				for(x = 0; x < w; ++x)
				{
					var node:AStar_Node = new AStar_Node(x, y);
					
					if(((bmp.getPixel32(x, y) >> 24) & 0xff) > 25)
						node.walkable = true;
					else
						node.walkable = false;
					
					lst.push(node);
				}
			}
		}
		
		public function getNode(x:int, y:int):AStar_Node
		{
			if(x >= 0 && x < w && y >= 0 && y < h)
				return lst[x + y * w];
			
			return null;
		}
	}
}