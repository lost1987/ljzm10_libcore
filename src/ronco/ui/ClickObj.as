package ronco.ui
{
	import flash.display.*;
	
	public class ClickObj extends UIElement
	{
		public var objChild:DisplayObject;
		private var bIn:Boolean = false;
		public var bMouseMove:Boolean = false;
		
		public function ClickObj(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_CLICKOBJ, _name, _parent);
		}
		
		public function init(obj:DisplayObject, w:int, h:int):void
		{	
			objChild = obj;
			
			if(objChild != null)
				addChild(objChild);
			
			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = w;
			lh = h;
		}
		
		//! 处理操作，如果返回true，表示截获操作，不继续交给后面的控件处理，否则会交给后面的控件处理
		public override function onCtrl(ctrl:UICtrl):Boolean
		{
			if(lstListener.length <= 0)
				return false;
			
			if(isIn(ctrl.mx, ctrl.my))
			{	
				if(bMouseMove)
				{
					if(funcTips != null)
						funcTips(this, true);
				}
				else 
				{
					if(!bIn)
					{
						if(funcTips != null)
							funcTips(this, true);
					}
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
				if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON)
				{
					procUINotify(this, UIDef.NOTIFY_CLICK_CLICKOBJ);
					
					return true;
				}
				
				return true;
			}
			
			return false;
		}		
	}
}