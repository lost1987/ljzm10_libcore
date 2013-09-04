package ronco.xqb
{
	public class Map extends Object
	{
		public var lst:Vector.<Pair> = new Vector.<Pair>;
		
		public function Map()
		{
		}
		
		public function insert(_key:Object, _value:Object):void
		{
			for(var i:int = 0; i < lst.length; ++i)
			{
				if(lst[i].key == _key)
				{
					lst[i].value = _value;
					
					return ;
				}
			}
			
			lst.push(new Pair(_key, _value));
		}
		
		public function getValue(_key:Object):Object
		{
			for(var i:int = 0; i < lst.length; ++i)
			{
				if(lst[i].key == _key)
					return lst[i].value;
			}
			
			return null;
		}
		
		public function remove(_key:Object):void
		{
			for(var i:int = 0; i < lst.length; ++i)
			{
				if(lst[i].key == _key)
				{
					lst.splice(i, 1);
					
					return ;
				}
			}			
		}
		
		public function hasKey(_key:Object):Boolean
		{
			for(var i:int = 0; i < lst.length; ++i)
			{
				if(lst[i].key == _key)
					return true;
			}
			
			return false;
		}
	}
}