package ronco.ui
{
	import fl.controls.CheckBox;
	import fl.events.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import ronco.base.*;
	import ronco.ui.*;

	
	public class UIList extends UIElement implements UIListener
	{
		public var curIndex:int = 0;							//! 当前选择的第几个
		public var maxIndex:int = 0;							//! 现在列表总数
		public var lst:Vector.<ronco.ui.UIElement> = new Vector.<ronco.ui.UIElement>;		// 游戏状态队列 
		private var scroll:ScrollBar;					//! 滚动条
		//private var backBitmap:Bitmap;					//! 底图
		private var lst_height:int;					//! 滚动调高
		private var rectList:Rectangle;
		private var scrollbit:Bitmap;					//! 滚动条标致图片
		
		private var w:int;								//! 宽
		private var h:int;								//! 高
		
		public function UIList(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_ELECONTAINER, _name, _parent);
		}
		
		public function Init(_w:int, _h:int, res_d1:BitmapData, res_d2:BitmapData, res_u1:BitmapData, res_u2:BitmapData,
							 res_thumb:BitmapData, res_track:BitmapData):void
		{
//			//! 添加地图
//			backBitmap = new _backres as Bitmap;
//			addChild(backBitmap);
			var d1:Bitmap = new Bitmap(res_d1);
			var d2:Bitmap = new  Bitmap(res_d2);
			var u1:Bitmap = new Bitmap(res_u1);
			var u2:Bitmap = new Bitmap(res_u2);
			var thumb:Bitmap = new Bitmap(res_thumb);
			var track:Bitmap = new Bitmap(res_track);
			w = _w;
			h = _h;
			//! 添加滚动条
			//scroll = new ScrollBar("滚动条"+_scroll, this);
			scroll = parentEle.findElement("滚动条") as ronco.ui.ScrollBar;
			var style:Object = new Object;
			
			style["downArrowDisabledSkin"] = d1;
			style["downArrowDownSkin"] = d1;
			style["downArrowOverSkin"] = d2;
			style["downArrowUpSkin"] = d1;
			style["upArrowDisabledSkin"] = u1;
			style["upArrowDownSkin"] = u1;
			style["upArrowOverSkin"] = u2;
			style["upArrowUpSkin"] = u1;
			style["thumbDisabledSkin"] = thumb;
			style["thumbDownSkin"] = thumb;
			style["thumbOverSkin"] = thumb;
			style["thumbUpSkin"] = thumb;
			style["trackDisabledSkin"] = track;
			style["trackDownSkin"] = track;
			style["trackOverSkin"] = track;
			style["trackUpSkin"] = track;
			
			scroll.init(style);
			scrollbit = thumb;
//			scroll.x = backBitmap.width - scrollbit.width;
//			scroll.y = 0;
			scroll.bar.setSize(w, h);
			
			
			if(lst_height > h)
				scroll.bar.maxScrollPosition = lst_height - h;
			else
				scroll.bar.maxScrollPosition = 0;
			
			scroll.bar.minScrollPosition = 0;
			scroll.bar.scrollPosition = 0;
			scroll.bar.lineScrollSize = 5;
			
			rectList = new Rectangle(0,0,w, h);
			//rectList = new Rectangle(0,0,0, 0);
			
			scrollRect = rectList;
			
			scroll.bar.addEventListener(fl.events.ScrollEvent.SCROLL, onScroll);
			
			cleanItem();
		}
		
		public function cleanItem():void
		{
			while(lst.length > 0)
			{
				this.removeChild(lst[0]);
				lst.splice(0,1);
			}
			maxIndex = 0;
			update();
		}
		
		public function AddItem(ele:UIElement):void
		{
			this.addChild(ele);
			lst.push(ele);
			lst_height += ele.lh;
			maxIndex++;
		}
		
		public function SubItme(ele:UIElement):void
		{
			this.removeChild(ele);
			for(var i:int = 0; i < lst.length; ++i)
				if(lst[i] == ele)
					lst.splice(i,1);
			lst_height -= ele.lh;
			maxIndex--;
			update();
		}
		
		public function SubCurItem():void
		{
			this.removeChild(lst[curIndex]);
			lst_height -= lst[curIndex].lh;
			//trace("UIList中的删除  msgid = " + lst[curIndex].msgid);
			lst.splice(curIndex, 1);
			maxIndex--;
			curIndex = 0;
			update();
		}
		
		public function onScroll(e:fl.events.ScrollEvent):void
		{
			rectList.top = scroll.bar.scrollPosition;
			rectList.bottom = rectList.top + h;
			trace("rectList.top = " + rectList.top);
			trace("rectList.bottom = " + rectList.bottom);
			scrollRect = rectList;
		}
		
		public function updateScroll():void
		{
			if(lst_height > h)
				scroll.bar.maxScrollPosition = lst_height - h;
			else
			{
				scroll.bar.maxScrollPosition = 0;
				rectList.top = 0;
				scrollRect = rectList;
			}	
		}
		
		public function cleanScroll():void
		{
			scroll.bar.maxScrollPosition = 0;
			lst_height = 0;
			maxIndex = 0;
			rectList.top = 0;
			rectList.left = 0;
			rectList.width = w;
			rectList.height = h;
			scrollRect = rectList;
		}
		
		public function onUINotify(ele:UIElement, notify:int):void
		{
			for(var i:int = 0; i < lst.length; ++i)
			{
				if(ele == lst[i])
				{
					curIndex = i;	
				}
				else
					(lst[i] as ronco.ui.CheckBox).setSaveable(false);
			}	
		}
		
		public function update():void
		{
			for(var i:int = 0; i < lst.length; ++i)
			{
				lst[i].x = 3;
				lst[i].y = i * lst[0].lh;
			}
			updateScroll();
		}
	}
}