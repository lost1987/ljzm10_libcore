package ronco.base
{
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.ByteArray;
	
	public interface ListenerMsgProc
	{
		function onConnect(_client:NetCore):void;
		
		function onClose(_client:NetCore):void;
		
		function onRecvMsg(_client:NetCore, _msg:NetBuff):void;
		
		function onConnectIOError(_client:NetCore):void;
		
		function onSecurityError(_client:NetCore):void;
	}
}