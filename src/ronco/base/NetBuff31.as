package ronco.base
{
	import flash.utils.*;
	
	public class NetBuff31 extends ByteArray
	{
		public var msgSize:int;		//! 如果msgSize为-1，表示消息头没有初始化，否则表示消息长度
		public var mainid:int;
		public var assid:int;
		public var msgid:int;
		
		public function NetBuff31()
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
		
		public function setMsgHead(_mid:int, _assid:int, _size:int, _msgid:int):void
		{
			msgSize = _size;
			mainid = _mid;
			assid = _assid;
			msgid = _msgid;
			
			writeByte(msgid);
			writeShort(msgSize);
			
			writeByte(mainid);
			writeByte(assid);
		}
		
		public function getMsgHead():void
		{			
			msgSize = _getMsgSize();
			assid = _getAssID();
			mainid = _getMainID();
		}
		
		public function getMsgID():void
		{
			msgid = _getMsgID();
		}		
		
		public static function countStringLength_GBK(str:String):int
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(str, "gbk");
			
			return bytes.length;
		}
		
		/**
		 * 如果 end 为 -1，默认为最后一个字符
		 **/ 
		public static function subString_GBK(str:String, begin:int, end:int = -1):String
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(str, "gbk");
			
			if(end < 0)
				end = bytes.length
			
			if(begin >= 0 && end > begin && end <= bytes.length)
			{
				bytes.position = begin;
				
				return bytes.readMultiByte(end - begin, "gbk"); 
			}
			
			return null;
		}		
		
		public function writeUByte(num:int):void
		{
			if(num > 127)
				num = num - 256;
			
			writeByte(num);
		}
		
		//! 写字符串，写入GBK编码，必须写入length长度
		public function writeStringEx_GBK(str:String, length:int):void
		{
			//var tstr:String = str.substr(0, length);
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(str, "gbk");
			bytes.position = 0;
			
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
		
		public function decode():void
		{
			for(var i:int = 5; i < length; ++i)
				this[i] ^= 0x7b;
		}
		
		public function encode():void
		{
			for(var i:int = 5; i < length; ++i)
				this[i] ^= 0x7b;			
		}
		
		public function getInt(off:int):int
		{
			var pos:int = position;
			
			position = off + 5;
			
			var num:int = readInt();
			
			position = pos;
			
			return num;
		}
		
		public function getShort(off:int):int
		{
			var pos:int = position;
			
			position = off + 5;
			
			var num:int = readShort();
			
			position = pos;
			
			return num;
		}		
		
		public function getByte(off:int):int
		{
			var pos:int = position;
			
			position = off + 5;
			
			var num:int = readByte();
			
			position = pos;
			
			return num;	
		}
		
		public function getUByte(off:int):int
		{
			var pos:int = position;
			
			position = off + 5;
			
			var num:int = readByte();
			
			position = pos;
			
			return num < 0 ? (256 + num) : num;	
		}
		
		public function getFloat(off:int):Number
		{
			var pos:int = position;
			
			position = off + 5;
			
			var num:Number = readFloat();
			
			position = pos;
			
			return num;	
		}		
		
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
			return (this[2] & 0x7f) * 256 + this[1];
		}
		
		private function _getMainID():int
		{
			return this[3];
		}
		
		private function _getAssID():int
		{
			return this[4];
		}
		
		private function _getMsgID():int
		{
			return this[0];
		}		
	}
}