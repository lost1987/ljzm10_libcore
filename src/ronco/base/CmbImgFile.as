package ronco.base
{
	import flash.net.*;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * 组合的图片文件
	 **/ 
	public class CmbImgFile
	{
		/**
		 * 子图片队列
		 * 
		 * "buff"
		 * "loader"
		 * "bmpdata"
		 **/ 
		public var lst:Vector.<Object> = new Vector.<Object>;
		
		/**
		 * construct
		 **/ 
		public function CmbImgFile()
		{
		}
		
		/**
		 * 下载完成后调用的函数
		 **/ 
		public function onLoader(url:String, isOK:Boolean, loader:URLLoader):void
		{
			var content:ByteArray = loader.data as ByteArray;
			
			content.endian = Endian.LITTLE_ENDIAN;
			
			var flag:int = content.readInt();
			var nums:int = content.readInt();
			
			var lstLength:Vector.<int> = new Vector.<int>;
			var i:int;
			
			for(i = 0; i < nums; ++i)
			{
				var begin:int = content.readInt();
				lstLength.push(content.readInt());
			}
			
			for(i = 0; i < nums; ++i)
			{
				var obj:Object = new Object;
				
				obj["buff"] = new ByteArray;
				obj["loader"] = null;
				obj["bmpdata"] = null;
				
				content.readBytes(obj["buff"], 0, lstLength[i]);
				
				lst.push(obj);
			}			
		}
		
		
	}
}