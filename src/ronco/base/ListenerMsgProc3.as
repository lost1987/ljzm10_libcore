package ronco.base
{
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.ByteArray;
	
	public interface ListenerMsgProc3
	{
		function onConnect(_client:NetCore3):void;
		
		function onClose(_client:NetCore3):void;
		
		function onRecvMsg(_client:NetCore3, _msg:NetBuff3):void;
	}
}