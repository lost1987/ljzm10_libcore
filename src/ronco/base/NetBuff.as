package ronco.base
{
	import flash.utils.*;
	
	public class NetBuff extends ByteArray
	{
		public var msgSize:int;		//! 如果msgSize为-1，表示消息头没有初始化，否则表示消息长度
		public var mainid:int;
		public var assid:int;
		
		public function NetBuff()
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
			
			////MainLog.singleton.output("NetBuff 清理数据~！");
		}
		
		public function setMsgHead(_mid:int, _assid:int, _size:int):void
		{
			msgSize = _size;
			mainid = (_mid << 2);
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
		
		public function writeString(str:String):void
		{
			for(var i:int = 0; i < str.length; ++i)
				writeByte(str.charCodeAt(i));
		}
		
		public function writeShortEx(nums:int):void
		{
			writeShort(nums);
//			writeByte(nums % 256);
//			writeByte(nums / 256);
		}
		
		public function writeIntEx(nums:int):void
		{
			writeInt(nums);
//			writeByte(nums % 256);
//			writeByte(nums % (256 * 256) / 256);
//			writeByte(nums % (256 * 256 * 256) / (256 * 256));
//			writeByte(nums / (256 * 256 * 256));
		}		
		
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
		}		
		
		public function getByte(off:int):int
		{
			off += 4;
			
			return this[off];
		}
		
//		public function getUnsignedByte(off:int):int
//		{
//			off += 4;
//			
//			return this[off] < 0 ? (256 - this[off]) : this[off];
//		}
		
		public function getStringEx(str:String, off:int, len:int):String
		{
			for(var i:int = 0; i < len; i += 2)
			{
				if(getShort(off + i) == 0)
					break;
				//MainLog.log.output(String.fromCharCode(getShort(off + i)) + ":" + getShort(off + i));
				
				str += String.fromCharCode(getShort(off + i));
			}
			
			return str;		
		}
		public function getString(str:String, off:int, len:int):String
		{			
			for(var i:int = 0; i < len; i += 2)
			{
				//MainLog.log.output(String.fromCharCode(getShort(off + i)) + ":" + getShort(off + i));
				
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
			return (this[2] >> 2);
		}
		
		private function _getAssID():int
		{
			return this[3];
		}		
	}
}