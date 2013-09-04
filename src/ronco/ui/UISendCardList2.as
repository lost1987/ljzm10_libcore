package ronco.ui
{
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ronco.base.*;
	import ronco.qp_core.*;
	
	public class UISendCardList2 extends UIElement
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
		private var lostNums:int = -1;			//! 剩余不发的牌数量
		
		private var timer:Timer = new Timer(24);	//! 计时器
		private var AniFrames:int = 2;			//! 动画固定帧数；
		private var AniCurFrames:int = 0;		//! 动画当前帧数
		private var Ani_Off_X:int		= 0;	//! 没帧动画横坐标偏移量
		private var Ani_Off_Y:int		= 0;	//! 没帧动画纵坐标偏移量
		
		private var Ani_X:int = 0;				//! 动画起始横坐标
		private var Ani_Y:int = 0;				//! 动画起始纵坐标
		
		private var curCard:int = 0;			//! 当前是针对第几组牌 vecotr的下标
		
		private var card:Card = null;			//! 用来画动画的图片
		
		public var lstUICard:Vector.<UICardListListener> = new Vector.<UICardListListener>;	//! ui模块列表
		public var lstUICardX:Vector.<int> = new Vector.<int>;	// 记录结束点X坐标
		public var lstUICardY:Vector.<int> = new Vector.<int>;// 记录结束点Y坐标
		
//		private var beginTime:Number;							// 动画开始播放的时间
//		private var curTime:Number;							// 当前时间
		
		public function UISendCardList2(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_SENDCARDLIST2, _name, _parent);
			timer.addEventListener(TimerEvent.TIMER, _onTimer);
		}
		
		//! 初始化 res资源， pool池索引， off间距， dqtype对齐方式， keyx关键横坐标， keyy关键纵坐标，_aniframes 每个小动画的帧数
		public function init(res:Class, pool:String, off:int, dqtype:int, keyx:int, keyy:int, _aniframes:int):void
		{
			card_bitmap = new res as Bitmap;
			cardWidth = card_bitmap.width / 15;
			cardHeight = card_bitmap.height / 4;
			AniFrames = _aniframes;
			offWidth = off;
			DQType = dqtype;
			key_X = keyx;
			key_Y = keyy;
			poolName = pool;
			cardListData = new CardList(poolName);
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
		// 清空数据
		public function clean():void
		{
			curCard = 0;
			var i:int = 0;
			for(i = 0; i < cardListData.lst.length; ++i)
			{
				removeChild(cardListData.lst[i]);
			}
			cardListData.clean();
			if(card != null)
			{
				removeChild(card);
				card = null;
			}
			
			lstUICard.splice(0, lstUICard.length);
			lstUICardX.splice(0, lstUICardX.length);
			lstUICardY.splice(0, lstUICardY.length);
		}
		// 添加listener
		public function addCardListener(listener:UICardListListener, x:int = 0, y:int = 0):void
		{
			lstUICard.push(listener);
			lstUICardX.push(x);
			lstUICardY.push(y);
		}
		// 播放动画
		public function play(num:int, _lost:int):void
		{
			var i:int = 0;
			lostNums = _lost;
			for(i = 0; i < num; ++i)
				addCardEx(Card.ANYCARD_POINT, Card.ANYCARD_TYPE);
			showNums = num;
			addAniCard(Card.ANYCARD_POINT, Card.ANYCARD_TYPE);
//			var date:Date = new Date();
//			beginTime = date.time;		
			timer.start();

		}
		// 停止播放
		public function stop():void
		{
			if(timer.running)
			{
				timer.stop();
				clean();
			}
		}
		// 定时函数
		public function _onTimer(e:TimerEvent):void
		{
//			var date:Date = new Date();
//			curTime = date.time;
//			if(curTime - beginTime >= (54 - 3) * 24 * 2)
//			{
//				timer.stop();
//				lstUICard[lstUICard.length - 1].onAniEnd();
//				clean();
//				return;
//			}
			if(AniCurFrames >= AniFrames)
			{
				AniCurFrames = 0;
				update();
				addAniCard(Card.ANYCARD_POINT, Card.ANYCARD_TYPE);
			}
			else
			{
				AniCurFrames++;
				AniUpdate();
				if(AniCurFrames == AniFrames)
				{
					lstUICard[curCard].onAniEnd();
					curCard = (curCard == lstUICard.length - 2 ? 0:++curCard);
					trace("curCard = " + curCard  + "    lstUICard.length = " + lstUICard.length);
					showNums--;
					if(showNums == lostNums)
					{
						timer.stop();
						lstUICard[lstUICard.length - 1].onAniEnd();
						clean();
					}
				}
			}
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
			
			card.x = getAniX();
			card.y = getAniY();
			
			Ani_Off_X = (lstUICardX[curCard] - card.x)/AniFrames;
			Ani_Off_Y = (lstUICardY[curCard] - card.y)/AniFrames;
			
			addChild(card);
		}
		// 动画牌更新位置
		public function AniUpdate():void
		{
			card.x = getAniX() + Ani_Off_X * AniCurFrames;
			card.y = getAniY() + Ani_Off_Y * AniCurFrames;
		}
		// 获得东画起始点X坐标
		public function getAniX():int
		{
			return cardListData.lst[showNums - 1].x;
		}
		// 获得动画起始点Y坐标
		public function getAniY():int
		{
			return cardListData.lst[showNums - 1].y;
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