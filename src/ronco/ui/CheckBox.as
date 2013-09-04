package ronco.ui
{
	import flash.display.*;
	import flash.geom.Rectangle;
	
	public class CheckBox extends UIElement
	{		
		public static const STATE_NORMAL:int 			= 0;	//普通状态
		public static const STATE_MOUSEOVER:int 		= 1;	//鼠标移上状态
		public static const STATE_MOUSEDOWN:int 		= 2;	//鼠标点击状态
		public static const STATE_DISABLE:int 		= 3;	//不可用状态
		
		public var state:int;
		private var img:Bitmap;
		private var imgsel:Bitmap;
		private var isSave:Boolean;
		private var imgRect:Rectangle;
		
		public function CheckBox(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_CHECKBOX, _name, _parent);
		}
		
		public function init2(res:BitmapData,selres:BitmapData):void
		{
			img = new Bitmap(res);
			imgRect = new Rectangle(0, 0, img.bitmapData.width / 4, img.bitmapData.height);
			img.scrollRect = imgRect;
			
			_chgState(STATE_NORMAL);
			
			addChild(img);
			
			imgsel = new Bitmap(selres);
			imgsel.visible = false;//隐藏选中
			
			addChild(imgsel);
			
			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = img.bitmapData.width / 4;
			lh = img.bitmapData.height;
		}		
		
		public function init(res:Class,selres:Class):void
		{
			img = new res as Bitmap;
			imgRect = new Rectangle(0, 0, img.bitmapData.width / 4, img.bitmapData.height);
			img.scrollRect = imgRect;
			
			_chgState(STATE_NORMAL);
			
			addChild(img);
			
			imgsel = new selres as Bitmap;
			imgsel.visible = false;//隐藏选中
			
			addChild(imgsel);
			
			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = img.bitmapData.width / 4;
			lh = img.bitmapData.height;
		}
		
		public function getSaveable():Boolean
		{
			return imgsel.visible;
		}
		
		public function setSaveable(arg0:Boolean):void
		{
			imgsel.visible = arg0;
		}
		
		/**
		 * 设置是否可以使用
		 **/ 
		public function setEnable(bEnable:Boolean):void
		{
			if(bEnable)
				_chgState(STATE_NORMAL);
			else
				_chgState(STATE_DISABLE);
		}
		
		protected function _chgState(_s:int):void
		{
			state = _s;
			
			imgRect.left = (img.bitmapData.width / 4) * _s;
			imgRect.right = imgRect.left + img.bitmapData.width / 4;
			imgRect.top = 0;
			imgRect.bottom = img.bitmapData.height;
			
			img.scrollRect = imgRect;
		}
		
		public override function onCtrl(ctrl:UICtrl):Boolean
		{
			if(state == STATE_DISABLE)
				return false;
			
			if(isIn(ctrl.mx, ctrl.my))
			{
				if(ctrl.lBtn == UICtrl.KEY_STATE_NORMAL)
				{
					if(state == STATE_NORMAL)
					{
						_chgState(STATE_MOUSEOVER);
						
						return true;
					}
				}
				else if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON || ctrl.lBtn == UICtrl.KEY_STATE_DOWN)
				{
					if(state == STATE_MOUSEOVER)
					{
						_chgState(STATE_MOUSEDOWN);
						
						return true;
					}
				}
				else if(ctrl.lBtn == UICtrl.KEY_STATE_UP)
				{
					if(state == STATE_MOUSEDOWN)
					{
						imgsel.visible = !imgsel.visible;
						
						_chgState(STATE_MOUSEOVER);
						
						procUINotify(this, UIDef.NOTIFY_CLICK_BTN);
						
						return true;
					}
				}
			}
			else if(state == STATE_MOUSEOVER || ctrl.lBtn == UICtrl.KEY_STATE_UP)
			{
				_chgState(STATE_NORMAL);
			}
			
			return false;
		}
	}
}