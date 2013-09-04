package ronco.base
{
	public class TimerMgr
	{
		public static var singleton:TimerMgr = new TimerMgr;
		
		public var lstTimer:Vector.<TimerInfo> = new Vector.<TimerInfo>;
		
		/**
		 * 增加timer
		 **/ 
		public function addTimer(timer:int, func:Function, param:Object):TimerInfo
		{
			var ti:TimerInfo = new TimerInfo;
			
			ti.paramOnTimer = param;
			ti.funcOnTimer = func;
			ti.timer = timer;
			
			lstTimer.push(ti);
			
			return ti;
		}
		
		/**
		 * 上一帧和这一帧的时间差
		 **/ 
		public function onProc(ot:int):void
		{
			var i:int = 0;
			var len:int = lstTimer.length;
			var ti:TimerInfo;
			
			while(i < len)
			{
				ti = lstTimer[i];
				if(ti != null)
				{
					if(ti.isRelease)
					{
						lstTimer.splice(i, 1);
						
						--len;
						
						continue;
					}
					
					if(ti.lastTime < 0)
						ti.lastTime = ti.timer;
					
					if(ti.lastTime <= ot)
					{
						if(ti.funcOnTimer != null)
							ti.funcOnTimer(ti);
						
						ti.lastTime = ti.timer - (ot - ti.lastTime);
					}
					else
						ti.lastTime -= ot;
				}
				
				++i;
			}
		}
		
		public function TimerMgr()
		{
		}
	}
}