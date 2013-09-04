package ronco.base
{
	import mx.core.*;
	
	//! zhs007 @ 2010.12.13
	//! 调整 initModule 接口，增加传入UIComponent参数
	
	//! zhs007 @ 2010.12.21
	//! 调整 initModule 接口，增加传入x, y参数
	
	public interface Module
	{
		function getModuleName():String;
		
		function initModule(_x:int, _y:int, _parent:UIComponent):void;
		
		function beginModule():void;
		
		function endModule():void;
		
		function enableModule(_enable:Boolean):void;
		
		function updateModule():void;
	}
}