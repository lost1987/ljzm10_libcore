package ronco.ui
{
	import flash.display.MovieClip;

	public class MoveClipBtn extends UIElement
	{
		public static const STATE_NORMAL:int 			= 0;	//普通状态
		public static const STATE_MOUSEOVER:int 		= 1;	//鼠标移上状态
		public static const STATE_MOUSEDOWN:int 		= 2;	//鼠标点击状态
		public static const STATE_DISABLE:int 		= 3;	//不可用状态
		
		private var clip:MovieClip;
		//private var imgRect:Rectangle;
		public var state:int;
		
		public function MoveClipBtn(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_MC_BUTTON, _name, _parent);
		}
		
		public function init(res:Class ,_format:Object=null):void
		{
			clip = new res as MovieClip;
			
			lw = clip.width;
			lh = clip.height;
			
			chgState(STATE_NORMAL);
			
			addChild(clip);
		}
		
		public function chgState(_s:int):void
		{
			state = _s;
			if(state == STATE_NORMAL)
			{
				clip.stop();
			}
			if(state == STATE_MOUSEOVER && state == STATE_MOUSEDOWN)
			{
				clip.gotoAndStop(8);
			}
			if(state == STATE_DISABLE)
			{
				clip.stop();
			}
		}
		
		public override function onCtrl(ctrl:UICtrl):Boolean
		{
			if(isIn(ctrl.mx, ctrl.my))
			{
				if(ctrl.lBtn == UICtrl.KEY_STATE_NORMAL)
				{
					if(state == STATE_NORMAL)
					{
						chgState(STATE_MOUSEOVER);
						
						return true;
					}
				}
				else if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON || ctrl.lBtn == UICtrl.KEY_STATE_DOWN)
				{
					if(state == STATE_MOUSEOVER)
					{
						chgState(STATE_MOUSEDOWN);
						
						return true;
					}
				}
				else if(ctrl.lBtn == UICtrl.KEY_STATE_UP)
				{
					if(state == STATE_MOUSEDOWN)
					{
						chgState(STATE_MOUSEOVER);
						
						procUINotify(this, UIDef.UI_MC_BUTTON);
						
						return true;
					}
				}
			}
			else if(state == STATE_MOUSEOVER || ctrl.lBtn == UICtrl.KEY_STATE_UP)
			{
				chgState(STATE_NORMAL);
				
			}
			
			return false;
		}
	}
}