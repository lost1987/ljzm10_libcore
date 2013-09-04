package ronco.base
{
	import flash.display.*;
	import flash.filters.*;
	
	public class Base
	{
		public static function str2color(str:String):int
		{
			return parseInt(str, 16);
		}
		
		public static function color2str(color:int):String
		{
			return color.toString(16);
		}
		//public static var lstColorMatrixFilter:Vector.<ColorMatrixFilter> = new Vector.<ColorMatrixFilter>;
		
		//! 安全删除，会检查是否存在子节点，有效率消耗
		public static function safeRemoveChild(parent:DisplayObjectContainer, child:DisplayObject):void
		{
			for(var i:int = 0; i < parent.numChildren; ++i)
			{
				if(parent.getChildAt(i) == child)
				{
					parent.removeChildAt(i);
					
					return ;
				}
			}
		}
		
		public static function setGray(obj:DisplayObject, bGray:Boolean, filterGray:ColorMatrixFilter):ColorMatrixFilter
		{
			var lst:Array = obj.filters;
			if(!bGray)
			{
				if(lst == null)
					return filterGray;
				
				//! 隐患，插入进入的滤镜地址会变，所以不知道哪个才是灰色的，只有全部清空先
				lst.splice(0, lst.length);
//				for(var i:int = 0; i < lst.length; ++i)
//				{
//					if(lst[i].hasOwnProperty("filter_type") && lst[i]["filter_type"] == "gray")
//						lst.splice(i, 1);
//				}
				
				obj.filters = lst;
				
				return filterGray;
			}
			
			if(lst == null)
				lst = new Array;			
			
			if(filterGray == null)
			{
				filterGray = new flash.filters.ColorMatrixFilter();
				//filterGray["filter_type"] = "gray";
				
				filterGray.matrix = new Array(    
					0.3,0.59,0.11,0,0,    
					0.3,0.59,0.11,0,0,    
					0.3,0.59,0.11,0,0,    
					0,0,0,1,0);
			}
			
			lst.push(filterGray);
			
			obj.filters = lst;
			
			return filterGray;
		}		
		
		public function Base()
		{
		}
	}
}