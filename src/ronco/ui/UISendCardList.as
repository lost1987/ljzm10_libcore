package ronco.ui
{	
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ronco.base.*;
	import ronco.qp_core.*;

	//!			用于显示用户打出的牌
	//!			包括牌的移动
	public class UISendCardList extends UIElement
	{
		public static const DQ_TYPE_LEFT:int		=	0;		//! 左对齐
		public static const DQ_TYPE_RIGHT	:int	=	1;		//! 右对齐
		public static const DQ_TYPE_CENTER:int	=	2;		//! 中心对齐
		
		public var cardListData:CardList;
		
		private var card_bitmap:Bitmap;		//! 牌的图片
		private var offWidth:int;				//! 牌间距
		private var cardWidth:int;				//! 牌的宽度（资源决定）
		private var cardHeight:int;			//! 牌的高度（资源决定）
		
		public var DQType:int = 0;				//! 对齐方式
		
		public var key_X:int	=	0;			//! 关键点横坐标
		public var key_Y:int	=	0;			//! 关键点纵坐标
		
		private var poolName:String;			//! 池的名字
		private var showNums:int = -1;			//! 显示的牌的数量
		
		private var timer:Timer = new Timer(24);	//! 计时器
		private var AniFrames:int = 2;			//! 动画固定帧数；
		private var AniCurFrames:int = 0;		//! 动画当前帧数
		private var Ani_Off_X:int		= 0;	//! 没帧动画横坐标偏移量
		private var Ani_Off_Y:int		= 0;	//! 没帧动画纵坐标偏移量
		
		private var Ani_X:int = 0;				//! 动画起始横坐标
		private var Ani_Y:int = 0;				//! 动画起始纵坐标
		
		private var curCard:int = 0;			//! 当前提取第几张牌
		
		private var card:Card = null;			//! 用来画动画的图片
		
		public function UISendCardList(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_SENDCARDLIST, _name, _parent);
			timer.addEventListener(TimerEvent.TIMER, _onTimer);
		}
		//! 初始化 res资源， pool池索引， off间距， dqtype对齐方式， keyx关键横坐标， keyy关键纵坐标
		//! bup是否竖着画牌， bcontrol是否能控制
		public function init(res:Class, pool:String, off:int, dqtype:int, keyx:int, keyy:int):void
		{
			card_bitmap = new res as Bitmap;
			cardWidth = card_bitmap.width / 15;
			cardHeight = card_bitmap.height / 4;
			offWidth = off;
			DQType = dqtype;
			key_X = keyx;
			key_Y = keyy;
			poolName = pool;
			cardListData = new CardList(poolName);
			
			//			var a1:TestSprite = new TestSprite();
			//			addChild(a1)
		}
		
		//! 改变动画帧数
		public function setAniFrames(ani:int):void
		{
			AniFrames = ani;
		}
		//! 获得当前动画帧数
		public function getAniFrames():int
		{
			return AniFrames;
		}
		
		//! 清空  需要显示的牌
		public function clean():void
		{
			Ani_X = 0;
			Ani_Y = 0;
			for(var i:int = 0; i < cardListData.lst.length; ++i)
			{
				removeChild(cardListData.lst[i]);
			}
		}
		//! 清空  动画
		private function cleanAni():void
		{
			if(card != null)
			{
				removeChild(card);
				card = null;
			}
			if(curCard >= cardListData.lst.length)
				curCard = 0;		// 当前需要动画的牌index
			AniCurFrames = 0;	// 动画东线帧数
		}
		//! 加一张牌
		private function addCardEx(point:int, type:int):void
		{
			var c:Card = (ResMgr.singleton.mapRes[poolName] as CardPool).newCard();
			
			c.setCard(point, type);
			c.canClick = false;
			c.visible = false;
			//c.pushInCardList(this);
			//! 添加数据
			cardListData.addCard(c);
			//! 界面添加
			addChild(c);
			
			update();
		}
		//! 添加一个动画牌
		private function addAniCard(point:int, type:int):void
		{
			if(card != null)
			{
				removeChild(card);
				card = null;
			}
				
			card = (ResMgr.singleton.mapRes[poolName] as CardPool).newCard();
			card.setCard(point, type);
			card.canClick = false;
			
			card.x = Ani_X;
			card.y = Ani_Y;
			
			Ani_Off_X = (cardListData.lst[curCard].x - Ani_X)/AniFrames;
			Ani_Off_Y = (cardListData.lst[curCard].y - Ani_Y)/AniFrames;
			
			addChild(card);
		}
		//! 设置需要显示的牌
		public function setCardList(_lst:CardList, _x:int, _y:int):void
		{
			if(_lst.lst.length == 0)
			{
				clean();
				cardListData.clean();
				cleanAni();
			}
			else
			{
				if(cardListData.lst.length != 0)
					return ;
				
				clean();
				cardListData.clean();
				showNums = 0;  // 暂时不显示牌				
				for(var i:int = 0; i < _lst.lst.length; ++i)
					addCardEx(_lst.lst[i].cardPoint, _lst.lst[i].cardType);
				// 设置动画起始坐标
				Ani_X = _x;
				Ani_Y = _y;	
				// 添加一个动画牌
				cleanAni();
				curCard = 0;
				addAniCard(cardListData.lst[0].cardPoint, cardListData.lst[0].cardType);
				timer.start();				
			}

		}
		
		
		
		private function _onTimer(event:TimerEvent):void
		{
			if(curCard >= cardListData.lst.length)
				timer.stop();
			else
			{
				if(AniCurFrames >= AniFrames)
				{
					AniCurFrames = 0;
					curCard++;
					_chgCurCard();
				}
				else
				{	
					AniCurFrames++;
					updateAni();					
				}
			}
		}
		//! 修改当前动画牌
		private function _chgCurCard():void
		{
			if(curCard >= cardListData.lst.length)
			{
				showNums = curCard;
				timer.stop();
				cleanAni();
				update();
			}
			else
			{
				addAniCard(cardListData.lst[curCard].cardPoint, cardListData.lst[curCard].cardType);
				showNums = curCard;
				//Ani_Off_X = (cardListData.lst[curCard].x - Ani_X)/AniFrames;
				//Ani_Off_Y = (cardListData.lst[curCard].y - Ani_Y)/AniFrames;
				updateAni();
				update();
			}
		}
		//! 动画位置更新
		public function updateAni():void
		{
			card.x = Ani_X + (Ani_Off_X * AniCurFrames);
			card.y = Ani_Y + (Ani_Off_Y * AniCurFrames);
		}
		//! 牌的位置更新
		public function update():void
		{
			var i:int = 0;
			var len:int = cardListData.lst.length;
			switch(DQType)
			{
				case DQ_TYPE_LEFT:
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
						cardListData.lst[i].setXY(key_X + (i * offWidth), key_Y);
					}
					break;
				}
				case DQ_TYPE_RIGHT:
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
						cardListData.lst[i].setXY(key_X - cardWidth - (len - 1 - i)*offWidth, key_Y);
					}						
					break;
				}
				case DQ_TYPE_CENTER:
				{
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
						
						cardListData.lst[i].setXY(_x1 + (i * offWidth), _y1);
					}						
					break;
				}
			}			
		}
	}
}