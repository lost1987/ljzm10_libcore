package ronco.xqb
{
	import flash.display.*;
	import flash.geom.*;

	public class BitmapBuilder
	{
		public static var singleton:BitmapBuilder = new BitmapBuilder;		// singleton
		
		public var rect:Rectangle = new Rectangle(0, 0, 0, 0);
		public var pt:Point = new Point(0, 0);
		
		public function BitmapBuilder()
		{
		}
		
		//! 9宫拼图
		public function buildBitmap(bmpdata:BitmapData, src:BitmapData, left:int, top:int, right:int, bottom:int, width:int, height:int):void
		{
			if(bmpdata.width >= width && bmpdata.height >= height)
			{
				var x:int = 0;
				var y:int = 0;
				var w:int = 0;
				var h:int = 0;
				
				//! 左上角
				rect.left = 0;
				rect.top = 0;
				rect.width = left;
				rect.height = top;
				
				pt.x = 0;
				pt.y = 0;
				bmpdata.copyPixels(src, rect, pt);
				
				//! 上面中间
				rect.left = left;
				rect.top = 0;
				rect.height = top;
				
				pt.y = 0;
				
				for(x = left; x < width - (src.width - right); )
				{
					if(x + right - left <= width - (src.width - right))
						w = right - left;
					else
						w = width - (src.width - right) - x;
					
					rect.width = w;
					
					pt.x = x;
					bmpdata.copyPixels(src, rect, pt);
					
					x += w;					
				}

				//! 右上角
				rect.left = right;
				rect.top = 0;
				rect.width = src.width - right;
				rect.height = top;
				
				pt.x = width - (src.width - right);
				pt.y = 0;
				bmpdata.copyPixels(src, rect, pt);
				
				//! 中间
				rect.top = top;
				
				for(y = top; y < height - (src.height - bottom); )
				{
					if(y + bottom - top <= height - (src.height - bottom))
						h = bottom - top;
					else
						h = height - (src.height - bottom) - y;
					
					rect.height = h;
					pt.y = y;
					
					//! 中间左边
					rect.left = 0;
					rect.width = left;
					
					pt.x = 0;
					bmpdata.copyPixels(src, rect, pt);
					
					//! 中间中间
					rect.left = left;
					rect.top = top;
					
					for(x = left; x < width - (src.width - right); )
					{
						if(x + right - left <= width - (src.width - right))
							w = right - left;
						else
							w = width - (src.width - right) - x;
						
						rect.width = w;
						
						pt.x = x;
						bmpdata.copyPixels(src, rect, pt);
						
						x += w;
					}
					
					//! 中间右边
					rect.left = right;
					rect.width = src.width - right;
					
					pt.x = width - (src.width - right);
					bmpdata.copyPixels(src, rect, pt);
					
					y += h;
				}

				//! 左下角
				rect.left = 0;
				rect.top = bottom;
				rect.width = left;
				rect.height = src.height - bottom;
				
				pt.x = 0;
				pt.y = height - (src.height - bottom);
				bmpdata.copyPixels(src, rect, pt);
				
				//! 下面中间
				rect.left = left;
				rect.top = bottom;
				rect.height = src.height - bottom;
				
				pt.y = height - (src.height - bottom);
				
				for(x = left; x < width - (src.width - right); )
				{
					if(x + right - left <= width - (src.width - right))
						w = right - left;
					else
						w = width - (src.width - right) - x;
					
					rect.width = w;
					
					pt.x = x;
					bmpdata.copyPixels(src, rect, pt);
					
					x += w;					
				}				

				//! 右下角
				rect.left = right;
				rect.top = bottom;
				rect.width = src.width - right;
				rect.height = src.height - bottom;
				
				pt.x = width - (src.width - right);
				pt.y = height - (src.height - bottom);				
				bmpdata.copyPixels(src, rect, pt);
			}
		}		
	}
}