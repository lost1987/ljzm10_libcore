package ronco.ui
{
	import fl.controls.Label;
	
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	public class UI3QInfo extends CheckBox
	{
		public static const _INFO_TYPE_NOMAL:int		=	0x01;//普通信件
		public static const _INFO_TYPE_VIRTUAL:int	=	0x02;//虚拟物品
		public static const _INFO_TYPE_KIND:int		=	0x04;//实物物品
		public static const _INFO_TYPE_READ:int		=	0x10;//已读信件
		public static const _INFO_TYPE_TAKE:int		=	0x20;//已取物品
		
//		public var statebit:Bitmap = new Bitmap();			// 类型状态 图标
//		public var stateRect:Rectangle = new Rectangle();
		public var Label_person:fl.controls.Label;			// 寄件人
		public var Label_time:fl.controls.Label;			// 时间
		public var Label_title:fl.controls.Label;			// 标题
		public var Label_losttime:fl.controls.Label;		// 剩余时间
		public var icon:ronco.ui.ImageChange;				// ICON
		
		public var person:String;
		public var time:String;
		public var title:String;
		public var losttime:String;
		public var msgid:int;
		
		//! 字体未读
		private var format:TextFormat = new TextFormat(null,12,0xdaca1c);
		//! 字体已读
		private var format_r:TextFormat = new TextFormat(null,12,0xb55739);
		//! 时间字体
		private var format_time:TextFormat = new TextFormat(null, 12, 0xff3535);
		
		public var curState:int;					// 当前状态
		
		public function UI3QInfo(_name:String, _parent:UIElement)
		{
			super(_name, _parent);
		}
		
		public function Init2(_btnres:BitmapData, _btnres2:BitmapData, _type:BitmapData, _msgid:int, _state:int, _name:String, _time:String,
							 _title:String, _lostTime:String):void
		{
			super.init2(_btnres, _btnres2);
			//			statebit = new _type as Bitmap;
			//			statebit.x = 0;
			//			statebit.y = 0;
			//			statebit.visible = true;
			//			addChild(statebit);
			
			msgid = _msgid;
			curState = _state;
			person = _name;
			time = _time;
			title = _title;
			losttime = _lostTime;
			
			
			icon = new ImageChange("icon", this);
			icon.init2(_type, 1, 6);
			icon.x = 4;
			icon.y = 13;
			addChild(icon);
			
			//! 寄件人
			Label_person = new fl.controls.Label();
			Label_person.setStyle("textFormat",format); // 以后便通过 : label.textField  对象设置字体属性
			Label_person.text = _name;
			Label_person.width =Label_person.textField.textWidth+5; // 此处的字体宽高是根据size=12 的字体计算的.
			Label_person.height = Label_person.textField.textHeight+5;
			Label_person.x = 23
			Label_person.y = 8
			
			addChild(Label_person);
			// 时间
			Label_time = new fl.controls.Label();
			Label_time.setStyle("textFormat",format); // 以后便通过 : label.textField  对象设置字体属性
			Label_time.text = _time;
			Label_time.width =Label_time.textField.textWidth+5; // 此处的字体宽高是根据size=12 的字体计算的.
			Label_time.height = Label_time.textField.textHeight+5;
			Label_time.x = 116;
			Label_time.y = 8;
			
			addChild(Label_time);
			// 主题
			Label_title = new fl.controls.Label();
			Label_title.setStyle("textFormat",format); // 以后便通过 : label.textField  对象设置字体属性
			Label_title.text = _title;
			Label_title.width =Label_title.textField.textWidth+5; // 此处的字体宽高是根据size=12 的字体计算的.
			Label_title.height = Label_title.textField.textHeight+5;
			Label_title.x = 23;
			Label_title.y = 27;
			
			addChild(Label_title);
			// 剩余时间
			Label_losttime = new fl.controls.Label();
			Label_losttime.setStyle("textFormat",format_time); // 以后便通过 : label.textField  对象设置字体属性
			Label_losttime.text = _lostTime;
			Label_losttime.width =Label_losttime.textField.textWidth+5; // 此处的字体宽高是根据size=12 的字体计算的.
			Label_losttime.height = Label_losttime.textField.textHeight+5;
			Label_losttime.x = 206;
			Label_losttime.y = 8;
			
			addChild(Label_losttime);
			
			updateState();
		}		

		public function Init(_btnres:Class, _btnres2:Class, _type:Class, _msgid:int, _state:int, _name:String, _time:String,
							 _title:String, _lostTime:String):void
		{
			super.init(_btnres, _btnres2);
//			statebit = new _type as Bitmap;
//			statebit.x = 0;
//			statebit.y = 0;
//			statebit.visible = true;
//			addChild(statebit);
			
			msgid = _msgid;
			curState = _state;
			person = _name;
			time = _time;
			title = _title;
			losttime = _lostTime;
			

			icon = new ImageChange("icon", this);
			icon.init(_type, 1, 6);
			icon.x = 4;
			icon.y = 13;
			addChild(icon);
			
			//! 寄件人
			Label_person = new fl.controls.Label();
			Label_person.setStyle("textFormat",format); // 以后便通过 : label.textField  对象设置字体属性
			Label_person.text = _name;
			Label_person.width =Label_person.textField.textWidth+5; // 此处的字体宽高是根据size=12 的字体计算的.
			Label_person.height = Label_person.textField.textHeight+5;
			Label_person.x = 23
			Label_person.y = 8
			
			addChild(Label_person);
			// 时间
			Label_time = new fl.controls.Label();
			Label_time.setStyle("textFormat",format); // 以后便通过 : label.textField  对象设置字体属性
			Label_time.text = _time;
			Label_time.width =Label_time.textField.textWidth+5; // 此处的字体宽高是根据size=12 的字体计算的.
			Label_time.height = Label_time.textField.textHeight+5;
			Label_time.x = 116;
			Label_time.y = 8;
			
			addChild(Label_time);
			// 主题
			Label_title = new fl.controls.Label();
			Label_title.setStyle("textFormat",format); // 以后便通过 : label.textField  对象设置字体属性
			Label_title.text = _title;
			Label_title.width =Label_title.textField.textWidth+5; // 此处的字体宽高是根据size=12 的字体计算的.
			Label_title.height = Label_title.textField.textHeight+5;
			Label_title.x = 23;
			Label_title.y = 27;
			
			addChild(Label_title);
			// 剩余时间
			Label_losttime = new fl.controls.Label();
			Label_losttime.setStyle("textFormat",format_time); // 以后便通过 : label.textField  对象设置字体属性
			Label_losttime.text = _lostTime;
			Label_losttime.width =Label_losttime.textField.textWidth+5; // 此处的字体宽高是根据size=12 的字体计算的.
			Label_losttime.height = Label_losttime.textField.textHeight+5;
			Label_losttime.x = 206;
			Label_losttime.y = 8;
			
			addChild(Label_losttime);
			
			updateState();
		}
		
		public function updateState():void
		{
			if(curState & _INFO_TYPE_NOMAL)
			{
				if(curState & _INFO_TYPE_READ)
				{
					icon.change2(0,1);
					Label_person.setStyle("textFormat", format_r);
					Label_title.setStyle("textFormat", format_r);
					Label_time.setStyle("textFormat", format_r);
				}
				else
				{
					icon.change2(0,0);
				}
			}
			else if(curState & _INFO_TYPE_VIRTUAL)
			{
				if(curState & _INFO_TYPE_READ)
				{
					if(curState & _INFO_TYPE_TAKE)
					{
						icon.change2(0,3);
					}
					else
					{
						icon.change2(0,2);
					}
					Label_person.setStyle("textFormat", format_r);
					Label_title.setStyle("textFormat", format_r);
					Label_time.setStyle("textFormat", format_r);
				}
				else
				{
					icon.change2(0,2);
				}
			}
			else if(curState & _INFO_TYPE_KIND)
			{
				if(curState & _INFO_TYPE_READ)
				{
					if(curState & _INFO_TYPE_TAKE)
					{
						icon.change2(0,5);
					}
					else
					{
						icon.change2(0,4);
					}
					Label_person.setStyle("textFormat", format_r);
					Label_title.setStyle("textFormat", format_r);
					Label_time.setStyle("textFormat", format_r);
				}
				else
				{
					icon.change2(0,4);
				}

			}
		}

		
		public override function onCtrl(ctrl:UICtrl):Boolean
		{
			if(isIn(ctrl.mx, ctrl.my))
			{
				if(ctrl.lBtn == UICtrl.KEY_STATE_NORMAL)
				{
					if(state == STATE_NORMAL)
					{
						_chgState(STATE_MOUSEOVER);
						
						return true;
					}
				}
				else if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON || ctrl.lBtn == UICtrl.KEY_STATE_DOWN)
				{
					if(state == STATE_MOUSEOVER)
					{
						_chgState(STATE_MOUSEDOWN);
						
						return true;
					}
				}
				else if(ctrl.lBtn == UICtrl.KEY_STATE_UP)
				{
					if(state == STATE_MOUSEDOWN)
					{
						setSaveable(true);
						
						_chgState(STATE_MOUSEOVER);
						
						procUINotify(this, UIDef.NOTIFY_CLICK_BTN);
						
						return true;
					}
				}
			}
			else if(state == STATE_MOUSEOVER || ctrl.lBtn == UICtrl.KEY_STATE_UP)
			{
				_chgState(STATE_NORMAL);
			}
			
			return false;
		}
		
		
		public function Read():void
		{
			if(!(curState & _INFO_TYPE_READ))
			{
				curState += _INFO_TYPE_READ;
			}
			updateState();
		}
		
		public function Take():void
		{
			if(!(curState & _INFO_TYPE_TAKE))
			{
				curState += _INFO_TYPE_TAKE;
			}
			updateState();
		}
		
	}
}