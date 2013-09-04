package ronco.ui
{
	import flash.utils.getTimer;
	import flash.ui.*;
	
	/**
	 * 热点区域
	 **/	
	public class Hotspot extends UIElement
	{
		/**
		 * 鼠标移入的延时发出时间
		 **/ 
		public var timeDelayMouseIn:int = 0;
		/**
		 * 鼠标移入的时间
		 **/ 
		public var timeMouseIn:int = 0;		
		/**
		 * 鼠标移入
		 **/ 
		public var mouseIn:Boolean = false;
		
		public function Hotspot(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_HOTSPOT, _name, _parent);
		}
		
		/**
		 * 初始化，矩形区域
		 **/		
		public function init(_x:int, _y:int, _w:int, _h:int):void
		{
			x = _x;
			y = _y;

			initEx(_w, _h);
		}
		
		/**
		 * 处理操作，如果返回true，表示截获操作，不继续交给后面的控件处理，否则会交给后面的控件处理
		 * 
		 * 热点区域主要处理鼠标移入移出
		 **/
		public override function onCtrl(ctrl:UICtrl):Boolean
		{
			if(!visible)
				return false;
			
			if(isIn(ctrl.mx, ctrl.my))
			{
				Mouse.cursor = MouseCursor.BUTTON;
				
				if(ctrl.lBtn == UICtrl.KEY_STATE_DOUBLECLICK)
				{
					procUINotify(this, UIDef.NOTIFY_DBCLICK_HOTSPOT);
					
					mouseIn = true;					
					
					return true;					
				}
				
				if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON)
				{
					procUINotify(this, UIDef.NOTIFY_CLICK_HOTSPOT);
					
					mouseIn = true;					
					
					return true;
				}
				
				if(mouseIn)
					return false;
				
				if(timeDelayMouseIn > 0)
				{
					var ct:int = getTimer();
					if(timeMouseIn <= 0)
					{
						timeMouseIn = ct;
						
						return true;
					}
					
					if(ct - timeMouseIn < timeDelayMouseIn)
						return true;
					
					timeMouseIn = 0;
				}

				mouseIn = true;
				
				if(funcTips != null)
					funcTips(this, true);
				
				procUINotify(this, UIDef.NOTIFY_IN_HOTSPOT);
				
				return true;
			}
			else if(mouseIn)
			{
				timeMouseIn = 0;
				
				mouseIn = false;
				
				if(funcTips != null)
					funcTips(this, false);
				
				procUINotify(this, UIDef.NOTIFY_OUT_HOTSPOT);
			}
			
			return false;
		}
	}
}