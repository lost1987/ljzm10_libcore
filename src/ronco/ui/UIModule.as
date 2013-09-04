package ronco.ui
{
	import fl.controls.TextInput;
	
	import flash.display.*;
	import flash.geom.Rectangle;
	
	import ronco.base.*;

	public class UIModule extends UIElement
	{
		public var img:Bitmap;
		
		/**
		 * 9宫格拼接对话框背景
		 **/ 
		public var backBitmapData:BitmapData;
		/**
		 * 9宫格拼接对话框背景用的rect
		 **/ 
		public var	backBitmapRect:Rectangle;
		
		
		public var btn_enter:ronco.ui.Button;
		public var btn_esc:ronco.ui.Button;
		
		public var state_noactive:Boolean = false;
		
		/**
		 * 对话框不检查底图透明度
		 **/ 
		public var back_nocolorkey:Boolean = false;
		
		/**
		 * 处理在对话框外面点击消息，注意，设置了这个标志后，该点击会被拦截
		 **/ 
		public var proc_outdownsoon:Boolean = false;		
		
		public var curActEdit:int = -1;
		public var lstEdit:Vector.<ronco.ui.TextInput> = new Vector.<ronco.ui.TextInput>; 
		
		public var bIn:Boolean = false;
		
		public function UIModule(_type:int, _name:String, _parent:UIElement)
		{
			super(_type, _name, _parent);
		}
		
		public function initDlg2(res:BitmapData):void
		{
			img = new Bitmap(res);
			
			addChild(img);
			
			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = img.bitmapData.width;
			lh = img.bitmapData.height;			
		}		
		
		public function initDlg(res:Class):void
		{
			img = new res as Bitmap;
			
			addChild(img);
			
			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = img.bitmapData.width;
			lh = img.bitmapData.height;			
		}
		
		/**
		 * 9宫格拼接对话框背景
		 **/ 
		public function initDlg3(_res:BitmapData, _left:int, _top:int, _right:int, _bottom:int, _width:int, _height:int):void
		{
			resizeDlg(_res, _left, _top, _right, _bottom, _width, _height);
		}
		
		/**
		 * 9宫格拼接对话框背景改变大小
		 **/ 
		public function resizeDlg(_res:BitmapData, _left:int, _top:int, _right:int, _bottom:int, _width:int, _height:int):void
		{
			if(backBitmapData == null)
				backBitmapData = new BitmapData(_width, _height);
			else if(backBitmapData.width < _width || backBitmapData.height < _height)
			{
				backBitmapData = new BitmapData(_width, _height);
			}
			
			BitmapBuilder.singleton.buildBitmap(backBitmapData, _res, _left, _top, _right, _bottom, _width, _height);
			
			if(backBitmapRect == null)
				backBitmapRect = new Rectangle;
			
			backBitmapRect.left = 0;
			backBitmapRect.top = 0;
			backBitmapRect.width = _width;
			backBitmapRect.height = _height;
			
			if(img == null)
			{
				img = new Bitmap(backBitmapData);
				addChild(img);
			}
			else
				img.bitmapData = backBitmapData;
			
			img.scrollRect = backBitmapRect;
			
			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = _width;
			lh = _height;					
		}		
		
		/**
		 * 背景大小改变后调用
		 **/ 
		public function onChgBackSize():void
		{
			lw = img.width;
			lh = img.height;			
		}
		
		public function reload(res:Bitmap):void
		{
			if(img != null)
			{
				img.parent.removeChild(img);
				//removeChild(img);
				img = null;
			}
			
			if(res != null)
			{
				img = res;
				addChildAt(res,0);
				lw = res.bitmapData.width;
				lh = res.bitmapData.height;	
			}
		}
		
		//! 判断是否在控件区域内
		public override function isIn(_x:int, _y:int):Boolean
		{
			if(_x > x && _x < x + lw && _y > y && _y < y + lh)
			{	
				if(back_nocolorkey)
					return true;
				
				if(img != null)
					return ((img.bitmapData.getPixel32(_x - x, _y - y) >> 24) & 0xff) > 25;
				
				return true;
			}
			
			return false;
		}						
		
		public function addEdit(_edt:ronco.ui.TextInput):void
		{
			lstEdit.push(_edt);
			_edt.notifymod = this;
		}
		
		public function _onEdtGetForce(_edt:ronco.ui.TextInput):void
		{
			if(lstEdit.length > 0)
			{
				for(var i:int = 0; i < lstEdit.length; ++i)
				{
					if(lstEdit[i] == _edt)
					{
						curActEdit = i;
						
						return ;
					}
				}
			}
		}
		
		public override function onKey(keyCode:int):Boolean
		{
			if(!enable)
				return false;
			
			if(!visible)
				return false;	
			
			if(keyCode == 9 && lstEdit.length > 0)
			{
				++curActEdit;
				
				if(curActEdit < 0)
					curActEdit = 0;
				else if(curActEdit >= lstEdit.length)
					curActEdit = 0;
				
				lstEdit[curActEdit].input.setFocus();
			}
			
			if(keyCode == 13 && btn_enter != null)
			{
				procUINotify(btn_enter, UIDef.NOTIFY_CLICK_BTN);
				
				return true;
			}
			else if(keyCode == 27 && btn_esc != null)
			{
				procUINotify(btn_esc, UIDef.NOTIFY_CLICK_BTN);
				
				return true;
			}
			
			return super.onKey(keyCode);
		}
		
		//! 处理操作，如果返回true，表示截获操作，不继续交给后面的控件处理，否则会交给后面的控件处理
		public override function onCtrl(ctrl:UICtrl):Boolean
		{
			if(!visible)
				return false;
			
			if(super.onCtrl(ctrl))
				return true;
			
			var inmine:Boolean = isIn(ctrl.mx, ctrl.my); 
			if(inmine)
			{ 
				if(!noprocCtrl)
				{
					if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON && !state_noactive)
					{
						UIMgr.singleton.setActive(this);
					}
					
					if(!bIn)
					{
						procUINotify(this, UIDef.NOTIFY_IN_MOD);
					}
					
					bIn = true;
				}
			}
			else
			{
				if(bIn)
					bIn = false;
				
				if(proc_outdownsoon)
				{
					if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON)
					{
						procUINotify(this, UIDef.NOTIFY_DLG_OUTDOWNSOON);
						
						return false;
					}
				}
			}
			
			if(noprocCtrl)
				return false;
						
			if(canHold)
			{
				var holdtmp:Boolean = isHold;
				
				var ret:Boolean = _procHold(ctrl);

				if(isHold != holdtmp)
				{
					if(isHold)
						alpha = 0.4;
					else
						alpha = 1;
				}
				
				return ret;
			}
			
			if(inmine)
				return true;
			
			return false;
		}		
	}
}