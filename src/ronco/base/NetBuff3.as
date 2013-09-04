package ronco.base
{
	import flash.utils.*;
	
	public class NetBuff3 extends ByteArray
	{
		public var msgSize:int;		//! 如果msgSize为-1，表示消息头没有初始化，否则表示消息长度
		public var mainid:int;
		public var assid:int;
		
		public function NetBuff3()
		{
			super();
			
			msgSize = -1;
			mainid = -1;
			assid = -1;
			
			endian = Endian.LITTLE_ENDIAN; 
		}
		
		public function clearEx():void
		{
			msgSize = -1;
			mainid = -1;
			assid = -1;
			
			clear();
		}
		
		public function setMsgHead(_mid:int, _assid:int, _size:int):void
		{
			msgSize = _size;
			mainid = _mid;
			assid = _assid;
			
			writeShort(msgSize);
//			writeByte(msgSize % 256);
//			writeByte(msgSize / 256);
			
			writeByte(mainid);
			writeByte(assid);
		}
		
		public function getMsgHead():void
		{			
			msgSize = _getMsgSize();
			assid = _getAssID();
			mainid = _getMainID();
		}
		
		//! 写字符串，写入GBK编码，必须写入length长度
		public function writeStringEx_GBK(str:String, length:int):void
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(str, "gbk");
			
			var i:int;
			
			if(length > bytes.length)
			{
				for(i = 0; i < bytes.length; ++i)
					writeByte(bytes[i]);
				
				for(; i < length; ++i)
					writeByte(0);
			}
			else
			{
				for(i = 0; i < length; ++i)
					writeByte(bytes.readByte());	
			}
		}
		
		public function writeString(str:String):void
		{
			for(var i:int = 0; i < str.length; ++i)
				writeShort(str.charCodeAt(i));
		}
		
		//! 写字符串，必须写入length长度
		public function writeStringEx(str:String, length:int):void
		{
			var i:int;
			
			if(length > str.length)
			{
				for(i = 0; i < str.length; ++i)
					writeShort(str.charCodeAt(i));
				
				for(; i < length; ++i)
					writeShort(0);
			}
			else
			{
				for(i = 0; i < length; ++i)
					writeShort(str.charCodeAt(i));				
			}
		}
		
//		public function writeShortEx(nums:int):void
//		{
//			writeByte(nums % 256);
//			writeByte(nums / 256);
//		}
//		
//		public function writeIntEx(nums:int):void
//		{
//			writeByte(nums % 256);
//			writeByte(nums % (256 * 256) / 256);
//			writeByte(nums % (256 * 256 * 256) / (256 * 256));
//			writeByte(nums / (256 * 256 * 256));
//		}		
		
		public function decode():void
		{
			for(var i:int = 4; i < length; ++i)
				this[i] ^= 0x7b;
		}
		
		public function encode():void
		{
			for(var i:int = 4; i < length; ++i)
				this[i] ^= 0x7b;			
		}
		
		public function getInt(off:int):int
		{
			var pos:int = position;
			
			position = off + 4;
			
			var num:int = readInt();
			
			position = pos;
			
			return num;
		}
		
		public function getShort(off:int):int
		{
			var pos:int = position;
			
			position = off + 4;
			
			var num:int = readShort();
			
			position = pos;
			
			return num;
//			off += 4;
//			
//			return this[off + 1] * 256 + this[off];
		}		
		
		public function getByte(off:int):int
		{
			var pos:int = position;
			
			position = off + 4;
			
			var num:int = readByte();
			
			position = pos;
			
			return num;		
//			off += 4;
//			
//			return this[off];
		}
		
//		public function getUnsignedByte(off:int):int
//		{
//			off += 4;
//			
//			return this[off] < 0 ? (256 - this[off]) : this[off];
//		}
		
		public function getStringEx_GBK(off:int, len:int):String
		{
			var bytes:ByteArray = new ByteArray();
			
			for(var i:int = 0; i < len; i++)
			{
				if(getByte(off + i) == 0)
					break ;
				
				bytes.writeByte(getByte(off + i));
			}
			
			bytes.writeByte(0);
			
			bytes.position = 0;
			
			return bytes.readMultiByte(bytes.length, "gbk");
		}
		
		public function getString(off:int, len:int):String
		{
			var str:String = "";
			
			for(var i:int = 0; i < len; i += 2)
			{
				if(getShort(off + i) == 0)
					continue;
				
				////MainLog.singleton.output(String.fromCharCode(getShort(off + i)) + ":" + getShort(off + i));
				
				str += String.fromCharCode(getShort(off + i));
			}
			
			return str;
		}		
		
		private function _getMsgSize():int
		{
			return (this[1] & 0x7f) * 256 + this[0];
		}
		
		private function _getMainID():int
		{
			return this[2];
		}
		
		private function _getAssID():int
		{
			return this[3];
		}		
	}
}