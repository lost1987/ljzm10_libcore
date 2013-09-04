package ronco.base
{
	public class AStar_Node
	{
		public var x:int;
		public var y:int;
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var walkable:Boolean = true;		//是否可穿越（通常把障碍物节点设置为false）
		public var parent:AStar_Node;
		public var costMultiplier:Number = 1.0;	//代价因子

		public function AStar_Node(_x:int, _y:int)
		{
			x = _x;
			y = _y;
		}

//		public function isEqu(right:AStar_Node):Boolean
//		{
//			return x == right.x && y == right.y;
//		}
	}
}