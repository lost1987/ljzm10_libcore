package ronco.qp_core
{
	public class CardListCtrl_GD
	{
		public static const _CARDLIST_TYPE_NONE:int			=	0;		//! 什么都不是，错误的牌型
		public static const _CARDLIST_TYPE_SINGLE:int			=	1;		//! 单张牌
		public static const _CARDLIST_TYPE_TWO:int			=	2;		//! 一对
		public static const _CARDLIST_TYPE_THREE:int			=	3;		//! 3张相同的，3条
		public static const _CARDLIST_TYPE_LIAN:int			=	4;		//! 连续的牌，顺子，5张
		public static const _CARDLIST_TYPE_LIANDUI:int		=	5;		//! 连续的对子，6张（3连对）
		public static const _CARDLIST_TYPE_THREE_TWO:int		=	6;		//! 3带2 带对子
		public static const _CARDLIST_TYPE_FEIJI:int			=	7;		//! 飞机，2个的3条
			
		public static const _CARDLIST_TYPE_BOMB_4:int			=	8;		//! 炸弹 4张
		public static const _CARDLIST_TYPE_BOMB_5:int			=	9;		//! 炸弹 5张
		public static const _CARDLIST_TYPE_TONGHUA:int		=	10;		//! 炸弹 同花顺 5张
		public static const _CARDLIST_TYPE_BOMB_6:int			=	11;		//! 炸弹 6张
		public static const _CARDLIST_TYPE_BOMB_7:int			=	12;		//! 炸弹 7张
		public static const _CARDLIST_TYPE_BOMB_8:int			=	13;		//! 炸弹 8张
		public static const _CARDLIST_TYPE_BOMB_9:int			=	14;		//! 炸弹 9张
		public static const _CARDLIST_TYPE_BOMB_10:int		=	15;		//! 炸弹 10张
		public static const _CARDLIST_TYPE_HUOJIAN:int		=	16;		//! 火箭（大小王  四鬼）
		
		private var LZP:int	=	2;	//!赖子点数
		public function CardListCtrl_GD()
		{
		}
		
		public function SetLZ(_lzp:int):void
		{
			LZP = _lzp;
		}
		
		public function GetLZP():int {	return LZP;		}
		
		public function IsLZ(card:Card):Boolean
		{
			return card.cardPoint == LZP && card.cardType == Card.CARD_TYPE_HEART ? true : false;
		}
		
		private function DepartCardList(_lst:CardList, _LZList:CardList, _NLZList:CardList):void
		{
			_LZList.clean();
			_NLZList.clean();
			
			var i:int = 0;
			for(i = 0; i < _lst.lst.length; ++i)
			{
				if(IsLZ(_lst.lst[i]))
					_LZList.addCard(_lst.lst[i]);
				else
					_NLZList.addCard(_lst.lst[i]);
			}
		}
		
		private function ChangeBA2A(_lst:CardList, _out:CardList):void
		{
			var i:int = 0;
			var len:int = _lst.lst.length;
			for(i = 0; i < len; ++i)
			{
				if(_lst.lst[i].cardPoint == Card.CARD_POINT_B_A)
				{
					//_lst.lst[i].cardPoint = Card.CARD_POINT_A;
					
					//_out.addCard(_lst.lst[i]);
					_out.addCardEx(Card.CARD_POINT_A, 0);
				}
				else
					_out.addCard(_lst.lst[i]);
			}
			_out.Sort2Ex();
		}
		
		public function GetType(_lst:CardList):void
		{
			var i:int = 0;
			var len:int = _lst.lst.length;
			var LZList:CardList = new CardList(_lst.poolName);
			var NLZList:CardList = new CardList(_lst.poolName);
			switch(len)
			{
				case 1:
					_lst.typeList = _CARDLIST_TYPE_SINGLE;
					_lst.typeValue = _lst.lst[0].cardPoint;
					break;
				case 2:
					_lst.typeValue = IsTwo(_lst);
					if(_lst.typeValue != -1)
						_lst.typeList = _CARDLIST_TYPE_TWO;
					break;
				case 3:
					_lst.typeValue = IsThree(_lst);
					if(_lst.typeValue != -1)
						_lst.typeList = _CARDLIST_TYPE_THREE;
					break;
				case 4:
					_lst.typeValue = IsHuoJian(_lst);
					if(_lst.typeValue != -1)
					{
						_lst.typeList = _CARDLIST_TYPE_HUOJIAN;
						return;
					}
					_lst.typeValue = IsSameBomb(_lst);
					if(_lst.typeValue != -1)
					{
						_lst.typeList = _CARDLIST_TYPE_BOMB_4;
						return;
					}					
					break;
				case 5:
					_lst.typeValue = IsSameBomb(_lst);
					if(_lst.typeValue != -1)
					{
						_lst.typeList = _CARDLIST_TYPE_BOMB_5;
						return;
					}	
					_lst.typeValue = IsTongHuaShun(_lst);
					if(_lst.typeValue != -1)
					{
						_lst.typeList = _CARDLIST_TYPE_TONGHUA;
						return;
					}
					_lst.typeValue = IsThreeTwo(_lst);
					if(_lst.typeValue != -1)
					{
						_lst.typeList = _CARDLIST_TYPE_THREE_TWO;
						return;
					}
					_lst.typeValue = IsShun(_lst);
					if(_lst.typeValue != -1)
					{
						_lst.typeList = _CARDLIST_TYPE_LIAN;
						return;
					}
					break;
				case 6:
					_lst.typeValue = IsSameBomb(_lst);
					if(_lst.typeValue != -1)
					{
						_lst.typeList = _CARDLIST_TYPE_BOMB_6;
						return;
					}
					_lst.typeValue = IsLianDui(_lst);
					if(_lst.typeValue != -1)
					{
						_lst.typeList = _CARDLIST_TYPE_LIANDUI;
						return;
					}
					_lst.typeValue = IsFeiJi(_lst);
					if(_lst.typeValue != -1)
					{
						_lst.typeList = _CARDLIST_TYPE_FEIJI;
						return;
					}
					break;
				case 7:
					_lst.typeValue = IsSameBomb(_lst);
					if(_lst.typeValue != -1)
					{
						_lst.typeList = _CARDLIST_TYPE_BOMB_7;
						return;
					}
					break;
				case 8:
					_lst.typeValue = IsSameBomb(_lst);
					if(_lst.typeValue != -1)
					{
						_lst.typeList = _CARDLIST_TYPE_BOMB_8;
						return;
					}
					break;
				case 9:
					_lst.typeValue = IsSameBomb(_lst);
					if(_lst.typeValue != -1)
					{
						_lst.typeList = _CARDLIST_TYPE_BOMB_9;
						return;
					}
					break;
				case 10:
					_lst.typeValue = IsSameBomb(_lst);
					if(_lst.typeValue != -1)
					{
						_lst.typeList = _CARDLIST_TYPE_BOMB_10;
						return;
					}
					break;
			}
		}
		
		public function IsBigTo(left:CardList, right:CardList):Boolean
		{
			GetType(left);
			GetType(right);
			if(left.typeList >= _CARDLIST_TYPE_BOMB_4 && right.typeList < _CARDLIST_TYPE_BOMB_4)
				return true;
			if(left.typeList < _CARDLIST_TYPE_BOMB_4 && right.typeList >= _CARDLIST_TYPE_BOMB_4)
				return false;
			if(left.typeList < _CARDLIST_TYPE_BOMB_4 && right.typeList < _CARDLIST_TYPE_BOMB_4)
			{
				if(left.typeList == right.typeList)
				{
					if(left.typeValue > right.typeValue)
						return true;
					else
						return false;
				}
				return false;
			}
			if(left.typeList >= _CARDLIST_TYPE_BOMB_4 && right.typeList >= _CARDLIST_TYPE_BOMB_4)
			{
				if(left.typeList > right.typeList)
					return true;
				else if(left.typeList < right.typeList)
					return false;
				else
				{
					if(left.typeValue > right.typeValue)
						return true;
					else
						return false;
				}
			}
			return false;
		}
		
		/*******************牌型判断函数********************************************************************************************************/
		/**
		 * 返回比较的点数  如果不是 返回-1
		 */
		//! 是否是对子  如果是  返回比较的点数  如果不是 返回-1
		private function IsTwo(_lst:CardList):int
		{
			var LZList:CardList = new CardList(_lst.poolName);
			var NLZList:CardList = new CardList(_lst.poolName);
			DepartCardList(_lst, LZList, NLZList);
			
			if(LZList.lst.length == 0)
			{
				if(NLZList.lst[0].cardPoint == NLZList.lst[1].cardPoint)
					return NLZList.lst[0].cardPoint;
				else
					return -1
			}
			else if(LZList.lst.length == 2)
			{
				return LZList.lst[0].cardPoint;
			}
			else if(LZList.lst.length == 1)
			{
				if(NLZList.lst[0].cardType == Card.CARD_TYPE_JOKER)
					return -1;
				else
					return NLZList.lst[0].cardPoint;
			}
			return -1;
		}
		private function IsThree(_lst:CardList):int
		{
			var LZList:CardList = new CardList(_lst.poolName);
			var NLZList:CardList = new CardList(_lst.poolName);
			DepartCardList(_lst, LZList, NLZList);
			
			switch(LZList.lst.length)
			{
				case 0:
					if(NLZList.lst[0].cardPoint == NLZList.lst[2].cardPoint &&
						NLZList.lst[0].cardType != Card.CARD_TYPE_JOKER && NLZList.lst[2].cardType != Card.CARD_TYPE_JOKER)
						return NLZList.lst[0].cardPoint;
					else
						return -1;
					break;
				case 1:
					if(NLZList.lst[0].cardPoint == NLZList.lst[1].cardPoint && 
						NLZList.lst[0].cardType != Card.CARD_TYPE_JOKER && NLZList.lst[1].cardType != Card.CARD_TYPE_JOKER)
						return NLZList.lst[0].cardPoint;
					else
						return -1;
					break;
				case 2:
					if(NLZList.lst[0].cardType != Card.CARD_TYPE_JOKER)
						return NLZList.lst[0].cardPoint;
					else
						return -1;
					break;
			}
			return -1;
		}
		private function IsShun(_lst:CardList):int
		{
			var TempList:CardList = new CardList(_lst.poolName);
			var cardkey:int = -1
			if(_lst.lst[0].cardPoint == Card.CARD_POINT_B_A)
			{
				cardkey = _IsShun(_lst);
				if(cardkey != -1)
					return cardkey;
				else
				{
					ChangeBA2A(_lst, TempList);
					return _IsShun(TempList);
				}
			}
			else
			{
				return _IsShun(_lst);
			}
			return -1;
		}
		
		private function _IsShun_Num(_lst:CardList, num:int):int
		{
			var Need:int = 0;
			var i:int = 0;
			for(i = 0; i < _lst.lst.length - 1; ++i)
			{
				if(_lst.lst[i].cardPoint != _lst.lst[i + 1].cardPoint + 1)
				{
					Need += (_lst.lst[i].cardPoint - _lst.lst[i + 1].cardPoint - 1);
				}
			}
			if(Need > num/2)
				return -1;
			else
			{
				if(_lst.lst[0].cardPoint + (num/2 - Need) > Card.CARD_POINT_B_A)
					return  Card.CARD_POINT_B_A;
				else
					return  _lst.lst[0].cardPoint + (num/2 - Need);
			}
			return -1;
		}
		
		private function _IsShun(_lst:CardList):int
		{
			var i:int = 0;
			var LZList:CardList = new CardList(_lst.poolName);
			var NLZList:CardList = new CardList(_lst.poolName);
			DepartCardList(_lst, LZList, NLZList);
			NLZList.Sort(false);
			
			var Need:int= 0;
			for(i = 0; i < NLZList.lst.length - 1; ++i)
			{
				if(NLZList.lst[i].cardPoint != NLZList.lst[i + 1].cardPoint + 1)
				{
					Need += (NLZList.lst[i].cardPoint - NLZList.lst[i + 1].cardPoint - 1);
				}
			}
			if(Need > LZList.lst.length)
				return -1;
			else
			{
				if(NLZList.lst[0].cardPoint + (LZList.lst.length - Need) > Card.CARD_POINT_B_A)
					return Card.CARD_POINT_B_A;
				else
					return NLZList.lst[0].cardPoint + (LZList.lst.length - Need);
			}
			
			return -1;
		}
		private function IsLianDui(_lst:CardList):int
		{
			var TempList:CardList = new CardList(_lst.poolName);
			if(_lst.lst[0].cardPoint == Card.CARD_POINT_B_A)
			{
				var ret:int = _IsLianDui(_lst);
				if(ret != -1)
					return ret;
				else
				{
					ChangeBA2A(_lst, TempList);
					return _IsLianDui(TempList);
				}
			}
			else
			{
				return _IsLianDui(_lst);
			}
			
			return -1;
		}
		private function _IsLianDui(_lst:CardList):int
		{
			var LZList:CardList = new CardList(_lst.poolName);
			var NLZList:CardList = new CardList(_lst.poolName);
			DepartCardList(_lst, LZList, NLZList);
			
			var List1:CardList = new CardList(_lst.poolName);
			NLZList.Sort2Ex();
			NLZList.GetCards_ForNums(1, List1);
			List1.Sort2Ex();
			
			if(List1.lst.length > 3)
				return -1;
			else
				return _IsShun_Num(List1, LZList.lst.length);
		}
		
		private function IsThreeTwo(_lst:CardList):int
		{
			var LZList:CardList = new CardList(_lst.poolName);
			var NLZList:CardList = new CardList(_lst.poolName);
			DepartCardList(_lst, LZList, NLZList);
			NLZList.Sort2Ex();
			switch(LZList.lst.length)
			{
				case 0:
				{
					if(NLZList.lst[0].cardPoint == NLZList.lst[2].cardPoint && 
						NLZList.lst[3].cardPoint == NLZList.lst[4].cardPoint && 
						NLZList.lst[2].cardPoint != NLZList.lst[3].cardPoint && 
						NLZList.lst[0].cardType != Card.CARD_TYPE_JOKER)
						return NLZList.lst[0].cardPoint;
					else
						return -1;
				}
					break;
				case 1:
				{
					if((NLZList.lst[0].cardPoint == NLZList.lst[1].cardPoint && 
						NLZList.lst[1].cardPoint != NLZList.lst[2].cardPoint &&
						NLZList.lst[2].cardPoint == NLZList.lst[3].cardPoint) ||
						(NLZList.lst[0].cardPoint == NLZList.lst[2].cardPoint &&
							NLZList.lst[2].cardPoint != NLZList.lst[3].cardPoint))
						return NLZList.lst[0].cardPoint;
					else
						return -1;
				}
					break;
				case 2:
				{
					if((NLZList.lst[0].cardPoint == NLZList.lst[2].cardPoint) || 
						(NLZList.lst[0].cardPoint == NLZList.lst[1].cardPoint &&
							NLZList.lst[1].cardPoint != NLZList.lst[2].cardPoint))
						return NLZList.lst[0].cardPoint;
					else
						return -1;
				}
					break;
			}
			return -1;
		}
		
		private function IsFeiJi(_lst:CardList):int
		{
			var TempList:CardList = new CardList(_lst.poolName);
			if(_lst.lst[0].cardPoint == Card.CARD_POINT_B_A)
			{
				var ret:int = _IsFeiJi(_lst);
				if(ret != -1)
					return ret;
				else
				{
					ChangeBA2A(_lst, TempList);
					return _IsFeiJi(TempList);
				}
			}
			else
			{
				return _IsFeiJi(_lst);
			}
			return -1;
		}
		
		private function _IsFeiJi(_lst:CardList):int
		{
			var LZList:CardList = new CardList(_lst.poolName);
			var NLZList:CardList = new CardList(_lst.poolName);
			DepartCardList(_lst, LZList, NLZList);
			NLZList.Sort2Ex();
			var List:CardList = new CardList(_lst.poolName);
			NLZList.GetCards_ForNums(1, List);
			if(List.lst.length == 2 && 
				(List.lst[0].cardPoint + 1 == List.lst[1].cardPoint ||
					List.lst[0].cardPoint - 1 == List.lst[1].cardPoint))
			{
				switch(LZList.lst.length)
				{
					case 0:
						if(NLZList.lst[0].cardPoint == NLZList.lst[2].cardPoint && 
							NLZList.lst[3].cardPoint == NLZList.lst[5].cardPoint)
							return NLZList.lst[0].cardPoint;
						else
							return -1;
						break;
					case 1:
						if(NLZList.lst[0].cardPoint == NLZList.lst[2].cardPoint &&
							NLZList.lst[3].cardPoint == NLZList.lst[4].cardPoint)
							return NLZList.lst[0].cardPoint;
						else
							return -1;
						break;
					case 2:
						if(NLZList.lst[0].cardPoint == NLZList.lst[3].cardPoint || 
							(NLZList.lst[0].cardPoint == NLZList.lst[1].cardPoint && NLZList.lst[2].cardPoint == NLZList.lst[3].cardPoint))
							return NLZList.lst[0].cardPoint;
						else
							return -1;
						break;
				}
			}

			return -1;
		}
		
		private function IsHuoJian(_lst:CardList):int
		{
			if(_lst.lst[0].cardType == Card.CARD_TYPE_JOKER &&
				_lst.lst[1].cardType == Card.CARD_TYPE_JOKER &&
				_lst.lst[2].cardType == Card.CARD_TYPE_JOKER &&
				_lst.lst[3].cardType == Card.CARD_TYPE_JOKER)
				return _lst.lst[0].cardPoint;
			else
				return -1;
			return -1;
		}
		
		private function IsTongHuaShun(_lst:CardList):int
		{
			var LZList:CardList = new CardList(_lst.poolName);
			var NLZList:CardList = new CardList(_lst.poolName);
			DepartCardList(_lst, LZList, NLZList);
			
			var ret:int = IsShun(_lst);
			if(IsTongHua(NLZList) && ret != -1)
				return ret;
			else
				return -1;
		}
		
		private function IsTongHua(_lst:CardList):Boolean
		{
			var i:int = 0;
			for(i = 0; i < _lst.lst.length - 1; ++i)
			{
				if(_lst.lst[i].cardType != _lst.lst[i + 1].cardType)
					return false;
			}
			return true;
		}
		
		private function IsSameBomb(_lst:CardList):int
		{
			var LZList:CardList = new CardList(_lst.poolName);
			var NLZList:CardList = new CardList(_lst.poolName);
			DepartCardList(_lst, LZList, NLZList);
			
			for(var i:int = 0; i < NLZList.lst.length; ++i)
				trace("NLZList[" + i + "].cardPoint = " +  NLZList.lst[i].cardPoint);
			
			if(NLZList.lst[0].cardPoint == NLZList.lst[NLZList.lst.length - 1].cardPoint)
				return NLZList.lst[0].cardPoint;
			else
				return -1;
		}
	}
}