package ronco.base
{
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.ByteArray;
	
	public interface ListenerMsgProc31
	{
		function onConnect(_client:NetCore31):void;
		
		function onClose(_client:NetCore31):void;
		
		function onRecvMsg(_client:NetCore31, _msg:NetBuff31):void;
	}
}