package ronco.ui
{
	/**
	 * 一组CheckBox，只允许选中一个
	 * 不是一个控件，只是一个扩展类
	 **/ 
	public class CheckBoxGroup implements UIListener
	{
		/**
		 * CheckBox队列
		 **/ 
		public var lst:Vector.<CheckBox> = new Vector.<CheckBox>();
		/**
		 * 选择的索引
		 **/ 
		public var indexSelect:int = -1;
		/**
		 * UIListener队列
		 **/ 
		public var lstListener:Vector.<UIListener> = new Vector.<UIListener>;
		
		/**
		 * 添加监听
		 **/ 
		public function addListener(listener:UIListener):void
		{
			lstListener.push(listener);
		}	
		
		/**
		 * 抛出UI通知消息
		 **/ 
		public function _onUINotify():void
		{
			for(var i:int = 0; i < lstListener.length; ++i)
			{
				lstListener[i].onUINotify(lst[0], UIDef.NOTIFY_CLICK_BTN);
			}			
		}		
		
		/**
		 * 添加控件
		 **/ 
		public function push(cb:CheckBox):void
		{
			lst.push(cb);
			
			cb.addListener(this);
		}
		
		/**
		 * 选择其中的某一个
		 **/ 
		public function select(index:int):void
		{
			var i:int;
			var len:int = lst.length;
			
			for(i = 0; i < len; ++i)
			{
				if(lst[i].enable)
					lst[i].setSaveable(false);
			}
			
			indexSelect = -1;
			
			if(index >= 0 && index < len)
			{
				lst[index].setSaveable(true);
				indexSelect = index;
			}
		}
		
		/**
		 * UI的通知接口
		 **/ 
		public function onUINotify(ele:UIElement, notify:int):void
		{
			if(notify == UIDef.NOTIFY_CLICK_BTN)
			{
				var i:int;
				var len:int = lst.length;
				
				for(i = 0; i < len; ++i)
				{
					//! === 会检查类型是否相等，
					//! == 可能会发生基本的类型转换
					if(lst[i].enable && ele == lst[i])
					{
						var last:int = indexSelect;
						
						select(i);
						
						if(last != i)
							_onUINotify();
					}
				}				
			}
		}		
		
		/**
		 * 构造函数
		 **/ 
		public function CheckBoxGroup()
		{
		}
	}
}