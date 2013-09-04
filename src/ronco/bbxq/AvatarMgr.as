package ronco.bbxq
{
	public class AvatarMgr
	{
		public static var singleton:AvatarMgr = new AvatarMgr;
		
		public var lst:Object = new Object;
		
		public function AvatarMgr()
		{
		}
		
		public function addAvatar(aid:int, name:String, type:int, img:String):void
		{
			var obj:Object = new Object;
			
			obj["aid"] = aid;
			obj["name"] = name;
			obj["type"] = type;
			obj["img"] = img;
			obj["resinfo"] = new AvatarRes();
			
			lst["a_" + aid] = obj; 
		}
		
		public function getAvatar(aid:int):Object
		{
			return lst["a_" + aid];
		}
		
		public function getAvatarRes(aid:int):AvatarRes
		{
			return (lst["a_" + aid] as Object)["resinfo"];
		}		
	}
}