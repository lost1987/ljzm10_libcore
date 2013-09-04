package ronco.ui
{
	import fl.managers.FocusManager;
	
	/**
	 * 输入框基类
	 **/ 
	public class EditBase extends UIElement
	{
		public function EditBase(_type:int, _name:String, _parent:UIElement)
		{
			super(_type, _name, _parent);
		}
		
		/**
		 * 是否激活状态
		 **/ 
		public function isActive(mgrFocus:FocusManager):Boolean
		{
			return false;
		}
	}
}