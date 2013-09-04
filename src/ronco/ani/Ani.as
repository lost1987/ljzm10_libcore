package ronco.ani
{
	/**
	 * 动画基类
	 **/ 
	public class Ani
	{
		/**
		 * 当前时间，当动画加入到管理器时，重置为0
		 **/ 
		public var timeCur:int;
		/**
		 * 是否需要自动删除
		 **/ 
		public var isNeedErase:Boolean = false;
		
		/**
		 * 外部传入的停止时调用接口
		 * 函数定义如下 onStop(ani:Ani):void
		 **/ 
		public var funcOnStop:Function;
		
		/**
		 * construct
		 **/
		public function Ani()
		{
			isNeedErase = false;
		}
		
		/**
		 * 每帧调用
		 **/ 		
		public function onUpdate(offtime:int):void
		{
			
		}
	
		/**
		 * 停止时调用
		 **/ 
		public function onStop():void
		{
			if(funcOnStop != null)
				funcOnStop(this);
		}
	}
}