package ronco.ui
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.ui.*;
	
	import ronco.base.*;
	
	public class Image extends UIElement
	{
		public var img:Bitmap;
		private var movieclip:MovieClip;
		
		public var bLoading:Boolean = false;
		public var filterGray:ColorMatrixFilter;
		public var needCheckImgAlpha:Boolean = true;
		public var canClick:Boolean = false;
//		public var isCatchCtrl:Boolean = true;		//! 是否拦截控制
		//private var load:Loader = new Loader();
		public var bIn:Boolean = false;
		public var bGray:Boolean = false;
		
		/**
		 * 图片的剪裁，不设置就没值
		 **/ 
		public var rectImg:Rectangle;
		
		/**
		 * 加载失败时调用，可以失败时显示默认图
		 * 函数定义如下
		 * onLoadFail():void
		 **/ 
		public var funcLoadFail:Function;
		
		public function Image(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_IMAGE, _name, _parent);
		}
		
		public function init2(res:BitmapData):void
		{
			if(img != null && this.contains(img))
			{
				this.removeChild(img);
			}
			
			img = new Bitmap(res);
			
			addChild(img);
			
			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = img.bitmapData.width;
			lh = img.bitmapData.height;
			
		}		
		
		/**
		 * 设置剪裁，一般用于血槽、进度条等
		 **/ 
		public function setClip(_left:Number, _top:Number, _right:Number, _bottom:Number):void
		{
			if(img == null)
				return ;
			
			if(rectImg == null)
				rectImg = new Rectangle();
			
			rectImg.left = _left;
			rectImg.top = _top;
			rectImg.right = _right;
			rectImg.bottom = _bottom;
			
			img.scrollRect = rectImg;
		}
		
		/**
		 * 设置百分比，只支持横着右边减少的
		 **/ 
		public function setProgress(pro:Number):void
		{
			setClip(0, 0, lw * pro, lh);
		}	
		
		/**
		 * 设置百分比，只支持竖着上边减少的
		 **/ 
		public function setProgressH(pro:Number):void
		{
			setClip(0, lh * (1 - pro), lw, lh);
			img.y = lh * (1 - pro);
		}		
		
		public function init(res:Class):void
		{
			img = new res as Bitmap;
			
			addChild(img);
			
			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = img.bitmapData.width;
			lh = img.bitmapData.height;
			
		}
		
		public function setCanClick(bclick:Boolean):void
		{
			canClick = bclick;
		}
		
		public function initLoad(res:Class):void
		{
			if(res != null)
			{
				movieclip = new res as MovieClip;
				if(movieclip != null)
				{
					movieclip.stop();
					movieclip.visible = false;
					addChild(movieclip);
				}
			}	
		}
		
		public function reSetRes(res:Class):void
		{
			img = new res as Bitmap;
			
			lw = img.bitmapData.width;
			lh = img.bitmapData.height;
		}
		
		public function reload(res:Class):void
		{
			if(img != null)
			{
				removeChild(img);
				img = null;
			}
			
			if(res != null)
				init(res);
		}
		
		public function reloadBmp(_bmp:BitmapData):void
		{
			if(_bmp != null)
			{
				if(img != null)
				{
					removeChild(img);
					img = null;
				}
				
				img = new Bitmap(_bmp);
				
				addChild(img);
				
				bLoading = false;
				
				//! 控件初始化完成以后，应该设置基类的逻辑宽高
				lw = img.bitmapData.width;
				lh = img.bitmapData.height;		
				
				if(bGray)
					setGray(bGray);
			}
		}
		
		public function setGray(_bGray:Boolean):void
		{
			bGray = _bGray;
			if(img == null)
				return;
			
			filterGray = ronco.base.Base.setGray(img, _bGray, filterGray);
//			var lst:Array = img.filters;
//			if(!bGray)
//			{
//				if(lst == null)
//					return ;
//				
//				for(var i:int = 0; i < lst.length; ++i)
//				{
//					if(lst[i] == filterGray)
//						lst.splice(i, 1);
//				}
//				
//				return ;
//			}
//			
//			if(lst == null)
//				lst = new Array;			
//			
//			if(filterGray == null)
//			{
//				filterGray = new flash.filters.ColorMatrixFilter();    
//				filterGray.matrix = new Array(    
//					0.3,0.59,0.11,0,0,    
//					0.3,0.59,0.11,0,0,    
//					0.3,0.59,0.11,0,0,    
//					0,0,0,1,0);
//			}
//			
//			lst.push(filterGray);
//			
//			img.filters = lst;
		}
		
		//! 处理操作，如果返回true，表示截获操作，不继续交给后面的控件处理，否则会交给后面的控件处理
		public override function onCtrl(ctrl:UICtrl):Boolean
		{
//			if(!isCatchCtrl)
//				return false;
			if(lstListener.length <= 0)
				return false;
			
			if(isIn(ctrl.mx, ctrl.my))
			{			
				if(!bIn)
				{
					if(funcTips != null)
						funcTips(this, true);
				}		
				bIn = true;
			}
			else if(bIn)
			{
				bIn = false;
				
				if(funcTips != null)
					funcTips(this, false);
			}
			
			if(isIn(ctrl.mx, ctrl.my))
			{
				if(canClick)
					Mouse.cursor = MouseCursor.BUTTON;
				
				if(ctrl.lBtn == UICtrl.KEY_STATE_UP)
				{
					procUINotify(this, UIDef.NOTIFY_CLICK_IMG);
					
					return true;
				}
//				if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON)
//				{
//					onUINotify(this, UIDef.NOTIFY_CLICK_IMG);
//					
//					return true;
//				}
				if(ctrl.lBtn == UICtrl.KEY_STATE_DOUBLECLICK)
				{
					procUINotify(this, UIDef.NOTIFY_DOUBLECLICK_IMG);
					
					return true;
				}
				
				return true;
			}
			//else
			//	Mouse.cursor = MouseCursor.AUTO;
			
			return false;
		}
		
		//! 判断是否在控件区域内
		public override function isIn(_x:int, _y:int):Boolean
		{
			if(_x > x && _x < x + lw && _y > y && _y < y + lh)
			{
				if(!needCheckImgAlpha)
					return true;
					
				if(img != null)
					return ((img.bitmapData.getPixel32(_x - x, _y - y) >> 24) & 0xff) > 25;
			}
			
			return false;
		}				
		
		/**创建资源并进行切割,返回一个资源数组*/
		public static function divide(res:Class , _rol:int , _vol:int):Array
		{
			var _imgArr:Array = new Array();
			var _img:Bitmap = new res as Bitmap;
			
			var _lw:int = _img.bitmapData.width/_vol;
			var _lh:int = _img.bitmapData.height/_rol;
			
			var _rect:Rectangle = new Rectangle(0,0,_lw,_lh);
			
			for(var i:int=0;i<_rol*_vol;i++)
			{
				var _img_:Bitmap = new res as Bitmap;
				
				_rect.left = i % _vol * _lw;
				_rect.right = _rect.left + _lw;				
				_rect.top = int(i / _vol) * _lh;
				_rect.bottom = _rect.top+ _lh;
				
				_img_.scrollRect = _rect;			
				_imgArr.push(_img_);
			}

			return _imgArr;
		}
		
		// 根据传入值显示区间 <当前值/总值>
		public function showStr(_pre:Number,_tol:Number):void
		{
			if(img != null)
			{
				var _rect:Rectangle = new Rectangle(0,0,_pre/_tol*lw,lh);
				img.scrollRect = _rect;
			}
		}
		
		//! 传入一个网络地址  下载图片显示
