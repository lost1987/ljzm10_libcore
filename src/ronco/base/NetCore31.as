package ronco.base
{
	import flash.events.*;
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.ByteArray;
	
	public class NetCore31
	{	
		public var socket:Socket;
		public var buffSend:NetBuff31;
		public var buffRecv:NetBuff31;
		
		public var msgIDSend:int;
		public var msgIDRecv:int;
		
		public var isConnect:Boolean;
		
		public var servAddr:String;
		public var servPort:int;
		
//		public var msgSize:int;		//! 如果msgSize为-1，表示消息头都没有读取完毕，否则表示消息长度
//		public var mainid:int;
//		public var assid:int;
		
		public var lstMsgProc:Vector.<ListenerMsgProc31> = new Vector.<ListenerMsgProc31>; 
		
		// tgw
		public var isTGW:Boolean = false;
		
		public var hostTGW:String = "";
		
		/**
		 * 允许msg处理报错
		 **/ 
		public var isAllowMsgError:Boolean = true;
		//public var msgProc:ListenerMsgProc;
		
		public function NetCore31(_msgProc:ListenerMsgProc31)
		{
			lstMsgProc.push(_msgProc);
			//msgProc = _msgProc;
			
			socket = new Socket();
			buffSend = new NetBuff31();
			buffRecv = new NetBuff31();
			
//			msgSize = -1;
			
			socket.addEventListener(Event.CONNECT, _onConnect);   
			socket.addEventListener(Event.CLOSE, _onClose); 			
			socket.addEventListener(ProgressEvent.SOCKET_DATA, _onRecv);
			socket.addEventListener(IOErrorEvent.IO_ERROR, _onIOError);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
		}
		
		public function addMsgProc(_msgProc:ListenerMsgProc31):void
		{
			lstMsgProc.push(_msgProc);
		}
		
		public function onConnect(_client:NetCore31):void
		{
			MainLog.singleton.output("connect ok!");
			
			if(isTGW)
			{
				var str:String = "tgw_l7_forward\r\nHost:" + hostTGW + "\r\n\r\n";
				var buf:ByteArray = new ByteArray;
				buf.writeMultiByte(str, "gbk");
				buf.writeByte(0);
				socket.writeBytes(buf);
				socket.flush();
				
				MainLog.singleton.output(str);
			}
			
			msgIDSend = 0x7b;
			msgIDRecv = 0x7b;
			
			for(var i:int = 0; i < lstMsgProc.length; ++i)
				lstMsgProc[i].onConnect(_client);
			
			isConnect = true;
		}
		
		public function onClose(_client:NetCore31):void
		{
			for(var i:int = 0; i < lstMsgProc.length; ++i)
				lstMsgProc[i].onClose(_client);
			
			isConnect = false;
		}		
		
		public function onRecvMsg(_client:NetCore31, _msg:NetBuff31):void
		{
			for(var i:int = 0; i < lstMsgProc.length; ++i)
			{
				lstMsgProc[i].onRecvMsg(_client, _msg);
				////MainLog.singleton.output("NetCore3 = " + _client + "msg.MainID = " + _msg.mainid + "msg.assID = " + _msg.assid);
			}
		}
		
		public function connect(addr:String, port:int):void
		{			
			MainLog.singleton.output("connect " + addr + ":" + port + "......");
			
			servAddr = addr;
			servPort = port;
			
			var isok:Boolean = false;
			
			while(!isok)
			{
				try{
					socket.connect(addr, port);
					
					isok = true;
				}
				catch(err:Error)
				{
					MainLog.singleton.output("connect err " + err);
				}
			}
			
//			if(isTGW)
//			{
//				var str:String = "tgw_l7_forward\r\nHost:app100719513.qzone.qzoneapp.com:8001\r\n\r\n";
//				var buf:ByteArray = new ByteArray;
//				buf.writeMultiByte(str, "gbk");
//				buf.writeByte(0);
//				socket.writeBytes(buf);
//				socket.flush();
//				
//				MainLog.singleton.output(str);
//			}
		}
		
		public function disconnect():void
		{
			MainLog.singleton.output("disconnect...");
			
			socket.close();
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
			msgIDSend++;
			if(msgIDSend > 0xff)
				msgIDSend = 0;
			
			buffSend.encode();
			
//			for(var i:int = 0; i < buffSend.length; ++i)
//				MainLog.log.output("send buff is " + i + ":" + buffSend[i]);
			
		//	try{
				socket.writeBytes(buffSend);
				socket.flush();
			/*}
			catch(re:RangeError)
			{
				MainLog.singleton.output("sendmsg fail range error");	
			}
			catch(e:Error)
			{
				MainLog.singleton.output("sendmsg fail error");
				
			}	*/		
			
			buffSend.clearEx();
		}
		
		private function __onRecv(event:Event):void
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
					if(buffRecv.length == 5)
					{
						//						for(var i:int = 0; i < buffRecv.length; ++i)
						//							MainLog.log.output("recv buff is " + i + ":" + buffRecv[i]);
						
						buffRecv.getMsgHead();
						
						//						msgSize = buffRecv.readShort();
						//						assid = buffRecv.readByte();
						//						mainid = buffRecv.readByte();
						
						////MainLog.singleton.output("recv msg head: " + buffRecv.mainid + "," + buffRecv.assid + "," + buffRecv.msgSize);
						
						if(buffRecv.msgSize == 5)
						{
							////MainLog.singleton.output("recv msg head: " + buffRecv.msgSize);
							buffRecv.decode();
							
							buffRecv.getMsgID();
							
							if(msgIDRecv != buffRecv.msgid)
							{
								MainLog.singleton.output("recv msgid fail " + msgIDRecv + " " + 
									buffRecv.msgid);
								
								disconnect();
								
								buffRecv.clearEx();
								
								return ;
							}
							else
							{
								msgIDRecv++;
								if(msgIDRecv > 0xff)
									msgIDRecv = 0;
							}
							
							onRecvMsg(this, buffRecv);
							
							buffRecv.clearEx();
						}
					}
				}				
				else if(buffRecv.msgSize > 5)
				{
					if(buffRecv.length == buffRecv.msgSize)
					{
						////MainLog.singleton.output("recv msg len is " + buffRecv.msgSize);
						
						buffRecv.decode();
						buffRecv.getMsgID();
						
						if(msgIDRecv != buffRecv.msgid)
						{
							MainLog.singleton.output("recv msgid fail " + msgIDRecv + " " + 
								buffRecv.msgid);
							
							disconnect();
							
							buffRecv.clearEx();
							
							return ;
						}				
						else
						{
							msgIDRecv++;
							if(msgIDRecv > 0xff)
								msgIDRecv = 0;
						}						
						
						//						for(var i:int = 0; i < buffRecv.length; ++i)
						//							MainLog.log.output("recv buff is " + i + ":" + buffRecv[i]);
						
						onRecvMsg(this, buffRecv);
						
						buffRecv.clearEx();
					}
				}
			} // while			
		}
		
		//收到服务器消息
		private function _onRecv(event:Event):void
		{
			if(isAllowMsgError)
			{
				__onRecv(event);
			}
			else
			{
				//try{
					__onRecv(event);
//				}
//				catch(err:Error) {
//					MainLog.singleton.output("NetCore31::_onRecv() err " + err.message);
//					
//					onClose(this);
//				}
			}
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
		
		private function _onIOError(event:IOErrorEvent):void
		{
			MainLog.singleton.output("NetCore31 ioerror " + event.toString());
			
			onClose(this);
		}
		
		private function _onSecurityError(event:SecurityErrorEvent):void
		{
			MainLog.singleton.output("NetCore31 SecurityError " + event.toString());
			
			connect(servAddr, servPort);
		}
	}
}
