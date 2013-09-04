package ronco.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
		
	import ronco.base.*;
	import ronco.qp_core.*;
	import ronco.base.MainLog;
	
	public class UICardList extends UIElement implements UICardListListener
	{	
		public static const DQ_TYPE_LEFT:int		=	0;		//! 左对齐
		public static const DQ_TYPE_RIGHT	:int	=	1;		//! 右对齐
		public static const DQ_TYPE_CENTER:int	=	2;		//! 中心对齐
		
		public var cardListData:CardList;
		
		private var card_bitmap:Bitmap;		//! 牌的图片
		private var offWidth:int;				//! 牌间距
		private var offHeight:int;				//! 牌点起高度
		private var cardWidth:int;				//! 牌的宽度（资源决定）
		private var cardHeight:int;			//! 牌的高度（资源决定）
		
		public var DQType:int = 0;				//! 对齐方式
		
		public var key_X:int	=	0;			//! 关键点横坐标
		public var key_Y:int	=	0;			//! 关键点纵坐标
		
		public var bUpright:Boolean = false;	//! 是否竖着
		public var bClick:Boolean = false;	//! 是否可以点击
		
		private var poolName:String;			//! 池的名字
		
		private var _Click_X:int	=	0;		//! 鼠标点击的X坐标
		private var _Click_Y:int	=	0;		//! 鼠标点击的y坐标
		private var _Click_Index:int = -1;		//! 鼠标点击的牌在序列中的ID
		
		private var left:int = 0;				//! 牌所在的矩形
		private var top:int = 0;
		private var right:int = 0;
		private var bottom:int = 0;
		
		public var bReadyDown:Boolean = false;
		public var downX:int = 0;				//! 鼠标点下的横坐标
		public var downY:int = 0;				//!	鼠标点下的纵坐标
		
		private var showNums:int = -1;			//! 显示的牌的数量
		
		public function UICardList(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_CARDLIST, _name, _parent);
			
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		//! 初始化 res资源， pool池索引， off间距， up站起高度， dqtype对齐方式， keyx关键横坐标， keyy关键纵坐标
		//! bup是否竖着画牌， bcontrol是否能控制
		public function init(res:Class, pool:String, off:int, up:int, dqtype:int, keyx:int, keyy:int, bup:Boolean, bcontrol:Boolean):void
		{
			card_bitmap = new res as Bitmap;
			cardWidth = card_bitmap.width / 15;
			cardHeight = card_bitmap.height / 4;
			offWidth = off;
			offHeight = up;
			DQType = dqtype;
			key_X = keyx;
			key_Y = keyy;
			bUpright = bup;
			poolName = pool;
			cardListData = new CardList(poolName);
			bClick = bcontrol;
			
//			var a1:TestSprite = new TestSprite();
//			addChild(a1)
		}
		//! 清空
		public function clean():void
		{
			for(var i:int = 0; i < cardListData.lst.length; ++i)
			{
				removeChild(cardListData.lst[i]);
			}
		}
		
		private function GetCardNum(_x:int, _y:int):int
		{
//			//MainLog.singleton.output("aaaaaaaa");
//			//MainLog.singleton.output("鼠标点击X = " + _x + 
//				"   鼠标点击Y = " + _y + 
//				"   牌序列LEFT = " + left + 
//				"   牌序列TOP = " + top + 
//				"   牌序列stageY = " + this.stage.y);
			if(_y > top)
			{
				////MainLog.singleton.output("点在牌内");
				if(bUpright)
				{
					return (_y - top)/offWidth;
				}
				else
				{
					return (_x - left)/offWidth;
				}				
			}
			else
			{
				////MainLog.singleton.output("点在牌外");
				if(bUpright)
				{
					return (_y - top)/offWidth;
				}
				else
				{
					//var begin = left + this.getWidth() - cardWidth;
					//_x - begin / offWidth
					var i:int = 0;
					var len:int = cardListData.lst.length - 1;

					for(i = len; i >= 0; i--)
					{
						if(_x > left + getWidth() - cardWidth - (len - i)*offWidth
						 && _x< left + getWidth() - (len - i)*offWidth)
						{
							if(cardListData.lst[i].isClick)
							{
							//	//MainLog.singleton.output("返回第 " + i + "张");
								return i;
							}
						}
					}
					return (_x - left)/offWidth;
				}	
			}

		}
		
//		//! 判断牌是否在举行区域内
//		public function isCardIn(index:int, bx:int, by:int, ex:int, ey:int):Boolean
//		{	
//			if(ey < top - offHeight || by > bottom)
//				return false;
//			
//			if(index >= 0 && index < cardListData.lst.length)
//			{
//				var cx:int = index * offWidth + left;
//				
//				if(bx > cx + cardWidth || ex < cx)
//					return false;
//				
//				if(!cardListData.lst[index].isClick)
//				{
//					if(ey < top || by > bottom)
//						return false;
//				}
//				
//				return true;
//			}
//			
//			return false;
//		}
//		
//		//! 处理操作，如果返回true，表示截获操作，不继续交给后面的控件处理，否则会交给后面的控件处理
//		public override function onCtrl(ctrl:UICtrl):Boolean
//		{
//			return false;
//			
//			var i:int;
//			var bx:int;
//			var by:int;
//			var ex:int;
//			var ey:int;
//			var tmp:int;
//			
//			if(!visible)
//				return false;
//			
//			if(!bClick)
//				return false;
//			
//			if(isIn(ctrl.mx, ctrl.my))
//			{	
//				if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON || ctrl.lBtn == UICtrl.KEY_STATE_DOWN)
//				{	 
//					//! 判断是否点在抬起区域，然后细节判断选中哪张牌
//					if(ctrl.my >= top - offHeight && ctrl.my < top)
//					{	
//						for(i = cardListData.lst.length - 1; i >= 0; --i)
//						{
//							if(cardListData.lst[i].isClick)
//							{
//								bx = i * offWidth;
//								
//								if(ctrl.mx >= bx && ctrl.mx < bx + cardWidth)
//								{
//									_Click_X = ctrl.mx;
//									_Click_Y = ctrl.my;
//									_Click_Index = i;
//								}
//							}
//						}
//					}
//					else
//					{
//						_Click_X = ctrl.mx;
//						_Click_Y = ctrl.my;						
//						_Click_Index = GetCardNum(ctrl.mx, ctrl.my);
//						if(_Click_Index >= cardListData.lst.length)
//							_Click_Index = cardListData.lst.length - 1;						
//					}
//					
//					return true;					
//				}
//				else if(ctrl.lBtn == UICtrl.KEY_STATE_UP)
//				{
//					var index:int = 0;
//					var big:int = 0;
//					var small:int = 0;
//					//var i:int = 0;
//					if(_Click_Index != -1)
//					{
//						index = GetCardNum(ctrl.mx, ctrl.my);
//						if(index >= cardListData.lst.length)
//							index = cardListData.lst.length - 1;
//						if(index > _Click_Index)
//						{
//							big = index;
//							small = _Click_Index;
//						}
//						else
//						{
//							big = _Click_Index;
//							small = index;
//						}
//						for(i = 0; i < cardListData.lst.length; ++i)
//						{
//							if(i >= small && i <= big)
//							{
//								cardListData.lst[i].setBackVisible(false);
//								cardListData.lst[i].isClick = !cardListData.lst[i].isClick;
//							}
//						}
//						_Click_Index = -1;
//						_Click_X = 0;
//						_Click_Y = 0;
//						update();
//					}
//					
//					return true;
//				}
//			}
//			
//			if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN)
//			{	
//				if(!bReadyDown)
//				{
//					bReadyDown = true;
//					
//					downX = ctrl.mx;
//					downY = ctrl.my;
//					
//					//MainLog.singleton.output("cardlist " + downX + " " + downY);
//				}
//				else
//				{
//					bx = downX;
//					by = downY;
//					ex = ctrl.mx;
//					ey = ctrl.my;
//					
//					if(bx > ex)
//						tmp = bx, bx = ex, ex = tmp;
//					if(by > ey)
//						tmp = by, by = ey, ey = tmp;			
//					
//					//MainLog.singleton.output("cardlist " + bx + " " + by + " " + ex + " " + ey);
//					
//					for(i = 0; i < cardListData.lst.length; ++i)
//					{
//						if(isCardIn(i, bx, by, ex, ey))
//							cardListData.lst[i].setBackVisible(true);
//						else
//							cardListData.lst[i].setBackVisible(false);
//					}
//					
//					update();									
//				}
//				
//				return false;
//			}
//			else if(ctrl.lBtn == UICtrl.KEY_STATE_UP)
//			{
//				bReadyDown = false;
//				
//				bx = downX;
//				by = downY;
//				ex = ctrl.mx;
//				ey = ctrl.my;
//				
//				if(bx > ex)
//					tmp = bx, bx = ex, ex = tmp;
//				if(by > ey)
//					tmp = by, by = ey, ey = tmp;			
//				
//				//MainLog.singleton.output("cardlist " + bx + " " + by + " " + ex + " " + ey);
//				
//				for(i = 0; i < cardListData.lst.length; ++i)
//				{
//					if(isCardIn(i, bx, by, ex, ey))
//						cardListData.lst[i].isClick = !cardListData.lst[i].isClick;
//				}
//				
//				_Click_Index = -1;
//				_Click_X = 0;
//				_Click_Y = 0;
//				update();				
//				
//				return false;
//			}			
//			
//			return false;
//		}
//		
//		//! 判断是否在控件区域内
//		public override function isIn(_x:int, _y:int):Boolean
//		{
//			if(bClick)
//			{
//				if(_x > left && _x < right && _y > top - offHeight && _y < bottom)
//					return true;
//			}
//			else
//			{
//				if(_x > left && _x < right && _y > top && _y < bottom)
//					return true;
//			}
//			
//			return false;
//		}		
		// 鼠标进入
		public function onMouseOver(e:MouseEvent):void
		{
			var index:int = 0;
			var big:int = 0;
			var small:int = 0;
			var i:int = 0;
			if(_Click_Index != -1 && e.buttonDown)
			{
				index = GetCardNum(e.stageX, e.stageY);
				if(index > _Click_Index)
				{
					big = index;
					small = _Click_Index;
				}
				else
				{
					big = _Click_Index;
					small = index;
				}
				for(i = 0; i < cardListData.lst.length; ++i)
					cardListData.lst[i].setBackVisible(false);
				for(i = 0; i < cardListData.lst.length; ++i)
				{
					if(i >= small && i <= big)
						cardListData.lst[i].setBackVisible(true);
				}
				update();
			}
		}
		// 鼠标点击
		public function onMouseDown(e:MouseEvent):void
		{
			if(bClick)
			{
				_Click_X = e.stageX;
				_Click_Y = e.stageY;
				_Click_Index = GetCardNum(e.stageX, e.stageY);
				if(_Click_Index >= cardListData.lst.length)
					_Click_Index = cardListData.lst.length - 1;
			}
		}
		// 鼠标松开
		public function onMouseUp(e:MouseEvent):void
		{
			var index:int = 0;
			var big:int = 0;
			var small:int = 0;
			var i:int = 0;
			if(_Click_Index != -1)
			{
				index = GetCardNum(e.stageX, e.stageY);
				if(index >= cardListData.lst.length)
					index = cardListData.lst.length - 1;
				if(index > _Click_Index)
				{
					big = index;
					small = _Click_Index;
				}
				else
				{
					big = _Click_Index;
					small = index;
				}
				for(i = 0; i < cardListData.lst.length; ++i)
				{
					if(i >= small && i <= big)
					{
						cardListData.lst[i].setBackVisible(false);
						cardListData.lst[i].isClick = !cardListData.lst[i].isClick;
					}
				}
				_Click_Index = -1;
				_Click_X = 0;
				_Click_Y = 0;
				update();
			}
		}
		// 鼠标划出
		public function onMouseOut(e:MouseEvent):void
		{
			var i:int = 0;
			if(_Click_Index != -1)
			{
				if(e.stageX > left && e.stageX < right && e.stageY > (top - offHeight) && e.stageY < bottom)
				{
					
				}
				else
				{
					for(i = 0; i < cardListData.lst.length; ++i)
					{
						cardListData.lst[i].setBackVisible(false);
					}
					_Click_Index = -1;
					_Click_X = 0;
					_Click_Y = 0;					
				}

			}
		}
		// 更新left和top
		public function _updateLeftAndTop():void
		{
			var len:int = cardListData.lst.length;
			switch(DQType)
			{
			case DQ_TYPE_LEFT:
					left = key_X;
					top = key_Y;
				break;
			case DQ_TYPE_RIGHT:
				if(bUpright)
				{
					left = key_X - cardWidth;
					top = key_Y;
				}
				else
				{
					left = key_X - getWidth();
					top = key_Y;
				}
				break;
			case DQ_TYPE_CENTER:
				if(bUpright)
				{
					left = key_X - cardWidth / 2;
					top = key_Y - getWidth()/2;
				}
				else
				{
					left = key_X - getWidth()/2;
					top = key_Y - cardHeight/2;
				}
				break;	
			}
			right = left + getWidth();
			bottom = top + getHeight();
		}
		//! 设置是否能点击
		public function setCanClick(can:Boolean):void
		{
			bClick = can;
			cardListData.setCanClick(can);
		}
		//! 设置显示的牌数
		public function setShowNums(num:int):void
		{
			showNums = num;
		}
		//! 获得显示的牌数
		public function getShowNums():int
		{
			return showNums;
		}
		//! 获得牌序列长度
		public function getWidth():int
		{
			if(bUpright)
				return cardWidth;
			else
				return ((cardListData.lst.length - 1) * offWidth) + cardWidth;
		}
		//! 获得牌序列高度
		public function getHeight():int
		{
			if(bUpright)
				return ((cardListData.lst.length - 1) * offWidth) + cardHeight;
			else
				return cardHeight;
		}
		//! 判断点是否在排序列中
//		public override function isIn(pointX:int, pointY:int):Boolean
//		{
//			var left:int = 0;
//			var top:int = 0;
//			var right:int = 0;
//			var bottom:int = 0;
//			switch(DQType)
//			{
//				case DQ_TYPE_LEFT:
//					left = key_X;
//					top = key_Y;
//					break;
//				case DQ_TYPE_RIGHT:
//					left = key_X - getWidth();
//					top = key_Y;
//					break;
//				case DQ_TYPE_CENTER:
//					left = key_X - getWidth() / 2;
//					top = key_Y - getHeight() / 2;
//					break;
//			}
//			right = left + getWidth();
//			bottom = top + getHeight();
//			if(pointX > left && pointX < right && pointY > top && pointY < bottom)
//			{
//				return true;
//			}
//			else	
//			{
//				var num:int = (pointX - left)/offWidth;
//				if(num < 0 || num >= cardListData.lst.length)
//					return false;
//				if(cardListData.lst[num].isClick)
//				{
//					if(pointX > left && pointX < right && pointY > (top - offHeight) && pointY < bottom)
//					{
//						return true;
//					}
//					else
//					{
//						return false;
//					}
//				}
//				else
//				{
//					return false;
//				}
//			}
//		}
		//! 加一张牌
		public function addCard(card:Card):void
		{
			card.pushInCardList(this);
			
			addChild(card);
			
			cardListData.lst.push(card);
			
			update();		
		}
		//! 加一张牌
		public function addCardEx(point:int, type:int):void
		{
			var c:Card = (ResMgr.singleton.mapRes[poolName] as CardPool).newCard();
			
			c.setCard(point, type);
			c.canClick = bClick;
			c.pushInCardList(this);
			//! 添加数据
			cardListData.addCard(c);
			//! 界面添加
			addChild(c);
			
			update();
		}
		//! 加牌序列
		public function addCardList(_lst:CardList):void
		{
			//cardListData.addCardList(_lst);
			for(var i:int = 0; i < _lst.lst.length; ++i)
				addCard(_lst.lst[i]);
			update();
		}
		//! 减牌
		public function subCard(card:Card):void
		{
			//cardListData.subCard(card);
			for(var i:int = 0; i < cardListData.lst.length; ++i)
				if(card.cardPoint == cardListData.lst[i].cardPoint && card.cardType == cardListData.lst[i].cardType)
				{
					cardListData.subCard(card);
					removeChild(cardListData.lst[i]);
				}
			update();
		}
		//! 减牌
		public function subCardEx(point:int, type:int):void
		{
			for(var i:int = 0; i < cardListData.lst.length; ++i)
				if(point == cardListData.lst[i].cardPoint && type == cardListData.lst[i].cardType)
				{
					cardListData.subCardEx(point, type);
					removeChild(cardListData.lst[i]);
				}
			update();
		}
		//! 减牌序列
		public function subCardList(_lst:CardList):void
		{
			for(var i:int = 0; i < _lst.lst.length; ++i)
			{
				for(var j:int = 0; j < cardListData.lst.length; ++j)
				{
					if(cardListData.lst[j].cardPoint == _lst.lst[i].cardPoint && cardListData.lst[j].cardType == _lst.lst[i].cardType)
						removeChild(cardListData[j]);
				}
			}
			cardListData.subCardList(_lst);
			
			update();
		}
		public function setCardList(_lst:CardList):void
		{
			clean();
			cardListData.clean();
			for(var i:int = 0; i < _lst.lst.length; ++i)
				addCardEx(_lst.lst[i].cardPoint, _lst.lst[i].cardType);
		}
		//! 设置选取的牌
		public function setSelectList(_lst:CardList):void
		{
			AllDown();
			cardListData.setSelectList(_lst);
			update();
		}
		//! 获得 选取牌
		public function getSelectList(_lst:CardList):void
		{
			for(var i:int = 0; i < cardListData.lst.length; ++i)
			{
				if(cardListData.lst[i].isClick)
					_lst.addCard(cardListData.lst[i]);
			}
		}
		//! 所有牌不被选
		public function AllDown():void
		{
			cardListData.AllDown();
			update();
		}
		//! 刷新每个牌的显示位子
		public function update():void
		{
			var i:int = 0;
			var len:int = cardListData.lst.length;
			_updateLeftAndTop();
			switch(DQType)
			{
				case DQ_TYPE_LEFT:
				{
					if(bUpright)
					{
						for(i = 0; i < len; ++i)
						{	
							if(showNums != -1)
							{
								if(i < showNums)
									cardListData.lst[i].visible = true;
								else
									cardListData.lst[i].visible = false;
							}
							else
							{
								cardListData.lst[i].visible = true;
							}
							cardListData.lst[i].setXY(key_X, key_Y + (i * offHeight));
						}	
					}
					else
					{
						for(i = 0; i < len; ++i)
						{
							if(showNums != -1)
							{
								if(i < showNums)
									cardListData.lst[i].visible = true;
								else
									cardListData.lst[i].visible = false;
							}
							else
							{
								cardListData.lst[i].visible = true;
							}
							if(cardListData.lst[i].isClick)
							{
								cardListData.lst[i].setXY(key_X + (i * offWidth), key_Y - offHeight);
							}
							else
							{
								cardListData.lst[i].setXY(key_X + (i * offWidth), key_Y);
							}
						}
					}

					break;
				}
				case DQ_TYPE_RIGHT:
				{
					if(bUpright)
					{
						for(i = 0; i < len; i++)
						{
							if(showNums != -1)
							{
								if(i < showNums)
									cardListData.lst[i].visible = true;
								else
									cardListData.lst[i].visible = false;
							}
							else
							{
								cardListData.lst[i].visible = true;
							}
							cardListData.lst[i].setXY(key_X - cardWidth, key_Y + (i * offHeight));
						}	
					}
					else
					{
						for(i = len - 1; i >= 0; i--)
						{
							if(showNums != -1)
							{
								if(i < showNums)
									cardListData.lst[i].visible = true;
								else
									cardListData.lst[i].visible = false;
							}
							else
							{
								cardListData.lst[i].visible = true;
							}
							if(cardListData.lst[i].isClick)
							{
								cardListData.lst[i].setXY(key_X - cardWidth - (len - 1 - i)*offWidth, key_Y - offHeight);
							}
							else
							{
								cardListData.lst[i].setXY(key_X - cardWidth - (len - 1 - i)*offWidth, key_Y);
							}
						}						
					}

					break;
				}
				case DQ_TYPE_CENTER:
				{
					if(bUpright)
					{
						var allHeight:int = cardHeight + (len - 1)*offHeight;
						var _y:int = key_Y - allHeight/2;
						var _x:int = key_X - cardWidth / 2;
						for(i = 0; i < len; ++i)
						{
							cardListData.lst[i].setXY(_x, _y + (i * offHeight));
						}
					}
					else
					{
						//var allWidth:int = cardWidth + (len - 1)*offWidth;
						var allWidth:int = 0;
						if(showNums != -1)
							allWidth = cardWidth + (showNums - 1)*offWidth;
						else
							allWidth = cardWidth + (len - 1)*offWidth;
						var _x1:int = key_X - allWidth/2;
						var _y1:int = key_Y - cardHeight / 2;
						
						for(i = 0; i < len; ++i)
						{
							if(showNums != -1)
							{
								if(i < showNums)
									cardListData.lst[i].visible = true;
								else
									cardListData.lst[i].visible = false;
							}
							else
							{
								cardListData.lst[i].visible = true;
							}
							
							if(cardListData.lst[i].isClick)
							{
								cardListData.lst[i].setXY(_x1 + (i * offWidth), _y1 - offHeight);
							}
							else
							{
								cardListData.lst[i].setXY(_x1 + (i * offWidth), _y1);
							}
						}						
					}

					break;
				}
			}
		}
//		//! 鼠标释放的判断
//		public function onMouseUp():void
//		{
//			var i:int = 0;
//			for(i = 0; i < cardListData.lst.length; ++i)
//			{
//				cardListData.lst[i].bMouseDown = false;
//				if(cardListData.lst[i].bMousePress as Boolean)
//				{
//					cardListData.lst[i].isClick = !cardListData.lst[i].isClick;
//					cardListData.lst[i].setBackVisible(false);
//				}
//			}
//			update();
//		}
		
		//! 清空托选牌
		public function cleanBackVisible():void
		{
			var i:int = 0;
			for(i= 0; i < cardListData.lst.length;++i)
			{
				if(cardListData.lst[i].bMousePress as Boolean)
				{
					cardListData.lst[i].setBackVisible(false);
				}
			}
		}
		
		public function getSendCard_X():int
		{
			if(cardListData.lst.length > 0)
				return cardListData.lst[cardListData.lst.length - 1].x;
			return key_X;
		}
		
		public function getSendCard_Y():int
		{
			if(cardListData.lst.length > 0)
				return cardListData.lst[cardListData.lst.length - 1].y;
			return key_Y;
		}
		
		public function onAniEnd():void
		{
			showNums++;
			update();
		}
	}
}