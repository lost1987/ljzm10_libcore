package ronco.bbxq
{
	public class ObjAniMgr
	{
		public static var singleton:ObjAniMgr = new ObjAniMgr;
		
		public var lst:Object = new Object;
		
		public function ObjAniMgr()
		{
		}
		
		public function addAni(_name:String):void
		{
			lst[_name] = new ObjAni(_name);
		}
	}
}