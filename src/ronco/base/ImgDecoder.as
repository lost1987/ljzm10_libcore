package ronco.base
{
	import flash.display.Loader;
	import flash.events.*;
	import flash.utils.ByteArray;

	/**
	 * 图片解码器
	 **/ 
	public class ImgDecoder
	{
		/**
		 * singleton
		 **/ 
		public static var singleton:ImgDecoder = new ImgDecoder;
		
		/**
		 * 解码器
		 * "loader"
		 * "buff"
		 * "funcLoader"			onLoader(isOK:Boolean, loader:Loader, param:Object)
		 * "param"				Object
		 * "isbegin"
		 **/ 
		public var lstDecoder:Vector.<Object> = new Vector.<Object>();
		
		/**
		 * 解码队列
		 * "buff"
		 * "funcLoader"			onLoader(isOK:Boolean, loader:Loader, param:Object)
		 * "param"				Object
		 **/ 
		public var lstRes:Vector.<Object> = new Vector.<Object>();		
		
		/**
		 * construct
		 **/ 
		public function ImgDecoder()
		{
		}
		
		/**
		 * 初始化，传入解码器数量
		 **/ 
		public function init(nums:int):void
		{
			for(var i:int = 0; i < nums; ++i)
			{
				var obj:Object = new Object;
				
				obj["loader"] = new Loader;
				obj["loader"].contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoadComplete);
				obj["loader"].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onLoadFail);
				
				obj["buff"] = null;
				obj["funcLoader"] = null;
				obj["param"] = null;
				
				obj["isbegin"] = false;
				
				lstDecoder.push(obj);
			}
		}
		
		/**
		 * 载入图片
		 **/ 
		public function load(buff:ByteArray, funcLoader:Function, param:Object, inList:Boolean):Boolean
		{
			var nums:int = lstDecoder.length;
			
			for(var i:int = 0; i < nums; ++i)
			{
				var loader:Object = lstDecoder[i];
				if(loader != null && !loader["isbegin"])
				{
					loader["buff"] = buff;
					loader["funcLoader"] = funcLoader;
					loader["param"] = param;
					
					_decode(loader);
					
					return true;
				}
			}
			
			if(inList)
			{
				var obj:Object = new Object;

				obj["buff"] = buff;
				obj["funcLoader"] = funcLoader;
				obj["param"] = param;				
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * 解码失败
		 **/ 
		private function _onLoadFail(e:IOErrorEvent):void
		{
			var nums:int = lstDecoder.length;
			
			for(var i:int = 0; i < nums; ++i)
			{
				var decoder:Object = lstDecoder[i];
				if(decoder != null && decoder["loader"].contentLoaderInfo == e.target)
				{
					if(decoder["funcLoader"] != null)
						decoder["funcLoader"](false, decoder["loader"], decoder["param"]);
					
					decoder["loader"].unload();
					
					decoder["isbegin"] = false;
					
					_next();					
				}
			}
		}
		
		/**
		 * 解码完成
		 **/ 
		private function _onLoadComplete(e:Event):void
		{
			var nums:int = lstDecoder.length;
			
			for(var i:int = 0; i < nums; ++i)
			{
				var decoder:Object = lstDecoder[i];
				if(decoder != null && decoder["loader"].contentLoaderInfo == e.target)
				{
					if(decoder["funcLoader"] != null)
						decoder["funcLoader"](true, decoder["loader"], decoder["param"]);
					
					decoder["loader"].unload();
					
					decoder["isbegin"] = false;
					
					_next();					
				}
			}
		}		
		
		/**
		 * 下载队列中如果有剩余元素，则继续解码
		 **/ 
		private function _next():void
		{
			if(lstRes.length <= 0)
				return ;
			
			var nums:int = lstDecoder.length;
			
			for(var i:int = 0; i < nums; ++i)
			{
				var loader:Object = lstDecoder[i];
				if(loader != null && !loader["isbegin"])
				{
					loader["buff"] = lstRes[0]["buff"];
					loader["funcLoader"] = lstRes[0]["funcLoader"];
					loader["param"] = lstRes[0]["param"];
					
					lstRes.splice(0, 1);
					
					_decode(loader);
					
					return ;
				}
			}
			
		}
		
		/**
		 * 解码
		 **/ 
		private function _decode(decoder:Object):void
		{
			decoder["isbegin"] = true;
			
			try{
				decoder["loader"].loadBytes(decoder["buff"]);
			}
			catch(err:Error){
				
				if(decoder["funcLoader"] != null)
					decoder["funcLoader"](false, decoder["loader"], decoder["param"]);
				
				decoder["loader"].unload();
				
				decoder["isbegin"] = false;
				
				_next();
			}
		}		
		
	}
}
