package ronco.ui
{
	import fl.controls.TextInput;
	import fl.managers.FocusManager;
	
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.ui.*;
	
	import ronco.base.*;
	import ronco.ui.richtext.RichTextArea;
	import ronco.ui.tree.Tree;
	
	/**
	 * UIMgr
	 * 
	 * 2011.09.23 调整控制类，使用CtrlMgr统一控制
	 **/ 
	public class UIMgr implements ListenerCtrl
	{
		public static var singleton:UIMgr = new UIMgr;			//! singleton
		
		public var ctrl:UICtrl = new UICtrl;
		public var ctrlOld:UICtrl = new UICtrl;
		public var lstUIMod:Vector.<UIElement> = new Vector.<UIElement>;	//! ui模块列表
		public var lstModal:Vector.<UIElement> = new Vector.<UIElement>;	//! 模态模块列表
		public var topGuide:UIElement;
		
		public var lstEdit:Vector.<EditBase> = new Vector.<EditBase>;	//! 输入栏列表
		public var curEdit:EditBase;										//! 当前激活的输入框
		
		public var curBtn:UIElement;								//! 当前激活的按钮
		
		public var mgrFocus:FocusManager;
		
		public var curImgContainer:ImgContainer;
		
		public var curScrollBarFunc:Function;
		
		/**
		 * 函数定义如下，如果返回true，表示这个消息被拦截了
		 * onOutDownSoon(x:int, y:int):Boolean
		 **/ 
		public var lstOutDownSoon:Vector.<Function> = new Vector.<Function>();
		
		/**
		 * 鼠标是否在UI上
		 **/ 
		public var isMouseOnUI:Boolean = false;
		//public var emptyInput:ronco.ui.TextInput;
		
		public var rectUI:Rectangle = new Rectangle;
		
		/**
		 * 按钮按下的触发函数
		 * 函数定义如下：
		 * onClickBtn(btn:Button):void
		 **/ 
		public var funcOnClickBtn:Function;
		
		/**
		 * 菜单队列
		 **/ 
		public var lstMenu:Vector.<UIElement> = new Vector.<UIElement>;
		
//		/**
//		 * on timer
//		 **/ 
//		public var lstOnIdle:Vector.<UIElement> = new Vector.<UIElement>;
		
		public function UIMgr()
		{
		}
		
		public function init():void
		{
			CtrlMgr.singleton.addListener(this);
			//emptyInput = newElement(UIDef.UI_TEXTINPUT, "__empty", null) as ronco.ui.TextInput;
		}
		
		public function newElement(_type:int, _name:String, _parent:UIElement):UIElement
		{
			switch(_type)
			{
				case UIDef.UI_BUTTON:
				{
					return new Button(_name, _parent);
				}
				case UIDef.UI_MODULE:
				{
					return new UIModule(UIDef.UI_MODULE, _name, _parent);
				}
				case UIDef.UI_IMAGE:
				{
					return new Image(_name, _parent);
				}				
				case UIDef.UI_IMGNUMBER:
				{
					return new ImgNumber(_name, _parent);
				}
				case UIDef.UI_IMGNUMBER2:
				{
					return new ImgNumber2(_name, _parent);
				}		
				case UIDef.UI_IMGNUMBER3:
				{
					return new ImgNumber3(_name, _parent);
				}
				case UIDef.UI_TEXTINPUT:
				{
					return new ronco.ui.TextInput(_name, _parent);
				}
				case UIDef.UI_CHECKBOX:
				{
					return new CheckBox(_name, _parent);
				}
				case UIDef.UI_LABEL:
				{
					return new Label(_name, _parent);
				}
				case UIDef.UI_LABEL2:
				{
					return new Label2(_name, _parent);
				}
				case UIDef.UI_SECTOR:
				{
					return new Sector(_name, _parent);
				}
				case UIDef.UI_TEXTAREA:
				{
					return new TextArea(_name, _parent);
				}
				case UIDef.UI_CARDLIST:
				{
					return new UICardList(_name, _parent);
				}
				case UIDef.UI_STATE_NUM:
				{
					return new Clock(_name, _parent);
				}
				case UIDef.UI_SCROLLLABEL:
				{
					return new ScrollLabel(_name, _parent);
				}
				case UIDef.UI_SCROLLBAR:
				{
					return new ScrollBarNew(_name, _parent);
					//return new ScrollBar(_name, _parent);
				}
				case UIDef.UI_IMAGECHANGE:
				{
					return new ImageChange(_name, _parent);
				}
				case UIDef.UI_MOVIESWF:
				{
					return new MovieClipSWF(_name, _parent);
				}
				case UIDef.UI_DATAGRID:
				{
					return new DataGrid(_name, _parent);
				}
				case UIDef.UI_EMPTY:
				{
					return new UIElement(UIDef.UI_EMPTY, _name, _parent);
				}
				case UIDef.UI_STATEIMG:
				{
					return new StateImg(_name, _parent);
				}
				case UIDef.UI_STATESWF:
				{
					return new StateSWF(_name, _parent);
				}
				case UIDef.UI_DLGMODULE:
				{
					return new UIModule(UIDef.UI_DLGMODULE, _name, _parent);
				}
				case UIDef.UI_SENDCARDLIST:
				{
					return new UISendCardList(_name, _parent);
				}
				case UIDef.UI_SCROLLLABEL2:
				{
					return new ScrollLabel2(_name, _parent);
				}
				case UIDef.UI_SCROLLLABELV:
				{
					return new ScrollLabelV(_name, _parent);
				}
				case UIDef.UI_SENDCARDLIST2:
				{
					return new UISendCardList2(_name, _parent);
				}
				case UIDef.UI_IMGCONTAINER:
				{
					return new ImgContainer(_name, _parent);
				}
				case UIDef.UI_ELECONTAINER:
				{
					return new UIList(_name, _parent);
				}
				case UIDef.UI_MOVEIMAGE:
				{
					return new MoveImage(_name, _parent);
				}
				case UIDef.UI_TREE:
				{
					return new ronco.ui.tree.Tree(_name, _parent);
				}
				case UIDef.UI_TEXTEX:
				{
					return new ronco.ui.TextEx(_name, _parent);
				}	
				case UIDef.UI_CD:
				{
					return new ronco.ui.CD(_name, _parent);
				}	
				case UIDef.UI_CLICKOBJ:
				{
					return new ronco.ui.ClickObj(_name, _parent);
				}
				case UIDef.UI_RICHTEXTAREA:
				{
					return new ronco.ui.richtext.RichTextArea(_name, _parent);
				}		
				case UIDef.UI_HOTSPOT:
				{
					return new Hotspot(_name, _parent);
				}
				case UIDef.UI_COMBOBOX:
				{
					return new ComboBox(_name, _parent);
				}
				case UIDef.UI_MULTEXTINPUT:
				{
					return new MulTextInput(_name, _parent);
				}
				case UIDef.UI_SCROLLBAR_RTA:
				{
					return new ScrollBar_RTA(_name, _parent);
				}		
				case UIDef.UI_GIF:
				{
					return new GIF(_name, _parent);
				}
				case UIDef.UI_COMBOBOXEX:
				{
					return new ComboBoxEx(_name, _parent);
				}	
				case UIDef.UI_MENU:
				{
					return new Menu(_name, _parent);
				}
				case UIDef.UI_TABTEXT:
				{
					return new TabText(_name, _parent);
				}					
				case UIDef.UI_LABEL3:
				{
					return new Label3(_name, _parent);
				}					
			}
			
			return null;
		}
		
		public function setActiveButton(btn:UIElement):void
		{
			var b:Button;
			
			if(curBtn != null && curBtn != btn)
			{
				b = curBtn as Button;
				if(b != null && b.state != Button.STATE_DISABLE)
				{
					b.chgState(Button.STATE_NORMAL);
				}
			}
			
			curBtn = btn;
			
//			b = curBtn as Button;
//			if(b != null)
//			{
//				b.chgState(Button.STATE_MOUSEOVER);
//			}
		}
		
		public function addEdit(edit:EditBase):void
		{
			for(var i:int = 0; i < lstEdit.length; ++i)
			{
				if(lstEdit[i] == edit)
					return ;
			}
			
			lstEdit.push(edit);
			
			//(edit as ronco.ui.TextInput).input.focusManager.activate();
		}
		
		public function removeEdit(edit:EditBase):void
		{
			for(var i:int = 0; i < lstEdit.length; ++i)
			{
				if(lstEdit[i] == edit)
				{
					//(edit as ronco.ui.TextInput).input.focusManager.deactivate();
					
					lstEdit.splice(i, 1);
					
					return ;
				}
//				else
//					++i;
			}
		}
		
		public function setActiveEdit(edit:EditBase):void
		{
			for(var i:int = 0; i < lstEdit.length; ++i)
			{
				if(lstEdit[i] == edit)
				{
					curEdit = edit;
				}
			}
		}
		
		//! 判断输入框是否被激活
		public function isEditActive():Boolean
		{
			if(mgrFocus != null && curEdit != null)
			{
				return curEdit.isActive(mgrFocus);
				
				//for(var i:int = 0; i < lstEdit.length; ++i)
//				{
//					var e:ronco.ui.TextInput = (curEdit as ronco.ui.TextInput);
//					if(e != null)
//					{
//						if(e.input == mgrFocus.getFocus())
//							return true;
//					}
//				}				
			}
			
			return false;
		}
		
		public function clearCurActiveEdit(edit:EditBase):void
		{
			for(var i:int = 0; i < lstEdit.length; ++i)
			{
				if(lstEdit[i] == edit)
				{
					curEdit = null;
				}
			}
		}
		
		public function clearActiveEdit():void
		{
			curEdit = null;
			
			if(mgrFocus != null)
			{
				mgrFocus.setFocus(null);
			}
		}
		
		public function addUIMod(ele:UIElement):void
		{
			if(ele.eleType != UIDef.UI_DLGMODULE && ele.eleType != UIDef.UI_MENU)
				return ;
			
			if(ele.eleType == UIDef.UI_MENU)
			{
				lstMenu.push(ele);
				
				return ;
			}
			
			var i:int;
			for(i = 0; i < lstUIMod.length; ++i)
			{
				if(ele == lstUIMod[i])
					return ;
			}
			
			lstUIMod.push(ele);
		}
		
		public function removeUIMod(ele:UIElement):void
		{	
			var i:int;
			
			if(ele.eleType == UIDef.UI_MENU)
			{
				for(i = 0; i < lstMenu.length; ++i)
				{
					if(ele == lstMenu[i])
					{
						lstMenu.splice(i, 1);
						
						break;
					}
				}				
				//lstMenu.push(ele);
				
				return ;
			}
			
			for(i = 0; i < lstUIMod.length; ++i)
			{
				if(ele == lstUIMod[i])
				{
					lstUIMod.splice(i, 1);
					
					break;
				}
			}
		}		
		
		//! 设置为模态模块
		public function addModalMod(ele:UIElement):void
		{
			if(ele.eleType != UIDef.UI_DLGMODULE && ele.eleType != UIDef.UI_MENU && ele.eleType != UIDef.UI_MODULE)
				return ;
			
			//! 首先查找是否队列中存在
			//! 如果存在，且是最顶，则退出，否则，则删除添加
			var i:int;
			for(i = 0; i < lstModal.length; ++i)
			{
				if(ele == lstModal[i])
				{
					if(i == lstModal.length - 1)
						return ;
					
					lstModal.splice(i, 1);
					
					lstModal.push(ele);
					
					return ;
				}
			}
			
			//! 如果没有，则添加
			lstModal.push(ele);
			
			setActive(ele);
		}
		
		public function removeModalMod(ele:UIElement):void
		{
			var i:int;
			for(i = 0; i < lstModal.length; ++i)
			{
				if(ele == lstModal[i])
				{	
					lstModal.splice(i, 1);
					
					return ;
				}
			}			
		}
		
		public function _procModalDlg(ele:UIElement):void
		{
			var i:int = 0;
			var len:int = lstModal.length;
			
			while(i < len)
			{
				if(lstModal[i] == ele)
					return ;
				
				++i;
			}
			
			i = 0;
			
			while(i < len)
			{
				if(lstModal[i] != null && lstModal[i] != ele && lstModal[i].parent == ele.parent)
					lstModal[i].parent.setChildIndex(lstModal[i], lstModal[i].parent.numChildren - 1);
				
				++i;
			}
		}
		
		/**
		 * 设置活动模块
		 **/ 
		public function setActive(ele:UIElement):void
		{
			var i:int;
			for(i = 0; i < lstUIMod.length; ++i)
			{
				if(ele == lstUIMod[i])
				{
					if(i == lstUIMod.length - 1)
					{
						_procModalDlg(ele);
						
						return ;
					}
					
					lstUIMod.splice(i, 1);
					
					break;
				}
			}
			
			if(ele.parent != null)
				ele.parent.setChildIndex(ele, ele.parent.numChildren - 1);
			
			lstUIMod.push(ele);
			
			_procModalDlg(ele);
		}
		
		/**
		 * 移除活动模块
		 **/ 
		public function removeActive(ele:UIElement):void
		{
			var i:int;
			for(i = 0; i < lstUIMod.length; ++i)
			{
				if(ele == lstUIMod[i])
				{
					if(i == lstUIMod.length - 1)
						return ;
					
					lstUIMod.splice(i, 1);
					
					break;
				}
			}
			
			if(ele.parent != null)
				ele.parent.setChildIndex(ele, 0);
			
			lstUIMod.splice(0, 0, ele);			
		}
		
		public function onMouseOver(e:MouseEvent):Boolean
		{
			isMouseOnUI = false;
			
			ctrl.mx = CtrlMgr.singleton.mx;
			ctrl.my = CtrlMgr.singleton.my;
			
			ctrlOld.stagex = ctrl.stagex;
			ctrlOld.stagey = ctrl.stagey;
			ctrlOld.mx = ctrl.mx;
			ctrlOld.my = ctrl.my;
			ctrlOld.lBtnDown = ctrl.lBtnDown;
			
			ctrl.stagex = e.stageX;
			ctrl.stagey = e.stageY;
			ctrl.lBtnDown = e.buttonDown;
			
			ctrl.lBtn = ctrl.lBtnDown ? UICtrl.KEY_STATE_DOWN : UICtrl.KEY_STATE_NORMAL;
			
			isMouseOnUI = onCtrl(ctrl);
			
			return isMouseOnUI;
		}
		
		public function onMouseOut(e:MouseEvent):Boolean
		{
			isMouseOnUI = false;
			
			return false;
			
			////MainLog.singleton.output("out");
			ctrl.mx = CtrlMgr.singleton.mx;
			ctrl.my = CtrlMgr.singleton.my;
			
			ctrlOld.mx = ctrl.mx;
			ctrlOld.my = ctrl.my;
			ctrlOld.lBtnDown = ctrl.lBtnDown;
			
			ctrl.lBtnDown = false;
			
			ctrl.lBtn = UICtrl.KEY_STATE_NORMAL;
			
			return onCtrl(ctrl, e.stageX, e.stageY);	
			
//			var i:int;
//			
//			if(lstModal.length > 0)
//			{
//				i = lstModal.length - 1;
//				
//				ctrl.mx = e.stageX;
//				ctrl.my = e.stageY;
//				
//				ctrl.lBtn = UICtrl.KEY_STATE_NORMAL;
//				
//				lstModal[i].onCtrl(ctrl);
//				
//				return true;
//			}
//			
//			for(i = lstUIMod.length - 1; i >= 0; --i)
//			{
//				if(lstUIMod[i].enable)
//				{
//					ctrl.mx = e.stageX;// - lstUIMod[i].x;
//					ctrl.my = e.stageY;// - lstUIMod[i].y;
//					
//					ctrl.lBtn = UICtrl.KEY_STATE_NORMAL;
//					
//					if(lstUIMod[i].onCtrl(ctrl))
//						return true;
//				}
//			}			
//			
//			return false;
		}
		
		public function onMouseDown(e:MouseEvent):Boolean
		{
			isMouseOnUI = false;
			
			ctrl.mx = CtrlMgr.singleton.mx;
			ctrl.my = CtrlMgr.singleton.my;
			
			ctrlOld.stagex = ctrl.stagex;
			ctrlOld.stagey = ctrl.stagey;
			ctrlOld.mx = ctrl.mx;
			ctrlOld.my = ctrl.my;
			ctrlOld.lBtnDown = ctrl.lBtnDown;
			
			ctrl.stagex = e.stageX;
			ctrl.stagey = e.stageY;
			ctrl.lBtnDown = true;
			
			ctrl.lBtn = UICtrl.KEY_STATE_DOWN_SOON;
			
			isMouseOnUI = onCtrl(ctrl);
			
			return isMouseOnUI;
		}
		
		public function onMouseWheel(e:MouseEvent):Boolean
		{
			isMouseOnUI = false;
			
			ctrl.mx = CtrlMgr.singleton.mx;
			ctrl.my = CtrlMgr.singleton.my;
			ctrl.delta = CtrlMgr.singleton.delta;
			
			ctrlOld.stagex = ctrl.stagex;
			ctrlOld.stagey = ctrl.stagey;
			ctrlOld.mx = ctrl.mx;
			ctrlOld.my = ctrl.my;
			ctrlOld.lBtnDown = ctrl.lBtnDown;
			
			ctrl.stagex = e.stageX;
			ctrl.stagey = e.stageY;
			ctrl.lBtnDown = true;
			
			ctrl.lBtn = ctrl.lBtnDown ? UICtrl.KEY_STATE_DOWN : UICtrl.KEY_STATE_NORMAL;
			
			isMouseOnUI = onCtrl(ctrl);
			
			return isMouseOnUI;
		}
	
		public function onDoubleClick(e:MouseEvent):Boolean
		{
			isMouseOnUI = false;
			
			ctrl.mx = CtrlMgr.singleton.mx;
			ctrl.my = CtrlMgr.singleton.my;
			
			ctrlOld.stagex = ctrl.stagex;
			ctrlOld.stagey = ctrl.stagey;
			ctrlOld.mx = ctrl.mx;
			ctrlOld.my = ctrl.my;
			ctrlOld.lBtnDown = ctrl.lBtnDown;
			
			ctrl.stagex = e.stageX;
			ctrl.stagey = e.stageY;
			ctrl.lBtnDown = true;
			
			ctrl.lBtn = UICtrl.KEY_STATE_DOUBLECLICK;
			
			isMouseOnUI = onCtrl(ctrl);
			
			return isMouseOnUI;
		}
		
		public function onMouseUp(e:MouseEvent):Boolean
		{
			isMouseOnUI = false;
			
			ctrl.mx = CtrlMgr.singleton.mx;
			ctrl.my = CtrlMgr.singleton.my;
			
			ctrlOld.stagex = ctrl.stagex;
			ctrlOld.stagey = ctrl.stagey;
			ctrlOld.mx = ctrl.mx;
			ctrlOld.my = ctrl.my;
			ctrlOld.lBtnDown = ctrl.lBtnDown;
			
			ctrl.stagex = e.stageX;
			ctrl.stagey = e.stageY;
			ctrl.lBtnDown = false;
			
			ctrl.lBtn = UICtrl.KEY_STATE_UP;
			
			isMouseOnUI = onCtrl(ctrl);
			
			return isMouseOnUI;
		}
		
		public function onKeyDown(e:KeyboardEvent):Boolean
		{
			var i:int;
			
			if(lstModal.length > 0)
			{
				i = lstModal.length - 1;
				
				lstModal[i].onKey(e.keyCode);
				
				return true;
			}
			
			for(i = lstUIMod.length - 1; i >= 0; --i)
			{
				if(lstUIMod[i].enable)
				{
					
					if(lstUIMod[i].onKey(e.keyCode))
						return true;
				}
			}
			
			return false;
		}
		
//		/**
//		 * 某些控件需要每帧处理
//		 **/ 
//		public function onIdle():void
//		{
//			
//		}
		
		public function onCtrl(ctrl:UICtrl):Boolean
		{	
			Mouse.cursor = MouseCursor.AUTO;
			
			if(topGuide != null && topGuide.visible)
			{
				if(topGuide.onCtrl(ctrl))
					return true;
			}
			
			if(curImgContainer != null )
			{
				curImgContainer.onCtrl(ctrl);
			}
			
			if(curScrollBarFunc != null && CtrlMgr.singleton.delta)
			{
				curScrollBarFunc(ctrl);
			}
			
			var i:int;
			var len:int;
			
			if(lstMenu.length > 0)
			{
				for(i = lstMenu.length - 1; i >= 0; --i)
				{
					if(lstMenu[i].enable)
					{
						ctrl.mx = ctrl.stagex;
						ctrl.my = ctrl.stagey;
						
						if(lstMenu[i].onCtrl(ctrl))
						{
							isMouseOnUI = true;
							
							if(curImgContainer != null)
								curImgContainer.onCtrlEnd();
							
							return true;
						}
					}
				}
			}
			
			
			if(lstModal.length > 0)
			{
				i = lstModal.length - 1;
				
				ctrl.mx = ctrl.stagex;
				ctrl.my = ctrl.stagey;
				
				if(lstModal[i].onCtrl(ctrl))
					isMouseOnUI = true;
				
				if(curImgContainer != null)
					curImgContainer.onCtrlEnd();
				
				return true;
			}
			
			for(i = lstUIMod.length - 1; i >= 0; --i)
			{
				if(lstUIMod[i].enable)
				{
					ctrl.mx = ctrl.stagex;
					ctrl.my = ctrl.stagey;
					
					if(lstUIMod[i].onCtrl(ctrl))
					{
						isMouseOnUI = true;
						
						if(curImgContainer != null)
							curImgContainer.onCtrlEnd();
						
						return true;
					}
				}
			}
			
			if(curImgContainer != null)
				curImgContainer.onCtrlEnd();
			else
			{
				if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON)
				{
					len = lstOutDownSoon.length;
					for(i = 0; i < len; ++i)
					{
						if(lstOutDownSoon[i](ctrl.mx, ctrl.my))
							return true;
					}
				}
			}
			
			return false;
		}
		
		/**
		 * 添加一个回调函数，在所有UI界面外面按下鼠标时调用，一个函数对象仅可能被添加一次
		 * 函数定义如下，如果返回true，表示这个消息被拦截了
		 * onOutDownSoon(x:int, y:int):Boolean 
		 **/
		public function addOutDownSoon(func:Function):void
		{
			var i:int;
			var len:int = lstOutDownSoon.length;
			for(i = 0; i < len; ++i)
			{
				if(lstOutDownSoon[i] == func)
					break;
			}
			
			lstOutDownSoon.push(func);
		}		

		/**
		 * 删除一个回调函数，在所有UI界面外面按下鼠标时调用
		 * 函数定义如下，如果返回true，表示这个消息被拦截了
		 * onOutDownSoon(x:int, y:int):Boolean 
		 **/		
		public function removeOutDownSoon(func:Function):void
		{
			var i:int;
			var len:int = lstOutDownSoon.length;
			for(i = 0; i < len; ++i)
			{
				if(lstOutDownSoon[i] == func)
				{
					lstOutDownSoon.splice(i, 1);
				}
			}			
		}
		
		/**
		 * 居中对齐对话框
		 **/ 
		public function centerDlg(ele:UIElement):void
		{
			if(ele.eleType == UIDef.UI_DLGMODULE)
			{
				var tw:int = rectUI.right - rectUI.left;
				var th:int = rectUI.bottom - rectUI.top;
				
				ele.x = rectUI.left + (tw - ele.lw) / 2;
				ele.y = rectUI.top + (th - ele.lh) / 2;
			}
		}
		
		/**
		 * 保证对话框在屏幕内
		 **/  
		public function forceInScreen(ele:UIElement, ele1:UIElement = null):void
		{
			if(ele.eleType == UIDef.UI_DLGMODULE)
			{
				var tx:int = ele.x;
				var ty:int = ele.y;
				
				
				if(ele1 == null)
				{
					if(ele.lw > rectUI.right)
						ele.x = rectUI.left;
					else if(tx < rectUI.left)
						ele.x = rectUI.left;
					else if(tx + ele.lw > rectUI.right)
						ele.x = rectUI.right - ele.lw;
					else
						ele.x = tx;
					
					if(ele.lh > rectUI.bottom)
						ele.y = rectUI.top;						
					else if(ty < rectUI.top)
						ele.y = rectUI.top;
					else if(ty + ele.lh > rectUI.bottom)
						ele.y = rectUI.bottom - ele.lh;
					else
						ele.y = ty;
				}
				else
				{
					if(ele.lw + ele1.lw > rectUI.right)
						ele.x = rectUI.left;
					else if(tx < rectUI.left)
						ele.x = rectUI.left;
					else if(tx + ele.lw + ele1.lw > rectUI.right)
						ele.x = rectUI.right - ele.lw - ele1.lw;
					else
						ele.x = tx;
					
					if(ele.lh > rectUI.bottom)
						ele.y = rectUI.top;						
					else if(ty < rectUI.top)
						ele.y = rectUI.top;
					else if(ty + ele.lh > rectUI.bottom)
						ele.y = rectUI.bottom - ele.lh;
					else
						ele.y = ty;
				}
			}			
		}
		
	}
}
