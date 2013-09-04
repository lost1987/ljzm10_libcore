package ronco.ui
{
	import fl.controls.ComboBox;
	import flash.events.Event;
	
	/**
	 * 下拉框
	 **/ 
	public class ComboBox extends UIElement
	{
		/**
		 * fl控件
		 **/ 
		public var cb:fl.controls.ComboBox = new fl.controls.ComboBox;
		
		/**
		 * 构造函数
		 **/ 
		public function ComboBox(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_COMBOBOX, _name, _parent);
		}
		
		/**
		 * 初始化
		 **/ 
		public function init(_x:int, _y:int, _w:int, _h:int):void
		{
			addChild(cb);
			
			x = _x;
			y = _y;
			initEx(_w, _h);
			
			cb.editable = false;
			cb.dropdownWidth = _w;
			cb.width = _w;
			cb.setStyle("buttonWidth", 12);
			cb.setStyle("upSkin", null);
			cb.addEventListener(Event.CHANGE, _onChange);
		}
		
		/**
		 * 添加节点
		 * 节点是一个Object，Object.label是显示文字，Object.data是对象的属性
		 **/ 
		public function push(obj:Object):void
		{
			cb.addItem(obj);
		}
		
		/**
		 * 清空节点
		 **/ 
		public function cleanup():void
		{
			cb.removeAll();
		}
		
		/**
		 * 获取当前选中节点
		 **/ 
		public function getSelectIndex():int
		{
			return cb.selectedIndex;
		}
		
		/**
		 * 选择节点
		 **/ 
		public function select(index:int):void
		{
			cb.selectedIndex = index;
		}		
		
		/**
		 * 内容改变
		 **/ 
		private function _onChange(e:Event):void
		{
			procUINotify(this, UIDef.NOTIFY_CMBBOX_CHANGE);
		}		
	}
}