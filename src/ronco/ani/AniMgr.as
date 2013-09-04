package ronco.ani
{
	/**
	 * 动画管理器
	 **/ 
	public class AniMgr
	{
		/**
		 * singleton
		 **/ 
		public static var singleton:AniMgr = new AniMgr;
		
		/**
		 * 活动动画队列
		 **/ 
		public var lst:Vector.<Ani> = new Vector.<Ani>(); 
		
		
		/**
		 * construct
		 **/
		public function AniMgr()
		{
		}
		
		/**
		 * 添加动画，动画只有被添加，才会产生效果
		 * 动画不允许重复添加
		 **/ 
		public function addAni(ani:Ani):void
		{
			if(lst.indexOf(ani) != -1)
				return;
				
			ani.timeCur = 0;
			
			var len:int = lst.length;
			for(var i:int = 0; i < len; ++i)
			{
				if(lst[i] == ani)
					return ;
			}
			
			lst.push(ani);
		}
		
		/**
		 * 删除动画
		 **/ 
		public function removeAni(ani:Ani):void
		{
			if(lst.indexOf(ani) == -1)
				return;
			
			var len:int = lst.length;
			for(var i:int = 0; i < len; )
			{
				if(lst[i] == ani)
				{
					ani.onStop();
					
					lst.splice(i, 1);
					
					len = lst.length;
				}
				else
					++i;
			}			
		}
		
		/**
		 * 每帧调用
		 **/ 
		public function onUpdate(offtime:int):void
		{
			var len:int = lst.length;
			for(var i:int = 0; i < len; )
			{
				lst[i].onUpdate(offtime);
				if(lst[i].isNeedErase)
				{
					lst[i].onStop();
					
					lst.splice(i, 1);
					
					len = lst.length;					
				}
				else
					++i;
			}		
		}
	}
}
