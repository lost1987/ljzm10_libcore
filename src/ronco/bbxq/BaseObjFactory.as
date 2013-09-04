package ronco.bbxq
{
	import ronco.base.*;
	
	public class BaseObjFactory
	{
		public static var factory:BaseObjFactory = new BaseObjFactory;		// singleton
		
		public function BaseObjFactory()
		{
		}
		
		public function newBaseObj(type:int, res:Class, cx:int, cy:int, _w:int, _h:int):BaseObj
		{
			//MainLog.singleton.output("new base obj type is" + type);
			
			switch(type)
			{
				case BaseDef.BOT_IMG:
				{
					return new BaseObj_Img(res, cx, cy, _w, _h);
				}
				case BaseDef.BOT_SWF:
				{
					return new BaseObj_SWF(res, cx, cy, _w, _h);
				}
				case BaseDef.BOT_PERSONDATAAMES:
				{
					return new BaseObj_Frames(res, cx, cy, _w, _h);
				}					
				case BaseDef.BOT_IMGSTATE:
				{
					return new BaseObj_ImgState(res, cx, cy, _w, _h);
				}
				case BaseDef.BOT_PERSONDATAAMESTATE:
				{
					return new BaseObj_FrameState(res, cx, cy, _w, _h);
				}
				case BaseDef.BOT_MAPAREA:
				{
					return new BaseObj_MapArea(res, cx, cy, _w, _h);
				}
				case BaseDef.BOT_SWFSTATE:
				{
					return new BaseObj_SWFState(res, cx, cy, _w, _h);
				}
			}
			
			return null;
		}
	}
}