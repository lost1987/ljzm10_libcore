package ronco.base
{
	import cmodule.unpkg.CLibInit;
	
	import flash.errors.IOError;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import mx.core.*;
	import mx.events.*;
	import mx.modules.*;
	
	public class ModuleMgr
	{
		public static const _RELOAD_TIME:int = 120000;
		
		//! singleton
		public static var singleton:ModuleMgr = new ModuleMgr;
		
		public var mapModuleFile:Object = new Object;	//! 模块文件表
		public var mapModule:Object = new Object;		//! 模块表

		public var lstLoading:Array = new Array;		//! 载入的模块队列
		//public var mapModule:Map = new Map;			//! 模块表
		
		
		public var lstDL:Vector.<Object> = new Vector.<Object>;	//! 下载的模块队列的队列
		public var curDL:int = 0;									//! 当前可操作的下载队列索引
		
//		public var lstDownload:Vector.<Object> = new Vector.<Object>;	//! 下载的模块列表
//		public var lstDownload2:Vector.<Object> = new Vector.<Object>;	//! 下载的模块列表
//		public var curDownload:int = -1;
//		
//		public var funcProgress:Function;
//		public var funcReady:Function;
		
		public var listener:ListenerModuleMgr;
		
		public var isNeedUnpkg:Boolean = false;
		
		public var isInitModule:Boolean = false;
		
		public var funcDownloadFail:Function;
		
		/**
		 * 同时下载数量
		 **/ 
		public const DOWNLOAD_THREAD_NUMS:int		=	10;
		
		public var m_SearchTime:int = 0;
		
		//! void refurbishPage
		public var refurbishPage:Function;				
		
		public function ModuleMgr()
		{
		}
		
		/**
		 * 确定一个模块是否已经可以使用
		 **/
		public function canUse(_name:String):Boolean
		{
			var minfo:ModuleInfo = mapModule[_name] as ModuleInfo;
			
			if(minfo == null)
				return false;
			
			if(minfo.mod == null || !minfo.isInited)
				return false;
			
			return minfo.canUse;
		}
		
		public function add2DownloadList(_name:String, _begin:Boolean):void
		{
			try{
				MainLog.singleton.output("ModuleMgr::add2DownloadList() " + _name);
				
				if(curDL >= lstDL.length)
				{
					var tmp:Object = new Object;
					
					tmp["lst"] = new Vector.<Object>;
					tmp["cur"] = 0;
					tmp["funcprogress"] = null;
					tmp["funcready"] = null;
					
					lstDL.push(tmp);
				}
				
				var lst:Vector.<Object> = (lstDL[curDL]["lst"] as Vector.<Object>);
				
				var i:int;
				for(i = 0; i < lst.length; ++i)
				{
					if(lst[i]["name"] == _name)
					{
						lst[i]["isbegin"] = _begin;
						
						return ;
					}
				}
				
				var obj:Object = new Object;
				
				obj["name"] = _name;
				obj["isbegin"] = _begin;
				
				lst.push(obj);
			}
			catch(err:Error)
			{
				MainLog.singleton.output("ModFactory::add2DownloadList " + err.message);
			}
		}
		
		public function beginDownloadList():Boolean
		{
			try{
				isInitModule = false;
				
				if(lstDL.length > 0 && curDL < lstDL.length)
				{
					var lst:Vector.<Object> = (lstDL[curDL]["lst"] as Vector.<Object>);
					var len:int = lst.length;
					if(len > 0)
					{
						lstDL[curDL]["cur"] = 0;
						lstDL[curDL]["readynums"] = 0;
						
	//					lstDL[curDL]["funcprogress"] = _fProgress;
	//					lstDL[curDL]["funcready"] = _fReady;
						
	//					funcProgress = _fProgress;
	//					funcReady = _fReady;
						
						if(curDL == 0)
						{
							curDL++;
							
							if(listener != null)
								listener.onDownloadBegin();
							
							var i:int = 0;
							while(i < lst.length && i < DOWNLOAD_THREAD_NUMS && lstDL[0]["cur"] < lst.length)
							{
								loadModuleDL(lst[i]["name"]);
								
								//lstDL[0]["cur"]++;
								
								++i;
							}
							
							//curDL++;
							
							return true;
						}
					}
					else
						MainLog.singleton.output("beginDownloadList list empty(" + curDL + ")!");
				}
				else
					MainLog.singleton.output("beginDownloadList list empty!");
				
				if(curDL == 0)
				{
					if(listener != null)
						listener.onDownloadEnd();
				}
			}
			catch(err:Error)
			{
				MainLog.singleton.output("ModuleMgr::beginDownloadList " + err.message);
			}
			
			return false;
			
//			if(lstDownload.length > 0)
//			{
//				lstDownload2.splice(0, lstDownload2.length);
//				
//				var tmp:Vector.<Object> = lstDownload;
//				lstDownload = lstDownload2;
//				lstDownload2 = tmp;
//				
////				for(var i:int = 0; i < lstDownload.length; ++i)
////				{
////					lstDownload2.push(lstDownload[i]);
////				}
//				
//				curDownload = 0;
//				
//				funcProgress = _fProgress;
//				funcReady = _fReady;
//				
//				loadModule(lstDownload2[curDownload]["name"], funcProgress, funcReady);
//			}
		}
		
		//! 添加模块，这里需要保证名字唯一，否则新添加的会覆盖旧的
		//! 添加模块时，不会即时载入模块
		public function addModule(_name:String, _filename:String, _type:int, _mid:int, _x:int, _y:int, _parent:UIComponent):void
		{
			var minfo:ModuleInfo = new ModuleInfo;
			
			minfo.file = _getModuleFile(_filename);
			minfo.modType = _type;
			minfo.modid = _mid;
			minfo.modName = _name;
			minfo.visibleParent = _parent;
			minfo.x = _x;
			minfo.y = _y;
			minfo.filename = _filename;
			
			mapModule[_name] = minfo;
			
			//mapModule.insert(_name, minfo);
		}
		
		//! 获取模块的IModuleInfo，主要用来添加侦听事件
		public function _getIModuleInfo(_name:String):IModuleInfo
		{
			var minfo:ModuleInfo = mapModule[_name] as ModuleInfo;
			//var minfo:ModuleInfo = mapModule.getValue(_name) as ModuleInfo;
			if(minfo != null)
				return minfo.file.imod;
			
			return null;
		}
		
		//! 载入一个模块，如果没有找到该模块，则返回false
		public function loadModuleDL(_name:String):Boolean
		{
			MainLog.singleton.output("loadModuleDL " + _name);
			
			var minfo:ModuleInfo = mapModule[_name] as ModuleInfo;
			if(minfo != null)
			{
				lstDL[0]["cur"]++;
				
				MainLog.singleton.output("loadModuleDL cur is " + lstDL[0]["cur"]);
				
				if(minfo.mod == null)
				{
					if(!minfo.file.imod.loaded)
					{
						lstLoading.push(minfo);
						
						minfo.time = 0;
						
						minfo.urlloader.addEventListener(Event.OPEN, onDownloadOpen);
						minfo.urlloader.addEventListener(ProgressEvent.PROGRESS, onDownloadProgress);
						minfo.urlloader.addEventListener(Event.COMPLETE, onDownloadComplete);
						minfo.urlloader.addEventListener(IOErrorEvent.IO_ERROR, onDownloadFail);
						
						minfo.urlloader.dataFormat = URLLoaderDataFormat.BINARY;
						
						//minfo.file.imod.addEventListener(ModuleEvent.PROGRESS, _onProgressDL);
						minfo.file.imod.addEventListener(ModuleEvent.READY, _onReadyDL);
						minfo.file.imod.addEventListener(ModuleEvent.ERROR, _onError);
						
						minfo.isBeginOnReady = false;
						
						try{
							minfo.urlloader.load(new URLRequest(minfo.filename));
							minfo.time = getTimer();
							//minfo.file.imod.load();
						}
						catch(err:Error) {
							//MainLog.singleton.output("ModuleMgr::loadModuleDL(" + _name + ") err - " + err.errorID + " " + err.message);
							
							//onDownloadFailImp(objLoader["loader"] as URLLoader);
						}
					}
					else if(!minfo.file.imod.ready)
					{
						lstLoading.push(minfo);
					}
					else
					{
						minfo.mod = (minfo.file.imod.factory.create() as ronco.base.Module);
						
//						minfo.mod.initModule(minfo.x, minfo.y, minfo.visibleParent);
//						
//						minfo.isInited = true;
						
						_onDownloadModEnd();
					}
				}
				else
				{
					_onDownloadModEnd();
				}
				
				return true;
			}
			
			return false;
		}		
		
		//! 载入一个模块，如果没有找到该模块，则返回false
		public function loadModule(_name:String, _fProgress:Function, _fReady:Function):Boolean
		{
			var minfo:ModuleInfo = mapModule[_name] as ModuleInfo;
			if(minfo != null)
			{
				if(minfo.mod == null)
				{
					if(!minfo.file.imod.loaded)
					{
						lstLoading.push(minfo);
						
						minfo.file.imod.addEventListener(ModuleEvent.PROGRESS, _fProgress);
						minfo.file.imod.addEventListener(ModuleEvent.READY, _onReady);
						minfo.file.imod.addEventListener(ModuleEvent.READY, _fReady);
						
						minfo.isBeginOnReady = false;
						
						minfo.file.imod.load();
					}
					else if(!minfo.file.imod.ready)
					{
						lstLoading.push(minfo);
					}
					else
					{
						minfo.mod = (minfo.file.imod.factory.create() as ronco.base.Module);
						
						minfo.mod.initModule(minfo.x, minfo.y, minfo.visibleParent);
						
						minfo.isInited = true;
					}
				}
				
				return true;
			}
			
			return false;
		}
		
		//! 载入一个模块，如果没有找到该模块，则返回false
		public function showModule(_name:String, _fProgress:Function, _fReady:Function):Boolean
		{
			var minfo:ModuleInfo = mapModule[_name] as ModuleInfo;
			if(minfo != null)
			{
				if(minfo.mod == null)
				{
					if(!minfo.file.imod.loaded)
					{
						lstLoading.push(minfo);
						
						minfo.file.imod.addEventListener(ModuleEvent.PROGRESS, _fProgress);
						minfo.file.imod.addEventListener(ModuleEvent.READY, _onReady);
						minfo.file.imod.addEventListener(ModuleEvent.ERROR, _onError);
						
						minfo.isBeginOnReady = true;
						
						minfo.file.imod.load();
					}
					else if(!minfo.file.imod.ready)
					{
						lstLoading.push(minfo);
					}
					else
					{
						minfo.mod = (minfo.file.imod.factory.create() as ronco.base.Module);
						
						minfo.mod.initModule(minfo.x, minfo.y, minfo.visibleParent);
						
						minfo.isInited = true;
						
						try{
							minfo.isBegin = true;
							minfo.mod.beginModule();
						}
						catch(err:Error)
						{
							MainLog.singleton.output("ModuleMgr::_onReady() beginModule " + minfo.filename + " err " + err.message);
						}
					}
				}
				else
				{
					try{
						minfo.isBegin = true;
						minfo.mod.beginModule();
					}
					catch(err:Error)
					{
						MainLog.singleton.output("ModuleMgr::_onReady() beginModule " + minfo.filename + " err " + err.message);
					}
				}
				
				return true;
			}
			
			return false;
		}
		
		public function beginModule(_name:String):void
		{
			var minfo:ModuleInfo = mapModule[_name] as ModuleInfo;
			if(minfo != null)
			{
				if(minfo.mod != null && minfo.isInited)
				{
//					try{
						minfo.isBegin = true;
						minfo.mod.beginModule();
//					}
//					catch(err:Error)
//					{
//						MainLog.singleton.output("ModuleMgr::beginModule() beginModule " + minfo.filename + " err " + err.message);
//					}
				}
			}			
		}		
		
		public function isModuleBegin(_name:String):Boolean
		{
			var minfo:ModuleInfo = mapModule[_name] as ModuleInfo;
			if(minfo != null)
			{
				if(minfo.mod != null && minfo.isInited && minfo.isBegin)
					return true;
			}
			
			return false;
		}
		
		public function endModule(_name:String):void
		{
			var minfo:ModuleInfo = mapModule[_name] as ModuleInfo;
			if(minfo != null)
			{
				if(minfo.mod != null && minfo.isInited && minfo.isBegin)
				{
					try{
						minfo.mod.endModule();
						minfo.isBegin = false;
					}
					catch(err:Error)
					{
						MainLog.singleton.output("ModuleMgr::endModule() endModule " + minfo.filename + " err " + err.message);
					}
				}
			}			
		}
		
		public function updateModule(_name:String):void
		{
			var minfo:ModuleInfo = mapModule[_name] as ModuleInfo;
			if(minfo != null)
			{
				if(minfo.mod != null && minfo.isInited)
				{
					try{
						minfo.mod.updateModule();
					}
					catch(err:Error)
					{
						MainLog.singleton.output("ModuleMgr::updateModule() updateModule " + minfo.filename + " err " + err.message);
					}
				}
			}	
		}
		
		public function enableModule(_name:String,_enable:Boolean):void
		{
			var minfo:ModuleInfo = mapModule[_name] as ModuleInfo;
			if(minfo != null)
			{
				if(minfo.mod != null && minfo.isInited)
				{
					try{
						minfo.mod.enableModule(_enable);
					}
					catch(err:Error)
					{
						MainLog.singleton.output("ModuleMgr::enableModule() enableModule " + minfo.filename + " err " + err.message);
					}
				}
			}	
		}
		
		public function _getModuleFile(_name:String):ModuleFileInfo
		{
			if(mapModuleFile[_name] != null)
				return mapModuleFile[_name];
			
			mapModuleFile[_name] = new ModuleFileInfo;
			mapModuleFile[_name].imod = ModuleManager.getModule(_name);
			
			return mapModuleFile[_name]; 
		}
		
		private function onDownloadFail(e:IOErrorEvent):void
		{
			MainLog.singleton.output("load module err : " + e);
			
//			if(funcDownloadFail != null)
//				funcDownloadFail();
			
			var i:int;
			var j:int;
			var nums:int = 0;
			
			for(i = 0; i < lstLoading.length; ++i)
			{
				if((lstLoading[i] as ModuleInfo).urlloader == e.target)
					nums++;
			}
			
			//for(j = 0; j < nums; ++j)
			{
				for(i = 0; i < lstLoading.length; ++i)
				{
					if((lstLoading[i] as ModuleInfo).urlloader == e.target)
					{
						var info:ModuleInfo = (lstLoading[i] as ModuleInfo);
						
						MainLog.singleton.output("ModuleMgr::onDownloadFail() " + info.modName + " " + info.filename);
						
						var minfo:ModuleInfo = (lstLoading[i] as ModuleInfo);
						
						minfo.time = 0;
						
						minfo.urlloader.addEventListener(Event.OPEN, onDownloadOpen);
						minfo.urlloader.addEventListener(ProgressEvent.PROGRESS, onDownloadProgress);
						minfo.urlloader.addEventListener(Event.COMPLETE, onDownloadComplete);
						minfo.urlloader.addEventListener(IOErrorEvent.IO_ERROR, onDownloadFail);
						
						minfo.urlloader.dataFormat = URLLoaderDataFormat.BINARY;
						
						//minfo.file.imod.addEventListener(ModuleEvent.PROGRESS, _onProgressDL);
						minfo.file.imod.addEventListener(ModuleEvent.READY, _onReadyDL);
						minfo.file.imod.addEventListener(ModuleEvent.ERROR, _onError);
						
						minfo.isBeginOnReady = false;
						
						try{
							minfo.urlloader.load(new URLRequest(minfo.filename));
							minfo.time = getTimer();
							//minfo.file.imod.load();
						}
						catch(err:Error) {
							//MainLog.singleton.output("ModuleMgr::loadModuleDL(" + _name + ") err - " + err.errorID + " " + err.message);
							
							//onDownloadFailImp(objLoader["loader"] as URLLoader);
						}
						
						
//						var info:ModuleInfo = (lstLoading[i] as ModuleInfo);
//						
//						var buff:ByteArray = e.target.data as ByteArray;
//						
//						if(isNeedUnpkg)
//						{
//							var cloader:CLibInit = new CLibInit;
//							var lib:Object = cloader.init();
//							
//							buff = lib.unpkg(buff, buff.length, 0x98a07c65, 0x504b0304, 0x5d2e786d, 0x79706573);
//						}
//						
//						info.file.imod.load(null, null, buff);
						
						//lstLoading.splice(i, 1);
						
						//var mod:ronco.base.Module = info.file.imod.factory.create() as ronco.base.Module;
						//info.mod = mod;
						
						break;
					}
				}
			}			
		}
		
		private function onDownloadComplete(e:Event):void
		{
			var i:int;
			var j:int;
			var nums:int = 0;
			
			for(i = 0; i < lstLoading.length; ++i)
			{
				if((lstLoading[i] as ModuleInfo).urlloader == e.target)
					nums++;
			}
			
			for(j = 0; j < nums; ++j)
			{
				for(i = 0; i < lstLoading.length; ++i)
				{
					if((lstLoading[i] as ModuleInfo).urlloader == e.target)
					{
						if((lstLoading[i] as ModuleInfo).urlloader.bytesLoaded != (lstLoading[i] as ModuleInfo).urlloader.bytesTotal)
						{
							var minfo:ModuleInfo = (lstLoading[i] as ModuleInfo);
							
							try{
								minfo.urlloader.close();
							}catch (error:IOError)
							{
							}
							
							minfo.time = 0;
							
							minfo.urlloader.addEventListener(Event.OPEN, onDownloadOpen);
							minfo.urlloader.addEventListener(ProgressEvent.PROGRESS, onDownloadProgress);
							minfo.urlloader.addEventListener(Event.COMPLETE, onDownloadComplete);
							minfo.urlloader.addEventListener(IOErrorEvent.IO_ERROR, onDownloadFail);
							
							minfo.urlloader.dataFormat = URLLoaderDataFormat.BINARY;
							
							minfo.file.imod.addEventListener(ModuleEvent.READY, _onReadyDL);
							minfo.file.imod.addEventListener(ModuleEvent.ERROR, _onError);
							
							minfo.isBeginOnReady = false;
							
							try{
								minfo.urlloader.load(new URLRequest(minfo.filename + getTimer().toString()));
								minfo.time = getTimer();
							}
							catch(err:Error) {
							}
						}
						else
						{
							var info:ModuleInfo = (lstLoading[i] as ModuleInfo);
							
							info.time = 0;
							
							var buff:ByteArray = e.target.data as ByteArray;
							
							if(isNeedUnpkg)
							{
								var cloader:CLibInit = new CLibInit;
								var lib:Object = cloader.init();
								
								buff = lib.unpkg(buff, buff.length, 0x98a07c65, 0x504b0304, 0x5d2e786d, 0x79706573);
							}
							
							MainLog.singleton.output("ModuleMgr::onDownloadComplete() " + info.modName + " " + info.filename);
							
							info.file.imod.load(null, null, buff);
							
							//lstLoading.splice(i, 1);
							
							//var mod:ronco.base.Module = info.file.imod.factory.create() as ronco.base.Module;
							//info.mod = mod;
							
							break;
						}
					}
				}
			}
			
			//_onDownloadModEnd();
		}
		
		private function onDownloadOpen(e:Event):void
		{
			for(var i:int = 0; i < lstLoading.length; ++i)
			{
				var info:ModuleInfo = (lstLoading[i] as ModuleInfo);
				if(info.urlloader == e.target)
				{	
					MainLog.singleton.output("ModuleMgr::onDownloadOpen() " + info.modName + " " + info.filename);
					
					info.time = getTimer();
					return ;
				}
			}	
		}
		
		private function onDownloadProgress(e:ProgressEvent):void
		{
			for(var i:int = 0; i < lstLoading.length; ++i)
			{
				var info:ModuleInfo = (lstLoading[i] as ModuleInfo);
				if(info.urlloader == e.target)
				{
					//MainLog.singleton.output("ModuleMgr::onDownloadProgress() " + info.modName + " " + info.filename);
					//MainLog.singleton.output("ModuleMgr::onDownloadProgress():" + e.bytesLoaded + "/" + e.bytesTotal);
					
					info.time = getTimer();
					
					if(listener != null)
					{
						var per:Number = e.bytesLoaded / e.bytesTotal;
						
						listener.onProgress(info, per);
					}
					
					return ;
				}
			}	
		}
		
		public function onTimer(time:int):void
		{
			var ctime:int = getTimer();
			
			if(m_SearchTime == 0)
			{
				m_SearchTime = ctime;
				return ;
			}
			else if(ctime - m_SearchTime <= 1000)
				return ;
			
			m_SearchTime = ctime;
			
			var i:int;
			var j:int;
			var nums:int = 0;
			
			//for(j = 0; j < nums; ++j)
			{
				for(i = 0; i < lstLoading.length; ++i)
				{
					if((lstLoading[i] as ModuleInfo).time != 0 && ctime - (lstLoading[i] as ModuleInfo).time >= _RELOAD_TIME)
					{
						var info:ModuleInfo = (lstLoading[i] as ModuleInfo);
						
						MainLog.singleton.output("ModuleMgr::reload() " + info.modName + " " + info.filename);
						
//						try{
//							if(refurbishPage != null)
//							{
//								refurbishPage();
//								
//								//return ;
//							}
//						}
//						catch(error:Error){
//							MainLog.singleton.output("ModuleMgr::reload err - " + error.message);
//						}
						
						var minfo:ModuleInfo = (lstLoading[i] as ModuleInfo);
						
						try{
							minfo.urlloader.close();
						}catch (error:IOError)
						{
						}
						
						minfo.time = 0;
						
						minfo.urlloader.addEventListener(Event.OPEN, onDownloadOpen);
						minfo.urlloader.addEventListener(ProgressEvent.PROGRESS, onDownloadProgress);
						minfo.urlloader.addEventListener(Event.COMPLETE, onDownloadComplete);
						minfo.urlloader.addEventListener(IOErrorEvent.IO_ERROR, onDownloadFail);
						
						minfo.urlloader.dataFormat = URLLoaderDataFormat.BINARY;
						
						minfo.file.imod.addEventListener(ModuleEvent.READY, _onReadyDL);
						minfo.file.imod.addEventListener(ModuleEvent.ERROR, _onError);
						
						minfo.isBeginOnReady = false;
						
						try{
							minfo.urlloader.load(new URLRequest(minfo.filename + getTimer().toString()));
							minfo.time = getTimer();
						}
						catch(err:Error) {
						}
					}
				}
			}
		}
		
		public function _onProgressDL(e:ModuleEvent):void
		{
			for(var i:int = 0; i < lstLoading.length; ++i)
			{
				var info:ModuleInfo = (lstLoading[i] as ModuleInfo);
				if(info.file.imod == e.module)
				{	
					if(listener != null)
					{
						var per:Number = e.bytesLoaded / e.bytesTotal;
						
						listener.onProgress(info, per);
					}
					
					return ;
				}
			}			
		}
		
		public function _onReadyDL(e:ModuleEvent):void
		{
			var i:int;
			var j:int;
			var nums:int = 0;
			
			for(i = 0; i < lstLoading.length; ++i)
			{
				if((lstLoading[i] as ModuleInfo).file.imod == e.module)
					nums++;
			}
			
			for(j = 0; j < nums; ++j)
			{
				for(i = 0; i < lstLoading.length; ++i)
				{
					if((lstLoading[i] as ModuleInfo).file.imod == e.module)
					{
						var info:ModuleInfo = (lstLoading[i] as ModuleInfo);
						
						lstLoading.splice(i, 1);
						
						var mod:ronco.base.Module = info.file.imod.factory.create() as ronco.base.Module;
						info.mod = mod;
						
						break;
					}
				}
			}
			
			_onDownloadModEnd();
		}
		
		public function _onError(e:ModuleEvent):void
		{
			//MainLog.singleton.output("load module err : " + e.errorText);
			
//			for(var i:int = 0; i < lstLoading.length; ++i)
//			{
//				var info:ModuleInfo = (lstLoading[i] as ModuleInfo);
//				if(info.file.imod == e.module)
//				{
//					info.file.imod.load();
//					
//					return ;
//				}
//			}			
		}		
		
		public function _onDownloadModEnd():void
		{
			isInitModule = true;
			
			var i:int;
			var minfo:ModuleInfo;
			
			MainLog.singleton.output("ModuleMgr::_onDownloadModEnd() - lstDL.length:" + lstDL.length);
			
			if(lstDL.length > 0)
			{
				var lst:Vector.<Object> = (lstDL[0]["lst"] as Vector.<Object>);
				MainLog.singleton.output("ModuleMgr::_onDownloadModEnd() - lst.length:" + lst.length);
				if(lst.length > 0)
				{
					var mlen:int = lst.length;
					
					lstDL[0]["readynums"]++;
					MainLog.singleton.output("ModuleMgr::_onDownloadModEnd() lstDL[0][\"readynums\"]:" + lstDL[0]["readynums"]);
					if(lstDL[0]["readynums"] >= lst.length)
					{
						for(i = 0; i < lst.length; ++i)
						{
							minfo = mapModule[lst[i]["name"]] as ModuleInfo;
							if(minfo != null)
							{
								if(minfo.mod != null)
								{
									if(!minfo.isInited)
									{
//										try{
											minfo.mod.initModule(minfo.x, minfo.y, minfo.visibleParent);
											minfo.isInited = true;
//										}
//										catch(err:Error)
//										{
//											MainLog.singleton.output("ModuleMgr::_onDownloadModEnd() initModule " + minfo.filename + " err " + err.message);
//										}
									}
								}
							}							
							
							if(listener != null)
							{
								var per:Number = i / mlen;
								
								listener.onProgress(null, per);
							}
						}
						
						for(i = 0; i < lst.length; ++i)
						{
							minfo = mapModule[lst[i]["name"]] as ModuleInfo;
							if(minfo != null)
							{
								if(minfo.mod != null)
								{	
//									try{
										if(lst[i]["isbegin"])
										{
											try{
												minfo.isBegin = true;
												minfo.mod.beginModule();
											}
											catch(err:Error)
											{
												MainLog.singleton.output("ModuleMgr::_onDownloadModEnd() beginModule " + minfo.filename + " err " + err.message);
											}
										}
	//									else
	//										minfo.mod.endModule();
//									}
//									catch(err:Error)
//									{
//										MainLog.singleton.output("ModuleMgr::_onDownloadModEnd() beginModule " + minfo.filename + " err " + err.message);
//									}
										
									minfo.canUse = true;
								}
							}							
						}		
						
						if(listener != null)	
							listener.onProgress(null, 1);
						
						lstDL[0]["cur"] = -1;
						lstDL[0]["readynums"] = -1;
						lstDL[0]["funcprogress"] = null;
						lstDL[0]["funcready"] = null;
						
						var len:int = lst.length;
						var i:int = 0;
						
						while(i < len)
						{
							lst.pop();
							
							++i;
						}						
						//lst.splice(0, lst.length);
						
						var tmp:Object = lstDL.shift();
						lstDL.push(tmp);
						
						curDL--;
						
						lst = (lstDL[0]["lst"] as Vector.<Object>);
						if(lst.length > 0 && lstDL[0]["cur"] == 0)
						{
							lstDL[0]["cur"] = 0;
							lstDL[0]["readynums"] = 0;
							
							var i:int = 0;
							while(i < lst.length && i < DOWNLOAD_THREAD_NUMS)
							{
								loadModuleDL(lst[i]["name"]);
								
								//lstDL[0]["cur"]++;
								
								++i;
							}
							
							//loadModuleDL(lst[0]["name"]);
							
							curDL++;							
						}
						else
						{
//							curDL = 0;

							if(listener != null)
								listener.onDownloadEnd();
						}
					}
					else if(lstDL[0]["cur"] < lst.length)
					{	
						loadModuleDL(lst[lstDL[0]["cur"]]["name"]);
						
//						lstDL[0]["cur"]++;
					}
				}
			}
		}
		
		public function _onReady(e:ModuleEvent):void
		{
			//isInitModule = true;
			
			var i:int;
			var j:int;
			var nums:int = 0;
			
			for(i = 0; i < lstLoading.length; ++i)
			{
				if((lstLoading[i] as ModuleInfo).file.imod == e.module)
					nums++;
			}
			
			for(j = 0; j < nums; ++j)
			{
				//var mlen:int = lstLoading.length;
				
				for(i = 0; i < lstLoading.length; ++i)
				{
					if((lstLoading[i] as ModuleInfo).file.imod == e.module)
					{
						var info:ModuleInfo = (lstLoading[i] as ModuleInfo);
						
						lstLoading.splice(i, 1);
						
						var mod:ronco.base.Module = info.file.imod.factory.create() as ronco.base.Module;
						info.mod = mod;
						mod.initModule(info.x, info.y, info.visibleParent);
						info.isInited = true;
						
						if(info.isBeginOnReady)
						{
							try{
								info.isBegin = true;
								mod.beginModule();
							}
							catch(err:Error)
							{
								MainLog.singleton.output("ModuleMgr::_onReady() beginModule " + info.filename + " err " + err.message);
							}
						}
						
//						if(listener != null)
//						{
//							var per:Number = i / mlen;
//							
//							listener.onProgress(null, per);
//						}						
						
						break;
					}
				}
			}
		}
		
//		public function _isLoaded(_mod:IModuleInfo):Boolean
//		{
//			int i;
//			for(i = 0; i < lstLoading.length; ++i)
//			{
//				if(lstLoading[i] == _mod)
//					return true;
//			}
//			
//			return false;
//		}
	}
}