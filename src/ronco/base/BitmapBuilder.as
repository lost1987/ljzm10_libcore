package ronco.base
{
	import flash.display.*;
	import flash.geom.*;

	public class BitmapBuilder
	{
		public static var singleton:BitmapBuilder = new BitmapBuilder;		// singleton
		
		public var rect:Rectangle = new Rectangle(0, 0, 0, 0);
		public var pt:Point = new Point(0, 0);
		
//		public var rectLeftTop:Rectangle = new Rectangle(0,0,0,0);
//		public var rectRightTop:Rectangle = new Rectangle(0,0,0,0);
//		public var rectLeftBottom:Rectangle = new Rectangle(0,0,0,0);
//		public var rectRightBottom:Rectangle = new Rectangle(0,0,0,0);
//		public var rectTopMiddle:Rectangle = new Rectangle(0,0,0,0);
//		public var rectBottomMiddle:Rectangle = new Rectangle(0,0,0,0);
//		public var rectLeftMiddle:Rectangle = new Rectangle(0,0,0,0);
//		public var rectrightMiddle:Rectangle = new Rectangle(0,0,0,0);
//		public var rectRow_:Rectangle = new Rectangle(0,0,0,0);
//		public var rectColum_:Rectangle = new Rectangle(0,0,0,0);
		
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
		/**九宫构图
		 * des:构成后的图 src:利用九宫构图资源 width：九宫图围起来中间部分宽度 height:九宫图围起来中间部分宽度
		 * */
		public function buildBitmap2(des:BitmapData, src:BitmapData, width:int, height:int):void
		{
			var w:int = src.width / 3;  
			var h:int = src.height / 3;
			var row:int = height / h;
			var colum:int = width / w;
			
			var row_:int = height % h;
			var colum_:int = width % w;
			
			//上边
			rect.x = 0;
			rect.y = 0;
			rect.width = w;
			rect.height = h;
			
			pt.x = 0;
			pt.y = 0;
			des.copyPixels(src, rect, pt);
			
			rect.x = w;
			var i:int = 0;
			for(i = 1; i <= colum; ++i)
			{
				pt.x = i * w;
				des.copyPixels(src, rect, pt);
			}
			
			if(colum_ != 0)
			{
				rect.width = colum_;
				pt.x = (colum + 1) * w;
				des.copyPixels(src, rect, pt);
			}
			
			pt.x += colum_;
			rect.x += w;
			rect.width = w;
			des.copyPixels(src, rect, pt);
			//下边
			rect.x = 0;
			rect.y = 2 * h;
			rect.width = w;
			rect.height = h;
			
			pt.x = 0;
			pt.y = height + h;
			des.copyPixels(src, rect, pt);
			
			rect.x = w;
			for(i = 1; i <= colum; ++i)
			{
				pt.x = i * w;
				des.copyPixels(src, rect, pt);
			}
			
			if(colum_ != 0)
			{
				rect.width = colum_;
				pt.x = (colum + 1) * w;
				des.copyPixels(src, rect, pt);
			}
			
			pt.x += colum_;
			rect.x += w;
			rect.width = w;
			des.copyPixels(src, rect, pt);
			//左边中间
			rect.x = 0;
			rect.y = h;
			rect.width = w;
			rect.height = h;
			
			pt.x = 0;
			pt.y = h;
			
			for(i = 1; i <= row; ++i)
			{
				pt.y = i * h;
				des.copyPixels(src, rect, pt);
			}
			
			if(row_ != 0)
			{
				rect.height = row_;
				pt.y = (row + 1) * h;
				des.copyPixels(src, rect, pt);
			}
			//右边中间
			rect.x = w * 2;
			rect.y = h;
			rect.width = w;
			rect.height = h;
			
			pt.x = w + width;
			pt.y = h;
			
			for(i = 1; i <= row; ++i)
			{
				pt.y = i * h;
				des.copyPixels(src, rect, pt);
			}
			
			if(row_ != 0)
			{
				rect.height = row_;
				pt.y = (row + 1) * h;
				des.copyPixels(src, rect, pt);
			}
			var j:int = 0;
			//中间区域
			for(i = 1; i <= row; ++i)
			{
				rect.x = w;
				rect.y = h;
				rect.width = w;
				rect.height = h;
				for(j = 1; j <= colum; ++j)
				{
					pt.x = j * w;
					pt.y = i * h;
					des.copyPixels(src, rect, pt);
				}
				rect.width = colum_;
				pt.x += w;
				des.copyPixels(src, rect, pt);
			}
			
			rect.x = w;
			rect.y = h;
			rect.width = w;
			rect.height = row_;
			
			for(i = 1; i <= colum; ++i)
			{
				pt.x = i * w;
				pt.y = (row + 1) * h;
				des.copyPixels(src, rect, pt);
			}
			
			rect.width = colum_;
			pt.x = (colum+1) * w;
			des.copyPixels(src, rect, pt);
			
		}
	}
}