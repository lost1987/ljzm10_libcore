package ronco.ui
{
	import flash.utils.ByteArray;
	import fl.controls.TextArea;
	import fl.managers.FocusManager;
	
	import flash.events.*;
	import flash.display.*;
	import flash.events.FocusEvent;
	import flash.text.TextFormat;
	import flash.system.IMEConversionMode;

	public class MulTextInput extends EditBase
	{
		public var textArea:fl.controls.TextArea = new fl.controls.TextArea();
		private var textformat:TextFormat = new TextFormat("宋体", 12, 0xFFFFFF);
		public var isFocus:Boolean = false;
		
		/**
		 * 限制输入字符数，把中文当作2字节处理
		 **/ 
		public var limitChats:int = 0;				
		/**
		 * 限制输入字符数，把中文当作1字节处理
		 **/ 
		public var limitChats1:int = 0;		
		
		public function MulTextInput(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_MULTEXTINPUT, _name, _parent);
		}
		
		/**
		 * 初始化
		 **/ 
		public function init(_resback:Class, _text:String, _fontSize:int=12, _indent:int=0, _bindent:int=5, _rightm:int=10, _lending:int=5):void
		{
//			textArea.imeMode = IMEConversionMode.CHINESE;	
			textArea.restrict = null;
			var bitmap:Bitmap;

			if(_resback == null)
				bitmap = new Bitmap();
			else
				bitmap = new _resback as Bitmap;
			
			textArea.setSize(bitmap.width, bitmap.height);
			//textArea.test = _text+"\n";
			textArea.editable = true;
			textArea.wordWrap = true;// 自动换行
			
			textformat.size = _fontSize;
			textformat.blockIndent = _bindent;// 整个模块缩进
			textformat.indent = _indent; // 第一行缩进
			textformat.rightMargin=_rightm;// 设置右边距
			textformat.leading = _lending;// 设置行距
//			
//			// 设置样式
			textArea.setStyle("upSkin",bitmap);
			textArea.setStyle("textFormat",textformat);
			textArea.setStyle("focusRectPadding",-1);// 设置控件边框 的宽度
			
			//textArea.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);//离开焦点
			if(flash.system.Capabilities.os.indexOf("Mac") == -1)
			{
				textArea.imeMode = flash.system.IMEConversionMode.CHINESE;
			}
			
			addChild(textArea);
			
			textArea.addEventListener(Event.CHANGE, onChange);
			textArea.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			textArea.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}	
		
		/**
		 * 是否激活状态
		 **/ 
		public override function isActive(mgrFocus:FocusManager):Boolean
		{
			return textArea == mgrFocus.getFocus();
		}		
		
//		public function get textFormat():TextFormat
//		{
//			return textformat;
//		}
//		
//		public function setText(_text:String):void
//		{
//			textArea.htmlText = _text+"\n";
//		}
//		
//		public function set textFormat(value:TextFormat):void
//		{
//			textformat = value;
//		}
		
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
		
		private function _getStringBytesLength(str:String, charSet:String):int
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(str,charSet);
			bytes.position = 0;
			return bytes.length;
		}				
		
		private function onChange(e:Event):void
		{	
			procUINotify(this, UIDef.NOTIFY_CHANGE);
			
			if(limitChats <= 0 && limitChats1 <= 0)
			{	
				return ;
			}
			
			var str:String = textArea.text;
			
			if(limitChats1 <= 0)
			{
				while(_getStringBytesLength(str, "gb2312") > limitChats)
				{
					str = str.substr(0, str.length - 1);
				}
			}
			else
			{
				while(_getStringBytesLength(str, "unicode") > limitChats1)
				{
					str = str.substr(0, str.length - 1);
				}
			}
			
			textArea.text = str;
			
			//			var target:fl.controls.TextInput = event.currentTarget as fl.controls.TextInput;  
			//			
			//			if (target.maxChars <= 0) return;  
			//			
			//			//原始文本  
			//			var oldText:String = target.text;  
			//			
			//			//新追加的文本  
			//			var addText:String;  
			//			
			//			//选中文字的长度（将要被覆盖的文字）  
			//			var delLen:int;  
			//			
			//			//文字总长度  
			//			var totalLen:int;  
			//			
			//			var insertOp:InsertTextOperation;  
			//			var pasteOp:PasteOperation;  
			//			
			//			var selectState:SelectionState;  
			//			
			//			
			//			if (event.operation is InsertTextOperation) {  
			//				//文本插入  
			//				insertOp = event.operation as InsertTextOperation;  
			//				
			//				//获取新追加的文本  
			//				addText = insertOp.text;  
			//				
			//				//获取选中文字的对象  
			//				selectState = insertOp.deleteSelectionState;      
			//				
			//				delLen = selectState ? getByteLenByStr(oldText.substring(selectState.absoluteStart, selectState.absoluteEnd)) : 0;   
			//				
			//				//总长度  
			//				totalLen = getByteLenByStr(oldText) + getByteLenByStr(addText) - delLen;  
			//				
			//				if (totalLen > target.maxChars) event.preventDefault();  
			//				
			//			} else if (event.operation is PasteOperation) {  
			//				//文本粘帖  
			//				pasteOp = event.operation as PasteOperation;  
			//				
			//				//获取粘帖的文本  
			//				addText = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT) as String;  
			//				
			//				//获取选中文字的对象  
			//				selectState = pasteOp.originalSelectionState;  
			//				
			//				delLen = selectState ? getByteLenByStr(oldText.substring(selectState.absoluteStart, selectState.absoluteEnd)) : 0;   
			//				
			//				//总长度  
			//				totalLen = getByteLenByStr(oldText) + getByteLenByStr(addText) - delLen;  
			//				
			//				if (totalLen > target.maxChars) event.preventDefault();  
			//				
			//			}//if event.operation end  
			
			//onUINotify(this, UIDef.NOTIFY_CHANGE);
		}	
		
		private function onFocusIn(e:FocusEvent):void
		{
			isFocus = true;
			
			UIMgr.singleton.setActiveEdit(this);
			
			procUINotify(this, UIDef.NOTIFY_EDIT_FORCEIN);
		}
		
		private function onFocusOut(e:FocusEvent):void
		{
			isFocus = false;
			
			UIMgr.singleton.clearCurActiveEdit(this);
			//onUINotify(this, UIDef.NOTIFY_CHANGE);
		}	
	}
}