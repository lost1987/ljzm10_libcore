package ronco.base
{
	public class ResizeMgr
	{
		public static var singleton:ResizeMgr = new ResizeMgr();
		
		//! void onResize(w, h)
		public var lst:Vector.<Function> = new Vector.<Function>();
		
		public function ResizeMgr()
		{
		}
		
		public function onResize(w:int, h:int):void
		{
			var l:int = lst.length;
			for(var i:int = 0; i < l; ++i)
			{
				var f:Function = lst[i];
				if(f != null)
				{
					f(w, h);
				}
			}
		}
	}
}