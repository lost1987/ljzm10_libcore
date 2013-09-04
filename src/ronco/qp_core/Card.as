package ronco.qp_core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import ronco.ui.UICardList;
	
	public class Card extends Sprite
	{
		public static const ANYCARD_POINT:int		=	14;
		public static const ANYCARD_TYPE:int		=	6;
		
		public static const 	CARD_POINT_A:int	=	1;
		public static const 	CARD_POINT_2:int	=	2;
		public static const 	CARD_POINT_3:int	=	3;
		public static const 	CARD_POINT_4:int	=	4;
		public static const 	CARD_POINT_5:int	=	5;
		public static const 	CARD_POINT_6:int	=	6;
		public static const 	CARD_POINT_7:int	=	7;
		public static const 	CARD_POINT_8:int	=	8;
		public static const 	CARD_POINT_9:int	=	9;
		public static const 	CARD_POINT_10:int	=	10;
		public static const 	CARD_POINT_J:int	=	11;
		public static const 	CARD_POINT_Q:int	=	12;
		public static const 	CARD_POINT_K:int	=	13;
		public static const 	CARD_POINT_B_A:int	=	14;
		public static const 	CARD_POINT_B_2:int	=	15;
		
		public static const CARD_TYPE_SPADE:int		=	3;	//黑桃
		public static const CARD_TYPE_HEART:int 		=	2;	//红桃
		public static const CARD_TYPE_CLUB:int 		=	1;	//梅花
		public static const CARD_TYPE_DIAMOND:int 	=	0;	//方片
		
		public static const CARD_TYPE_JOKER:int		=	4;	//王
		
		private var card_bitmap:Bitmap;				//! 图片资源
		public var cardRect:Rectangle = new Rectangle;	//! 切割矩形
		
		public var cardback:Bitmap = new Bitmap;	//! 覆盖层
		private var cardbrect1:Rectangle = new Rectangle();
		
		public var cardType:int;		//! 0-3，4是王
		public var cardPoint:int;		//! 1-15，1，2小王、大王
		
		public var isClick:Boolean;	//! 是否被选取
		public var canClick:Boolean;	//! 能否点击
		
		public var bMousePress:Boolean;//! 是否是 鼠标滑过
		public var bMouseDown:Boolean;	//! 是否是 鼠标按下
		
		public static var Click_X:int = 0;	//! 鼠标点击点 横坐标
		public static var Click_Y:int = 0;	//! 鼠标点击点 纵坐标
		
		private var cardList:UICardList;	//! 所属的CardList
		//! 构造函数
		public function Card(res:BitmapData)
		{
			super();
			card_bitmap = new Bitmap(res);
			cardback = new Bitmap(res);
			
			addChild(card_bitmap);
			card_bitmap.visible = false;
			
			cardType = ANYCARD_TYPE;
			cardPoint = ANYCARD_POINT;	
			
			isClick = false;
			canClick = true;
			bMousePress = false;
			bMouseDown = false;
			
			cardbrect1.top = 2 * card_bitmap.bitmapData.height / 4;
			cardbrect1.height = card_bitmap.bitmapData.height / 4;
			cardbrect1.left = 14 * card_bitmap.bitmapData.width / 15;
			cardbrect1.width = card_bitmap.bitmapData.width / 15;
			
			cardback.scrollRect = cardbrect1;
			cardback.visible = false;
			cardback.alpha = 0.35;
			addChild(cardback);
			
//			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
//			addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			this.doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			
//			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
//			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
//			addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			//addEventListener(MouseEvent.
		}
		//! 添加从属序列
		public function pushInCardList(lst:UICardList):void
		{
			cardList = lst;
		}
		//! 设置牌 加牌 显示
		public function setCard(point:int, type:int):void
		{
			cardType = type;
			cardPoint = point;
			
			update();
		}
		//! 设置牌 加牌 显示
		public function setCardEx(card:Card):void
		{
			cardType = card.cardPoint;
			cardPoint = card.cardType;
			
			update();
		}
		//! 清理 不显示
		public function clean():void
		{
			this.visible = false;
		}
//		//! 鼠标放开事件
//		public function onMouseUp(event:MouseEvent):void
//		{	
//			if(!canClick)
//				return;
//			if(bMouseDown)
//				isClick = !isClick;
//			bMouseDown = false;
//			Card.Click_X = 0;
//			Card.Click_Y = 0;
//			
//			cardList.onMouseUp();
//		}
//		
		public function onDoubleClick(event:MouseEvent):void
		{
			cardList.AllDown();
		}
//		//! 鼠标点下事件
//		public function onMouseDown(event:MouseEvent):void
//		{
//			if(!canClick)
//				return;
//			bMouseDown = true;
//			Card.Click_X = event.stageX;
//			Card.Click_Y = event.stageY;
//		}
//		//! 鼠标滑过事件
//		public function onMouseMove(event:MouseEvent):void
//		{
//			if(!canClick)
//				return;
//		}
//		//! 鼠标在上事件
//		public function onMouseOver(event:MouseEvent):void
//		{
//			if(!canClick)
//				return;
//			if(event.buttonDown)
//			{
//				if(Card.Click_X == 0)
//				{
//					Card.Click_X = event.stageX;
//					Card.Click_Y = event.stageY;
//				}
//				bMousePress = true;
//				cardback.visible = true;
//			}
//		}
//		//! 鼠标出事件
//		public function onMouseOut(event:MouseEvent):void
//		{
//			if(!canClick)
//				return;
//			if(event.buttonDown)
//			{
//				if(event.stageX > Card.Click_X)
//				{// 鼠标想右移动
//					if(event.stageX < this.x)
//					{
//						bMousePress = false;
//						cardback.visible = false;		
//					}
//					else
//					{
//						bMousePress = true;
//						cardback.visible = true;		
//					}		
//				}
//				else
//				{// 鼠标向左移动
//					if(event.stageX > this.x)
//					{
//						bMousePress = false;
//						cardback.visible = false;		
//					}
//					else
//					{
//						bMousePress = true;
//						cardback.visible = true;		
//					}					
//				}
//				if(!cardList.isIn(event.stageX, event.stageY))
//				{
//					cardList.cleanBackVisible();
//				}					
//			}	
//		}
		//! 改变拖动状态
		public function setBackVisible(b:Boolean):void
		{
			bMousePress = b;
			cardback.visible = b;
		}
		//! 设置XY
		public function setXY(_x:int, _y:int):void
		{
			this.x = _x;
			this.y = _y;
		}
		//! 根据牌点数和类型  选着显示
		public function update():void
		{
			//! 王
			if(cardType == CARD_TYPE_JOKER)
			{
				if(cardPoint == 1)
				{
					cardRect.top = 1 * card_bitmap.bitmapData.height / 4;
					cardRect.height = card_bitmap.bitmapData.height / 4;
					cardRect.left = 13 * card_bitmap.bitmapData.width / 15;
					cardRect.width = card_bitmap.bitmapData.width / 15;
				}
				else if(cardPoint == 2)
				{
					cardRect.top = 0 * card_bitmap.bitmapData.height / 4;
					cardRect.height = card_bitmap.bitmapData.height / 4;
					cardRect.left = 13 * card_bitmap.bitmapData.width / 15 ;
					cardRect.width = card_bitmap.bitmapData.width / 15;	
				}
			}
			//! ANYCARD
			else if(cardType == ANYCARD_TYPE)
			{
				cardRect.top = 2 * card_bitmap.bitmapData.height / 4;
				cardRect.height = card_bitmap.bitmapData.height / 4;
				cardRect.left = 13 * card_bitmap.bitmapData.width / 15;
				cardRect.width = card_bitmap.bitmapData.width / 15;
			}
			else
			{
				if(cardPoint > 13)
				{
//					cardRect.top = (cardType - 1) * card_bitmap.bitmapData.height / 4;
//					cardRect.height = card_bitmap.bitmapData.height / 4;
//					cardRect.left = (cardPoint - 14) * card_bitmap.bitmapData.width / 15;
//					cardRect.width = card_bitmap.bitmapData.width / 15;
					
					cardRect.top = (3 - cardType) * card_bitmap.bitmapData.height / 4;
					cardRect.height = card_bitmap.bitmapData.height / 4;
					cardRect.left = (cardPoint - 14) * card_bitmap.bitmapData.width / 15;
					cardRect.width = card_bitmap.bitmapData.width / 15;
				}
				else
				{
//					cardRect.top = (cardType - 1) * card_bitmap.bitmapData.height / 4;
//					cardRect.height = card_bitmap.bitmapData.height / 4;
//					cardRect.left = (cardPoint - 1) * card_bitmap.bitmapData.width / 15;
//					cardRect.width = card_bitmap.bitmapData.width / 15;
					
					cardRect.top = (3 - cardType) * card_bitmap.bitmapData.height / 4;
					cardRect.height = card_bitmap.bitmapData.height / 4;
					cardRect.left = (cardPoint - 1) * card_bitmap.bitmapData.width / 15;
					cardRect.width = card_bitmap.bitmapData.width / 15;
				}				
			}
			
			card_bitmap.scrollRect = cardRect;
			
			card_bitmap.visible = true;	
		}
	}
}