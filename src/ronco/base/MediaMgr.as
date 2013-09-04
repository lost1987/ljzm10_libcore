package ronco.base
{
	import flash.media.*;
	import flash.net.*;
	
	public class MediaMgr
	{
		public static var singleton:MediaMgr = new MediaMgr;
		
		// "url", "sound", "urlrequest"
		public var lst:Object = new Object;
		// "name", "channel"
		public var playing:Vector.<Object> = new Vector.<Object>;
		
		public var bSoundOn:Boolean = true;
		
		public function MediaMgr()
		{
		}
		
		public function addMedia(name:String, url:String):void
		{
			var obj:Object = new Object;
			
			obj["url"] = url;
			obj["url"] = new URLRequest(url);
			obj["media"] = new Sound(obj["url"] as URLRequest);
			
			lst[name] = obj;
		}
		
		public function playMedia(name:String, loops:int):void
		{	
			if(!bSoundOn)
				return ;
			
			var obj:Object = lst[name];
			if(obj != null)
			{
				var s:Sound = obj["media"] as Sound;
				if(s != null)
				{
					var channel:SoundChannel = s.play(0, loops);
					
//					for(var i:int = 0; i < playing.length; ++i)
//					{
//						if(playing[i]["name"] == name)
//							return ;
//					}				
//					
//					playing.push(name);
				}
			}
		}
		
//		public function stopMedia(name:String):void
//		{
////			var obj:Object = lst[name];
////			if(obj != null)
////			{
////				var s:Sound = obj["media"] as Sound;
////				if(s != null)
////				{
////					s.stop();
////					
////					for(var i:int = 0; i < playing.length; ++i)
////					{
////						if(playing[i] == name)
////						{
////							playing.splice(i, 1);
////							
////							return ;
////						}
////					}
////				}
////			}			
//		}
		
		public function turnSound(bSound:Boolean):void
		{
			bSoundOn = bSound;
			
//			if(!bSound)
//			{
//				for(var i:int = 0; i < playing.length; ++i)
//				{
//					
//				}				
//			}
		}
	}
}