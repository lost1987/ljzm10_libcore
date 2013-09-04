package ronco.ui
{
	import fl.controls.Label;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.ui.*;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import ronco.base.TimerInfo;
	import ronco.base.TimerMgr;
	
	public class Button extends UIElement
	{
		public static const STATE_NORMAL:int 			= 0;	//普通状态
		public static const STATE_MOUSEOVER:int 		= 1;	//鼠标移上状态
		public static const STATE_MOUSEDOWN:int 		= 2;	//鼠标点击状态
		public static const STATE_DISABLE:int 		= 3;	//不可用状态
		
		public var img:Bitmap;
		private var imgRect:Rectangle;
		public var state:int;
		
		public var isMouseOnNotify:Boolean = true;			// 鼠标移入时，是否触发通知事件
		public var isMouseOutNotify:Boolean = true;
		public var isBtnDown:Boolean = false;					// 在按钮区域内按下
		public var isCheckAphla:Boolean = true;				// 是否检查按钮透明区域
		
		private var bIn:Boolean = false;
		
		/**
		 * label自动居中
		 **/ 
		public var isLabelAutoCenter:Boolean;
		
		public var label:fl.controls.Label;// 按钮名
		private var format:TextFormat = new TextFormat(null,12,0xffffff);
		
		private var isflashmod:Boolean = false;
		private var tiFlash:TimerInfo;
		
		private var tiHold:TimerInfo;
		/**
		 *  按住函数接口
		 * 函数定义如下：
		 * onHold(btn:Button, time:int):void
		 **/ 
		public var funcHold:Function;
		public var timeHold:int = 0;
		
		public var limitRect:Rectangle;
		public var onBtnMove:Function;
		
		public function Button(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_BUTTON, _name, _parent);
		}
		
		public function init2(res:BitmapData ,_label:String="",_format:Object=null):void
		{
			img = new Bitmap(res);
			imgRect = new Rectangle(0, 0, img.bitmapData.width / 4, img.bitmapData.height);
			img.scrollRect = imgRect;
			
			chgState(STATE_NORMAL);
			
			addChild(img);
			
			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = img.bitmapData.width / 4;
			lh = img.bitmapData.height;
			
			//! 设置按钮label
			if(_label != "")
			{
				label = new fl.controls.Label();
				if((_format as TextFormat) != null )
					format  = _format as TextFormat;
				
				label.setStyle("textFormat",format); // 以后便通过 : label.textField  对象设置字体属性
				label.text = _label;
				label.width =label.textField.textWidth+5; // 此处的字体宽高是根据size=12 的字体计算的.
				label.height = label.textField.textHeight+5;
				label.x = (lw - label.width)/2;
				label.y = (lh -label.height)/2;
				
				isLabelAutoCenter = true;
				
				addChild(label);
			}	
		}		
		
		public function init(res:Class ,_label:String="",_format:Object=null):void
		{
			img = new res as Bitmap;
			imgRect = new Rectangle(0, 0, img.bitmapData.width / 4, img.bitmapData.height);
			img.scrollRect = imgRect;
			
			chgState(STATE_NORMAL);
			
			addChild(img);
			
			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = img.bitmapData.width / 4;
			lh = img.bitmapData.height;
			
			//! 设置按钮label
			if(_label != "")
			{
				label = new fl.controls.Label();
				if((_format as TextFormat) != null )
					format  = _format as TextFormat;
				
				label.setStyle("textFormat",format); // 以后便通过 : label.textField  对象设置字体属性
				label.text = _label;
				label.width =label.textField.textWidth+5; // 此处的字体宽高是根据size=12 的字体计算的.
				label.height = label.textField.textHeight+5;
				label.x = (lw - label.width)/2;
				label.y = (lh -label.height)/2;
				
				isLabelAutoCenter = true;
				
				addChild(label);
			}	
		}
		
		/**
		 * 改变文字
		 **/ 
		public function chgLabel(str:String):void
		{
			label.text = str;
			label.width = label.textField.textWidth + 5; // 此处的字体宽高是根据size=12 的字体计算的.
			label.height = label.textField.textHeight + 5;
			
			if(isLabelAutoCenter)
				label.x = (lw - label.width) / 2;
			
			label.y = (lh -label.height) / 2;			
		}
		
		/**
		 * 初始化，可以配置label的x坐标
		 **/ 
		public function initex(res:Class, _labelx:int, _label:String = "", _format:Object = null):void
		{
			img = new res as Bitmap;
			imgRect = new Rectangle(0, 0, img.bitmapData.width / 4, img.bitmapData.height);
			img.scrollRect = imgRect;
			
			chgState(STATE_NORMAL);
			
			addChild(img);
			
			//! 控件初始化完成以后，应该设置基类的逻辑宽高
			lw = img.bitmapData.width / 4;
			lh = img.bitmapData.height;
			
			//! 设置按钮label
			if(_label != "")
			{
				label = new fl.controls.Label();
				if((_format as TextFormat) != null )
					format  = _format as TextFormat;
				
				label.setStyle("textFormat",format); // 以后便通过 : label.textField  对象设置字体属性
				label.text = _label;
				label.width =label.textField.textWidth+5; // 此处的字体宽高是根据size=12 的字体计算的.
				label.height = label.textField.textHeight+5;
				label.x = _labelx;
				label.y = (lh -label.height)/2;
				
				isLabelAutoCenter = false;
				
				addChild(label);
			}	
		}		
		
		public function setEnabel(_b:Boolean):void
		{
			enable = _b;
			if(_b)
			{
				state = STATE_NORMAL;				
			}
			else
			{
				state = STATE_DISABLE;
			}
			imgRect.left = (img.bitmapData.width / 4) * state;
			imgRect.right = imgRect.left + img.bitmapData.width / 4;
			imgRect.top = 0;
			imgRect.bottom = img.bitmapData.height;
			
			img.scrollRect = imgRect;
		}
		
		public function reload(res:Loader):void
		{
			if(res != null)
			{
				if(img != null)
				{
					removeChild(img);
					img = null;
				}
				
				img = Bitmap(res.content);
				img.scrollRect = imgRect;
				
				addChild(img);
			}
		}
		
		public function reloadEx(res:Class):void
		{
			if(res != null)
			{
				if(img != null)
				{
					removeChild(img);
					img = null;
				}
				
				img = new res as Bitmap;
				img.scrollRect = imgRect;
				
				addChild(img);
			}
		}
		
		public function reloadBmp(bd:BitmapData):void
		{
			if(bd != null)
			{
				img.bitmapData = bd;
				
//				if(img != null)
//				{
//					removeChild(img);
//					img = null;
//				}
				
				//img = new res as Bitmap;
				imgRect.left = (img.bitmapData.width / 4) * state;
				imgRect.right = imgRect.left + img.bitmapData.width / 4;
				imgRect.top = 0;
				imgRect.bottom = img.bitmapData.height;
				
				img.scrollRect = imgRect;
				
				//addChild(img);
			}
		}		
		
		public function chgState(_s:int):void
		{
			if(state != _s)
			{
				if(isMouseOutNotify && state != STATE_DISABLE && _s == STATE_NORMAL)
					procUINotify(this, UIDef.NOTIFY_MOUSEOUT_BTN);
				
				state = _s;
				
				imgRect.left = (img.bitmapData.width / 4) * _s;
				imgRect.right = imgRect.left + img.bitmapData.width / 4;
				imgRect.top = 0;
				imgRect.bottom = img.bitmapData.height;
				
				img.scrollRect = imgRect;
				
				if(state == STATE_MOUSEDOWN)
					timeHold = getTimer();
				
//				if(_s == STATE_MOUSEOVER)
//					Mouse.cursor = MouseCursor.BUTTON;
//				else if(_s == STATE_NORMAL || _s == STATE_DISABLE)
//					Mouse.cursor = MouseCursor.AUTO;
			}
		}
		
		public override function _procHold(ctrl:UICtrl):Boolean
		{
			if(isHold)
			{
				if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN || ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON)
				{	
					//! 这里将对话框特殊处理了，防止对话框移出屏幕
					if(limitRect != null)
					{
						var tx:int = x + ctrl.mx - xHold;
						var ty:int = y + ctrl.my - yHold;
						
//						if(tx < limitRect.left)
//							x = limitRect.left;
//						else if(tx + lw > limitRect.right)
//							x = limitRect.right - lw;
//						else
//							x = tx;
						
						if(ty < limitRect.top)
							y = limitRect.top;
						else if(ty + lh > limitRect.bottom)
							y = limitRect.bottom - lh;
						else
							y = ty;
					}
					else
					{
					//	x += ctrl.mx - xHold;
						y += ctrl.my - yHold;				
					}
					
					xHold = ctrl.mx;
					yHold = ctrl.my;
					
					if(onBtnMove != null)
						onBtnMove(this);
					
					return true;
				}
				else
				{
					////MainLog.singleton.output("hold off");
					
					isHold = false;
				}
				
				return true;
			}
			else if(isIn(ctrl.mx, ctrl.my))
			{
				if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN || ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON)
				{
					//					if(isHold)
					//					{
					//						x += ctrl.mx - xHold;
					//						y += ctrl.my - yHold;
					//						
					//						xHold = ctrl.mx;
					//						yHold = ctrl.my;						
					//					}
					//					else 
					if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON)
					{
						//UIMgr.singleton.setActive(this);
						////MainLog.singleton.output("hold on");
						
						if(areaNoHold != null)
						{
							if(!((ctrl.mx - x) < areaNoHold.left || (ctrl.mx - x) > areaNoHold.right || 
								(ctrl.my - y) < areaNoHold.top || (ctrl.my - y) > areaNoHold.bottom))
								return true;
						}
						
						isHold = true;
						
						xHold = ctrl.mx;
						yHold = ctrl.my;
					}
					
					return true;
				}
				else
					isHold = false;
				
				return true;
			}
			
			return false;
		}
				
		//! 处理操作，如果返回true，表示截获操作，不继续交给后面的控件处理，否则会交给后面的控件处理
		public override function onCtrl(ctrl:UICtrl):Boolean
		{			
			if(!visible)
				return false;
			
			if(isIn(ctrl.mx, ctrl.my))
			{			
				if(!bIn)
				{
					if(funcTips != null)
						funcTips(this, true);
				}		
				bIn = true;
			}
			else if(bIn)
			{
				bIn = false;
				
				if(funcTips != null)
					funcTips(this, false);
			}
			
			if(state != STATE_DISABLE)
			{			
				if(canHold)
					_procHold(ctrl);
				
				if(isIn(ctrl.mx, ctrl.my) && visible)
				{
					Mouse.cursor = MouseCursor.BUTTON;
					
					if(ctrl.lBtn == UICtrl.KEY_STATE_NORMAL)
					{
						if(state == STATE_NORMAL)
						{
							chgState(STATE_MOUSEOVER);
							
							UIMgr.singleton.setActiveButton(this);
							
							if(isMouseOnNotify)
								procUINotify(this, UIDef.NOTIFY_MOUSEIN_BTN);
	
							return true;
						}
					}
					else if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON)
					{
						isBtnDown = true;
						
						chgState(STATE_MOUSEDOWN);
						
						
						
						return true;					
					}
					else if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN)
					{
						if(isBtnDown)
							chgState(STATE_MOUSEDOWN);
						else
						{
							chgState(STATE_MOUSEOVER);
							
							UIMgr.singleton.setActiveButton(this);
						}
	
						return true;
					}
					else if(ctrl.lBtn == UICtrl.KEY_STATE_UP)
					{
						if(isBtnDown)
						{
							isBtnDown = false;
							
							chgState(STATE_MOUSEOVER);
							
							UIMgr.singleton.setActiveButton(this);
							
							procUINotify(this, UIDef.NOTIFY_CLICK_BTN);
							
							if(!visible)
								chgState(STATE_NORMAL);
							
							if(UIMgr.singleton.funcOnClickBtn != null)
								UIMgr.singleton.funcOnClickBtn(this);
							
							return true;
						}
					}
					
					return true;
				}
				else
				{
					//Mouse.cursor = MouseCursor.AUTO;
					
					if(state == STATE_MOUSEOVER || state == STATE_MOUSEDOWN) // ctrl.lBtn == UICtrl.KEY_STATE_UP)
					{										
						if(isBtnDown)
						{
							if(ctrl.lBtn == UICtrl.KEY_STATE_UP || ctrl.lBtn == UICtrl.KEY_STATE_NORMAL)
							{
								isBtnDown = false;
								
								chgState(STATE_NORMAL);
								
								//						if(isMouseOutNotify)
								//							onUINotify(this, UIDef.NOTIFY_MOUSEOUT_BTN);						
							}
							else
							{
								chgState(STATE_MOUSEOVER);
								
								UIMgr.singleton.setActiveButton(this);
							}
						}
						else
						{
							chgState(STATE_NORMAL);
							
							//					if(isMouseOutNotify)
							//						onUINotify(this, UIDef.NOTIFY_MOUSEOUT_BTN);					
						}
					}						
				}
			}
			else if(state == STATE_DISABLE)
			{				
				if(isIn(ctrl.mx, ctrl.my) && visible)
				{
					return true;
				}
			}
			return false;
		}
		
		//! 判断是否在控件区域内
		public override function isIn(_x:int, _y:int):Boolean
		{
			if(_x > x && _x < x + lw && _y > y && _y < y + lh)
			{
				if(img != null)
				{
					if(isCheckAphla)
					{
						return ((img.bitmapData.getPixel32(imgRect.left + _x - x, imgRect.top + _y - y) >> 24) & 0xff) > 25;
					}
					else
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		public function setFlashMode(fm:Boolean):void
		{
			if(fm)
			{
				if(tiFlash != null)
					tiFlash.isRelease = true;
				
				tiFlash = TimerMgr.singleton.addTimer(200, onTimerFlash, null);
			}
			else
			{
				if(tiFlash != null)
					tiFlash.isRelease = true;				
			}
		}
		
		public function setGray(_b:Boolean):void
		{
			ronco.base.Base.setGray(this, _b, null);
		}
		
		public function onTimerFlash(ti:TimerInfo):void
		{
			if(state == STATE_NORMAL)
			{
				isflashmod = !isflashmod;
				
				if(isflashmod)
				{
					imgRect.left = (img.bitmapData.width / 4);
					imgRect.right = imgRect.left + img.bitmapData.width / 4;
					imgRect.top = 0;
					imgRect.bottom = img.bitmapData.height;
					
					img.scrollRect = imgRect;
				}
				else
				{
					imgRect.left = (img.bitmapData.width / 4) * 2;
					imgRect.right = imgRect.left + img.bitmapData.width / 4;
					imgRect.top = 0;
					imgRect.bottom = img.bitmapData.height;
					
					img.scrollRect = imgRect;					
				}
			}
		}
		
		public function setHoldFunc(func:Function):void
		{
			funcHold = func;
			
			if(funcHold != null)
			{
				if(tiHold != null)
					tiHold.isRelease = true;
				
				tiHold = TimerMgr.singleton.addTimer(200, onTimerHold, null);
			}
			else
			{
				if(tiHold != null)
					tiHold.isRelease = true;		
			}
		}
		
		public function onTimerHold(ti:TimerInfo):void
		{
			if(state == STATE_MOUSEDOWN)
			{
				if(funcHold != null)
					funcHold(this, getTimer() - timeHold);
			}
		}
		
		
	}
}
