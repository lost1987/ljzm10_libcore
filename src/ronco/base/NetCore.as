package ronco.base
{
	import flash.events.*;
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.ByteArray;
	
	public class NetCore
	{	
		public var socket:Socket;
		public var buffSend:NetBuff;
		public var buffRecv:NetBuff;
		
//		public var msgSize:int;		//! 如果msgSize为-1，表示消息头都没有读取完毕，否则表示消息长度
//		public var mainid:int;
//		public var assid:int;
		
		public var lstMsgProc:Vector.<ListenerMsgProc> = new Vector.<ListenerMsgProc>; 
		//public var msgProc:ListenerMsgProc;
		
		public function NetCore(_msgProc:ListenerMsgProc)
		{
			lstMsgProc.push(_msgProc);
			//msgProc = _msgProc;
			
			socket = new Socket();
			buffSend = new NetBuff();
			buffRecv = new NetBuff();
			
//			msgSize = -1;
			socket.addEventListener(IOErrorEvent.IO_ERROR,_onConnectIOError);
			socket.addEventListener(Event.CONNECT, _onConnect);   
			socket.addEventListener(Event.CLOSE, _onClose); 			
			socket.addEventListener(ProgressEvent.SOCKET_DATA, _onRecv);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,_onSecurityError);
		}
				
		public function addMsgProc(_msgProc:ListenerMsgProc):void
		{
			lstMsgProc.push(_msgProc);
		}
		
		public function onConnect(_client:NetCore):void
		{
			for(var i:int = 0; i < lstMsgProc.length; ++i)
				lstMsgProc[i].onConnect(_client);
		}
		
		public function onClose(_client:NetCore):void
		{
			for(var i:int = 0; i < lstMsgProc.length; ++i)
				lstMsgProc[i].onClose(_client);
		}		
		
		public function onRecvMsg(_client:NetCore, _msg:NetBuff):void
		{
			for(var i:int = 0; i < lstMsgProc.length; ++i)
			{
				lstMsgProc[i].onRecvMsg(_client, _msg);
				////MainLog.singleton.output("NetCore = " + _client + "msg.MainID = " + _msg.mainid + "msg.assID = " + _msg.assid);
			}
		}
		
		public function connect(addr:String, port:int):void
		{
			//MainLog.singleton.output("connect " + addr + ":" + port + "......");
				
			socket.connect(addr, port);

		}
		
		public function onConnectIOError(_client:NetCore):void
		{
			for(var i:int = 0; i < lstMsgProc.length; ++i)
				lstMsgProc[i].onConnectIOError(_client);
		}
		
		public function onSecurityError(_client:NetCore):void
		{
			for(var i:int = 0; i < lstMsgProc.length; ++i)
				lstMsgProc[i].onSecurityError(_client);
		}
		
//		public function pushMsgHead(_mid:int, _assid:int, _size:int):void
//		{
//			buffSend.writeShort(_size);
//			
//			buffSend.writeByte(_assid);
//			buffSend.writeByte(_mid);
//		}
		
		public function sendMsg():void
		{
			buffSend.encode();
			
//			for(var i:int = 0; i < buffSend.length; ++i)
//				MainLog.log.output("send buff is " + i + ":" + buffSend[i]);
				
			socket.writeBytes(buffSend);
			socket.flush();
			
			buffSend.clearEx();
		}
		
		//收到服务器消息
		private function _onRecv(event:Event):void
		{
			//! readBytes不是阻塞的，如果读取不到那么多数据，会抛出 EOFError 的错误，简单处理，
			//! 一个一个字节来处理
			while(socket.bytesAvailable)
			{
				//socket.readBytes(buffRecv, 0, 4);
				
				buffRecv.writeByte(socket.readByte());
				
				if(buffRecv.msgSize == -1)
				{
					//! 一个一个字节的处理，不可能一下子大于4，没断言
					if(buffRecv.length == 4)
					{
//						for(var i:int = 0; i < buffRecv.length; ++i)
//							MainLog.log.output("recv buff is " + i + ":" + buffRecv[i]);
						
						buffRecv.getMsgHead();
						
//						msgSize = buffRecv.readShort();
//						assid = buffRecv.readByte();
//						mainid = buffRecv.readByte();
						
						////MainLog.singleton.output("recv msg head: " + buffRecv.mainid + "," + buffRecv.assid + "," + buffRecv.msgSize);
						
						if(buffRecv.msgSize == 4)
						{
//							//MainLog.singleton.output("recv msg head: " + buffRecv.msgSize);
							
							onRecvMsg(this, buffRecv);
							
							buffRecv.clearEx();
						}
					}
				}				
				else if(buffRecv.msgSize > 4)
				{
					if(buffRecv.length == buffRecv.msgSize)
					{
//						//MainLog.singleton.output("recv msg len is " + buffRecv.msgSize);
						
						buffRecv.decode();
						
//						for(var i:int = 0; i < buffRecv.length; ++i)
//							MainLog.log.output("recv buff is " + i + ":" + buffRecv[i]);
						
						onRecvMsg(this, buffRecv);
						
						buffRecv.clearEx();
					}
				}
			} // while
		}
		
		//连接服务器后输出
		private function _onConnect(event:Event):void
		{
			//MainLog.singleton.output("connect: " + event);
			
			onConnect(this);
		}
		
		//断开服务器后输出
		private function _onClose(event:Event):void
		{
			//MainLog.singleton.output("close connect: " + event);
			
			onClose(this);
		}
		
		//连接服务器失败
		public function _onConnectIOError(event:IOErrorEvent):void
		{
			//MainLog.singleton.output("connect fail");
			
			onConnectIOError(this);
		}
		
		public function _onSecurityError(evt:SecurityErrorEvent):void
		{
			//MainLog.singleton.output("security error");
			
			onSecurityError(this);
		}
	}
}
