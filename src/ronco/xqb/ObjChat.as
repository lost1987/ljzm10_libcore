package ronco.xqb
{
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	public class ObjChat extends Sprite
	{
		public var imgChat:Bitmap;						// 对话的背景图
		public var chat:TextField = new TextField;		// 对话显示
		
		public function ObjChat(img:Bitmap, _x:int, _y:int, _w:int, _h:int)
		{
			imgChat = img;
			
			//imgChat.scale9Grid = new Rectangle(7, 7, 1, 1);
			
			imgChat.width = _w;
			imgChat.height = _h;
			
			addChild(imgChat);
			
			chat.multiline = true;
			chat.wordWrap = true;
			chat.selectable = false;
			
			chat.x = _x;
			chat.y = _y;			
			chat.height = _h;
			chat.width = _w;
			
			//chat.text = "哈哈，我显示出来了。";
			
			addChild(chat);
		}
	}
}
