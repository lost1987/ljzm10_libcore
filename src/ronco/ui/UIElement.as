package ronco.ui
{

	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import mx.containers.Canvas;
	
	import ronco.base.*;
	
	public class UIElement extends Sprite
	{
		public var eleType:int;				//! element type
		//public var eleID:int;					//! element ID
		public var parentEle:UIElement;		//! parent Element
		public var lw:int;						//! 逻辑宽度
		public var lh:int;						//! 逻辑高度
		
		public var enable:Boolean = true;		//! 是否可用
		
		public var canHold:Boolean = false;	//! 是否可以被拖动，默认不可以
		public var isHold:Boolean = false;	//! 如果可以被拖动，表示是否是拖动状态
		public var xHold:int;
		public var yHold:int;
		
		public var visibleTimer:Timer = new Timer(50);
		public var visibleSkip:Number;
		
		public var moveTimer:Timer = new Timer(50);
		public var moveToX:int;
		public var moveToY:int;
		public var killMove:Boolean = false;
		public var moveSpeed:int = 10;
		public var moveRotate:Boolean = false;
		public var moveScale:Number = 1;
		
		/**
		 * 控件属性，外部可以设置这个属性，然后在控件操作时获取
		 **/ 
		public var data:Object;
		/**
		 * 不可拖动的区域
		 **/ 
		public var areaNoHold:Rectangle;

		//! 子Element队列
		public var lstEleChild:Vector.<UIElement> = new Vector.<UIElement>;		
		//! UIListener队列
		public var lstListener:Vector.<UIListener> = new Vector.<UIListener>;
		
		/**
		 * tips函数
		 * 函数定义如下：
		 * onTips(ele:UIElement, isShow:Boolean):void
		 **/ 
		public var funcTips:Function;
		/**
		 * tips显示用的参数
		 **/ 
		public var dataTips:Object;
		
		/**
		 * 不处理操作
		 **/ 
		public var noprocCtrl:Boolean = false;
		
		public var preSendChildMsg:Function = null;
		
//		/**
//		 * 控件计时器接口
//		 * 接口定义如下：
//		 * onTimer(ele:UIElement, param:Object):void
//		 **/ 
//		public var funcOnTimer:Function;
//		public var paramOnTimer:Object;
		
		public function UIElement(_type:int, _name:String, _parent:UIElement)
		{
			eleType = _type;
			name = _name;
			//eleID = _eid;
			parentEle = _parent;
			
			if(parentEle != null)
				parentEle._addEleChild(this);
			
			visibleTimer.addEventListener(TimerEvent.TIMER, onVisibleTimer);
			moveTimer.addEventListener(TimerEvent.TIMER, onMoveTimer);
			
			super();
		}
		
		/**
		 * 释放接口
		 **/ 
		public function releaseEle():void
		{
			if(parentEle != null)
				parentEle._removeEleChild(this);
			
			visibleTimer.stop();
			
			for(var i:int = 0; i < lstEleChild.length; ++i)
			{
				lstEleChild[i].__releaseEle();
			}
			
			var len:int = lstEleChild.length;
			i = 0;
			
			while(i < len)
			{
				lstEleChild.pop();
				
				++i;
			}			
			//lstEleChild.splice(0, lstEleChild.length);
		}
		
		/**
		 * 释放接口，内部用
		 **/ 
		public function __releaseEle():void
		{	
			for(var i:int = 0; i < lstEleChild.length; ++i)
			{
				lstEleChild[i].__releaseEle();
			}
			
			var len:int = lstEleChild.length;
			i = 0;
			
			while(i < len)
			{
				lstEleChild.pop();
				
				++i;
			}			
			//lstEleChild.splice(0, lstEleChild.length);
		}		
		
		public function initEx(_w:int, _h:int):void
		{
			lw = _w;
			lh = _h;			
		}
		
		public function setShow():void
		{
//			if(visible == false)
			{
				alpha = 0;
				visible = true;
			}
			visibleSkip = 0.1;
			visibleTimer.start();
		}
		
		public function setHide():void
		{
			visibleSkip = -0.1;
			visibleTimer.start();
		}
		
		private function onVisibleTimer(e:TimerEvent):void
		{
			if(visibleSkip > 0 && alpha >= 1)
			{
				visibleTimer.stop();
				alpha = 1;
			}
			else if(visibleSkip < 0 && alpha <= 0)
			{
				visibleTimer.stop();
				alpha = 0;
				visible = false;
			}
			else
			{
				alpha += visibleSkip;
			}
		}
		
		//! 添加监听
		public function addListener(listener:UIListener):void
		{
			lstListener.push(listener);
		}
		
		//! 删除监听
		public function removeListener(listener:UIListener):void
		{
			var i:int = lstListener.indexOf(listener);
			if(i >= 0)
				lstListener.splice(i, 1);
		}		
		
		//! 判断是否在控件区域内
		public function isIn(_x:int, _y:int):Boolean
		{
			return _x > x && _x < x + lw && _y > y && _y < y + lh;
		}
		
		//! 处理操作，如果返回true，表示截获操作，不继续交给后面的控件处理，否则会交给后面的控件处理
		public function onCtrl(ctrl:UICtrl):Boolean
		{
			//MainLog.log.output("on ctrl " + ctrl.mx + " " + ctrl.my);
			
//			if(eleType == UIDef.UI_EMPTY)
//			{
//				//MainLog.singleton.output("on ctrl " + ctrl.mx + " " + ctrl.my);
//			}
			
			if(!visible)
				return false;
			
			if(!enable)
				return false;
			
			if(noprocCtrl)
				return false;
			
			ctrl.mx -= x;
			ctrl.my -= y;
			
			if(scrollRect != null)
			{
				ctrl.mx += scrollRect.left;
				ctrl.my += scrollRect.top;
				
				if(ctrl.mx < scrollRect.left || ctrl.my < scrollRect.top || ctrl.mx > scrollRect.right || ctrl.my > scrollRect.bottom)
				{
					ctrl.mx += x;
					ctrl.my += y;
					
					ctrl.mx -= scrollRect.left;
					ctrl.my -= scrollRect.top;
					
					return false;
				}
			}
			
			if(preSendChildMsg != null)
			{
				preSendChildMsg(ctrl);
			}
			
			for(var i:int = 0; i < lstEleChild.length; ++i)
			{
				if(lstEleChild[lstEleChild.length - i - 1].visible)
				{
					if(lstEleChild[lstEleChild.length - i - 1].lstListener.length <= 0 &&
							lstEleChild[lstEleChild.length - i - 1].eleType != UIDef.UI_MODULE)
						continue;
					
					if(lstEleChild[lstEleChild.length - i - 1].onCtrl(ctrl))
						return true;
				}
			}
			
			ctrl.mx += x;
			ctrl.my += y;			
			
			if(scrollRect != null)
			{
				ctrl.mx -= scrollRect.left;
				ctrl.my -= scrollRect.top;
			}
			
//			if(canHold)
//				return _procHold(ctrl);
			
//			if(isIn(ctrl.mx, ctrl.my))
//				return true;
			
			return false;
		}
		
		public function onKey(keyCode:int):Boolean
		{
			for(var i:int = 0; i < lstEleChild.length; ++i)
			{
				if(lstEleChild[lstEleChild.length - i - 1].visible &&
					lstEleChild[lstEleChild.length - i - 1].enable &&
					lstEleChild[lstEleChild.length - i - 1].lstListener.length > 0 && 
					lstEleChild[lstEleChild.length - i - 1].onKey(keyCode))
					return true;
			}
			return false;
		}
		
		//! 抛出UI通知消息
		public function procUINotify(ele:UIElement, notify:int):void
		{
			for(var i:int = 0; i < lstListener.length; ++i)
			{
				lstListener[i].onUINotify(ele, notify);
			}			
		}
		
		//! 增加子元素
		//! 一般不会给外部使用
		public function _addEleChild(ele:UIElement):void
		{
			addChild(ele);
			
			lstEleChild.push(ele);
		}
		
		//! 增加子元素
		//! 一般不会给外部使用
		public function _removeEleChild(ele:UIElement):void
		{
			removeChild(ele);
			
			for(var i:int = 0; i < lstEleChild.length; ++i)
			{
				if(lstEleChild[i] == ele)
				{
					lstEleChild.splice(i, 1);
					
					break;
				}
			}
		}		
		
		//! 设置一个子元素置顶
		public function setChild2Top(ele:UIElement):void
		{
			var i:int;
			for(i = 0; i < lstEleChild.length; ++i)
			{
				removeChild(lstEleChild[i]);
			}
			
			for(i = 0; i < lstEleChild.length; ++i)
			{
				if(lstEleChild[i] != ele)
					addChild(lstEleChild[i]);
			}
			
			addChild(ele);
		}
		
		public function findElement(_name:String):UIElement
		{
			if(name == _name)
				return this;
			
			var ele:UIElement;
			
			for(var i:int = 0; i < lstEleChild.length; ++i)
			{
				ele = lstEleChild[i].findElement(_name);
				if(ele != null)
					return ele;
			}
			
			return null;
		}
		
		public function getRealX():int
		{
			var _tmp:int = x;
			var _p:UIElement = parentEle;
			while(_p != null)
			{
				_tmp += _p.x;
				_p = _p.parentEle;
			}
			
			return _tmp;
		}
		
		public function getRealY():int
		{
			var _tmp:int = y;
			
			if(scrollRect != null)
				_tmp -= scrollRect.y;
			var _p:UIElement = parentEle;
			while(_p != null)
			{
				_tmp += _p.y;
				if(_p != null && _p.scrollRect != null)
					_tmp -= _p.scrollRect.y;				
				_p = _p.parentEle;				
			}
			
			return _tmp;
		}		
		
		/**
		 * 设置不可拖动区域
		 **/ 
		public function setNoHoldArea(left:int, top:int, right:int, bottom:int):void
		{
			if(areaNoHold == null)
				areaNoHold = new Rectangle;
			
			areaNoHold.left = left;
			areaNoHold.right = right;
			areaNoHold.top = top;
			areaNoHold.bottom = bottom;
		}
		
		public function _procHold(ctrl:UICtrl):Boolean
		{
			if(isHold)
			{
				if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN || ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON)
				{	
					//! 这里将对话框特殊处理了，防止对话框移出屏幕
					if(eleType == UIDef.UI_DLGMODULE)
					{
						var tx:int = x + ctrl.mx - xHold;
						var ty:int = y + ctrl.my - yHold;
						
						if(lw > UIMgr.singleton.rectUI.right)
							x = UIMgr.singleton.rectUI.left;
						else if(tx < UIMgr.singleton.rectUI.left)
							x = UIMgr.singleton.rectUI.left;
						else if(tx + lw > UIMgr.singleton.rectUI.right)
							x = UIMgr.singleton.rectUI.right - lw;
						else
							x = tx;

						if(lh > UIMgr.singleton.rectUI.bottom)
							y = UIMgr.singleton.rectUI.top;						
						else if(ty < UIMgr.singleton.rectUI.top)
							y = UIMgr.singleton.rectUI.top;
						else if(ty + lh > UIMgr.singleton.rectUI.bottom)
							y = UIMgr.singleton.rectUI.bottom - lh;
						else
							y = ty;
					}
					else
					{
						x += ctrl.mx - xHold;
						y += ctrl.my - yHold;				
					}
					
					xHold = ctrl.mx;
					yHold = ctrl.my;
					
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
		
		public function moveTo(_x:int, _y:int):void
		{
			moveToX = _x;
			moveToY = _y;
			moveTimer.start();
		}
		
		private function onMoveTimer(e:TimerEvent):void
		{
			var len:Number = (x - moveToX) * (x - moveToX) + (y - moveToY) * (y - moveToY);
			moveSpeed += 2;
			
			if(len < moveSpeed * moveSpeed)
			{
				x = moveToX;
				y = moveToY;
				
				moveTimer.stop();
				if(killMove)
				{
					this.releaseEle();
				}
			}
			else
			{
				if(x > moveToX)
					x -= Math.sqrt(moveSpeed * moveSpeed / len * (x - moveToX) * (x - moveToX));
				else
					x += Math.sqrt(moveSpeed * moveSpeed / len * (x - moveToX) * (x - moveToX));
				
				if(y > moveToY)
					y -= Math.sqrt(moveSpeed * moveSpeed / len * (y - moveToY) * (y - moveToY));
				else
					y += Math.sqrt(moveSpeed * moveSpeed / len * (y - moveToY) * (y - moveToY));
				
				if(moveRotate)
				{
//					this.rotationZ += 30;
//					
//					if(this.scaleX < 0.5)
//					{
//						moveScale = 1;
//					}
//					else if(this.scaleX > 1)
//					{
//						moveScale = -1;
//					}
//					this.scaleX += 0.05 * moveScale;
//					this.scaleY += 0.05 * moveScale;
					
					if(Math.abs(y - moveToY) < 200)
					{
//						if(x > moveToX)
//							x += Math.sqrt(moveSpeed * moveSpeed / len * (x - moveToX) * (x - moveToX)) * 1.5;
//						else
//							x -= Math.sqrt(moveSpeed * moveSpeed / len * (x - moveToX) * (x - moveToX)) * 1.5;
//						
//						if(y > moveToY)
//							y += Math.sqrt(moveSpeed * moveSpeed / len * (y - moveToY) * (y - moveToY)) * 0.5;
//						else
//							y -= Math.sqrt(moveSpeed * moveSpeed / len * (y - moveToY) * (y - moveToY)) * 0.5;
						
						this.alpha -= 0.02;
//						this.rotationZ += 30;
					}
				}
			}
			
//			var ok:int = 0;
//			if(x > moveToX)
//			{
//				if(x - moveToX > 10)
//				{
//					x -= 10;
//				}
//				else
//				{
//					x = moveToX;
//					ok += 1;
//				}
//			}
//			else if(x < moveToX)
//			{
//				if(moveToX - x > 10)
//				{
//					x += 10;
//				}
//				else
//				{
//					x = moveToX;
//				}
//			}
//			else
//			{
//				ok += 1;
//			}
//			
//			if(y > moveToY)
//			{
//				if(y - moveToY > 10)
//				{
//					y -= 10;
//				}
//				else
//				{
//					y = moveToY;
//					ok += 1;
//				}
//			}
//			else if(y < moveToY)
//			{
//				if(moveToY - y > 10)
//				{
//					y += 10;
//				}
//				else
//				{
//					y = moveToY;
//				}
//			}
//			else
//			{
//				ok += 1;
//			}
//			
//			if(ok == 2)
//			{
//				moveTimer.stop();
//				if(killMove)
//				{
//					this.releaseEle();
//				}
//			}
		}
		
//		public function onIdle():void
//		{
//		}
		
	}
}