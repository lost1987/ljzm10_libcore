package ronco.base
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;

	public class BitmapLoaderMgr
	{
		public static var singleton:BitmapLoaderMgr = new BitmapLoaderMgr();
		
		//! "name", "filename", "loader"
		public var lst:Object = new Object(); 
		
		public function BitmapLoaderMgr()
		{
		}
		
		public function add(name:String, filename:String, loader:Loader):void
		{
			if(lst.hasOwnProperty(name))
			{
				lst[name]["name"] = name;
				lst[name]["filename"] = filename;
				lst[name]["loader"] = loader;
			}
			else
			{
				var obj:Object = new Object();
				
				obj["name"] = name;
				obj["filename"] = filename;
				obj["loader"] = loader;
				
				lst[name] = obj;
			}
		}
		
		public function newBitmap(name:String):Bitmap
		{
			if(lst.hasOwnProperty(name) && lst[name]["loader"] as Loader)
			{
				var bmp:Bitmap = (lst[name]["loader"] as Loader).content as Bitmap;
				
				if(bmp != null)
					return new Bitmap(bmp.bitmapData);
			}
			
			return null;
		}
		
		public function getBitmapData(name:String):BitmapData
		{
			if(lst.hasOwnProperty(name) && lst[name]["loader"] as Loader)
			{
				var bmp:Bitmap = (lst[name]["loader"] as Loader).content as Bitmap;
				
				if(bmp != null)
					return bmp.bitmapData;
			}
			
			return null;			
		}
	}
}