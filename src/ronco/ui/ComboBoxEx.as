package ronco.ui
{
	import flash.display.DisplayObjectContainer;
	
	public class ComboBoxEx extends UIElement implements UIListener
	{
		/**
		 * 主label
		 **/ 
		public var main:Label;
		/**
		 * btn
		 **/ 
		public var btn:Button;		
//		/**
//		 * label队列
//		 * "label" 是字符串
//		 * "data" 是一个Object数据，外部使用
//		 * "uilabel" 是具体控件
//		 **/ 
//		public var lst:Vector.<Object> = new Vector.<Object>();
		
		/**
		 * 菜单
		 **/ 
		public var menu:Menu;
		
		public var iSel:int;
		
		/**
		 * 选择后调用函数，定义如下：
		 * onSelect(cmb:ComboBoxEx, sel:int):void
		 **/ 
		public var funcOnSelect:Function;
		
		public var bIn:Boolean = false;
		
		public var funcOnBtn:Function;
		
		/**
		 * construct
		 **/ 
		public function ComboBoxEx(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_COMBOBOXEX, _name, _parent);
			
			iSel = -1;
		}
		
		/**
		 * 初始化
		 **/ 
		public function init(_resBtn:Class, _x:int, _y:int, _w:int, _h:int, _label_ox:int, _label_oy:int):void
		{
			main = UIMgr.singleton.newElement(UIDef.UI_LABEL, "label", this) as Label;
			main.init("");
			main.x = _label_ox;
			main.y = _label_oy;
			
			btn = UIMgr.singleton.newElement(UIDef.UI_BUTTON, "btn", this) as Button;
			btn.init(_resBtn);
			btn.x = _w - btn.lw;
			btn.y = 0;
			btn.addListener(this);
			
			x = _x;
			y = _y;
			
			initEx(_w, _h);
			
			
		}
		
		/**
		 * 设置下拉菜单
		 */
		public function setMenu(_resLstBack:Class, _resSelect:Class, _w:int, _label_ox:int, _label_oy:int, _yoff:int, _label_h:int, _left:int, _top:int, _right:int, _bottom:int, _img_ox:int, _img_oy:int, _parentView:DisplayObjectContainer):void
		{
			menu = UIMgr.singleton.newElement(UIDef.UI_MENU, "menu", null) as Menu;
			menu.init(_resLstBack, _resSelect, _w, _label_ox, _label_oy, _yoff, _label_h, _left, _top, _right, _bottom, _img_ox, _img_oy, _parentView);
		}
		
		/**
		 * 添加节点
		 * 节点是一个Object，Object.label是显示文字，Object.data是对象的属性
		 **/ 
		public function push(obj:Object):void
		{
			var data:Object = new Object();
			data["data"] = obj["data"];
			data["index"] = menu.lst.length;
			
			menu.push(obj["label"], data, _onMenu);
			//lst.push(obj);
			//cb.addItem(obj);
		}
		
		/**
		 * 清空节点
		 **/ 
		public function cleanup():void
		{
			menu.cleanup();
			//lst.splice(0, lst.length);
			//cb.removeAll();
		}
		
		/**
		 * 获取当前选中节点
		 **/ 
		public function getSelectIndex():int
		{
			return iSel;//cb.selectedIndex;
		}
		
		/**
		 * 选择节点
		 **/ 
		public function select(index:int):void
		{
			if(index >= 0 && index < menu.lst.length)
			{
				iSel = index;
				
				main.setText(menu.lst[index]["label"]);
				
				if(funcOnSelect != null)
					funcOnSelect(this, iSel);
			}
			
			//cb.selectedIndex = index;
		}		
		
		/**
		 * 菜单响应
		 **/ 
		public function _onMenu(_menu:Object, param:Object):void
		{
			if(param != null)
			{
				select(param["index"]);
				
				menu.show(false);
			}
		}
		
		/**
		 * 处理操作，如果返回true，表示截获操作，不继续交给后面的控件处理，否则会交给后面的控件处理
		 **/ 
		public override function onCtrl(ctrl:UICtrl):Boolean
		{
			if(isIn(ctrl.mx, ctrl.my))
			{			
				if(!bIn)
				{
					if(funcTips != null)
						funcTips(this, true);
				}		
				bIn = true;
			}
			else if(bIn)
			{
				bIn = false;
				
				if(funcTips != null)
					funcTips(this, false);
			}
			
			//if(isIn(ctrl.mx, ctrl.my))
			{
				return super.onCtrl(ctrl);
//				if(bChgColor && format.color != colorHeightLight)
//				{
//					Mouse.cursor = MouseCursor.BUTTON;
//					
//					format.color = colorHeightLight;
//					
//					label.setStyle("textFormat", format);
//				}
//				
//				if(ctrl.lBtn == UICtrl.KEY_STATE_UP)
//				{
//					onUINotify(this, UIDef.NOTIFY_CLICK_LABEL);
//					
//					return true;
//				}
//				
//				if(ctrl.lBtn != UICtrl.KEY_STATE_NORMAL)
//					return true;
			}
//			else if(format.color != color)
//			{
//				Mouse.cursor = MouseCursor.AUTO;
//				
//				format.color = color;
//				
//				label.setStyle("textFormat", format);				
//			}
			
			return false;
		}
		
		/**
		 * 子控件通知器
		 **/ 
		public function onUINotify(ele:UIElement, notify:int):void
		{
			if(notify == UIDef.NOTIFY_CLICK_BTN && ele == btn)
			{
				procUINotify(this, UIDef.NOTIFY_CLICK_BTN);
				
				menu.x = getRealX();
				menu.y = getRealY() + lh;
				
				menu.show(true);
				
				if(funcOnBtn != null)
				{
					funcOnBtn();
				}
			}
		}
		
	}
}
