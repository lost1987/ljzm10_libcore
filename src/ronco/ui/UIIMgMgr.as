package ronco.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class UIIMgMgr
	{
		public static var singleton:UIIMgMgr = new UIIMgMgr();
		
		/** 已经载入完成的图片资源，用url作为索引，保存的为Loader **/
		public var lstRes:Object = new Object;
		
		/** 
		 * 等待队列，包括：
		 * 	["url"]				String，图片路径
		 * 	["loader"]			Loader，下载器
		 * 	["urlloader"]		URLLoader，下载器
		 * 	["lstcom"]			Vector.<Function>，图片完成的回调函数队列
		 *	["lsterr"]			Vector.<Function>，图片失败的回调函数队列
		 **/
		public var lstWait:Vector.<Object> = new Vector.<Object>;
		
		/**
		 * 取一张图片
		 **/
		public function getImg(url:String, comfunc:Function, errfunc:Function):void
		{
			var loader:Loader = lstRes[url];
			
			//! 已经载入成功
			if(loader != null)
			{
				comfunc((loader.contentLoaderInfo.content as Bitmap).bitmapData);
				return ;
			}
			
			//! 正在载入中
			var i:int;
			var len:int = lstWait.length;
			var obj:Object;
			
			for(i = 0; i < len; ++i)
			{
				obj = lstWait[i];
				
				if(obj["url"] == url)
				{
					(obj["lstcom"] as Vector.<Function>).push(comfunc);
					(obj["lsterr"] as Vector.<Function>).push(errfunc);
					
					return;
				}
			}
			
			//! 新的图片
			obj = new Object;
			
			obj["url"] = url;
			obj["loader"] = new Loader;
			obj["urlloader"] = new URLLoader;
			(obj["urlloader"] as URLLoader).dataFormat = URLLoaderDataFormat.BINARY;
			(obj["urlloader"] as URLLoader).addEventListener(Event.COMPLETE, loadEnd);
			(obj["urlloader"] as URLLoader).addEventListener(IOErrorEvent.IO_ERROR, loadError);
			obj["lstcom"] = new Vector.<Function>;
			obj["lsterr"] = new Vector.<Function>;
			(obj["lstcom"] as Vector.<Function>).push(comfunc);
			(obj["lsterr"] as Vector.<Function>).push(errfunc);
			
			lstWait.push(obj);
			
			(obj["urlloader"] as URLLoader).load(new URLRequest(url));
		}
		
		/**
		 * 去除监听
		 **/
		public function removeFunc(comfunc:Function, errfunc:Function):void
		{
			var i:int;
			var len:int = lstWait.length;
			var obj:Object;
			
			for(i = 0; i < len; ++i)
			{
				obj = lstWait[i];
				
				var j:int;
				var jlen:int;
				
				var lst:Vector.<Function> = obj["lstcom"];
				jlen = lst.length;
				
				for(j = 0; j < jlen; ++j)
				{
					if(lst[j] == comfunc)
					{
						lst.splice(j, 1);
						break;
					}
				}
				
				lst = obj["lsterr"];
				jlen = lst.length;
				
				for(j = 0; j < jlen; ++j)
				{
					if(lst[j] == errfunc)
					{
						lst.splice(j, 1);
						break;
					}
				}
			}
		}
		
		public function loadEnd(event:Event):void
		{
			var i:int;
			var len:int = lstWait.length;
			var obj:Object;
			
			for(i = 0; i < len; ++i)
			{
				obj = lstWait[i];
				
				if((obj["urlloader"] as URLLoader) == event.target)
				{
					var content:ByteArray = event.target.data as ByteArray;
					
					(obj["loader"] as Loader).contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
					(obj["loader"] as Loader).loadBytes(content);
					
					return ;
				}
			}
		}
		
		public function loadError(event:Event):void
		{
			var i:int;
			var len:int = lstWait.length;
			var obj:Object;
			
			for(i = 0; i < len; ++i)
			{
				obj = lstWait[i];
				
				if((obj["urlloader"] as URLLoader) == event.target)
				{
					var j:int;
					var jlen:int = (obj["lsterr"] as Vector.<Function>).length;
					
					for(j = 0; j < jlen; ++j)
					{
						(obj["lsterr"] as Vector.<Function>)[j]();
					}
					
					obj["url"] = null;
					obj["loader"] = null;
					obj["urlloader"] = null;
					(obj["lstcom"] as Vector.<Function>).splice(0, (obj["lstcom"] as Vector.<Function>).length);
					(obj["lsterr"] as Vector.<Function>).splice(0, (obj["lsterr"] as Vector.<Function>).length);
					obj["lstcom"] = null;
					obj["lsterr"] = null;
					
					lstWait.splice(i, 1);
					return ;
				}
			}
		}
		
		public function loadComplete(event:Event):void
		{
			var i:int;
			var len:int = lstWait.length;
			var obj:Object;
			
			for(i = 0; i < len; ++i)
			{
				obj = lstWait[i];
				
				if((obj["loader"] as Loader).contentLoaderInfo == event.target)
				{
					var j:int;
					var jlen:int = (obj["lstcom"] as Vector.<Function>).length;
					
					for(j = 0; j < jlen; ++j)
					{
						(obj["lstcom"] as Vector.<Function>)[j](((obj["loader"] as Loader).contentLoaderInfo.content as Bitmap).bitmapData);
					}
					
					lstRes[obj["url"]] = obj["loader"];
					
					obj["url"] = null;
					obj["loader"] = null;
					obj["urlloader"] = null;
					(obj["lstcom"] as Vector.<Function>).splice(0, (obj["lstcom"] as Vector.<Function>).length);
					(obj["lsterr"] as Vector.<Function>).splice(0, (obj["lsterr"] as Vector.<Function>).length);
					obj["lstcom"] = null;
					obj["lsterr"] = null;
					
					lstWait.splice(i, 1);
					return ;
				}
			}
		}
		
		public function UIIMgMgr()
		{
		}
	}
}