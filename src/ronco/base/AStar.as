package ronco.base
{
	import flash.display.*;
	
	public class AStar
	{
		private var _open:Array = new Array();							//开放列表
		private var _closed:Array = new Array();						//封闭列表

		private var _grid:AStar_Grid;
		//private var _grid:Grid;

		private var _endNode:AStar_Node;// = new AStar_Node(0, 0);		//终点
		private var _startNode:AStar_Node;// = new AStar_Node(0, 0);		//起点

		private var _path:Array = new Array();//最终的路径节点
		
		// private var _heuristic:Function = manhattan;
		// private var _heuristic:Function = euclidian;
		private var _heuristic:Function = diagonal; //估计公式

		private var _straightCost:Number = 1.0; //直线代价       
		private var _diagCost:Number = Math.SQRT2; //对角线代价       
		
		public function AStar()
		{
		}
		
		public function countEndNode(sx:int, sy:int, ex:int, ey:int):AStar_Node
		{
			if(ex < 0)
				ex = 0;
			if(ex >= _grid.w)
				ex = _grid.w;
			if(ey < 0)
				ey = 0;
			if(ey >= _grid.h)
				ey = _grid.h;
			
			var node:AStar_Node = _grid.getNode(ex, ey);
			if(node.walkable)
				return node;
			
			while(!node.walkable)
			{
				if(sx > ex)
					++ex;
				else if(sx < ex)
					--ex;
				
				if(sy > ey)
					++ey;
				else if(sy < ey)
					--ey;
				
				node = _grid.getNode(ex, ey);
				
				if(sx == ex && sy == ey)
					break;				
			}
			
			return node;
		}

		//判断节点是否开放列表
		private function isOpen(node:AStar_Node):Boolean
		{
			var i:int;
			
			for(i = 0; i < _open.length; i++)
			{
				if(_open[i] == node)
					return true;
			}
			
			return false;
		}

		//判断节点是否封闭列表
		private function isClosed(node:AStar_Node):Boolean
		{
			var i:int;
			
			for(i = 0; i < _closed.length; i++)
			{
				if(_closed[i] == node)
					return true;
			}
			
			return false;
		}

		//对指定的网络寻找路径
		public function findPath(grid:AStar_Grid, sx:int, sy:int, ex:int, ey:int):Boolean
		{
			_grid = grid;
			//_grid=grid;

			_open.splice(0);
			_closed.splice(0);
			_path.splice(0);

			_startNode = grid.getNode(sx, sy);
			_endNode = countEndNode(sx, sy, ex, ey);
			
			if(_startNode == _endNode)
				return true;
				
			_startNode.g = 0;
			_startNode.h = _heuristic(_startNode);
			_startNode.f = _startNode.g + _startNode.h;

			return search();
		}

		//计算周围节点代价的关键处理函数
		public function search():Boolean
		{
			var _t:uint = 1;
			var node:AStar_Node = _startNode;
			
			//如果当前节点不是终点
			while(node != _endNode)
			{
				//找出相邻节点的x,y范围
				var startX:int = Math.max(0, node.x - 1);
				var endX:int = Math.min(_grid.w - 1, node.x + 1);
				var startY:int = Math.max(0, node.y - 1);
				var endY:int = Math.min(_grid.h - 1, node.y + 1);              
				
				//循环处理所有相邻节点
				for(var i:int = startX; i <= endX; i++)
				{
					for(var j:int = startY; j <= endY; j++)
					{
						var test:AStar_Node = _grid.getNode(i, j);
						
						//如果是当前节点，或者是不可通过的，则跳过
						if(test == node || !test.walkable)
							continue;

						var cost:Number = _straightCost;                     

						//如果是对象线，则使用对角代价
						if (!((node.x == test.x) || (node.y == test.y)))
							cost=_diagCost;

						//计算test节点的总代价                     
						var g:Number=node.g + cost * test.costMultiplier;
						var h:Number=_heuristic(test);                     
						var f:Number=g + h;                

						//如果该点在open或close列表中
						if (isOpen(test) || isClosed(test))
						{
							//如果本次计算的代价更小，则以本次计算为准
							if (f<test.f)
							{
								//trace("\n第",_t,"轮，有节点重新指向，x=",i,"，y=",j,"，g=",g,"，h=",h,"，f=",f,"，test=",test.toString());                             

								test.f=f;
								test.g=g;
								test.h=h;
								test.parent=node;//重新指定该点的父节点为本轮计算中心点
							}
						}
						else//如果还不在open列表中，则除了更新代价以及设置父节点，还要加入open数组
						{
							test.f=f;
							test.g=g;
							test.h=h;
							test.parent=node;
							_open.push(test);
						}
					}
				}
				_closed.push(node);//把处理过的本轮中心节点加入close节点              

//				//辅助调试，输出open数组中都有哪些节点
//				for(i=0;i<_open.length;i++)
//				{
//					trace(_open[i].toString());  
//				}
				
				if (_open.length == 0)
				{
					trace("没找到最佳节点，无路可走!");

					return false
				}

				_open.sortOn("f", Array.NUMERIC);//按总代价从小到大排序

				node=_open.shift() as AStar_Node;//从open数组中删除代价最小的结节，同时把该节点赋值为node，做为下次的中心点

				//trace("第",_t,"轮取出的最佳节点为：",node.toString());

				_t++;

			}
			//循环结束后，构建路径
			buildPath();

			return true;
		}

		//根据父节点指向，从终点反向连接到起点
		private function buildPath():void
		{
			//_path.splice(0);
			//_path=new Array();

			var node:AStar_Node=_endNode;
			_path.push(node);

			while(node != _startNode)
			{
				node=node.parent;
				_path.unshift(node);
			}
		}

		//曼哈顿估价法
		private function manhattan(node:AStar_Node):Number
		{
			return Math.abs(node.x - _endNode.x) * _straightCost + Math.abs(node.y + _endNode.y) * _straightCost;
		}

		//几何估价法
		private function euclidian(node:AStar_Node):Number
		{
			var dx:Number=node.x - _endNode.x;
			var dy:Number=node.y - _endNode.y;

			return Math.sqrt(dx * dx + dy * dy) * _straightCost;
		}
		
		//对角线估价法
		private function diagonal(node:AStar_Node):Number
		{
			var dx:Number=Math.abs(node.x - _endNode.x);
			var dy:Number=Math.abs(node.y - _endNode.y);
			var diag:Number=Math.min(dx, dy);
			var straight:Number=dx + dy;

			return _diagCost * diag + _straightCost * (straight - 2 * diag);
		}

//		//返回所有被计算过的节点(辅助函数)
//		public function get visited():Array
//		{
//			return _closed.concat(_open);
//		}

//		//返回open数组
//		public function get openArray():Array{
//			return this._open;
//		}
//
//		//返回close数组
//		public function get closedArray():Array{
//			return this._closed;
//		}

		public function get path():Array
		{
			return _path;
		}

	}
}