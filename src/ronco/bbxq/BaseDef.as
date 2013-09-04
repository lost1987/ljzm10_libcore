package ronco.bbxq
{
	import flash.display.*;
	
	public class BaseDef
	{
		public static var SCENE_UPDATE_TIME:int	=	30;		// 场景刷新间隔时间
		
		public static var BOT_IMG:int			=	1;			// 基本图片对象
		public static var BOT_SWF:int			=	2;			// 基本动画对象
		public static var BOT_PERSONDATAAMES:int		=	3;			// 基本帧动画对象
		public static var BOT_IMGSTATE:int	=	4;			// 基本图片多状态对象
		public static var BOT_PERSONDATAAMESTATE:int	=	5;			// 多状态的帧动画对象
		public static var BOT_MAPAREA:int		=	6;			// 地图区域，不显示
		public static var BOT_SWFSTATE:int	=	7;			// swf多状态对象
		
		//! Avatar相关
		public static var AVATAR_LAYER_NUMS:int	=	4;			// avatar层数量
		
		public static var AVATAR_BODY:int			=	0;			// 身体 
		public static var AVATAR_CLOTHES:int		=	1;			// 衣服
		public static var AVATAR_HAIR:int			=	2;			// 头发
		public static var AVATAR_ITEM:int			=	3;			// 道具
		
		public function BaseDef()
		{
		}
		
//		public static function printfObj(obj:DisplayObject):void
//		{
//			MainLog.log.output(obj.name + obj.toString() + " " + obj.x + " " + obj.y);
//			MainLog.log.output("child--->>");
//			
//			if(obj as DisplayObjectContainer)
//			{
//				var i:int = 0;
//				
//				do{
//					if((obj as DisplayObjectContainer).getChildAt(i) != null)
//						MainLog.log.output((obj as DisplayObjectContainer).getChildAt(i).name + (obj as DisplayObjectContainer).getChildAt(i).toString() + " " + (obj as DisplayObjectContainer).getChildAt(i).x + " " + (obj as DisplayObjectContainer).getChildAt(i).y);
//						//printfObj((obj as DisplayObjectContainer).getChildAt(i));
//					else
//						break;
//					
//					++i;
//				}while(i < 2);
//			}
//			
//			MainLog.log.output("child<<--");
//		}
	}
}
