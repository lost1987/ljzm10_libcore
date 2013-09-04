package ronco.base
{
	import flash.events.*;
	import flash.net.*;
	
	/**
	 * 这个类是一个下载的基类
	 * 多下载器
	 **/ 
	public class LoaderEx
	{
		/**
		 * singleton
		 **/ 
		public static var singleton:LoaderEx = new LoaderEx();
		
		/**
		 * 下载器
		 * "loader"
		 * "url"
		 * "dataformat"
		 * "funcLoader"			onLoader(url:String, isOK:Boolean, loader:URLLoader)
		 * "funcOnBegin"		onBegin(url):void
		 * "funcOnEnd"			onEnd(url):void
		 * "funcOnRefurbish"	onRefurbish(url, per):void
		 * "isbegin"
		 **/ 
		public var lstLoader:Vector.<Object> = new Vector.<Object>();
		
		/**
		 * 下载队列
		 * "url"
		 * "dataformat"
		 * "funcLoader"			onLoader(url:String, isOK:Boolean, loader:URLLoader)
		 * "funcOnBegin"		onBegin(url):void
		 * "funcOnEnd"			onEnd(url):void
		 * "funcOnRefurbish"	onRefurbish(url, per):void
		 **/ 
		public var lstRes:Vector.<Object> = new Vector.<Object>();		
		
//		/**
//		 * 是否已经开始下载了
//		 **/ 
//		public var isBegin:Boolean = false;
		
//		/**
//		 * 下载开始时调用的接口
//		 * void onBegin()
//		 **/ 
//		public var funcBegin:Function;
//		/**
//		 * 下载结束时调用的接口
//		 * void onEnd()
//		 **/ 
//		public var funcEnd:Function;
//		/**
//		 * 下载进度刷新接口，参数是0-1之间的一个浮点数
//		 * void onRefurbish(per:Number)
//		 **/ 
//		public var funcRefurbish:Function;		
		
		/**
		 * construct
		 **/ 
		public function LoaderEx()
		{
		}
		
		/**
		 * 初始化下载器
		 **/ 
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
			
			for(i = 0; i < nums; ++i)
			{
				var loader:Object = new Object();
				
				loader["loader"] = new URLLoader();
				loader["loader"].addEventListener(Event.COMPLETE, _onDownloadComplete);
				loader["loader"].addEventListener(IOErrorEvent.IO_ERROR, _onDownloadFail);
				
				loader["url"] = null;
				loader["dataformat"] = null;

				loader["funcLoader"] = null;
				loader["funcOnBegin"] = null;
				loader["funcOnEnd"] = null;
				loader["funcOnRefurbish"] = null;
				
				loader["isbegin"] = false;
				
				lstLoader.push(loader);
			}
		}
		
		/**
		 * 下载一个文件
		 * 如果当前没有多余的下载器，且inList为false，则返回false
		 * 否则，如果有多余下载器，马上下载
		 * 否则，则入下载队列
		 **/ 
		public function load(url:String, dataFormat:String, funcLoader:Function, inList:Boolean, 
							 funcOnBegin:Function, funcOnEnd:Function, funcOnRefurbish:Function):Boolean
		{	
			var nums:int = lstLoader.length
			for(var i:int = 0; i < nums; ++i)
			{
				var loader:Object = lstLoader[i];
				if(loader != null && !loader["isbegin"])
				{
					//loader["isbegin"] = true;
					
					loader["url"] = url;
					loader["dataformat"] = dataFormat;
					
					loader["funcLoader"] = funcLoader;
//					loader["funcOnBegin"] = funcOnBegin;
//					loader["funcOnEnd"] = funcOnEnd;
//					loader["funcOnRefurbish"] = funcOnRefurbish;
					
					_download(loader);
					
//					loader["loader"].dataFormat = loader["dataformat"];
//					
//					//MainLog.singleton.output("LoaderEx::download(" + loader["url"] + ")");
////					if(loader["funcOnBegin"] != null)
////						loader["funcOnBegin"](loader["url"]);
//					
//					var request:URLRequest;
//					
//					try{
//						request = new URLRequest(loader["url"]);
//						loader["loader"].load(request);
//					}
//					catch(err:Error) {
//						//MainLog.singleton.output("LoaderEx::download(" + loader["url"] + ") err - " + err.errorID + " " + err.message);
//						
//						if(loader["funcLoader"] != null)
//							loader["funcLoader"](loader["url"], false, loader["loader"]);
//						
//						return false;
//					}
					
					return true;
				}
			}
			
			if(inList)
			{
				var res:Object = new Object();
				
				res["url"] = url;
				res["dataformat"] = dataFormat;
				
				res["funcLoader"] = funcLoader;
//				res["funcOnBegin"] = funcOnBegin;
//				res["funcOnEnd"] = funcOnEnd;
//				res["funcOnRefurbish"] = funcOnRefurbish;
				
				lstRes.push(res);
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * 当某一个下载器下载完成后，判断是否还有需要下载的内容
		 **/ 
		private function _next():void
		{
			if(lstRes.length <= 0)
				return ;
			
			var res:Object = lstRes[0];
			
			var nums:int = lstLoader.length
			for(var i:int = 0; i < nums; ++i)
			{
				var loader:Object = lstLoader[i];
				if(loader != null && !loader["isbegin"])
				{
					//loader["isbegin"] = true;
					
					loader["url"] = res["url"];
					loader["dataformat"] = res["dataformat"];
					
					loader["funcLoader"] = res["funcLoader"];
//					loader["funcOnBegin"] = res["funcOnBegin"];
//					loader["funcOnEnd"] = res["funcOnEnd"];
//					loader["funcOnRefurbish"] = res["funcOnRefurbish"];
					
					lstRes.splice(0, 1);
					
					_download(loader);
					
					return ;
					
//					loader["loader"].dataFormat = loader["dataformat"];
//					
//					//MainLog.singleton.output("LoaderEx::download(" + loader["url"] + ")");
////					if(loader["funcOnBegin"] != null)
////						loader["funcOnBegin"](loader["url"]);
//					
//					var request:URLRequest;
//					
//					try{
//						request = new URLRequest(loader["url"]);
//						loader["loader"].load(request);
//					}
//					catch(err:Error) {
//						//MainLog.singleton.output("LoaderEx::download(" + loader["url"] + ") err - " + err.errorID + " " + err.message);
//						
//						if(loader["funcLoader"] != null)
//							loader["funcLoader"](loader["url"], false, loader["loader"]);
//					}				
//					
//					return ;
				}
			}			
		}
		
		/**
		 * 下载失败
		 **/ 
		private function _onDownloadFail(e:Event):void
		{
			var i:int;
			
			for(i = 0; i < lstLoader.length; ++i)
			{
				var loader:Object = lstLoader[i];
				
				if(loader["loader"] == e.target)
				{
					//MainLog.singleton.output("LoaderEx::onDownloadFail - " + loader["url"]);
					
					if(loader["funcLoader"] != null)
						loader["funcLoader"](loader["url"], false, loader["loader"]);
					
					loader["isbegin"] = false;
					
					_next();
					
					return ;
				}
			}
		}
		
		/**
		 * 下载成功
		 **/ 
		private function _onDownloadComplete(e:Event):void
		{
			var i:int;
			
			for(i = 0; i < lstLoader.length; ++i)
			{
				var loader:Object = lstLoader[i];
				
				if(loader["loader"] == e.target)
				{
					if(loader["funcLoader"] != null)
						loader["funcLoader"](loader["url"], true, loader["loader"]);
					
					loader["isbegin"] = false;
					
					_next();
					
					return ;
				}
			}
		}
		
		private function _download(loader:Object):void
		{
			loader["isbegin"] = true;
			
			loader["loader"].dataFormat = loader["dataformat"];
			
			//MainLog.singleton.output("LoaderEx::_download(" + loader["url"] + ")");
			
			var request:URLRequest;
			
			try{
				request = new URLRequest(loader["url"]);
				loader["loader"].load(request);
			}
			catch(err:Error) {
				//MainLog.singleton.output("LoaderEx::_download(" + loader["url"] + ") err - " + err.errorID + " " + err.message);
				
				if(loader["funcLoader"] != null)
					loader["funcLoader"](loader["url"], false, loader["loader"]);
				
				loader["isbegin"] = false;
				
				_next();
			}
		}
		
	}
}
