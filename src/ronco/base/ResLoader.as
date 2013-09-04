package ronco.base
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;

	public class ResLoader
	{
		public static var singleton:ResLoader = new ResLoader();
		
		//! "loader", "res_obj", "urlresuest"
		public var lstLoader:Vector.<Object> = new Vector.<Object>();
		//! "id", "name", "filename", "func", "res"
		public var lstRes:Vector.<Object> = new Vector.<Object>();
		public var poolRes:Vector.<Object> = new Vector.<Object>();
		
		public var numsLoader:int = 5;
		
		public var maxNums:int = 0;
		public var curNums:int = 0;
		
		public function ResLoader()
		{
		}
		
		public function init(nums:int):void
		{
			var len:int = lstLoader.length;
			var i:int = 0;
			
			while(i < len)
			{
				lstLoader.pop();
				
				++i;
			}
			
			//lstLoader.splice(0, lstLoader.length);
			
			numsLoader = nums;
			
			for(i = 0; i < numsLoader; ++i)
			{
				var obj:Object = new Object();
				
				obj["loader"] = new URLLoader;
				(obj["loader"] as URLLoader).addEventListener(Event.COMPLETE, onDownloadComplete);
				(obj["loader"] as URLLoader).addEventListener(IOErrorEvent.IO_ERROR, onDownloadFail);
				
				obj["res_obj"] = null;
				//obj["urlresuest"] = null;
				
				lstLoader.push(obj);
			}
		}
		
		//! 传入函数，应该是 func(id, name, filename, loader)这样的，
		public function addRes(id:int, name:String, filename:String, func:Function):void
		{
			var obj:Object;
			
			if(poolRes.length > 0)
				obj = poolRes.pop();
			else
				obj = new Object();
			
			obj["name"] = name;
			obj["filename"] = filename;
			obj["func"] = func;
			obj["id"] = id;
			
			obj["res"] = null;
			//obj["loader"] = null;
			
			lstRes.push(obj);
		}
		
		public function start():void
		{
			curNums = maxNums = lstRes.length;
			
			for(var i:int = 0; i < lstLoader.length; ++i)
				next(lstLoader[i]);
		}
		
		private function onDownloadFailImp(loader:URLLoader):void
		{
			var objLoader:Object;
			
			for(var i:int = 0; i < lstLoader.length; ++i)
			{
				if(lstLoader[i]["loader"] == loader)
				{
					objLoader = lstLoader[i];
					
					break;
				}
			}
			
			if(objLoader != null)
			{
				var objRes:Object = objLoader["res_obj"];
				
				--curNums;
				
				objRes["func"](objRes["id"], objRes["name"], objRes["filename"], null);
				
				objRes["func"] = null;
				
				poolRes.push(objRes);
				
				next(objLoader);
			}			
		}
		
		private function onDownloadFail(e:IOErrorEvent):void
		{
			onDownloadFailImp(e.target as URLLoader);
//			var objLoader:Object;
//			
//			for(var i:int = 0; i < lstLoader.length; ++i)
//			{
//				if(lstLoader[i]["loader"] == e.target)
//				{
//					objLoader = lstLoader[i];
//					
//					break;
//				}
//			}
//			
//			if(objLoader != null)
//			{
//				var objRes:Object = objLoader["res_obj"];
//				
//				--curNums;
//				
//				objRes["func"](objRes["id"], objRes["name"], objRes["filename"], null);
//				
//				objRes["func"] = null;
//				
//				poolRes.push(objRes);
//				
//				next(objLoader);
//			}
		}
		
		private function onDownloadComplete(e:Event):void
		{
			var objLoader:Object;
			
			for(var i:int = 0; i < lstLoader.length; ++i)
			{
				if(lstLoader[i]["loader"] == e.target)
				{
					objLoader = lstLoader[i];
					
					break;
				}
			}
			
			if(objLoader != null)
			{
				//var byte:ByteArray = e.target.data as ByteArray;
				
				var objRes:Object = objLoader["res_obj"];
				
				objRes["res"] = new Loader();
				(objRes["res"] as Loader).contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				(objRes["res"] as Loader).loadBytes(e.target.data as ByteArray);
			}
		}
		
		private function onLoadComplete(e:Event):void 
		{
			var objLoader:Object;
			
			for(var i:int = 0; i < lstLoader.length; ++i)
			{
				if(lstLoader[i]["res_obj"] != null && lstLoader[i]["res_obj"]["res"] != null && (lstLoader[i]["res_obj"]["res"] as Loader).contentLoaderInfo == e.target)
				{
					objLoader = lstLoader[i];
					
					break;
				}
			}
			
			if(objLoader != null)
			{
				var objRes:Object = objLoader["res_obj"];
				
				--curNums;
				
				objRes["func"](objRes["id"], objRes["name"], objRes["filename"], objRes["res"]);
				
				objRes["func"] = null;
				objRes["res"] = null;
				
				poolRes.push(objRes);
				
				next(objLoader);
			}
			
			e.currentTarget.removeEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		private function next(objLoader:Object):void
		{
			try {
				if(lstRes.length > 0)
				{
					(objLoader["loader"] as URLLoader).dataFormat = URLLoaderDataFormat.BINARY;
					
					objLoader["res_obj"] = lstRes[0];
					lstRes.splice(0, 1);
					
					var request:URLRequest = new URLRequest(objLoader["res_obj"]["filename"]);
					(objLoader["loader"] as URLLoader).load(request);
				}
			}
			catch(err:Error) {
				//MainLog.singleton.output("ResLoader::next() err - " + err.errorID + " " + err.message);
				
				onDownloadFailImp(objLoader["loader"] as URLLoader);
			}
		}
	}
}