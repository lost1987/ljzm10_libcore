package ronco.base
{
	import flash.events.*;
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.ByteArray;
	
	public class NetCore3
	{	
		public var socket:Socket;
		public var buffSend:NetBuff3;
		public var buffRecv:NetBuff3;
		
		public var isConnect:Boolean;
		
//		public var msgSize:int;		//! 如果msgSize为-1，表示消息头都没有读取完毕，否则表示消息长度
//		public var mainid:int;
//		public var assid:int;
		
		public var lstMsgProc:Vector.<ListenerMsgProc3> = new Vector.<ListenerMsgProc3>; 
		//public var msgProc:ListenerMsgProc;
		
		public function NetCore3(_msgProc:ListenerMsgProc3)
		{
			lstMsgProc.push(_msgProc);
			//msgProc = _msgProc;
			
			socket = new Socket();
			buffSend = new NetBuff3();
			buffRecv = new NetBuff3();
			
//			msgSize = -1;
			
			socket.addEventListener(Event.CONNECT, _onConnect);   
			socket.addEventListener(Event.CLOSE, _onClose); 			
			socket.addEventListener(ProgressEvent.SOCKET_DATA, _onRecv);
		}
		
		public function addMsgProc(_msgProc:ListenerMsgProc3):void
		{
			lstMsgProc.push(_msgProc);
		}
		
		public function onConnect(_client:NetCore3):void
		{
			for(var i:int = 0; i < lstMsgProc.length; ++i)
				lstMsgProc[i].onConnect(_client);
			
			isConnect = true;
		}
		
		public function onClose(_client:NetCore3):void
		{
			for(var i:int = 0; i < lstMsgProc.length; ++i)
				lstMsgProc[i].onClose(_client);
			
			isConnect = false;
		}		
		
		public function onRecvMsg(_client:NetCore3, _msg:NetBuff3):void
		{
			for(var i:int = 0; i < lstMsgProc.length; ++i)
			{
				lstMsgProc[i].onRecvMsg(_client, _msg);
				////MainLog.singleton.output("NetCore3 = " + _client + "msg.MainID = " + _msg.mainid + "msg.assID = " + _msg.assid);
			}
		}
		
		public function connect(addr:String, port:int):void
		{			
			//MainLog.singleton.output("connect " + addr + ":" + port + "......");
				
			socket.connect(addr, port);
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
							////MainLog.singleton.output("recv msg head: " + buffRecv.msgSize);
							
							onRecvMsg(this, buffRecv);
							
							buffRecv.clearEx();
						}
					}
				}				
				else if(buffRecv.msgSize > 4)
				{
					if(buffRecv.length == buffRecv.msgSize)
					{
						////MainLog.singleton.output("recv msg len is " + buffRecv.msgSize);
						
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
	}
}