//		public function reLoadURL(url:URLRequest):void
//		{
//			if(img != null)
//			{
//				removeChild(img);
//				img = null;
//			}
//			
//			if(movieclip != null)
//			{
//				movieclip.gotoAndPlay(0);
//				movieclip.visible = true;
//			}
//			load.load(url);
//			bLoading = true;
//			load.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaderComoplete);
//			load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoaderIOError);
//		}
//		
//		private function onLoaderIOError(evt:Event):void
//		{
////			if(img != null)
////			{
////				removeChild(img);
////				img = null;
////			}
//			
//			if(funcLoadFail != null)
//				funcLoadFail();
//		}
//		
//		private function onLoaderComoplete(evt:Event):void
//		{
//			if(movieclip != null)
//			{
//				movieclip.stop();
//				movieclip.visible = false;
//			}
//			var bmp:Bitmap = load.content as Bitmap;
//			reloadBmp(bmp.bitmapData);
//		}
		
		public function load(_url:String):void
		{
			if(bLoading)
			{
				UIIMgMgr.singleton.removeFunc(loadComplete, loadError);
				bLoading = false;
			}
			
			if(img != null)
			{
				removeChild(img);
				img = null;
			}
			
			if(movieclip != null)
			{
				movieclip.gotoAndPlay(0);
				movieclip.visible = true;
			}
			
			bLoading = true;
			UIIMgMgr.singleton.getImg(_url, loadComplete, loadError);
		}
		
		public function loadComplete(bdata:BitmapData):void
		{
			bLoading = false;
			
			if(movieclip != null)
			{
				movieclip.stop();
				movieclip.visible = false;
			}
			
			reloadBmp(bdata);
		}
		
		public function loadError():void
		{
			if(funcLoadFail != null)
				funcLoadFail();
		}
		
		public function setImgBorder(b:Boolean = false, c:uint = 0, strong:int = 2):void
		{
			var glowFilter:GlowFilter;
			if(b)
				glowFilter= new GlowFilter(c, 1, 6, 6, strong);
			else
				glowFilter = new GlowFilter(c, 0);
			this.filters = new Array(glowFilter);
		}
	}
}