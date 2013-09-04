package ronco.base
{
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.*;
	
	public class CtrlMgr
	{
		public static var singleton:CtrlMgr = new CtrlMgr;
		
		public var isDisable:Boolean = false;
		
		public var lst:Vector.<ListenerCtrl> = new Vector.<ListenerCtrl>;
		
		public var mx:int;
		public var my:int;
		
		public var delta:int = 0;
		
		public var closeRectObj:Object;
		
		/**
		 * 判断双击需要的数据
		 **/ 
		public var timeClick:int = -1;
		public var timerDBClick:int = 300;
		public var offDBClick:int = 2;
		public var xClick:int;
		public var yClick:int;
		
		/**
		 * 可操作的矩形区域
		 * 如果这个值为空，则不拦截任何消息
		 * 否则，包括鼠标移动在内的所有操作都会被拦截
		 **/ 
		public var ctrlRect:Rectangle;
		public var funcClickOut:Function;
		
		public function CtrlMgr()
		{
		}
		
		public function addListener(listener:ListenerCtrl):void
		{
			for(var i:int = 0; i < lst.length; ++i)
			{
				if(lst[i] == listener)
					return ;
			}
			
			lst.push(listener);
		}
		
		public function removeListener(listener:ListenerCtrl):void
		{
			for(var i:int = 0; i < lst.length; ++i)
			{
				if(lst[i] == listener)
				{
					lst.splice(i, 1);
					
					return ;
				}
			}
		}		
		
		public function onMouseOver(e:MouseEvent):void
		{
			if(isDisable)
				return ;
			
			if(ctrlRect != null && e.target != closeRectObj)
			{
				if(e.stageX < ctrlRect.left || e.stageX > ctrlRect.right || 
						e.stageY < ctrlRect.top || e.stageY > ctrlRect.bottom)
					return ;
			}
			
			mx = e.stageX;
			my = e.stageY;
			
			for(var i:int = 0; i < lst.length; ++i)
			{
				if(lst[i].onMouseOver(e))
					return ;
			}
		}
		
		public function onMouseOut(e:MouseEvent):void
		{
			if(isDisable)
				return ;
			
			for(var i:int = 0; i < lst.length; ++i)
			{
				if(lst[i].onMouseOut(e))
					return ;
			}			
		}
		
		public function onMouseDown(e:MouseEvent):void
		{
			if(isDisable)
				return ;
			
			if(ctrlRect != null && e.target != closeRectObj)
			{
				if(e.stageX < ctrlRect.left || e.stageX > ctrlRect.right || 
					e.stageY < ctrlRect.top || e.stageY > ctrlRect.bottom)
				{
					if(funcClickOut != null)
						funcClickOut(e);
					return ;
				}
			}
			
			var ctime:int = getTimer();
			
			if(timeClick == -1)
			{
				timeClick = ctime;
			}
			else
			{
				if(ctime - timeClick > timerDBClick)
					timeClick = ctime;
				else if(Math.abs(e.stageX - xClick) <= offDBClick && Math.abs(e.stageY - yClick) <= offDBClick)
				{
					onDoubleClick(e);
					
					return ;
				}
			}
			
			mx = e.stageX;
			my = e.stageY;
			
			xClick = mx;
			yClick = my;
			
			for(var i:int = 0; i < lst.length; ++i)
			{
				if(lst[i].onMouseDown(e))
					return ;
			}			
		}
		
		public function onMouseUp(e:MouseEvent):void
		{
			if(isDisable)
				return ;
			
			if(ctrlRect != null && e.target != closeRectObj)
			{
				if(e.stageX < ctrlRect.left || e.stageX > ctrlRect.right || 
					e.stageY < ctrlRect.top || e.stageY > ctrlRect.bottom)
					return ;
			}
			
			mx = e.stageX;
			my = e.stageY;
			
			for(var i:int = 0; i < lst.length; ++i)
			{
				if(lst[i].onMouseUp(e))
					return ;
			}			
		}
		
		public function onMouseWheel(e:MouseEvent):void
		{
			if(isDisable)
				return ;
			
			if(ctrlRect != null && e.target != closeRectObj)
			{
				if(e.stageX < ctrlRect.left || e.stageX > ctrlRect.right || 
					e.stageY < ctrlRect.top || e.stageY > ctrlRect.bottom)
					return ;
			}
			
			mx = e.stageX;
			my = e.stageY;
			
			delta = e.delta;
			
			for(var i:int = 0; i < lst.length; ++i)
			{
				if(lst[i].onMouseWheel(e))
				{
					delta = 0;
					return ;
				}
			}	
			delta = 0;
		}
		
		
		public function onDoubleClick(e:MouseEvent):void
		{
			if(isDisable)
				return ;
			
			if(ctrlRect != null && e.target != closeRectObj)
			{
				if(e.stageX < ctrlRect.left || e.stageX > ctrlRect.right || 
					e.stageY < ctrlRect.top || e.stageY > ctrlRect.bottom)
					return ;
			}
			
			mx = e.stageX;
			my = e.stageY;
			
			for(var i:int = 0; i < lst.length; ++i)
			{
				if(lst[i].onDoubleClick(e))
					return ;
			}			
		}
		
		public function onKeyDown(e:KeyboardEvent):void
		{
			if(isDisable)
				return ;
			
			for(var i:int = 0; i < lst.length; ++i)
			{
				if(lst[i].onKeyDown(e))
					return ;
			}			
		}
	}
}