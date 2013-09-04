package ronco.qp_core
{
	public class CardListCtrl_DDZ
	{
		public static const T_NULL:int = -1;			//! 不成牌型，值是-1
		public static const T_SINGLE:int = 1;			//! 单张，值是1张的点数
		public static const T_DOUBLE:int = 2;			//! 对，值是2张的点数
		public static const T_THREE:int = 3;			//! 三张，值是3张的点数
		public static const T_THREE_ONE:int = 4;		//! 三带一，值是3张的点数
		public static const T_THREE_TWO:int = 5;		//! 三带二，值是3张的点数
		public static const T_SUNZHI:int = 6;			//! 顺子，值是最小一张的点数
		public static const T_LIANDUI:int = 7;		//! 连对，值是最小一张的点数
		public static const T_DOUBLETHREE:int = 8;  //! 飞机
		public static const T_DOUBLETHREETWO:int =9; //! 飞机带翅膀.-单张
		public static const T_DOUBLETHREEFOUR:int=10//! 飞机带翅膀-对子
		public static const T_FOUR_TWO:int = 11;		//! 四带二，值是4张牌的点数
		public static const T_BOMB:int = 13;			//! 炸弹，值是牌的点数
		public static const T_HUOJIAN:int = 14;		//! 火箭，值是20


		public function CardListCtrl_DDZ()
		{
		}
		
		// ！ 获取牌型
		public static function GetType(_lst:CardList):int
		{
			if(_lst.lst.length == 1)
				return T_SINGLE; // 单张
			if(isDui(_lst))
				return T_DOUBLE; // ！对子
			if(isHuoJian(_lst))
				return T_HUOJIAN;//  ！火箭
			if(isThree(_lst))
				return T_THREE; // ！三带
			if(isBomb(_lst))
				return T_BOMB; // ！炸弹
			if(isThreeOne(_lst))
				return T_THREE_ONE;// ！三带一
			if(isThreeTwo(_lst))
				return T_THREE_TWO;// ！三带二
			if(isFourTwo(_lst))
				return T_FOUR_TWO;// ！四带二
			if(isShun(_lst))
				return T_SUNZHI;// ！顺子
			if(isLianDui(_lst))
				return T_LIANDUI;// ！连对
			if(isFeiJi(_lst))
				return T_DOUBLETHREE;// ！飞机
			if(isFeiJiChiBangOne(_lst))
				return T_DOUBLETHREETWO;// ！飞机带翅膀.-单张
			if(isFeiJiChiBangTwo(_lst))
				return T_DOUBLETHREEFOUR;// ！飞机带翅膀-对子
			
			return T_NULL; // 错误牌型
		}
		
		public static function IsBigTo(left:CardList, right:CardList):Boolean
		{
			return true;
		}
		
		//更新牌型
		public static function countMyType(_mylst:CardList):void
		{
			if(_mylst.lst.length == 0)// ！错误牌型
			{
				_mylst.typeList = T_NULL;
				_mylst.typeValue = -1;				
				return ;
			}
			
			if(_mylst.lst.length == 1)// ！单牌
			{
				_mylst.typeList = T_SINGLE;
				if(_mylst.lst[0].cardType == Card.CARD_TYPE_JOKER)
					_mylst.typeValue = _mylst.lst[0].cardPoint + 15;
				else
					_mylst.typeValue = _mylst.lst[0].cardPoint;
				return;
			}
			else if(_mylst.lst.length == 2)
			{
				if(isDui(_mylst)) // ！对子
				{
					_mylst.typeList = T_DOUBLE;
					_mylst.typeValue = _mylst.lst[0].cardPoint;
				}
				else if(isHuoJian(_mylst))// ！火箭
				{
					_mylst.typeList = T_HUOJIAN;
					_mylst.typeValue = 20; 
				}
				else 
				{
					_mylst.typeList = T_NULL;
					_mylst.typeValue = -1;	
				}
			}
			else if(_mylst.lst.length == 3)
			{
				if(isThree(_mylst))// ！三张
				{
					_mylst.typeList = T_THREE;
					_mylst.typeValue = _mylst.lst[0].cardPoint;
				}
				else
				{
					_mylst.typeList = T_NULL;
					_mylst.typeValue = -1;	
				}
			}
			else if(_mylst.lst.length == 4)
			{
				_mylst.SortEx();
				if(_mylst.lst[0].cardPoint == _mylst.lst[3].cardPoint )//！炸弹
				{
					_mylst.typeList = T_BOMB;
					_mylst.typeValue = _mylst.lst[0].cardPoint;
				}
				else
				{					
					//! 按多少排序后，只需要判断第1张牌和第3张牌是否相等即可判断出是不是3张一样的
					if(_mylst.lst[0].cardPoint == _mylst.lst[2].cardPoint) //！三带一
					{
						_mylst.typeList = T_THREE_ONE;
						_mylst.typeValue = _mylst.lst[0].cardPoint;
					}
					else//！错误牌型
					{
						_mylst.typeList = T_NULL;
						_mylst.typeValue = -1;
					}					
				}	
			}
			else if(_mylst.lst.length == 5)
			{
				if(isShun(_mylst))// 顺子
				{
					_mylst.typeList = T_SUNZHI;
					_mylst.typeValue = _mylst.lst[0].cardPoint;
				}
				else if(isThreeTwo(_mylst)) // 三带二
				{
					_mylst.typeList = T_THREE_TWO;
					_mylst.typeValue = _mylst.lst[0].cardPoint;
				}
				else
				{
					_mylst.typeList = T_NULL;
					_mylst.typeValue = -1;
				}
			}
			else // ! 大于等于6张牌
			{
				if(isFourTwo(_mylst)) // 四带二
				{
					_mylst.typeList = T_FOUR_TWO;
					_mylst.typeValue = _mylst.lst[0].cardPoint;
					return;
				}
				
				if(isShun(_mylst)) //！顺子
				{
					_mylst.typeList = T_SUNZHI;
					_mylst.typeValue = _mylst.lst[0].cardPoint;
					return;
				}
				
				if(isFeiJi(_mylst))//！飞机
				{
					_mylst.typeList = T_DOUBLETHREE;
					_mylst.typeValue = _mylst.lst[0].cardPoint;
					return;
				}
				
				if(isFeiJiChiBangOne(_mylst))//！飞机翅膀-单
				{
					_mylst.typeList = T_DOUBLETHREETWO;
					_mylst.typeValue = _mylst.lst[0].cardPoint;
					return;
				}

				if(isFeiJiChiBangTwo(_mylst))//！飞机翅膀-对
				{
					_mylst.typeList = T_DOUBLETHREEFOUR;
					_mylst.typeValue = _mylst.lst[0].cardPoint;
					return;
				}
				
				if(isLianDui(_mylst))//！连对
				{
					_mylst.typeList = T_LIANDUI;
					_mylst.typeValue = _mylst.lst[0].cardPoint;
					return;
				}
				
				_mylst.typeList = T_NULL;
				_mylst.typeValue = -1;
			}
		}
						
		//搜索手中有没大的牌
		public static function serchForSend(_lst:CardList , _lastlst:CardList):CardList
		{
			//火箭
			if(_lst.typeList == T_HUOJIAN)
				return null;
			
			switch(_lastlst.typeList)
			{
				case		T_SINGLE://单张
					return  findSingle(_lst,_lastlst) ;	
					
				case		T_DOUBLE://对子
					return  findDouble(_lst,_lastlst);		
					
				case		T_THREE://三张
					return  findThree(_lst,_lastlst) ;		
					
				case		T_THREE_ONE://三带一
					return  findThreeOne(_lst,_lastlst) ;		
					
				case		T_THREE_TWO://三带二
					return  findThreeTwo(_lst,_lastlst) ;
					
				case		T_DOUBLETHREE://飞机
					return   findFeiJi(_lst,_lastlst);
					
				case		T_DOUBLETHREETWO://飞机带翅膀-单张
					return  findFeiJi_ChiBang(_lst,_lastlst);
					
				case		T_DOUBLETHREEFOUR://飞机带翅膀-对子
					return  findDoubleThreeFour(_lst,_lastlst);
					
				case		T_SUNZHI://顺子
					return  findShun(_lst,_lastlst) ;		
					
				case		T_LIANDUI://连对
					return  findLianDui(_lst,_lastlst) ;
					
				case		T_FOUR_TWO://四带二
					return  findFourTwo(_lst,_lastlst) ;
					
				case		T_BOMB://四带两对
					return  findBomb(_lst,_lastlst);
					
				default:
					return  null;
					
			}
			
		}
		
		// ！是否是对子
		public static function isDui(_lst:CardList):Boolean
		{
			return _lst.lst.length == 2 && _lst.lst[0].cardPoint == _lst.lst[1].cardPoint;
		}
		
		// ！是否是三张
		public static function isThree(_lst:CardList):Boolean
		{
			_lst.Sort(false); // 排序
			return _lst.lst.length == 3 && _lst.lst[0].cardPoint == _lst.lst[2].cardPoint;
		}
		
		// ！是否是三带一
		public static function isThreeOne(_lst:CardList):Boolean
		{
			_lst.SortEx(); // 排序
			return _lst.lst.length == 4 && _lst.lst[0].cardPoint == _lst.lst[2].cardPoint;
		}
		
		// ！是否是三代二
		public static function isThreeTwo(_lst:CardList):Boolean
		{
			_lst.SortEx(); // 排序
			return _lst.lst.length == 5 && _lst.lst[0].cardPoint == _lst.lst[2].cardPoint && _lst.lst[3].cardPoint == _lst.lst[4].cardPoint;
		}
		
		// ！是否是飞机
		public static function isFeiJi(_lst:CardList):Boolean
		{
			var len:int = _lst.lst.length;
			
			if(len < 6 || len%3 != 0)
				return false;
			for(var i:int=0;i<len;i++)
			{
				if(_lst.lst[i].cardPoint == 15 || _lst.lst[i].cardType == Card.CARD_TYPE_JOKER)
					return false;
			}			
			_lst.SortEx(); // 排序
			var num:int = len/3;
			for(i=0;i<num;i++)
			{
				if(_lst.lst[i*3].cardPoint != _lst.lst[i*3+2].cardPoint)
					return false;	// 连牌相同			
				if(i < num -1 ){
					if(_lst.lst[i*3].cardPoint - 1 != _lst.lst[(i+1)*3].cardPoint)
						return false;	// 连牌相差1
				}
			}
			return true;
		}
		
		// ！是否是飞机带翅膀-单张
		public static function isFeiJiChiBangOne(_lst:CardList):Boolean
		{
			_lst.SortEx();
			var len:int = _lst.lst.length;
			
			if(len % 4 != 0 || len < 8)
				return false;
			
			var num:int = len * 3 / 4;
			for(var i:int=0;i<num;i++)
			{
				if(_lst.lst[i].cardPoint == 15 || _lst.lst[i].cardType == Card.CARD_TYPE_JOKER)
					return false;
			}
			
			var cardlst:CardList = new CardList(_lst.poolName);
			for(i=0;i<num;i++)			
				cardlst.addCard(_lst.lst[i]);
			
			if(!isFeiJi(cardlst))
				return false;
			
			return true;
		}
		
		// ！是否是飞机带翅膀-对子
		public static function isFeiJiChiBangTwo(_lst:CardList):Boolean
		{
			_lst.SortEx();
			var len:int = _lst.lst.length;
			
			if(len % 5 != 0 || len < 10)
				return false;
			
			var cardlst:CardList = new CardList(_lst.poolName);
			var cardDouble:CardList = new CardList(_lst.poolName);
			var num:int = len * 3 / 5;
			
			for(var i:int=0;i<num;i++)
				cardlst.addCard(_lst.lst[i]);
			
			if(!isFeiJi(cardlst))
				return false;			
			
			for(i=num;i<len;i++)
				cardDouble.addCard(_lst.lst[i]);
			
			var _nums:int = cardDouble.lst.length/2;
			
			for(i = 0; i < _nums - 1; i+=2)
			{
				if(cardDouble.lst[i].cardPoint != cardDouble.lst[i + 1].cardPoint)
					return false;
			}
//			for(i=0;i<_nums-1;i++)
//			{
//				if(_lst.lst[i*2].cardPoint != _lst.lst[i*2+1].cardPoint)
//					return false;
//			}
			return true;
		}
		
		// ！是否是顺子
		public static function isShun(_lst:CardList):Boolean
		{
			_lst.Sort(false);
			
			var len:int = _lst.lst.length;
			if(len < 5)
				return false;
			
			for(var i:int=0;i<len;i++)
			{//包含 2或王
				if(_lst.lst[i].cardPoint == 15 || _lst.lst[i].cardType == Card.CARD_TYPE_JOKER)
					return false;
			}
			
			// 添加列表的顺序可能倒序. 故作此处理.
			if(_lst.lst[0].cardPoint>_lst.lst[1].cardPoint){
				for(i=0;i<len-1;i++)
				{//前后两张相差为1
					if(_lst.lst[i].cardPoint != (_lst.lst[i+1].cardPoint +1))
						return false;	
				}				
			}
			else
			{
				for(i=0;i<len-1;i++)
				{//前后两张相差为1
					if(_lst.lst[i].cardPoint != (_lst.lst[i+1].cardPoint -1))
						return false;						
				}				
			}
			return true;	
		}
		
		// ！是否是连对
		public static function isLianDui(_lst:CardList):Boolean
		{
			_lst.Sort(false);
			var len:int = _lst.lst.length;
			
			if(len < 6 || len % 2 != 0)
				return false;
			for(var i:int=0;i<len;i++)
			{
				if(_lst.lst[i].cardPoint == 15 || _lst.lst[i].cardType == Card.CARD_TYPE_JOKER)
					return false;	
			}
			
			var num:int = len/2;
			for(i=0;i<num;i++)
			{
				if(_lst.lst[i*2].cardPoint != _lst.lst[i*2+1].cardPoint)
					return false;	
				
				if(i < num -1 ){
					if(_lst.lst[i*2].cardPoint - 1 != _lst.lst[(i+1)*2].cardPoint)
						return false;					
				}
			}
			return true;
		}
		
		// ！是否是炸弹
		public static function isBomb(_lst:CardList):Boolean
		{
			_lst.SortEx();			
			return _lst.lst.length==4 && _lst.lst[0].cardPoint == _lst.lst[3].cardPoint;
		}
		
		// ！是否是四带二
		public static function isFourTwo(_lst:CardList):Boolean
		{
			_lst.SortEx();
			if(_lst.lst.length == 6)
			{
				if(_lst.lst[0].cardPoint == _lst.lst[3].cardPoint)
					return true;
			}
			else if(_lst.lst.length == 8)
			{
				if(_lst.lst[0].cardPoint == _lst.lst[3].cardPoint && 
					_lst.lst[4].cardPoint == _lst.lst[5].cardPoint &&
					_lst.lst[6].cardPoint == _lst.lst[7].cardPoint)
					return true;
			}
			return false;
		}
		
		// ！是否是火箭
		public static function isHuoJian(_lst:CardList):Boolean
		{
			return _lst.lst.length==2 && _lst.lst[0].cardType == _lst.lst[1].cardType && _lst.lst[0].cardType==Card.CARD_TYPE_JOKER;
		}		
		
		// 判断列表是否存在该数据
		public static function isHas(card:Card , _lst:CardList):Boolean
		{
			for(var i:int=0;i<_lst.lst.length;i++)
			{
				if(_lst.lst[i].cardPoint == card.cardPoint && 
					_lst.lst[i].cardType == card.cardType)
					
					return true;
			}
			return false;
		}
		
		//！找单张，找不到就找炸弹
		public static function findSingle(_mylst:CardList , _lastlst:CardList):CardList
		{
			var cardlst:CardList = new CardList(_mylst.poolName);
			var len:int = _mylst.lst.length-1;
			_mylst.Sort(false);
			
			for(var i:int=len;i>=0;i--)
			{
				if(_lastlst.lst[0].cardType == Card.CARD_TYPE_JOKER)
				{
					if(_mylst.lst[i].cardType != Card.CARD_TYPE_JOKER)
						continue;
					else
					{
						if(_mylst.lst[i].cardPoint > _lastlst.lst[0].cardPoint)
						{
							cardlst.addCardEx(_mylst.lst[i].cardPoint,_mylst.lst[i].cardType);
							return cardlst;
						}
					}
				}
				else
				{
					if(_mylst.lst[i].cardType == Card.CARD_TYPE_JOKER)
					{
						cardlst.addCardEx(_mylst.lst[i].cardPoint,_mylst.lst[i].cardType);
						return cardlst;
					}
					else
					{
						if(_mylst.lst[i].cardPoint > _lastlst.lst[0].cardPoint)
						{
							cardlst.addCardEx(_mylst.lst[i].cardPoint,_mylst.lst[i].cardType);
							return cardlst;
						}					
					}
				}
			}			
			return findBomb(_mylst,_lastlst);
		}
		
		//！找对子，找不到就找炸弹
		public static function findDouble(_mylst:CardList , _lastlst:CardList):CardList
		{
			var cardlst:CardList = new CardList(_mylst.poolName);
			var len:int = _mylst.lst.length-2;
			
			_mylst.Sort(false);
			
			for(var i:int=len;i>=0;i--)
			{
				if(_mylst.lst[i].cardPoint==_mylst.lst[i+1].cardPoint )
				{
					if(_mylst.lst[i].cardPoint>_lastlst.lst[0].cardPoint)
					{
						cardlst.addCardEx(_mylst.lst[i].cardPoint,_mylst.lst[i].cardType);
						cardlst.addCardEx(_mylst.lst[i+1].cardPoint,_mylst.lst[i+1].cardType);
						return cardlst;
					}
				}
			}			
			return findBomb(_mylst,_lastlst);
		}
		
		//！找连队，找不到就找炸弹
		public static function findLianDui(_mylst:CardList , _lastlst:CardList):CardList
		{
			if(_mylst.lst.length<_lastlst.lst.length)			
				return findBomb(_mylst,_lastlst);
			
			_mylst.Sort(false);			
			var len:int = _lastlst.lst.length;
			for(var i:int = _mylst.lst.length-len;i>=0;i--)
			{
				var _cardlst:CardList = new CardList(_mylst.poolName);
				var _cardcount:int = 0;
				for(var j:int=0;_cardcount<len && (i+j)<_mylst.lst.length;j++)
				{	
					if(j!=0 && j!=1 && _mylst.lst[i+j].cardPoint == _mylst.lst[i+j-2].cardPoint)					
						continue;
					
					_cardlst.addCardEx(_mylst.lst[i+j].cardPoint,_mylst.lst[i+j].cardType);
					_cardcount++;
				}
				
				if(isLianDui(_cardlst) &&　_cardlst.lst[0].cardPoint > _lastlst.lst[0].cardPoint)
					return _cardlst;
			}			
			return findBomb(_mylst,_lastlst);
		}
		
		//！找顺子   ----  根据选中的牌随意找  (暂时如此)
		public static function searchShun(_clst:CardList):void
		{
//			var num:int = lst.length;
//			for(var i:int=num-1 ; i>=0 ; i--)
//			{
//				if(lst[i].cardType == 5 || lst[i].cardPoint == 15)
//					continue;
//				if(i != (num-1) && lst[i].cardPoint == lst[i+1].cardPoint)
//					continue;
//				if(i != (num-1) && lst[i].cardPoint != lst[i+1].cardPoint+1)
//				{
//					_clst.removeLst(_clst);
//					continue;
//				}
//				_clst.addCard(lst[i].cardType,lst[i].cardPoint);
//			}
		}
		
		//! 找顺子
		public static function findShun2(_mylst:CardList):CardList
		{
			if(_mylst.lst.length < 5)
				return null;
			return null;
		}
		
		//！找顺子，找不到就找炸弹
		public static function findShun(_mylst:CardList , _lastlst:CardList):CardList
		{
			if(_mylst.lst.length<_lastlst.lst.length)			
				return findBomb(_mylst,_lastlst);
			
			_mylst.Sort(false);
			var last_nums:int = _lastlst.lst.length;
			for(var i:int=_mylst.lst.length-last_nums-1;i>=0;i--)
			{
				if(_mylst.lst[i].cardPoint != 15 && _mylst.lst[i].cardType != Card.CARD_TYPE_JOKER)
				{
					var _cardlst:CardList = new CardList(_mylst.poolName);
					var _cardcount:int = 0;
					for(var j:int=0;_cardcount<last_nums&&(i+j)<_mylst.lst.length;j++)
					{
						if( j!=0 && _mylst.lst[i+j].cardPoint == _mylst.lst[i+j-1].cardPoint)
							continue;
						
						_cardlst.addCardEx(_mylst.lst[i+j].cardPoint,_mylst.lst[i+j].cardType);
						_cardcount++;
					}
					
					if(isShun(_cardlst) && _cardlst.lst[0].cardPoint > _lastlst.lst[0].cardPoint)
						return _cardlst;
				}
			}
			return findBomb(_mylst,_lastlst);
		}
		
		//！找三张，找不到就找炸弹
		public static function findThree(_mylst:CardList , _lastlst:CardList):CardList
		{
			var cardlst:CardList = new CardList(_mylst.poolName);
			
			_mylst.SortEx();			
			for(var i:int=_mylst.lst.length-3;i>=0;--i)
			{
				if(_mylst.lst[i].cardPoint==_mylst.lst[i+2].cardPoint && _mylst.lst[i].cardPoint>_lastlst.lst[0].cardPoint)
				{
					cardlst.addCardEx(_mylst.lst[i].cardPoint,_mylst.lst[i].cardType);
					cardlst.addCardEx(_mylst.lst[i+1].cardPoint,_mylst.lst[i+1].cardType);
					cardlst.addCardEx(_mylst.lst[i+2].cardPoint,_mylst.lst[i+2].cardType);
					return cardlst;
				}
			}			
			return findBomb(_mylst,_lastlst);
		}
		
		//！找三带一，找不到就找炸弹
		public static function findThreeOne(_mylst:CardList , _lastlst:CardList):CardList
		{
			var cardlst:CardList = new CardList(_mylst.poolName);
			var nums:int = _mylst.lst.length ;
			
			cardlst = findThree(_mylst,_lastlst);			
			if(cardlst != null && cardlst.lst.length == 3)
			{
				for(var i:int=nums-1;i>=0;i--){
					if(_mylst.lst[i].cardPoint != cardlst.lst[0].cardPoint)
					{
						cardlst.addCardEx(_mylst.lst[i].cardPoint,_mylst.lst[i].cardType);
						return cardlst;
					}
				}
			}
			return findBomb(_mylst,_lastlst);
		}
		
		//！找三带二，找不到就找炸弹
		public static function findThreeTwo(_mylst:CardList , _lastlst:CardList):CardList
		{
			var cardlst:CardList = new CardList(_mylst.poolName);
			var nums:int = _mylst.lst.length ;
			
			cardlst = findThree(_mylst,_lastlst);			
			if(cardlst != null && cardlst.lst.length == 3)
			{
				for(var i:int=nums-2;i>=0;i--)
				{
					if(_mylst.lst[i].cardPoint==_mylst.lst[i+1].cardPoint &&cardlst.lst[0].cardPoint != _mylst.lst[i].cardPoint )
					{	
						cardlst.addCardEx(_mylst.lst[i].cardPoint,_mylst.lst[i].cardType);
						cardlst.addCardEx(_mylst.lst[i+1].cardPoint,_mylst.lst[i+1].cardType);
						return cardlst;	
					}					
				}
			}
			return findBomb(_mylst,_lastlst);			
		}
		
		//！找飞机
		public static function findFeiJi(_mylst:CardList , _lastlst:CardList):CardList
		{
			_mylst.Sort(false);
			if(_mylst.lst.length >= _lastlst.lst.length)
			{
				var len:int = _mylst.lst.length-_lastlst.lst.length;
				for(var i:int=len;i>=0;i--)
				{
					var cardlst:CardList = new CardList(_mylst.poolName);
					for(var j:int=0;j<_lastlst.lst.length;j++)
					{
						cardlst.addCardEx(_mylst.lst[i+j].cardPoint,_mylst.lst[i+j].cardType);
					}
					if(isFeiJi(cardlst) && (cardlst.lst[0].cardPoint > _lastlst.lst[0].cardPoint))
					{
						return cardlst;
					}
				}				
			}			
			return findBomb(_mylst,_lastlst);
		}		
		
		//！找飞机带对子
		public static function findDoubleThreeFour(_mylst:CardList , _lastlst:CardList):CardList
		{
			if(_mylst.lst.length < _lastlst.lst.length)			
				return 	findBomb(_mylst,_lastlst);			
			
			var cardlist:CardList = new CardList(_mylst.poolName);
			var _lastlistAdd:CardList = new CardList(_mylst.poolName);
			
			_mylst.Sort(false);			
			for(var i:int=0;i<_lastlst.lst.length * 3 / 5;i++)
			{
				_lastlistAdd.addCardEx(_lastlst.lst[i].cardPoint,_lastlst.lst[i].cardType);
			}
			
			cardlist = findFeiJi(_lastlistAdd,_lastlst);			
			if(cardlist != null && cardlist.lst.length>4)
			{//非炸弹
				for(i=_mylst.lst.length-2;i>=0;i--)
				{
					for(var j:int=0;j<cardlist.lst.length;j++)
					{
						if( _mylst.lst[i].cardPoint == _mylst.lst[i+1].cardPoint  && (! isHas(_mylst.lst[i] , cardlist) ) )
						{
							cardlist.addCardEx(_mylst.lst[i].cardPoint,_mylst.lst[i].cardType);
							cardlist.addCardEx(_mylst.lst[i+1].cardPoint,_mylst.lst[i+1].cardType);
							
							if(cardlist.lst.length == _lastlst.lst.length)
								return cardlist;
						}
					}
				}
			}	
			return findBomb(_mylst,_lastlst);
		}		
		
		//！找飞机带翅膀-单张
		public static function findFeiJi_ChiBang(_mylst:CardList , _lastlst:CardList):CardList
		{
			if(_mylst.lst.length < _lastlst.lst.length)			
				return 	findBomb(_mylst,_lastlst);			
			
			var cardlist:CardList = new CardList(_mylst.poolName);
			var _lastlistAdd:CardList = new CardList(_mylst.poolName);
			
			_mylst.Sort(false);			
			for(var i:int=0;i<_lastlst.lst.length * 3 / 4;i++)
			{
				_lastlistAdd.addCardEx(_lastlst.lst[i].cardPoint,_lastlst.lst[i].cardType);
			}
			
			cardlist = findFeiJi(_lastlistAdd,_lastlst);
			if(cardlist != null && cardlist.lst.length>4)
			{//非炸弹.
				for(i = _mylst.lst.length-1; i>=0;i--)
				{
					if( ! isHas(_mylst.lst[i] , cardlist))
					{
						cardlist.addCardEx(_mylst.lst[i].cardPoint,_mylst.lst[i].cardType);
						
						if(cardlist.lst.length == _lastlst.lst.length)
							return cardlist;
					}
				}
			}			
			return findBomb(_mylst,_lastlst);
		}		
		
		//！找四带二，找不到就找炸弹
		public static function findFourTwo(_mylst:CardList , _lastlst:CardList):CardList
		{	
			var cardlst:CardList = new CardList(_mylst.poolName);
			var cardaddlst:CardList = new CardList(_mylst.poolName);
			var nums:int = _mylst.lst.length ;
			var count:int =0;
			
			_mylst.Sort(false);
			
			cardlst = findBomb(_mylst,_lastlst);
			
			if(cardlst != null && cardlst.lst.length == 4 && nums>5)
			{
				for(var i:int=nums-1;i>=0;i--)
				{
					if(_mylst.lst[i].cardPoint != cardlst.lst[0].cardPoint)
					{
						count++;
						cardaddlst.addCardEx(_mylst.lst[i].cardPoint,_mylst.lst[i].cardType);
						
						if(cardaddlst.lst.length == 2 && cardaddlst.lst[0].cardPoint == cardaddlst.lst[1].cardPoint)
						{
							//cardaddlst.removeChildAt(1);
							cardaddlst.lst.shift();
							continue;
						}
						
						if(count>1)
						{
							cardlst.addCardList(cardaddlst);
							return cardlst;
						}
					}
				}					
			}
			return  findBomb(_mylst,_lastlst);
		}
		
		//！找四带l一对，找不到就找炸弹
		public function findFourDul(_mylst:CardList , _lastlst:CardList):CardList
		{
			var cardlst:CardList = new CardList(_mylst.poolName);
			var count:int =0;			
			_mylst.Sort(false);
			
			cardlst = findBomb(_mylst,_lastlst);
			if(cardlst != null && cardlst.lst.length == 4 && _mylst.lst.length>5)
			{
				for(var i:int=_mylst.lst.length-2;i>=0;--i)
				{
					if(_mylst.lst[i].cardPoint != cardlst.lst[0].cardPoint && _mylst.lst[i].cardPoint==_mylst.lst[i+1].cardPoint)
					{
						cardlst.addCardEx(_mylst.lst[i].cardPoint,_mylst.lst[i].cardType);
						cardlst.addCardEx(_mylst.lst[i+1].cardPoint,_mylst.lst[i+1].cardType);
						return cardlst;
					}
				}
			}
			return findBomb(_mylst,_lastlst);
		}
		
		//！找炸弹
		public static function findBomb(_mylst:CardList , _lastlst:CardList):CardList
		{
			_mylst.Sort(false);//排序
			var cardlst:CardList = new CardList(_mylst.poolName);
			var len:int=_mylst.lst.length - 4;
			for(var i:int=len;i>=0;i--)
			{				
				if(_mylst.lst[i].cardPoint == _mylst.lst[i+3].cardPoint)
				{
					if(_lastlst.typeList<T_BOMB || _mylst.lst[i].cardPoint > _lastlst.lst[0].cardPoint)
					{
						cardlst.addCardEx(_mylst.lst[i].cardPoint,_mylst.lst[i].cardType);
						cardlst.addCardEx(_mylst.lst[i+1].cardPoint,_mylst.lst[i+1].cardType);
						cardlst.addCardEx(_mylst.lst[i+2].cardPoint,_mylst.lst[i+2].cardType);
						cardlst.addCardEx(_mylst.lst[i+3].cardPoint,_mylst.lst[i+3].cardType);
						return cardlst;
					}
				}
			}
			return findHuoJian(_mylst);
		}
		
		//！找火箭
		public static function findHuoJian(_lst:CardList):CardList
		{
			_lst.Sort(false);
			var cardlst:CardList = new CardList(_lst.poolName);
			var len:int=_lst.lst.length;
			for(var i:int = 0;i<len-1;++i)
			{
				if(_lst.lst[i].cardType == _lst.lst[i + 1].cardType  &&  _lst.lst[i].cardType == Card.CARD_TYPE_JOKER)
				{
					cardlst.addCardEx(_lst.lst[i].cardPoint,_lst.lst[i].cardType);
					cardlst.addCardEx(_lst.lst[i+1].cardPoint,_lst.lst[i+1].cardType);
					return cardlst;
				}
			}
			return null;
		}		
		
		// ！能否出牌
		public static function canSend(_mylst:CardList,_lastlst:CardList):Boolean
		{
			if(_lastlst.typeList == T_NULL)
				return true;
			if(_mylst.typeList == T_NULL)
				return false;
			
			if(_lastlst.typeList == T_HUOJIAN)
				return false;
			
			if(_mylst.typeList == T_HUOJIAN)
				return true;			
			
			if(_lastlst.typeList == T_BOMB)
			{
				if(_mylst.typeList == T_BOMB)
					return _mylst.typeValue > _lastlst.typeValue;				
				return false;
			}
			
			if(_mylst.typeList == T_BOMB)
				return true;
			
			// 同类型 牌判断
			if(_mylst.lst.length != _lastlst.lst.length)
				return false;
			
			if(_lastlst.typeList == _mylst.typeList)	
				return _mylst.typeValue > _lastlst.typeValue;
			
			if(_lastlst.typeList == T_NULL && _mylst.typeList != T_NULL)
				return true;	
			
			return false;
		}
	}
}