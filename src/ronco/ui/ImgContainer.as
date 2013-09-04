package ronco.ui
{
	import fl.controls.Label;
	
	import flash.display.*;
	import flash.errors.IOError;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.*;
	
	import ronco.base.Base;
	
	public class ImgContainer extends UIElement
	{
		public var bitmap:Bitmap;
		
		//private var rect:Rectangle;//切割矩形
		//private var canUse:Boolean;
		//private var canAccept:Boolean;
		public var defaultImg:Bitmap;
		public var imgParent:DisplayObjectContainer;		//! 拾取后的父节点
		public var img:Bitmap;								//! 拾取后的图片
		//public var loader:Loader = new Loader;
		public var isLoading:Boolean = false;;			//!	是否正在下载
		
		public var imgoffx:int;
		public var imgoffy:int;
		public var downx:int;
		public var downy:int;
		public var isdown:Boolean = false;
		public var isfree:Boolean = false;
		public var isnoout:Boolean = false;		//! 不允许拖出
		public var bIn:Boolean = false;
		public var matrix:Array = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
		
		public var url:String;
		public var bGray:Boolean = false;
		public var filterGray:ColorMatrixFilter;
		
		public var dataEx:Object = new Object;
		
//		public var dataCtrl:Object;
		
		/**
		 * 数量基本控件定义
		 **/ 
		private var labelNums:fl.controls.Label;
		
		/**
		 * 锁定图标
		 **/ 
		private var imgLock:Bitmap;
		
		/**
		 * 加载失败时调用，可以失败时显示默认图
		 * 函数定义如下
		 * onLoadFail():void
		 **/ 
		public var funcLoadFail:Function;
		
		//public var filterGray:ColorMatrixFilter;
		
//		private var _lw:int;
//		private var _lh:int;
		
		public function ImgContainer( _name:String, _parent:UIElement)
		{
			super(UIDef.UI_IMGCONTAINER, _name, _parent);
//			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void{  
//				isLoading = false;
//				if(bitmap != null)
//				{
//					removeChild(bitmap);
//					bitmap = null;
//				}
//				
//				bitmap = e.currentTarget.content;  
//				addChildAt(bitmap, 0);
//				initEx(bitmap.bitmapData.width, bitmap.bitmapData.height);
//				if(defaultImg != null)
//					defaultImg.visible = false;
//				
//				setEnable(enable);
//				filters = [new ColorMatrixFilter(matrix)];
//				setGray(bGray);
//			});  
//			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(e:Event):void{
//				if(funcLoadFail != null)
//					funcLoadFail();
////				reload(null);
//			});
		}
		
		public function loadComplete(bdata:BitmapData):void
		{
			isLoading = false;
			
			if(bitmap != null)
			{
				removeChild(bitmap);
				bitmap = null;
			}
			
			bitmap = new Bitmap;
			bitmap.bitmapData = bdata;
			addChildAt(bitmap, 0);
			
			initEx(bitmap.bitmapData.width, bitmap.bitmapData.height);
			
			if(defaultImg != null)
				defaultImg.visible = false;
			
			setEnable(enable);
			filters = [new ColorMatrixFilter(matrix)];
			setGray(bGray);
		}
		
		public function loadError():void
		{
			if(funcLoadFail != null)
				funcLoadFail();
		}
		
		public function initBmp(bd:BitmapData):void
		{
			url = null;
			
			if(bd == null)
			{
				reload(null);
				
				return ;
			}
			
			if(bitmap == null)
				bitmap = new Bitmap(bd);
			else
				bitmap.bitmapData = bd;
			
			//bitmap = new _res as Bitmap;
			//rect = new Rectangle(0,0,bitmap.width/2,bitmap.height);
			//			bitmap.scrollRect = rect;
			//canUse = true;
			//canAccept = true;
			//canHold = true;
			addChildAt(bitmap, 0);
			
			//			_lw = bitmap.bitmapData.width/2;
			//			_lh = bitmap.bitmapData.height;
			
			initEx(bitmap.bitmapData.width, bitmap.bitmapData.height);
		}		
		
		public function init(_res:Class):void
		{
			bitmap = new _res as Bitmap;
			//rect = new Rectangle(0,0,bitmap.width/2,bitmap.height);
//			bitmap.scrollRect = rect;
			//canUse = true;
			//canAccept = true;
			//canHold = true;
			addChildAt(bitmap, 0);
			
//			_lw = bitmap.bitmapData.width/2;
//			_lh = bitmap.bitmapData.height;
			
			initEx(bitmap.bitmapData.width, bitmap.bitmapData.height);
		}
		
		public function setBitmap(_bitmap:Bitmap):void
		{
			if(bitmap != null)
			{
				removeChild(bitmap);
				bitmap = null;
			}
			bitmap = _bitmap;
			addChildAt(bitmap, 0);
			initEx(bitmap.bitmapData.width, bitmap.bitmapData.height);
		}
		
		public function setEnable(_is:Boolean):void
		{
			enable = _is;
			
			if(enable)
				ronco.base.Base.setGray(this, false, null);
			else
				ronco.base.Base.setGray(this, true, null);
			
//			if(bitmap != null)
//			{
//				if(_is)
//				{
//					rect = new Rectangle(0,0,bitmap.width/2,bitmap.height);
//					bitmap.scrollRect = rect;
//					canUse = true;
//				}
//				else
//				{
//					rect = new Rectangle(bitmap.width/2,0,bitmap.width/2,bitmap.height);
//					bitmap.scrollRect = rect;
//					canUse = false;
//				}
//			}
		}
		
		public function setData(_data:Object):void
		{
			data = _data;
		}
		
		public function reloadBmp(bd:BitmapData):void
		{
			//			while(numChildren > 0)
			//			{
			//				removeChildAt(0);
			//			}
			if(isLoading)
			{
//				try {
//					loader.close();
//					
//				} catch (error:IOError) {
//					
//				}
				UIIMgMgr.singleton.removeFunc(loadComplete, loadError);
				isLoading = false;
			}
			
			//			if(res == null)
			//			{
			//				try {
			//					loader.close();
			//					
			//				} catch (error:IOError) {
			//					
			//				}
			//				
			//			}
			//			if(res == null)
			//			{
			//				if(isLoading)
			//				{
			//					loader.close();
			//					isLoading = false;
			//				}
			//			}
			
			if(bitmap != null)
			{
				removeChild(bitmap);
				bitmap = null;
			}
			
			if(bd != null)
				initBmp(bd);			
		}
		
		public function reload(res:Class):void
		{
			url = null;
//			while(numChildren > 0)
//			{
//				removeChildAt(0);
//			}
			if(isLoading)
			{
//				try {
//					loader.close();
//					
//				} catch (error:IOError) {
//					
//				}
				UIIMgMgr.singleton.removeFunc(loadComplete, loadError);
				isLoading = false;
			}
			
//			if(res == null)
//			{
//				try {
//					loader.close();
//					
//				} catch (error:IOError) {
//					
//				}
//				
//			}
//			if(res == null)
//			{
//				if(isLoading)
//				{
//					loader.close();
//					isLoading = false;
//				}
//			}
			
			if(bitmap != null)
			{
				removeChild(bitmap);
				bitmap = null;
			}
			
//			if(loader != null)
//			{
//				loader.unload();
//			}			
			
			if(res != null)
				init(res);
		}
		
		public function onCtrlEnd():void
		{
			if(isfree && UIMgr.singleton.curImgContainer == this)
			{
				procUINotify(this, UIDef.NOTIFY_FREE_IMGCONTAINER);
				
				if(!UIMgr.singleton.isMouseOnUI)
					procUINotify(this, UIDef.NOTIFY_DROP_IMGCONTAINER);
				
				UIMgr.singleton.curImgContainer = null;
				
				isfree = false;
				ronco.base.Base.safeRemoveChild(imgParent, img);
				img = null;
				
				if(bitmap != null)
				{
					ronco.base.Base.setGray(bitmap, false, null);
				}				
			}
		}
		
		//! 处理操作，如果返回true，表示截获操作，不继续交给后面的控件处理，否则会交给后面的控件处理
		public override function onCtrl(ctrl:UICtrl):Boolean
		{
			if(!visible)
				return false;
			
			// 如果不可用，还要处理点击？
			if(!enable)
			{				
				if(isIn(ctrl.mx, ctrl.my))
				{				
					if(!bIn)
					{
						if(funcTips != null)
							funcTips(this, true);
						
						bIn = true;
						
						procUINotify(this, UIDef.NOTIFY_IN_IMGCONTAINER);
					}
					
					
					if(bitmap != null && ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON)
					{					
						procUINotify(this, UIDef.NOTIFY_CLICK_DISABLE_IMGCONTAINER);
					}
					else if(bitmap != null && ctrl.lBtn == UICtrl.KEY_STATE_DOUBLECLICK)
					{
						procUINotify(this, UIDef.NOTIFY_DOUBLECLICK_IMGCONTAINER);
						
						return true;
					}
					
					return true;
				}
				else if(bIn)
				{
					bIn = false;
						
					if(funcTips != null)
						funcTips(this, false);
					
					procUINotify(this, UIDef.NOTIFY_OUT_IMGCONTAINER);
					
					return false;
				}
				
				
				return false;
			}
			
			// 如果发现自己被拖起来，设置 isfree 状态，在 onCtrlEnd 里面处理
			if(UIMgr.singleton.curImgContainer != null)
			{
				if(UIMgr.singleton.curImgContainer == this)
				{
					if(ctrl.lBtn != UICtrl.KEY_STATE_DOWN)
						isfree = true;
					
					img.x = ctrl.stagex - imgoffx;
					img.y = ctrl.stagey - imgoffy;
					
					return false;
				}
				else
				{
					if(isIn(ctrl.mx, ctrl.my))
					{
						if(ctrl.lBtn != UICtrl.KEY_STATE_DOWN)
						{
							procUINotify(this, UIDef.NOTIFY_SWAP_IMGCONTAINER);
							//ronco.base.Base.safeRemoveChild(this, bitmap);
							
							//bitmap = null;
							
							//bitmap = new Bitmap(UIMgr.singleton.curImgContainer.img.bitmapData);
							
							//addChild(bitmap);
							
							return true;
						}						
						
						return true;
					}
//					else
//					{
//						if(ctrl.lBtn != UICtrl.KEY_STATE_DOWN)
//						{
//							onUINotify(this, UIDef.NOTIFY_SWAP_IMGCONTAINER);
//							
//							return true;
//						}						
//					}
				}
			}
			else if(isdown)
			{
				if(bitmap != null && ctrl.lBtn == UICtrl.KEY_STATE_UP)
				{					
					procUINotify(this, UIDef.NOTIFY_CLICK_IMGCONTAINER);
				}
				
				if(ctrl.lBtn != UICtrl.KEY_STATE_DOWN)
				{
					isdown = false;
					
					return true;
				}
					
				var ox:int = downx > ctrl.stagex ? downx - ctrl.stagex : ctrl.stagex - downx;
				var oy:int = downy > ctrl.stagey ? downy - ctrl.stagey : ctrl.stagey - downy;
				
				if(ox >= lw / 2 || oy >= lh / 2)
				{
					UIMgr.singleton.curImgContainer = this;
					img = new Bitmap(bitmap.bitmapData);
					imgParent.addChild(img);
					img.x = ctrl.stagex - imgoffx;
					img.y = ctrl.stagey - imgoffy;
					
					procUINotify(this, UIDef.NOTIFY_UP_IMGCONTAINER);
					
					ronco.base.Base.setGray(bitmap, true, null);
				}
				
				
				return true;
					
			}
			else if(isIn(ctrl.mx, ctrl.my))
			{	
				Mouse.cursor = MouseCursor.BUTTON;
				
				if(isnoout && bitmap != null && ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON)
				{
					procUINotify(this, UIDef.NOTIFY_CLICK_IMGCONTAINER);
				}
				else if(!isnoout && bitmap != null && ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON)
				{
					isdown = true;
					downx = ctrl.stagex;
					downy = ctrl.stagey;
					imgoffx = ctrl.mx - x;
					imgoffy = ctrl.my - y;
					
				}
				else if(bitmap != null && ctrl.lBtn == UICtrl.KEY_STATE_UP && isdown)
				{
					isdown = false;
					
					procUINotify(this, UIDef.NOTIFY_CLICK_IMGCONTAINER);
				}
				else if(bitmap != null && ctrl.lBtn == UICtrl.KEY_STATE_DOUBLECLICK)
				{
					procUINotify(this, UIDef.NOTIFY_DOUBLECLICK_IMGCONTAINER);
					
					return true;
				}				
				
				if(!bIn)
				{
					if(funcTips != null)
						funcTips(this, true);
					
					procUINotify(this, UIDef.NOTIFY_IN_IMGCONTAINER);
				}
				
				bIn = true;
				
				return true;
			}
			else if(bIn)
			{
				bIn = false;
				
				if(funcTips != null)
					funcTips(this, false);
				
				procUINotify(this, UIDef.NOTIFY_OUT_IMGCONTAINER);
				
				return false;
			}
			
			return false;
		}
		
		public function load(_url:String):void
		{
			if(url == _url)
				return ;
			
			url = _url;
			
			if(isLoading)
			{
//				try {
//					loader.close();
//					
//				} catch (error:IOError) {
//					
//				}
				UIIMgMgr.singleton.removeFunc(loadComplete, loadError);
				isLoading = false;
			}
			
//			if (loader != null)
//			{
//				loader.unload();
//			}
			
			if(bitmap != null)
			{
				removeChild(bitmap);
				bitmap = null;
			}
			
//			var urlRequest:URLRequest = new URLRequest(_url);
//			loader.load(urlRequest);
			isLoading = true;
			UIIMgMgr.singleton.getImg(_url, loadComplete, loadError);
			
			if(defaultImg != null)
				defaultImg.visible = true;
				
		}
		
		public function setDefaultImg(_res:Class):void
		{
			defaultImg = new _res as Bitmap;
			addChildAt(defaultImg, 0);
		}
		
		public function setMatrix(_array:Array):void
		{
			matrix = _array;
			if(bitmap != null)
			{
				filters = [new ColorMatrixFilter(matrix)];
			}
		}

		/**
		 * 设置数量属性
		 **/		
		public function setNumsState(_x:int, _y:int, _fontname:String, _fontsize:int, _fontColor:uint, _hasBorder:Boolean, _colorBorder:uint, _autosize:String = flash.text.TextFieldAutoSize.RIGHT):void
		{
			if(labelNums != null)
			{
				removeChild(labelNums);
			}
			
			labelNums = new fl.controls.Label();
			
			var format:TextFormat = new TextFormat();
			format.color = _fontColor;
//			format.bold = _hasBorder;
			format.size = _fontsize;
			
			labelNums.setStyle("textFormat", format);	
			labelNums.autoSize = _autosize;
			
			labelNums.x = _x;
			labelNums.y = _y;
			labelNums.text = _fontname;
			
			if(_hasBorder)
			{
				var lst:Array;
				
				lst = labelNums.filters;
				if(lst == null)
					lst = new Array;
				
				var filterDropShadow:DropShadowFilter = new DropShadowFilter(0, 0, _colorBorder, 1, 2, 2, 255);					
				
				lst.push(filterDropShadow);
				
				labelNums.filters = lst;
			}
			
			addChild(labelNums);
		}
		
		/**
		 * 设置显示数量
		 **/ 
		public function setShowNums(strNum:String):void
		{
			if(labelNums == null)
				return ;			
			
			labelNums.text = strNum;
		}

		/**
		 * 显示数量
		 **/
		public function showNums(bShow:Boolean):void
		{
			if(labelNums == null)
				return ;
			
			labelNums.visible = bShow;
		}
		
		/**
		 * 设置锁图标
		 **/ 
		public function setImgLock(_x:int, _y:int, _imgLock:Class):void
		{
			imgLock = new _imgLock as Bitmap;
			
			imgLock.x = _x;
			imgLock.y = _y;
			
			addChild(imgLock);
		}
		
		/**
		 * 显示锁图标
		 **/
		public function showImgLock(bShow:Boolean):void
		{
			if(imgLock == null)
				return ;
			
			imgLock.visible = bShow;
		}
		
		
		public function setGray(_bGray:Boolean):void
		{
			if(bitmap == null)
				return;
			
			bGray = _bGray;
			filterGray = ronco.base.Base.setGray(bitmap, _bGray, filterGray);
		}
	}
}