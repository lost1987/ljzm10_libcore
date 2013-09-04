package ronco.ui
{
	import flash.utils.ByteArray;
	import fl.controls.TextInput;
	import fl.managers.FocusManager;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.Rectangle;
	import flash.system.IMEConversionMode;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.controls.TextInput;

	public class TextInput extends EditBase
	{		
		public static const STATE_NORMAL:int 			= 0;	//普通状态
		public static const STATE_MOUSEOVER:int 		= 1;	//鼠标移上状态
		public static const STATE_MOUSEDOWN:int 		= 2;	//鼠标点击状态
		public static const STATE_DISABLE:int 		= 3;	//不可用状态
		
		private var img:Bitmap;
		private var imgRect:Rectangle;
		
		public var filterDropShadow:DropShadowFilter;
		public var filterGrow:GlowFilter;
		
		public var state:int;
		public var isFocus:Boolean = false;
		public var input:fl.controls.TextInput;				// 设置输入框信息
		public var format:TextFormat;							// 设置输入字体样式		
		
		private var _numRestrict:Boolean = false;				// 是否只接收数字
		private var _recSpace:Boolean = true;					// 是否接收空格键
		
		/**
		 * 限制输入字符数，把中文当作2字节处理
		 **/ 
		public var limitChats:int = 0;
		
		public var notifymod:UIModule;
		
		public function TextInput(name:String , _parent:UIElement)
		{
			super(UIDef.UI_TEXTINPUT, name, _parent);
			
			//UIMgr.singleton.addEdit(this);
		}
		
		public function init2(res:BitmapData, _fontsize:int = 12, _ox:int = 7, _oy:int = 2, _w:int = 0, _h:int = 0):void
		{
			img = new Bitmap(res);
			imgRect = new Rectangle(0, 0, img.bitmapData.width / 4, img.bitmapData.height);
			img.scrollRect = imgRect;
			
			if(_w == 0)
				_w = img.bitmapData.width / 4 - _ox * 2;
			
			if(_h == 0)
				_h = img.bitmapData.height - _oy * 2;
			
			chgState(STATE_NORMAL);
			
			addChild(img);
			
			// 添加输入框	
			input = new fl.controls.TextInput();
			input.move(_ox, _oy);
			input.setSize(_w, _h);
			input.maxChars = 64;//字符限制
			
			format = new TextFormat(null, _fontsize);
			
			input.setStyle("upSkin", 0);
			input.setStyle("textFormat", format); // 设置字体
			input.setStyle("focusRectPadding", 10000); // 设置取消边框
			if(flash.system.Capabilities.os.indexOf("Mac") == -1)
			{
				input.imeMode = flash.system.IMEConversionMode.CHINESE; // 设置输入法
			}
//			input.imeMode = flash.system.IMEConversionMode.ALPHANUMERIC_HALF; // 设置输入法
			
			addChild(input);
			
			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = img.bitmapData.width / 4;
			lh = img.bitmapData.height;
			
			input.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			input.addEventListener(Event.CHANGE, onChange);
			input.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			input.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}		

		public function init(res:Class, _fontsize:int = 12, _ox:int = 7, _oy:int = 2, _w:int = 0, _h:int = 0):void
		{
			img = new res as Bitmap;
			imgRect = new Rectangle(0, 0, img.bitmapData.width / 4, img.bitmapData.height);
			img.scrollRect = imgRect;
			
			if(_w == 0)
				_w = img.bitmapData.width / 4 - _ox * 2;
			
			if(_h == 0)
				_h = img.bitmapData.height - _oy * 2;
			
			chgState(STATE_NORMAL);
			
			addChild(img);

			// 添加输入框	
			input = new fl.controls.TextInput();
			input.move(_ox, _oy);
			input.setSize(_w, _h);
			input.maxChars = 64;//字符限制
			
			format = new TextFormat(null, _fontsize);

			input.setStyle("upSkin", 0);
			input.setStyle("textFormat", format); // 设置字体
			input.setStyle("focusRectPadding", 10000); // 设置取消边框
			if(flash.system.Capabilities.os.indexOf("Mac") == -1)
			{
				input.imeMode = flash.system.IMEConversionMode.CHINESE; // 设置输入法
			}
//			input.imeMode = flash.system.IMEConversionMode.ALPHANUMERIC_HALF; // 设置输入法
			
			addChild(input);

			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = img.bitmapData.width / 4;
			lh = img.bitmapData.height;
			
			input.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			input.addEventListener(Event.CHANGE, onChange);
			input.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			input.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);			
		}
				
		public function chgState(_s:int):void
		{
			state = _s;
			
			imgRect.left = (img.bitmapData.width / 4) * _s;
			imgRect.right = imgRect.left + img.bitmapData.width / 4;
			imgRect.top = 0;
			imgRect.bottom = img.bitmapData.height;
			
			img.scrollRect = imgRect;
			
			// if diabaled
			if(input != null)
			{
				if(state == STATE_DISABLE){
					input.editable = false;
					input.textField.selectable = false;
				} else{
					input.editable = true;
					input.textField.selectable = true;
				}					
			}			
		}
		
		// 设置输入法
		public function setIMECoversion(_str:String=null):void
		{
			input.imeMode = _str;
		}
		
		// 获取文本样式设置对象
		public function getTextFormat():TextFormat
		{
			return format;
		}
		
		//  获取文本显示和输入设置对象
		public function getTextField():TextField
		{
			return input.textField;
		}
		
		// 是否只接收数字输入
		public function get numRestrict():Boolean
		{
			return _numRestrict;
		}
		
		public function set numRestrict(value:Boolean):void
		{
			_numRestrict = value;
			
			if(_numRestrict)
				input.restrict= "0-9";
			else
				input.restrict = null;
		}
		
		//! 是否接受空格输入
		public function get recSpace():Boolean
		{
			return _recSpace;
		}
		
		public function set recSpace(value:Boolean):void
		{
			_recSpace = value;
			
			if(!_recSpace)
			{
				if(numRestrict)
					input.restrict = "0-9^ ";
				else
					input.restrict = "0-9a-zA-Z\u4e00-\u9fa5";
			}
		}
				
		public function setLocale(_x:int,_y:int):void
		{
			this.x = _x;
			this.y = _y;
		}
		
		public function setSize(_w:int,_h:int):void
		{
			input.setSize(_w,_h);
			//this.width = _w;
			//this.height = _h;
		}

		/**设置能否使用*/
		public function enable_r(_enable:Boolean):void
		{
			if(_enable)
				chgState(STATE_NORMAL)
			else
				chgState(STATE_DISABLE)
				
		}
		
		// 设置字体颜色
		public function setFontColor(_color:uint):void
		{
			format.color = _color;
			
			input.setStyle("textFormat", format);
		}		
		
		// 设置是否有描边
		public function setBorder(_hasBorder:Boolean, _color:uint):void
		{
			var lst:Array;
			
			if(_hasBorder)
			{
				lst = input.filters;
				if(lst == null)
					lst = new Array;
				
				if(filterDropShadow != null)
					filterDropShadow.color = _color;
				else
					filterDropShadow = new DropShadowFilter(0, 0, _color, 1, 2, 2, 255);					
				
				lst.push(filterDropShadow);
				
				input.filters = lst;
			}
			else
			{
				lst = input.filters;
				if(lst != null)	
				{
					for(var i:int = 0; i < lst.length; ++i)
					{
						if(lst[i] == filterDropShadow)
						{
							lst.splice(i, 1);
							
							break;
						}
					}
				}
				
				input.filters = lst;
			}	
		}
		
		/**
		 * 是否激活状态
		 **/ 
		public override function isActive(mgrFocus:FocusManager):Boolean
		{
			return input == mgrFocus.getFocus();
		}

		//! 处理操作，如果返回true，表示截获操作，不继续交给后面的控件处理，否则会交给后面的控件处理
		public override function onCtrl(ctrl:UICtrl):Boolean
		{
			
			if(isIn(ctrl.mx, ctrl.my))
			{
				if(ctrl.lBtn == UICtrl.KEY_STATE_NORMAL)
				{
					if(state != STATE_DISABLE)
					{
						if(state == STATE_NORMAL)
						{
							chgState(STATE_MOUSEOVER);
							
							return true;
						}						
					}
				}
				else if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON || ctrl.lBtn == UICtrl.KEY_STATE_DOWN)// 响应输入、光标
				{
					if(state != STATE_DISABLE)
					{
						if(state != STATE_MOUSEDOWN)
						{
							chgState(STATE_MOUSEDOWN);
							
							procUINotify(this, UIDef.NOTIFY_FOCUS_GET);
							
							if(notifymod != null)
							{
								notifymod._onEdtGetForce(this);
							}
							//isFocus = true;
							return true;
						}						
					}					
				}
				else if(ctrl.lBtn == UICtrl.KEY_STATE_UP)
				{
					if(state != STATE_DISABLE)
					{
						if(state != STATE_MOUSEDOWN)
						{
							chgState(STATE_MOUSEOVER);
							
							procUINotify(this, UIDef.NOTIFY_CLICK_BTN);
							
							return true;
						}						
					}
				}
			}// inside of TextInput 
			else if(state == STATE_MOUSEOVER || state == STATE_MOUSEDOWN)
			{
				chgState(STATE_NORMAL);
			}// out of TextInput 
			
			return false;
		}
		
		public override function onKey(keyCode:int):Boolean
		{
			if (keyCode == 9)
			{
				procUINotify(this, UIDef.NOTIFY_KEY_TAB);
				
				return true;
			}
			
			return false;
		}
		
		private function onMouseDown(e:Event):void
		{
			isFocus = true;
			
			procUINotify(this, UIDef.NOTIFY_FOCUS_GET);
			
			if(notifymod != null)
			{
				notifymod._onEdtGetForce(this);
			}			
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
			if(limitChats <= 0)
			{
				procUINotify(this, UIDef.NOTIFY_CHANGE);
				
				return ;
			}
			
			var str:String = input.text;
			
			while(_getStringBytesLength(str, "gb2312") > limitChats)
			{
				str = str.substr(0, str.length - 1);
			}
			
			input.text = str;
			
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
			
			procUINotify(this, UIDef.NOTIFY_CHANGE);
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