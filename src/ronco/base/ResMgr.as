package ronco.base
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.core.ByteArrayAsset;

	public class ResMgr
	{
		public static var singleton:ResMgr = new ResMgr;
		
		public var mapRes:Dictionary = new Dictionary;
		
		public var mapClass:Dictionary = new Dictionary;
		
		public function ResMgr()
		{
		}
		
		public function addClass(name:String, res:Class):void
		{
			mapClass[name] = res;
		}
		
		public function addRes(name:String, res:Class):void
		{
			mapRes[name] = new res as Bitmap;
			//mapRes.insert(name, res);
			//lst.push(res);
		}
		
		public function NewBitmap(name:String):Bitmap
		{	
			if(mapRes[name] != null)
				return new Bitmap(mapRes[name].bitmapData);
			
			return null;
		}
		
		public function GetBitmapData(name:String):BitmapData
		{	
			if(mapRes[name] != null)
				return mapRes[name].bitmapData;
			
			return null;
		}
		
		public function addByteArrayAsset(name:String, res:Class):void
		{
			mapRes[name] = new res as ByteArrayAsset;
		}
		
		public function GetByteArray(name:String):ByteArray
		{	
			var byte:ByteArray;
			
			if(mapRes[name] != null)
			{
				byte = mapRes[name] as ByteArray;
				
				byte.position = 0;
			}
			
			return byte;
		}
	}
}