package ronco.xqb
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	
	// 单图片多状态
	public class BaseObj_ImgState extends BaseObj
	{
		public var img:Bitmap;
		public var imgRect:Rectangle = new Rectangle;
		public var mapState:Map = new Map;
		
		public function BaseObj_ImgState(res:Class, _cx:int, _cy:int, _w:int, _h:int)
		{
			img = new res as Bitmap;
			
			addChild(img);
			
			super(_cx, _cy, _w, _h);
		}
		
		// 增加State
		public function addState(name:String, frame:int):void
		{
			mapState.insert(name, frame);
		}
		
		public override function chgState(name:String):void
		{
			if(mapState.hasKey(name))
			{
				var index:int = (mapState.getValue(name) as int);
				
				imgRect.top = 0;
				imgRect.bottom = img.bitmapData.height;			
				imgRect.left = index * int(img.bitmapData.width / mapState.lst.length);
				imgRect.right = imgRect.left + int(img.bitmapData.width / mapState.lst.length);
				
				img.scrollRect = imgRect;
			}
			
			super.chgState(name);
		}
		
		public override function isIn(_x:int, _y:int):Boolean
		{	
			if(super.isIn(_x, _y))
			{	
				if(mirror)
					return ((img.bitmapData.getPixel32(lw - (_x - (x - lw)) + imgRect.left, _y - y + imgRect.top) >> 24) & 0xff) > 25;
				else
					return ((img.bitmapData.getPixel32(_x - x + imgRect.left, _y - y + imgRect.top) >> 24) & 0xff) > 25;
			}
			
			return false;
		}
		
	}
}