package ronco.ui
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import ronco.ui.*;
	
	//import mx.controls.Image;
	
	// 使用一个图片，来显示数字
	// 图片的要求是：0-9 正负号 一共12个
	public class ImgNumber3 extends UIElement
	{
		public static const DQ_TYPE_LEFT:int		=	0;		//! 左对齐
		public static const DQ_TYPE_RIGHT	:int	=	1;		//! 右对齐
		public static const DQ_TYPE_CENTER:int	=	2;		//! 中心对齐
		
		
		public static const ST_WAIT:int			=	0;
		public static const ST_OUT:int			=	1;
		public static const ST_IN:int				=	3;
		
		private var state:int = ST_WAIT;			
		
		private var img:Bitmap;
		
		private var imgRect:Rectangle = new Rectangle;	//zhs007：临时的矩形，由于bitmap的矩形设置后可以复用
		//因此，这里只需要一个临时对象，即可省去不停的new
		//private var resImg:Class;						// 这个是备份的资源
		private var numArray:Array = new Array;		//zhs007：这种必须初始化的变量，直接初始化
		
		//public var num:Number;		// 当前显示的数字
		public var curStr:String;	// 当前显示的字符串
		public var type:int;		// 图片类型
		public var imgWidth:int;	// 图片元素个数
		
		//public var newNum:Number;	// 即将显示的数字
		public var newStr:String;	// 即将显示的字符串
		
		private var key_X:int;		// 关键点横坐标
		private var key_Y:int;		// 关键点纵坐标
		private var alignType:int;	// 对齐方式
		
		private var timer:Timer = new Timer(24);
		private var setup:int = 1;	// 每次移动2个像素
		private var count:int = 0;
		// 构造函数
		public function ImgNumber3(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_IMGNUMBER3, _name, _parent);
			timer.addEventListener(TimerEvent.TIMER, _onTimer);
		}
		
		// 初始化接口，传入资源即可
		public function init(res:Class, _type:int, keyX:int, keyY:int, aligntype:int):void
		{
			//resImg = res;
			key_X = keyX;
			key_Y = keyY;
			alignType = aligntype;
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
		
		private function _updateXY(_numStr:String):void
		{
			switch(alignType)
			{
				case DQ_TYPE_LEFT:
					this.x = key_X;
					this.y = key_Y;
					break;
				case DQ_TYPE_RIGHT:
					this.x = key_X - (_numStr.length * (img.bitmapData.width / imgWidth));
					this.y = key_Y;
					break;
				case DQ_TYPE_CENTER:
					this.x = key_X - (_numStr.length * (img.bitmapData.width / imgWidth))/2;
					this.y = key_Y - (img.bitmapData.height / 2);
					break;
			}
//			this.width = _numStr.length * (img.bitmapData.width / imgWidth);
//			this.height = img.bitmapData.height;
			//this.initEx(_numStr.length * (img.bitmapData.width / imgWidth), img.bitmapData.height);
		}
		
		//! 内部使用的接口，下划线打头，容易标识
		private function _showNum(_pos:Number, _index:int):void
		{
			var tmp_img:Bitmap = new Bitmap(img.bitmapData);
			
			imgRect.left = img.bitmapData.width / imgWidth * _index;
//			imgRect.top = 0;
//			imgRect.width = img.bitmapData.width / imgWidth;
//			imgRect.height = img.bitmapData.height;
			
			switch(state)
			{
				case ST_WAIT:
					imgRect.top = 0;
					imgRect.width = img.bitmapData.width / imgWidth;
					imgRect.height = img.bitmapData.height;	
					break;
				case ST_OUT:
					imgRect.top = count * setup;
					imgRect.width = img.bitmapData.width / imgWidth;
					imgRect.height = img.bitmapData.height - (count*setup);	
					break;
				case ST_IN:
					imgRect.top = 0;
					imgRect.width = img.bitmapData.width / imgWidth;
					imgRect.height = img.bitmapData.height - (count*setup);	
					break;
			}
			
			tmp_img.scrollRect = imgRect;
			
			tmp_img.x = _pos * img.bitmapData.width / imgWidth;
			
			addChild(tmp_img);
			numArray.push(tmp_img);
		}
		
		// 时间的回调函数
		public function _onTimer(e:TimerEvent):void
		{
			switch(state)
			{
				case ST_WAIT:
					state = ST_OUT;
					_showStrEx(curStr);
					break;
				case ST_OUT:
					count++;
					//trace(count);
					_showStrEx(curStr);
					if(count * setup >= img.bitmapData.height)
					{
						state = ST_IN;
					}
					break;
				case ST_IN:
					count--;
					//trace(count);
					if(newStr != null)
					{
						_showStrEx(newStr);
						if(count == 0)
						{
							curStr = newStr;
							state = ST_WAIT;
							timer.stop();
						}
					}	

					break;
			}
		}
		public function _showStrEx(_numStr:String):void
		{
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
							
							switch(state)
							{
								case ST_WAIT:
									imgRect.top = 0;
									imgRect.width = img.bitmapData.width / imgWidth;
									imgRect.height = img.bitmapData.height;	
									break;
								case ST_OUT:
								case ST_IN:
									imgRect.top = count * setup;
									imgRect.width = img.bitmapData.width / imgWidth;
									imgRect.height = img.bitmapData.height - (count*setup);	
									break;
//								case ST_IN:
//									imgRect.top = 0;
//									imgRect.width = img.bitmapData.width / imgWidth;
//									imgRect.height = img.bitmapData.height - (count*setup);	
//									break;
							}		
							numArray[i].scrollRect = imgRect;
							numArray[i].visible = true;
						}
					}
					break;

			}
			lw = img.bitmapData.width / imgWidth * _numStr.length;
			lh = img.bitmapData.height;					
		}
		public function _showStr(_numStr:String):void
		{
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
		// 根据字符串来显示图片
		public function showStr(_numStr:String):void
		{
			_updateXY(_numStr);
			
			_showStr(_numStr);
		}
		
		public function showStrEx(_numStr:String):void
		{
			if(curStr == null)
				curStr = _numStr;
			else
				newStr = _numStr;
			
			if(curStr == newStr || newStr == null)
			{
				_updateXY(curStr);
				
				_showStrEx(curStr);	
				
				return ;
			}
			
			switch(type)
			{
				case 1:
				{
					timer.start();
				}
				break;
			}

		}
	}
}