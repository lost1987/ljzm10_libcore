package ronco.xqb
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	
	// 单图片
	public class BaseObj_Img extends BaseObj
	{
		public var img:Bitmap;
		
		public function BaseObj_Img(res:Class, _cx:int, _cy:int, _w:int, _h:int)
		{
			img = new res as Bitmap;
			
			addChild(img);
			
			super(_cx, _cy, _w, _h);
		}
		
		public override function isIn(_x:int, _y:int):Boolean
		{
			//return this.hitTestPoint(_x, _y);
			
			if(super.isIn(_x, _y))
			{
				if(mirror)
					return (((img.bitmapData.getPixel32(lw - (_x - (x - lw)), _y - y) >> 24) & 0xff) > 25);
				else
					return (((img.bitmapData.getPixel32(_x - x, _y - y) >> 24) & 0xff) > 25);
			}
			
			return false;
		}
	}
}