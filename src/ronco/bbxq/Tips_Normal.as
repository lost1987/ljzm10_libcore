package ronco.bbxq
{
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import ronco.base.*;
	
	public class Tips_Normal extends Sprite
	{
		public static var res_name:String;
		public static var res_bmp:Bitmap;
		public static var res_left:int;
		public static var res_top:int;
		public static var res_right:int;
		public static var res_bottom:int;
		
		public var img:Bitmap;
		public var chat:TextField = new TextField;		// 对话显示
		
		public function Tips_Normal(_info:String, _w:int, _h:int)
		{
			super();
			
			if(res_bmp == null)
				res_bmp = new ResMgr.singleton.mapRes[res_name] as Bitmap;
			
			var tmpdata:BitmapData = new BitmapData(_w, _h);
			BitmapBuilder.singleton.buildBitmap(tmpdata, res_bmp.bitmapData, 
				res_left, res_top, res_right, res_bottom, _w, _h);
			img = new Bitmap(tmpdata);
			addChild(img);
			
			chat.x = res_left;
			chat.y = res_top;			
			chat.height = _h - res_bottom;
			chat.width = _w - res_right;
			
			chat.multiline = true;
			chat.wordWrap = true;
			chat.selectable = false;
			
			chat.text = _info;
			
			addChild(chat);
		}
		
		public static function initRes(_resname:String, _l:int, _t:int, _r:int, _b:int):void
		{
			res_name = _resname;
			res_left = _l;
			res_top = _t;
			res_right = _r;
			res_bottom = _b;
		}
	}
}