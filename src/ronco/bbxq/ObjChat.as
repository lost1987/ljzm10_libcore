package ronco.bbxq
{
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import ronco.base.*;

	public class ObjChat extends Sprite
	{
		public static var res_name:String;
		public static var res_bmp:Bitmap;
		public static var res_name1:String;			// 对话的尖尖
		public static var res_left:int;
		public static var res_top:int;
		public static var res_right:int;
		public static var res_bottom:int;
		
		public var imgChat:Bitmap;						// 对话的背景图
		public var imgChat1:Bitmap;					// 对话的尖尖
		public var chat:TextField = new TextField;		// 对话显示
		
		public function ObjChat(_w:int, _h:int)
		{
			super();
			
			if(res_bmp == null)
				res_bmp = new ResMgr.singleton.mapRes[res_name] as Bitmap;
			
			var tmpdata:BitmapData = new BitmapData(_w, _h);
			BitmapBuilder.singleton.buildBitmap(tmpdata, res_bmp.bitmapData, 
				res_left, res_top, res_right, res_bottom, _w, _h);
			imgChat = new Bitmap(tmpdata);
			addChild(imgChat);
			
			imgChat1 = new ResMgr.singleton.mapRes[res_name1] as Bitmap;
			imgChat1.x = _w / 2;
			imgChat1.y = _h - 2;
			addChild(imgChat1);
			
			chat.x = res_left;
			chat.y = res_top;			
			chat.height = _h - res_bottom;
			chat.width = _w - res_right;
			
			chat.multiline = true;
			chat.wordWrap = true;
			chat.selectable = false;
			
//			chat.text = "";
			
			addChild(chat);
		}
		
		public static function initRes(_resname:String, _resname1:String, _l:int, _t:int, _r:int, _b:int):void
		{
			res_name = _resname;
			res_name1 = _resname1;
			res_left = _l;
			res_top = _t;
			res_right = _r;
			res_bottom = _b;
		}		
	}
}
