package ronco.ui
{	
	import flash.display.*;
	import flash.events.FocusEvent;
	import flash.text.TextFormat;
	
	// 用于输出面板
	public class TextArea extends UIElement
	{
		public var textArea:TextAreaOver = new TextAreaOver();
		private var textformat:TextFormat = new TextFormat("宋体",12,0xFFFFFF);
		
		public function TextArea(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_TEXTAREA,_name, _parent);
		}
		
		// 初始化信息
		public function init2(_resback:BitmapData,_text:String,_fontSize:int=12,_indent:int=0,_bindent:int=5,_rightm:int=10,_lending:int=5):void
		{
			var bitmap:Bitmap;
			
			if(_resback == null)
				bitmap = new Bitmap();
			else
				bitmap = new Bitmap(_resback);
			
			textArea.setSize(bitmap.width, bitmap.height);
			textArea.htmlText = _text+"\n";
			textArea.editable = false;
			textArea.wordWrap = true;// 自动换行
			
			textformat.size = _fontSize;
			textformat.blockIndent = _bindent;// 整个模块缩进
			textformat.indent = _indent; // 第一行缩进
			textformat.rightMargin=_rightm;// 设置右边距
			textformat.leading = _lending;// 设置行距
			
			// 设置样式
			textArea.setStyle("upSkin",bitmap);
			textArea.setStyle("textFormat",textformat);
			textArea.setStyle("focusRectPadding",-1);// 设置控件边框 的宽度
			
			textArea.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);//离开焦点
			
			addChild(textArea);
		}		
		
		// 初始化信息
		public function init(_resback:Class,_text:String,_fontSize:int=12,_indent:int=0,_bindent:int=5,_rightm:int=10,_lending:int=5):void
		{
			var bitmap:Bitmap;
			
			if(_resback == null)
				bitmap = new Bitmap();
			else
				bitmap = new _resback as Bitmap;
						
			textArea.setSize(bitmap.width, bitmap.height);
			textArea.htmlText = _text+"\n";
			textArea.editable = false;
			textArea.wordWrap = true;// 自动换行
			
			textformat.size = _fontSize;
			textformat.blockIndent = _bindent;// 整个模块缩进
			textformat.indent = _indent; // 第一行缩进
			textformat.rightMargin=_rightm;// 设置右边距
			textformat.leading = _lending;// 设置行距
			
			// 设置样式
			textArea.setStyle("upSkin",bitmap);
			textArea.setStyle("textFormat",textformat);
			textArea.setStyle("focusRectPadding",-1);// 设置控件边框 的宽度
			
			textArea.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);//离开焦点
			
			addChild(textArea);
		}
		
		// 设置滚轴皮肤    滚动条 / 滚道  / 上按钮  / 下按钮
		public function setScroll2(_resBar:BitmapData,_resRoad:BitmapData,_resUp:BitmapData,_resDown:BitmapData):void
		{
			var bitmap0:Bitmap = new Bitmap(_resBar);
			var bitmap1:Bitmap = new Bitmap(_resRoad);
			var bitmap2:Bitmap = new Bitmap(_resUp);
			var bitmap3:Bitmap = new Bitmap(_resDown);
			
			textArea.setStyle("thumbUpSkin",bitmap0);//滚轴
			textArea.setStyle("thumbOverSkin",bitmap0);
			textArea.setStyle("thumbDownSkin",bitmap0);
			textArea.setStyle("thumbDisabledSkin",bitmap0);
			
			textArea.setStyle("trackOverSkin",bitmap1);// 滑道
			textArea.setStyle("trackUpSkin",bitmap1);
			textArea.setStyle("trackDownSkin",bitmap1);
			textArea.setStyle("trackDisabledSkin",bitmap1);	
			
			textArea.setStyle("upArrowOverSkin",bitmap2);// 上按钮
			textArea.setStyle("upArrowDownSkin",bitmap2);
			textArea.setStyle("upArrowUpSkin",bitmap2); 
			textArea.setStyle("upArrowDisabledSkin",bitmap2); 
			
			textArea.setStyle("downArrowUpSkin",bitmap3);// 下按钮
			textArea.setStyle("downArrowOverSkin",bitmap3);
			textArea.setStyle("downArrowDownSkin",bitmap3);
			textArea.setStyle("downArrowDisabledSkin",bitmap3);
		}		
		
		// 设置滚轴皮肤    滚动条 / 滚道  / 上按钮  / 下按钮
		public function setScroll(_resBar:Class,_resRoad:Class,_resUp:Class,_resDown:Class):void
		{
			var bitmap0:Bitmap = new _resBar as Bitmap;
			var bitmap1:Bitmap = new _resRoad as Bitmap;
			var bitmap2:Bitmap = new _resUp as Bitmap;
			var bitmap3:Bitmap = new _resDown as Bitmap;

			textArea.setStyle("thumbUpSkin",bitmap0);//滚轴
			textArea.setStyle("thumbOverSkin",bitmap0);
			textArea.setStyle("thumbDownSkin",bitmap0);
			textArea.setStyle("thumbDisabledSkin",bitmap0);

			textArea.setStyle("trackOverSkin",bitmap1);// 滑道
			textArea.setStyle("trackUpSkin",bitmap1);
			textArea.setStyle("trackDownSkin",bitmap1);
			textArea.setStyle("trackDisabledSkin",bitmap1);	

			textArea.setStyle("upArrowOverSkin",bitmap2);// 上按钮
			textArea.setStyle("upArrowDownSkin",bitmap2);
			textArea.setStyle("upArrowUpSkin",bitmap2); 
			textArea.setStyle("upArrowDisabledSkin",bitmap2); 

			textArea.setStyle("downArrowUpSkin",bitmap3);// 下按钮
			textArea.setStyle("downArrowOverSkin",bitmap3);
			textArea.setStyle("downArrowDownSkin",bitmap3);
			textArea.setStyle("downArrowDisabledSkin",bitmap3);
		}

		// 向末尾添加文本内容
		public function appendText(arg0:String):void
		{
			textArea.appendText(arg0+"\n");
		}
				
		public function get textFormat():TextFormat
		{
			return textformat;
		}
		
		public function setText(_text:String):void
		{
			textArea.htmlText = _text+"\n";
		}
		
		public function set textFormat(value:TextFormat):void
		{
			textformat = value;
		}
		
		public function setSize(_w:int,_h:int):void
		{
			textArea.setSize(_w,_h);
		}
		
		public function setFontSize(_size:int):void
		{
			textformat.size = _size;
		}
		
		public function setFontColor(_color:int):void
		{
			textformat.color = _color;
		}
		
		// 设置行距
		public function setLeading(arg0:int):void
		{
			textformat.leading = arg0;
		}
		
		// 设置右边距
		public function setRightMargin(arg0:int):void
		{
			textformat.rightMargin=arg0;
		}
		
		// 设置模块缩进
		public function setBlockIndent(arg0:int):void
		{
			textformat.blockIndent = arg0;
		}
		
		// 设置第一行缩进
		public function  setIndent(arg0:int):void
		{
			textformat.indent = arg0;
		}
		
		public function onFocusOut(evt:FocusEvent):void
		{
			textArea.verticalScrollBar.scrollPosition = textArea.verticalScrollBar.scrollPosition;
		}
	}
}