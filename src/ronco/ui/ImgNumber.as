package ronco.ui
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	//import mx.controls.Image;
	
	// 使用一个图片，来显示数字
	// 图片的要求是：0-9 正负号 一共12个
	public class ImgNumber extends UIElement
	{
		private var img:Bitmap;
		
		private var imgRect:Rectangle = new Rectangle;	//zhs007：临时的矩形，由于bitmap的矩形设置后可以复用
														//因此，这里只需要一个临时对象，即可省去不停的new
		//private var resImg:Class;						// 这个是备份的资源
		private var numArray:Array = new Array;		//zhs007：这种必须初始化的变量，直接初始化
		
		public var num:Number;
		public var type:int;
		public var imgWidth:int;
		// 构造函数
		public function ImgNumber(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_IMGNUMBER, _name, _parent);
		}
		
		// 初始化接口，传入资源即可
		public function init2(res:BitmapData, _type:int):void
		{
			//resImg = res;
			type = _type;
			img = new Bitmap(res);
			switch (type)
			{
				case 1:			//纯数字 0-9
					imgWidth = 10;
					break;
				case 2:			//时间 0-9:
					imgWidth = 11;
					break;
				case 3:			//正负 0-9 + -
					imgWidth = 12;
					break;
				case 4:			//分数 0-9 /
					imgWidth = 11;
					break;
			}
		}		
		
		// 初始化接口，传入资源即可
		public function init(res:Class, _type:int):void
		{
			//resImg = res;
			type = _type;
			img = new res as Bitmap;
			switch (type)
			{
				case 1:			//纯数字 0-9
					imgWidth = 10;
					break;
				case 2:			//时间 0-9:
					imgWidth = 11;
					break;
				case 3:			//正负 0-9 + -
					imgWidth = 12;
					break;
				case 4:			//分数 0-9 /
					imgWidth = 11;
					break;
			}
		}
		
		//! 内部使用的接口，下划线打头，容易标识
		private function _showNum(_pos:Number, _index:int):void
		{
			var tmp_img:Bitmap = new Bitmap(img.bitmapData);
			
			imgRect.left = img.bitmapData.width / imgWidth * _index;
			imgRect.top = 0;
			imgRect.width = img.bitmapData.width / imgWidth;
			imgRect.height = img.bitmapData.height;
			
			tmp_img.scrollRect = imgRect;
			
			tmp_img.x = _pos * img.bitmapData.width / imgWidth;
			
			addChild(tmp_img);
			numArray.push(tmp_img);
		}
		
		// 根据字符串来显示图片
		public function showStr(_numStr:String):void
		{
			num = Number(_numStr);
			
			// 这里首先把现有的字符串隐藏
			for(var i:int = 0; i < numArray.length; ++i)
			{
				numArray[i].visible = false;
				
			}
			
			switch(type)
			{
			// 然后根据显示的文字来决定哪些字符显示，如果不足，则需要增加
				case 1:
					for(i = 0; i < _numStr.length; ++i)
					{
						if(i >= numArray.length)
						{
							_showNum(i, Number(_numStr.charAt(i)));
						}
						else
						{
							imgRect.left = img.bitmapData.width / imgWidth * Number(_numStr.charAt(i));
							
							imgRect.top = 0;
							imgRect.width = img.bitmapData.width / imgWidth;
							imgRect.height = img.bitmapData.height;
							
							numArray[i].scrollRect = imgRect;
							numArray[i].visible = true;
						}
					}
					break;
				case 2:
					for(i = 0; i < _numStr.length; ++i)
					{
						if(i >= numArray.length)
						{
							if(_numStr.charAt(i) == ':')
							{
								_showNum(i, 10)
							}
							else
							{
								_showNum(i, Number(_numStr.charAt(i)));
							}
						}
						else
						{
							if(_numStr.charAt(i) == ':')
							{
								imgRect.left = img.bitmapData.width / imgWidth * 10;
							}
							else
							{
								imgRect.left = img.bitmapData.width / imgWidth * Number(_numStr.charAt(i));
							}
							
							imgRect.top = 0;
							imgRect.width = img.bitmapData.width / imgWidth;
							imgRect.height = img.bitmapData.height;
							
							numArray[i].scrollRect = imgRect;
							numArray[i].visible = true;
						}
					}
					break;
				case 3:
					for(i = 0; i < _numStr.length; ++i)
					{
						if(i >= numArray.length)
						{
							if(_numStr.charAt(i) == '+')
							{
								_showNum(i, 10)
							}
							else if(_numStr.charAt(i) == '-')
							{
								_showNum(i, 11)
							}
							else
							{
								_showNum(i, Number(_numStr.charAt(i)));
							}
						}
						else
						{
							if(_numStr.charAt(i) == '+')
							{
								imgRect.left = img.bitmapData.width / imgWidth * 10;
							}
							else if(_numStr.charAt(i) == '-')
							{
								imgRect.left = img.bitmapData.width / imgWidth * 11;
							}
							else
							{
								imgRect.left = img.bitmapData.width / imgWidth * Number(_numStr.charAt(i));
							}
							
							imgRect.top = 0;
							imgRect.width = img.bitmapData.width / imgWidth;
							imgRect.height = img.bitmapData.height;
							
						 	numArray[i].scrollRect = imgRect;
							numArray[i].visible = true;
						}
					}
					break;
				case 4:
					for(i = 0; i < _numStr.length; ++i)
					{
						if(i >= numArray.length)
						{
							if(_numStr.charAt(i) == '/')
							{
								_showNum(i, 10)
							}
							else
							{
								_showNum(i, Number(_numStr.charAt(i)));
							}
						}
						else
						{
							if(_numStr.charAt(i) == '/')
							{
								imgRect.left = img.bitmapData.width / imgWidth * 10;
							}
							else
							{
								imgRect.left = img.bitmapData.width / imgWidth * Number(_numStr.charAt(i));
							}
							
							imgRect.top = 0;
							imgRect.width = img.bitmapData.width / imgWidth;
							imgRect.height = img.bitmapData.height;
							
							numArray[i].scrollRect = imgRect;
							numArray[i].visible = true;
						}
					}
					break;
					
					
			}
			lw = img.bitmapData.width / imgWidth * _numStr.length;
			lh = img.bitmapData.height;
		}
	}
}