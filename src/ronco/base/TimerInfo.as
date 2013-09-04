package ronco.base
{
	public class TimerInfo
	{
		/**
		 * 控件计时器接口
		 * 接口定义如下：
		 * onTimer(param:Object):void
		 **/ 
		public var funcOnTimer:Function;
		
		public var paramOnTimer:Object;
		
		public var timer:int = -1;
		
		public var lastTime:int = -1;
		
		public var isRelease:Boolean = false;
		
		public function TimerInfo()
		{
		}
	}
}