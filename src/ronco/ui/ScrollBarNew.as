package ronco.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.BitmapAsset;
	
	import ronco.base.BitmapBuilder;
	import ronco.ui.*;
	import ronco.ui.UIDef;
	import ronco.ui.UIElement;
	import ronco.ui.UIListener;
	
	public class ScrollBarNew extends UIElement implements UIListener 
	{
		public var main:UIElement;
		public var btnUp:ronco.ui.Button;
		public var btnDown:ronco.ui.Button;
		public var btnMid:ronco.ui.Button;
		public var imgBack:ronco.ui.Image;
		public var hotspot:ronco.ui.Hotspot;
		
		public var mx:Number = 0;
		public var my:Number = 0;
		public var w:Number = 0;
		public var h:Number = 0;
		
		public var ctrlDest:UIElement;
		public var rectDest:Rectangle;
		public var iMovesp:Number = 0.1;		//! 鼠标移动的像素间隔
		public var iMovespPoint:int = 1;
		
		public var perent:Number = 0;
		
		//最大滚动的高度		
		private var _maxScrollPosition:Number = 500;
		
		/**
		 * 滚动条刷新接口，函数定义如下：
		 * onScroll(bar:ScrollBar):void
		 **/ 
		public var funcOnScroll:Function;
		
		public var midBitmap:BitmapData;
		public var backBitmap:BitmapData;
		
		public function ScrollBarNew(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_SCROLLBAR, _name, _parent);
		}
		
		public override function set visible(value:Boolean):void
		{
			main.visible = value;
		}
		
		public override function get visible():Boolean
		{
			return main.visible;
		}
		
		public override function get x():Number
		{
			return mx;
		}
		
		public override function set x(n:Number):void
		{
			mx = n;
			resize();
		}
		
		public override function get y():Number
		{
			return my;
		}
		
		public override function set y(n:Number):void
		{
			my = n;
			resize();
		}
		
		public function setSize(_w:Number,_h:Number):void
		{
			w = _w;
			h = _h;			 
			resize(mx,my,w,h);
			moveMidBtn(this.perent);
		}
		
		public function get scrollPosition():Number
		{
			return int(perent/iMovesp);
		}
		
		public function set scrollPosition(num:Number):void
		{
			if(num < 0)
				num = 0;
			perent = num * iMovesp;
			moveMidBtn(perent);
			
			setMovesp(iMovespPoint)
		}
		
		public function get maxScrollPosition():Number
		{
			return int(1/iMovesp);	
		}
		
		public function set maxScrollPosition(num:Number):void
		{
			if(num <= 0)
			{
				num = 0;
				main.visible = false;
			}else
				main.visible = true;
			
			if(ctrlDest != null && ctrlDest.scrollRect != null)
				_maxScrollPosition = num *iMovespPoint + ctrlDest.scrollRect.height;		
			
			
			setMovesp(iMovespPoint);
			resize();
			moveMidBtn(perent);
			
		}	
		
		public function createBtnBitmap(src:BitmapData,_width:int,_height:int):BitmapData
		{
			var bm:Bitmap = new Bitmap;			
			bm.bitmapData = new BitmapData(_width * 4,_height);
			
			var _h:int = src.height;
			var _w:int = src.width/4;
			for(var i:int = 0; i < 4; ++i)
			{
				var tbm:Bitmap = new Bitmap;			
				tbm.bitmapData = new BitmapData(_width,_height);		
				
				var tsrc:Bitmap =  new Bitmap;			
				tsrc.bitmapData = new BitmapData(_w,_h);		
				
				tsrc.bitmapData.copyPixels(src,new Rectangle(_w * i,0,_w,_h),new Point(0,0));
				
				BitmapBuilder.singleton.buildBitmap(tbm.bitmapData, tsrc.bitmapData, 5, 10, _w - 5, _h - 10, _width, _height);
				
				bm.bitmapData.copyPixels(tbm.bitmapData,new Rectangle(0,0,_width,_height),new Point(_w * i,0));
			}
			return bm.bitmapData;
		}
		
		public function init(_x:int,_y:int,_w:int,_h:int,upRes:Class,downRes:Class,backRes:Class,midRes:Class,_parent:UIElement):void
		{
			main = new UIElement(UIDef.UI_EMPTY, "主要", _parent);
			
			hotspot = new Hotspot("hot",main);
			imgBack = new Image("back", main);
			btnUp = new Button("up", main);			
			btnDown = new Button("down", main);
			btnMid = new Button("mid", main);
			
		
			backBitmap = (new backRes as Bitmap).bitmapData;
			
			
			btnUp.init(upRes);
			btnDown.init(downRes);
			midBitmap = (new midRes as Bitmap).bitmapData;
			
			btnMid.init2(createBtnBitmap(midBitmap,backBitmap.width,200));		
			imgBack.init(backRes);		
			
			var bm:Bitmap = new Bitmap;			
			bm.bitmapData = new BitmapData(backBitmap.width,_h);
			BitmapBuilder.singleton.buildBitmap(bm.bitmapData, backBitmap, 2, 2, backBitmap.width - 2, backBitmap.height - 2, backBitmap.width, _h);
			imgBack.init2(bm.bitmapData);
			
			btnMid.canHold = true;
			
			
			main.addListener(this);
			btnUp.addListener(this);
			btnDown.addListener(this);
			btnMid.addListener(this);
			imgBack.addListener(this);
			hotspot.addListener(this);
			
			mx = _x;
			my = _y;
			h = imgBack.lh;
			w = _w;
			
			btnMid.limitRect = new Rectangle(0,0 + btnUp.lh,btnMid.lw,h - btnDown.lh - btnUp.lh);
			btnMid.onBtnMove = onMidBtnMove;
			btnUp.setHoldFunc(onHoldUp);
			btnDown.setHoldFunc(onHoldDown);
			hotspot.init(0,0,btnMid.lw,h);
			
			//imgBack.setHoldFunc(onHoldBackImg);
			
			resize();
			
			btnUp.visible = false;
			btnDown.visible = false;
			imgBack.visible = false;	
			btnMid.alpha = 0.5;
		}
		
		public function onHoldBackImg(ele:ronco.ui.Image,time:int):void
		{
			if(ele.mouseY <= btnMid.y)
			{
				moveMidBtn(perent - iMovesp);
			}else
			{
				moveMidBtn(perent + iMovesp);
			}
		}
		
		public function onHoldUp(btn:Button,time:int):void
		{
			moveMidBtn(perent - iMovesp);
		}
		
		public function onHoldDown(btn:Button,time:int):void
		{
			moveMidBtn(perent + iMovesp);
		}
		
		public function setMovesp(sp:int):void
		{
			iMovespPoint = sp;
			if(ctrlDest != null && ctrlDest.scrollRect != null)
			{				
				if(_maxScrollPosition  - ctrlDest.scrollRect.height <= 0)
					iMovesp = 0;
				else
					iMovesp = sp / (_maxScrollPosition  - ctrlDest.scrollRect.height);
			}
		}
		
		public function resize(_x:int = -1,_y:int = -1,_w:int = -1,_h:int = -1):void
		{
			if(_x == -1 && _y == -1 &&  _w == -1 &&  _h == -1 )
			{
				
			}else
			{
				mx = _x;
				my = _y;
				h = _h;
				w = _w;
				
				var bm:Bitmap = new Bitmap;			
				bm.bitmapData = new BitmapData(backBitmap.width,_h);
				BitmapBuilder.singleton.buildBitmap(bm.bitmapData, backBitmap, 2, 2, backBitmap.width - 2, backBitmap.height - 2, backBitmap.width, h);
				
				if(imgBack.img.bitmapData != null)
				{
					imgBack.img.bitmapData.dispose();
				}
				imgBack.init2(bm.bitmapData);
			}
			
			hotspot.initEx(w,h);
			
			btnMid.y = btnUp.lh
			btnDown.y = h - btnDown.lh;
			
			var th:int = 20;
			if(ctrlDest != null && ctrlDest.scrollRect != null)
			{
				var _percent:Number = maxScrollPosition/30;
				if(_percent > 1)
					_percent = 1;
				
				th = ctrlDest.scrollRect.height - btnUp.lh - btnDown.lh;
				if(th <0)
					th = 0;
				th *= (1 -   _percent);
				if(th < 20)
					th = 20;
				
			}
			
			btnMid.limitRect = new Rectangle(0,0 + btnUp.lh,btnMid.lw,h - btnDown.lh - btnUp.lh);
			
			if(btnMid.img.bitmapData != null)
			{
				btnMid.img.bitmapData.dispose();
			}
			
			btnMid.reloadBmp(createBtnBitmap(midBitmap,midBitmap.width/4,th));	
			btnMid.lw = midBitmap.width/4;
			btnMid.lh = th;
			
			btnMid.x = (imgBack.lw - btnMid.lw)/2;
			
			main.x = mx;
			main.y = my;
		}
		
		/**
		 * 设置目标
		 **/
		public function setDest(_dest:UIElement):void
		{
			ctrlDest = _dest;
			
			rectDest = new Rectangle;
			rectDest.left = 0;
			rectDest.top = 0;
			rectDest.right = ctrlDest.lw;
			rectDest.bottom = ctrlDest.lh;
			
			ctrlDest.scrollRect = rectDest;
			ctrlDest.addListener(this);
			ctrlDest.preSendChildMsg = preSendMsg;
			main.preSendChildMsg = preSendMsg;
			
		}	
		
		public function preSendMsg(ctrl:UICtrl):void
		{
			if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON)
				setFocus();
		}
		
		public function onMidBtnMove(btn:Button):void
		{
			if( btn.limitRect != null)
			{
				perent = (btn.y - btn.limitRect.top)/(btn.limitRect.height - btn.lh);		
				
				onScroll();
				//! bar.scrollPosition过半下移
				
			}
		}
		public function moveMidBtn(_perent:Number):void
		{
			if(_perent < 0)
				_perent = 0;
			if(perent > 1)
				_perent = 1;			
			
			perent = _perent;
			
			if( (btnMid.limitRect.height - btnMid.lh) * perent <=  (btnMid.limitRect.height - btnMid.lh))
				btnMid.y = btnMid.limitRect.top + (btnMid.limitRect.height - btnMid.lh) * perent;
			else
				btnMid.y = btnMid.limitRect.top + (btnMid.limitRect.height - btnMid.lh) ;
			
			onScroll();
		}
		
		public function  onScroll():void
		{
			if(ctrlDest != null)
			{
				var ty:Number = _maxScrollPosition - ctrlDest.scrollRect.height;
				
				//if(ty <= 0)
				//{
				//main.visible = true;
				if(iMovesp > 0)
					ty *= int(perent/iMovesp) * iMovesp ;		
				else
					ty = 0;	
				
				if(ty < 0)
					ty = 0;	
				
				if(ty > _maxScrollPosition - ctrlDest.scrollRect.height)
					ty = _maxScrollPosition - ctrlDest.scrollRect.height;
				
				rectDest.top = ty ;				
				
				rectDest.bottom = rectDest.top + ctrlDest.lh;
				
				ctrlDest.scrollRect = rectDest;
				//				}else
				//				{
				//					main.visible = false;
				//				}
			}
			
			if(funcOnScroll != null)
			{
				funcOnScroll(this);
			}
		}
		
		public function setFocus():void
		{
			UIMgr.singleton.curScrollBarFunc = onMouseWheel;
		}
		
		public function onMouseWheel(ctrl:UICtrl):void
		{
			scrollPosition -= ctrl.delta;
		}
		
		public function onUINotify(ele:UIElement, notify:int):void
		{			
				
			if(notify == UIDef.NOTIFY_CLICK_BTN && ele == btnUp)
			{
				moveMidBtn(perent - iMovesp);
			}else if(notify == UIDef.NOTIFY_CLICK_BTN && ele == btnDown)
			{
				moveMidBtn(perent + iMovesp);
			}else if(notify == UIDef.NOTIFY_CLICK_IMG && ele == imgBack)
			{
				if(ele.mouseY < btnMid.y)
				{
					moveMidBtn(perent - iMovesp);
				}else
				{
					moveMidBtn(perent + iMovesp);
				}
			}else if((notify == UIDef.NOTIFY_IN_HOTSPOT || notify == UIDef.NOTIFY_MOUSEIN_BTN )
				&& (ele == hotspot || ele == btnUp || ele == btnDown || ele == btnMid ))
			{
				btnUp.visible = true;
				btnDown.visible = true;
				imgBack.visible = true;	
				btnMid.alpha = 1;
			}else if((notify == UIDef.NOTIFY_OUT_HOTSPOT || notify == UIDef.NOTIFY_MOUSEOUT_BTN )
				&& (ele == hotspot || ele == btnUp || ele == btnDown || ele == btnMid ))
			{
				btnUp.visible = false;
				btnDown.visible = false;
				imgBack.visible = false;	
				btnMid.alpha = 0.5;
			}
			
			
		}
	}
}