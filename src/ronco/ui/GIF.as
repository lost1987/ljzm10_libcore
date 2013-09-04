package ronco.ui
{
	import flash.net.URLRequest;
	import flash.ui.*;
	
	import ronco.ui.GIFPlayer.gif.player.GIFPlayer;

	public class GIF extends UIElement
	{		
		public var gif:GIFPlayer;
		
		public var canClick:Boolean = false;
		
		public function GIF(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_IMAGE, _name, _parent);
		}
		
		public function init(res:GIFPlayer):void
		{
			gif = res;
			addChild(res);
		}
		
		public function load(_url:String):void
		{
			var request:URLRequest = new URLRequest(_url);
			gif.load(request);
		}
		
		//! 处理操作，如果返回true，表示截获操作，不继续交给后面的控件处理，否则会交给后面的控件处理
		public override function onCtrl(ctrl:UICtrl):Boolean
		{
			if(lstListener.length <= 0)
				return false;
			
			if(isIn(ctrl.mx, ctrl.my))
			{
				if(canClick)
					Mouse.cursor = MouseCursor.BUTTON;
				
				if(ctrl.lBtn == UICtrl.KEY_STATE_UP)
				{
					procUINotify(this, UIDef.NOTIFY_CLICK_GIF);
					
					return true;
				}
				
				return true;
			}
			//else
				//Mouse.cursor = MouseCursor.AUTO;
			
			return false;
		}
	}
}