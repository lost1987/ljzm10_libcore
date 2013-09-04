package ronco.xqb
{
	public interface Module
	{
		function initModule():void;
		
		function beginModule():void;
		
		function endModule():void
		
		function enableModule(_enable:Boolean):void;
		
		function updateModule():void;
	}
}