package ronco.ani
{
	import flash.display.DisplayObject;

	/**
	 * 每间隔一段时间改变 visible 状态
	 **/ 
	public class Ani_ShowHide extends Ani
	{
		/**
		 * 改变时间
		 **/ 
		public var timeChg:int;
		
		/**
		 * 动画改变的对象
		 **/ 
		public var obj:DisplayObject;
		
		/**
		 * construct
		 **/ 
		public function Ani_ShowHide(_timeChg:int, _obj:DisplayObject)
		{
			super();
			
			timeChg = _timeChg;
			obj = _obj;
		}
		
		/**
		 * 每帧调用
		 **/ 		
		public override function onUpdate(offtime:int):void
		{
			timeCur += offtime;
			
			if(timeCur >= timeChg)
			{
				obj.visible = !obj.visible;
				
				timeCur = 0;
			}
		}		
		
		/**
		 * 停止时调用
		 **/ 
		public override function onStop():void
		{
			obj.visible = true;
			
			super.onStop();
		}
	}
}