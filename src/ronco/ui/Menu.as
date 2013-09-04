package ronco.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	import ronco.base.Base;
	import ronco.base.BitmapBuilder;
	import ronco.base.ResMgr;

	public class Menu extends UIElement implements UIListener
	{
		/**
		 * label队列
		 * "label" 是字符串
		 * "data" 是一个Object数据，外部使用
		 * "uilabel" 是具体控件
		 * "hotspot" 是每一行的热点区域
		 * "func" 该选项绑定的函数
		 **/ 
		public var lst:Vector.<Object> = new Vector.<Object>();
		
		/**
		 * 背景资源
		 **/ 
		public var resBack:Bitmap;
		/**
		 * 背景
		 **/ 
		public var bmpBack:Bitmap;
		/**
		 * 背景图素
		 **/ 
		public var backBmpData:BitmapData;		
		/**
		 * 选择条
		 **/ 
		public var imgSelected:Image;
		
		/**
		 * 第一项和最后一项的x坐标偏移
		 **/ 
		public var bx:int;
		/**
		 * 第一项和最后一项的y坐标偏移
		 **/ 
		public var by:int;
		/**
		 * 2项之间的坐标偏移
		 **/ 
		public var yoff:int;
		/**
		 * 选择图片的 x偏移
		 **/ 
		public var img_ox:int;
		/**
		 * 选择图片的 y偏移
		 **/ 
		public var img_oy:int;
		/**
		 * label高度
		 **/ 
		public var labelHeight:int;
		/**
		 *背景九宫格 
		 */		
		public var left:int;
		public var top:int;
		public var right:int;
		public var bottom:int;
		
		public var rectBack:Rectangle = new Rectangle;
		
		/**
		 * 显示父节点
		 **/ 
		public var parentView:DisplayObjectContainer;
		
		/**
		 * 上一个选中的节点
		 **/ 
		public var lastNode:Object;
		
		public var alignLabel:String = "left";
		
		public var scrollBar:ScrollBarNew;
		
		public var empty:UIElement;
		
		public var main:UIElement;
		
		/**
		 * construct
		 **/ 
		public function Menu(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_MENU, _name, _parent);
		}
		
		/**
		 * 初始化
		 **/ 
		public function init(_res:Class, _resSelected:Class, _w:int, _ox:int, _oy:int, _yoff:int, _label_h:int, _left:int, _top:int, _right:int, _bottom:int, _img_ox:int, _img_oy:int, _parentView:DisplayObjectContainer):void
		{
			resBack = new _res as Bitmap;
			
			bx = _ox;
			by = _oy;
			yoff = _yoff;
			labelHeight = _label_h;
			
			lw = _w;
			parentView = _parentView;
			
			left = _left;
			top = _top;
			right = _right;
			bottom = _bottom;
			
			main = UIMgr.singleton.newElement(UIDef.UI_EMPTY, "main", this);
			main.addListener(this);
			empty = UIMgr.singleton.newElement(UIDef.UI_EMPTY, "empty", this);
			empty.addListener(this);
			
			_rebuild();
			
			setImg(_resSelected, _img_ox, _img_oy);
			
			visible = false;
		}
		
		
		/**
		 * 
		 */
		public function setImg(_resSelected:Class, _ox:int, _oy:int):void			
		{
			imgSelected = UIMgr.singleton.newElement(UIDef.UI_IMAGE, "img", main) as Image;
			imgSelected.init(_resSelected);
			img_ox = _ox;
			img_oy = _oy;
			imgSelected.visible = false;
		}
		
		/**
		 * show & hide
		 **/ 
		public function show(bVisible:Boolean):void
		{
			if(visible == bVisible)
				return ;
			
			visible = bVisible;
			
			if(bVisible)
			{	
				if(parentView != null)
				{
					parentView.addChild(this);
					//parentView.addChild(empty);
					
				}
				
				UIMgr.singleton.addUIMod(this);
			}
			else
			{
				if(parentView != null)
				{
					//Base.safeRemoveChild(parentView, empty);
					Base.safeRemoveChild(parentView, this);					
				}
				
				UIMgr.singleton.removeUIMod(this);
			}
			resetScrollBar();
		}
		
		public override function initEx(_w:int, _h:int):void
		{
			lw = _w;
			lh = _h;			
			
			main.initEx(lw,lh);
			empty.initEx(lw,lh);
			
			if(scrollBar != null)
				scrollBar.setDest(main);
		}
		
		/**
		 * 重建背景
		 **/ 
		public function _rebuild():void
		{
			var nums:int = lst.length;
			
			if(nums <= 0 && bmpBack != null)
			{
				rectBack.top = 0;
				rectBack.left = 0;
				rectBack.right = 0;
				rectBack.bottom = 0;
				
				bmpBack.scrollRect = rectBack;
//				bmpBack.width = 0;
//				bmpBack.height = 0;
				resetScrollBar();
				return ;
			}
			
			if(nums >= 2)
				initEx(lw, by * 2 + nums * labelHeight + (nums - 1) * yoff);
			else
				initEx(lw, by * 2 + nums * labelHeight);
			
			if(lw == 0 || lh == 0)
				return ;
			
			if(backBmpData == null)
			{
				backBmpData = new BitmapData(lw, lh);
				bmpBack = new Bitmap(backBmpData);
				
				main.addChild(bmpBack);
			}
			else
			{
				if(backBmpData.width < lw || backBmpData.height < lh)
				{
					backBmpData.dispose();
					
					backBmpData = new BitmapData(lw, lh);
					bmpBack.bitmapData = backBmpData;
				}
			}
			
			BitmapBuilder.singleton.buildBitmap(backBmpData, resBack.bitmapData, left, top, right, bottom, lw, lh);
			
//			bmpBack.width = lw;
//			bmpBack.height = lh;
			
			rectBack.top = 0;
			rectBack.left = 0;
			rectBack.right = lw;
			rectBack.bottom = lh;
			
			bmpBack.scrollRect = rectBack;		
			
			resetScrollBar();
		}
		
		/**
		 * 添加节点
		 * 节点是一个Object
		 * "label" 是字符串
		 * "data" 是一个Object数据，外部使用
		 * "uilabel" 是具体控件
		 * "hotspot" 是每一行的热点区域
		 * "func" 该选项绑定的函数，定义如下：onMenu(menu:Object, param:Object) 
		 **/ 
		public function push(str:String, param:Object, func:Function):Object
		{
			var obj:Object = new Object();
			
			obj["label"] = str;
			obj["data"] = param;
			obj["func"] = func;
			
			var nums:int = lst.length;
			
			var label:Label = UIMgr.singleton.newElement(UIDef.UI_LABEL, "label", main) as Label;
			label.init(obj["label"], 12, alignLabel);
			label.setSize(lw - bx * 2 , labelHeight);
			label.setBorder(true, 0);
			label.x = bx;
			label.y = by + nums * labelHeight;
			
			if(nums > 0)
				label.y += nums * yoff;
			
			var hotspot:Hotspot = UIMgr.singleton.newElement(UIDef.UI_HOTSPOT, "hotspot", main) as Hotspot;
			hotspot.init(label.x, label.y, label.lw - getScrollBarWitdth(), label.lh);
			hotspot.addListener(this);
			hotspot.data = obj;
			
			obj["uilabel"] = label;
			obj["hotspot"] = hotspot;
			
			lst.push(obj);
			
			_rebuild();
			
			return obj;
		}
		
		/**
		 * 清空节点
		 **/ 
		public function cleanup():void
		{
			imgSelected.visible = false;
			
			var len:int = lst.length;
			var i:int = 0;
			var obj:Object;
			
			while(i < len)
			{
				obj = lst[i];
				
				obj["uilabel"].releaseEle();
				obj["hotspot"].releaseEle();
				
				if(obj["uilabel"].parent != null)
					obj["uilabel"].parent.removeChild(obj["uilabel"]);
				
				if(obj["hotspot"].parent != null)
					obj["hotspot"].parent.removeChild(obj["hotspot"]);
				
				++i;
			}
			
			len = lst.length;
			i = 0;
			
			while(i < len)
			{
				lst.pop();
				
				++i;
			}			
			//lst.splice(0, lst.length);
			
			_rebuild();
		}
		
		/**
		 * 子控件通知器
		 **/ 
		public function onUINotify(ele:UIElement, notify:int):void
		{
			var node:Object = ele.data;
			
			if(notify == UIDef.NOTIFY_IN_HOTSPOT)
			{	
				lastNode = node;
				
				imgSelected.visible = true;
				imgSelected.x = ele.x + img_ox;
				imgSelected.y = ele.y + img_oy;
			}
			else if(notify == UIDef.NOTIFY_OUT_HOTSPOT)
			{
				if(lastNode != null && lastNode == node)
					imgSelected.visible = false;
			}
			else if(notify == UIDef.NOTIFY_CLICK_HOTSPOT)
			{
				if(node != null && node["func"] != null)
					node["func"](node, node["data"]);
//				imgSelected.visible = true;
//				
//				imgSelected.x = node.hotspot.x;
//				imgSelected.y = node.hotspot.y;
//				
//				if(func != null)
//					func(node, null);
			}
		}
		
		//! 处理操作，如果返回true，表示截获操作，不继续交给后面的控件处理，否则会交给后面的控件处理
		public override function onCtrl(ctrl:UICtrl):Boolean
		{
			if(!visible)
				return false;
			
			if(super.onCtrl(ctrl))
				return true;		
			
			var inmine:Boolean = isIn(ctrl.mx, ctrl.my); 
			if(!inmine)
			{
				if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON)
				{
					show(false);
					
					return false;
				}
			}
			
			if(inmine)
				return true;
			
			return false;
		}	
		
		public function resetScrollBar():void
		{
			var nums:int = lst.length;
			
			if(scrollBar != null)
			{
				if(nums >= 10)
				{
					scrollBar.visible = true;
					
					var _htemp:int = by * 2 + 10 * labelHeight + (10 - 1) * yoff;
					scrollRect = new Rectangle(0,0,lw,_htemp);
					
					scrollBar.setSize(12,_htemp);					
					scrollBar.maxScrollPosition = by * 2 + nums * labelHeight + (nums - 1) * yoff -_htemp;
					scrollBar.x = lw - 15;
					scrollBar.y = 0;
					lh = _htemp;
				
				}else
				{
					scrollBar.visible = false;
					
					scrollRect = null;
				}
			}
		}
		
		public function getScrollBarWitdth():int
		{
			if(scrollBar != null)
			{
				return 25;
			}
			
			return 0;
		}	
		
		
		public function SetScrollBar(styleScrollBar:Object):void
		{			
			
			scrollBar = UIMgr.singleton.newElement(UIDef.UI_SCROLLBAR, name, empty) as ronco.ui.ScrollBarNew;
			
			scrollBar.init(lw - 15, 0,12,lh,ronco.base.ResMgr.singleton.mapClass["scroll_up"] as Class
				,ResMgr.singleton.mapClass["scroll_down"] as Class
				,ResMgr.singleton.mapClass["scroll_back"] as Class
				,ResMgr.singleton.mapClass["scroll_mid"] as Class,empty);			
			scrollBar.setMovesp(1);		
			scrollBar.addListener(this);
		
			//
			
			_rebuild();
			return;
		}
		
	}
}
