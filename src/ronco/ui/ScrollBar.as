package ronco.ui
{
	import fl.controls.*;
	import fl.events.ScrollEvent;
	
	import flash.geom.Rectangle;
	
	public class ScrollBar extends UIElement
	{
		public var bar:fl.controls.ScrollBar = new fl.controls.ScrollBar;
		
		public var ctrlDest:UIElement;
		public var rectDest:Rectangle;
		public var iMovesp:int = 1;		//! 鼠标移动的像素间隔
		
		/**
		 * 滚动条刷新接口，函数定义如下：
		 * onScroll(bar:ScrollBar):void
		 **/ 
		public var funcOnScroll:Function;
		
		public function ScrollBar(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_SCROLLBAR, _name, _parent);
		}
		
		//! style["downArrowDisabledSkin"]
		//! style["downArrowDownSkin"]
		//! style["downArrowOverSkin"]
		//! style["downArrowUpSkin"]
		//! style["upArrowDisabledSkin"]
		//! style["upArrowDownSkin"]
		//! style["upArrowOverSkin"]
		//! style["upArrowUpSkin"]
		//! style["thumbDisabledSkin"]
		//! style["thumbDownSkin"]
		//! style["thumbOverSkin"]
		//! style["thumbUpSkin"]
		//! style["trackDisabledSkin"]
		//! style["trackDownSkin"]
		//! style["trackOverSkin"]
		//! style["trackUpSkin"]
		public function init(style:Object):void
		{
			if(style == null)
				return ;
			
			if(style["downArrowDisabledSkin"] != null)
				bar.setStyle("downArrowDisabledSkin", style["downArrowDisabledSkin"]);
			
			if(style["downArrowDownSkin"] != null)
				bar.setStyle("downArrowDownSkin", style["downArrowDownSkin"]);
			
			if(style["downArrowOverSkin"] != null)
				bar.setStyle("downArrowOverSkin", style["downArrowOverSkin"]);
			
			if(style["downArrowUpSkin"] != null)
				bar.setStyle("downArrowUpSkin", style["downArrowUpSkin"]);
			
			if(style["upArrowDisabledSkin"] != null)
				bar.setStyle("upArrowDisabledSkin", style["upArrowDisabledSkin"]);
			
			if(style["upArrowDownSkin"] != null)
				bar.setStyle("upArrowDownSkin", style["upArrowDownSkin"]);
			
			if(style["upArrowOverSkin"] != null)
				bar.setStyle("upArrowOverSkin", style["upArrowOverSkin"]);
			
			if(style["upArrowUpSkin"] != null)
				bar.setStyle("upArrowUpSkin", style["upArrowUpSkin"]);
			
			if(style["thumbDisabledSkin"] != null)
				bar.setStyle("thumbDisabledSkin", style["thumbDisabledSkin"]);
			
			if(style["thumbDownSkin"] != null)
				bar.setStyle("thumbDownSkin", style["thumbDownSkin"]);
			
			if(style["thumbOverSkin"] != null)
				bar.setStyle("thumbOverSkin", style["thumbOverSkin"]);
			
			if(style["thumbUpSkin"] != null)
				bar.setStyle("thumbUpSkin", style["thumbUpSkin"]);
			
			if(style["trackDisabledSkin"] != null)
				bar.setStyle("trackDisabledSkin", style["trackDisabledSkin"]);
			
			if(style["trackDownSkin"] != null)
				bar.setStyle("trackDownSkin", style["trackDownSkin"]);
			
			if(style["trackOverSkin"] != null)
				bar.setStyle("trackOverSkin", style["trackOverSkin"]);
			
			if(style["trackUpSkin"] != null)
				bar.setStyle("trackUpSkin", style["trackUpSkin"]);			
			
			addChild(bar);
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
			
			bar.addEventListener(fl.events.ScrollEvent.SCROLL, _onScroll);
		}
		
		/**
		 * 内部用的函数，滚动条移动时处理
		 **/ 
		private function _onScroll(e:fl.events.ScrollEvent):void
		{	
			if(ctrlDest != null)
			{
				//! bar.scrollPosition过半下移
				if(int(bar.scrollPosition * 10) % 10 <= 4)
					rectDest.top = int(bar.scrollPosition) * iMovesp;
				else
					rectDest.top = int(bar.scrollPosition + 1) * iMovesp;
				
				rectDest.bottom = rectDest.top + ctrlDest.lh;
				
				ctrlDest.scrollRect = rectDest;
			}
			
			if(funcOnScroll != null)
				funcOnScroll(this);
		}				
	}
}