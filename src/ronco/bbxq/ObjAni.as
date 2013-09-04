package ronco.bbxq
{
	public class ObjAni
	{
		public var name:String;			//! 名字
		
		public var lst:Object = new Object;
		
		public function ObjAni(_name:String)
		{
			name = _name;
		}
		
		public function addAni(_name:String, frames:int):void
		{
			var ani:Object = new Object;
			
			ani["name"] = _name;
			ani["frames"] = frames;
			ani["lst"] = new Array;
			
			lst[_name] = ani;
		}
		
		public function addAniFrame(_name:String, frameindex:int, timer:int):void
		{
			var ani:Object = (lst[_name] as Object);
			if(ani != null && frameindex >= 0 && frameindex < (ani["frames"] as int))
			{
				if(frameindex == (ani["lst"] as Array).length)
				{
					var frame:Object = new Object;
					
					frame["timer"] = timer;
					frame["lst"] = new Array;
					
					(ani["lst"] as Array).push(frame);
				}
			}
		}
		
		public function addAniFrameInfo(_name:String, frameindex:int, layer:int, resid:int):void
		{
			var ani:Object = (lst[_name] as Object);
			if(ani != null && frameindex >= 0 && frameindex < (ani["frames"] as int) && frameindex < (ani["lst"] as Array).length)
			{
				var frame:Object = (ani["lst"] as Array)[frameindex];
				var info:Object = new Object;
				
				info["layer"] = layer;
				info["resid"] = resid;
				
				(frame["lst"] as Array).push(info);
			}			
		}
		
		// 根据时间获得帧数
		public function countFrame(_name:String, time:int):int
		{
			var ani:Object = (lst[_name] as Object);
			if(ani == null)
				return -1;
			
			if(ani["frames"] <= 1)
				return 0;
			
			var total:int = 0;
			for(var i:int = 0; i < ani["frames"]; ++i)
			{
				if(time >= total && time < total + (ani["lst"] as Array)[i]["timer"])
					return i;
				
				total += (ani["lst"] as Array)[i]["timer"];
			}
			
			return -1;
		}
	}
}
