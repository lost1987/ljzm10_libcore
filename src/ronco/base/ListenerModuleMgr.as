package ronco.base
{
	public interface ListenerModuleMgr
	{
		function onProgress(info:ModuleInfo, per:Number):void;
		
		function onDownloadBegin():void;
		
		function onDownloadEnd():void;
	}
}