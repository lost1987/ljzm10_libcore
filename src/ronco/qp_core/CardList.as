package ronco.qp_core
{
	import flash.display.Bitmap;
	
	import mx.effects.easing.Back;
	
	import ronco.base.ResMgr;
	import ronco.ui.UIElement;
	
	public class CardList
	{
		public static const T_NULL:int			=	-1;		//! 默认牌型
		
		public var lst:Vector.<Card> = new Vector.<Card>;			//! 牌序列
		
		private var lstSortExTmp:Vector.<Card> = new Vector.<Card>;	//! 按数量排序时需要的临时列表
		
		public var typeList:int = T_NULL;		//! 牌型
		public var typeValue:int = -1;			//! 牌型对应的值
		public var bPass:Boolean = false;		//! 是否是PASS
		
		public var poolName:String;			//! 池的名字
		
		public function CardList(pool:String)
		{
			poolName = pool;
		}
		
		private function _compare_Down(a:Card, b:Card):int
		{
			if(a.cardType == Card.CARD_TYPE_JOKER)
			{
				if(b.cardType == Card.CARD_TYPE_JOKER)
				{
					if(a.cardPoint > b.cardPoint)
					{
						//trace("a.point = " + a.cardPoint + "    b.point = " + b.cardPoint + " 返回 -1");
						return -1;
					}
					else
					{
						//trace("a.point = " + a.cardPoint + "    b.point = " + b.cardPoint + " 返回 1");
						return 1;
					}
				}	
				//trace("a.type = " + a.cardType + "    b.type = " + b.cardType + " 返回 -1");
				return -1;
			}
			
			if(b.cardType == Card.CARD_TYPE_JOKER)
			{
				//trace("a.type = " + a.cardType + "    b.type = " + b.cardType + " 返回 1");
				return 1;
			}
			
			if(a.cardPoint > b.cardPoint)
			{	
				//trace("a.point = " + a.cardPoint + "    b.point = " + b.cardPoint + " 返回 -1");
				return -1;
			}
			else if(a.cardPoint < b.cardPoint)
			{
				//trace("a.point = " + a.cardPoint + "    b.point = " + b.cardPoint + " 返回 1");
				return 1;
			}
			if(a.cardType > b.cardType)
			{
				//trace("a.type = " + a.cardType + "    b.type = " + b.cardType + " 返回 -1");
				return -1;
			}
			else if(a.cardType < b.cardType)
			{
				//trace("a.type = " + a.cardType + "    b.type = " + b.cardType + " 返回 -1");
				return 1;
			}
			//trace("a.type = " + a.cardType + "   a.point = " + a.cardPoint + "   b.type = " + b.cardType + "  b.point = " + b.cardPoint + "  返回 0");
			return 0;
		}
		
		//！排序
		public function Sort(bUp:Boolean):void
		{
			if(bUp)
				lst.sort(_compare_Up);
			else
				lst.sort(_compare_Down);
		}
		
		//! 排序 SortSendCard 2副牌
		public function Sort2Ex():void
		{
			var i:int;
			
			//! 清空临时队列
			lstSortExTmp.splice(0, lstSortExTmp.length);
			
			for(i = 0; i < lst.length; ++i)
			{
				lstSortExTmp.push(lst[i]);
			}
			
			lst.splice(0, lst.length);
			
			//! 排序
			lstSortExTmp.sort(_compare_Down);

			//! 按多少排序
			for(var c_nums:int = 7; c_nums > 0; --c_nums)
			{
				for(i = 0; i < lstSortExTmp.length - c_nums; )
				{
					if(lstSortExTmp[i].cardPoint == lstSortExTmp[i + c_nums].cardPoint)
					{
						for(var j:int = 0; j <= c_nums; ++j)
							lst.push(lstSortExTmp[i + j]);
						
						lstSortExTmp.splice(i, c_nums + 1);
					}
					else
						++i;
				}
			}
			
			//! 最后加入单张
			for(i = 0; i < lstSortExTmp.length; ++i)
				lst.push(lstSortExTmp[i]);
			
			lstSortExTmp.splice(0, lstSortExTmp.length);			
		}
		
		//！ 排序 SortSendCard 1副牌
		public function SortEx():void
		{
			var i:int;
			
			//! 清空临时队列
			lstSortExTmp.splice(0, lstSortExTmp.length);
			
			for(i = 0; i < lst.length; ++i)
			{
				lstSortExTmp.push(lst[i]);
			}
			
			lst.splice(0, lst.length);
			
			//! 排序
			lstSortExTmp.sort(_compare_Down);
			
//			for(i = 0; i < lstSortExTmp.length; ++i)
//				trace("point = " + lstSortExTmp[i].cardPoint + "   type = " + lstSortExTmp[i].cardType);
			
			//! 按多少排序
			for(var c_nums:int = 3; c_nums > 0; --c_nums)
			{
				for(i = 0; i < lstSortExTmp.length - c_nums; )
				{
					if(lstSortExTmp[i].cardPoint == lstSortExTmp[i + c_nums].cardPoint)
					{
						for(var j:int = 0; j <= c_nums; ++j)
							lst.push(lstSortExTmp[i + j]);
						
						lstSortExTmp.splice(i, c_nums + 1);
					}
					else
						++i;
				}
			}
			
			//! 最后加入单张
			for(i = 0; i < lstSortExTmp.length; ++i)
				lst.push(lstSortExTmp[i]);
			
			lstSortExTmp.splice(0, lstSortExTmp.length);		
		}
		
		
		public function GetCards_ForNums(num:int, _out:CardList):void
		{	
			var i:int = 0;
			var j:int = 0;
			this.Sort2Ex();
			
			_out.clean();
			
			if(num == 1)
			{
				for(i = 0; i < this.lst.length; ++i)
				{
					var bHas:Boolean = false;
					
					for(j = 0; j < _out.lst.length; ++j)
					{
						if(this.lst[i].cardPoint == _out.lst[j].cardPoint)
						{
							bHas = true;
							
							break;
						}
					}
					
					if(!bHas)	//! 判断是否有牌
						_out.addCard(this.lst[i]);
				}
			}
			else	//! 其它牌，硬牌放在后面
			{
				if(this.lst.length < num)
					return ;
				
				for(i = 0; i < this.lst.length - num + 1; ++i)
				{
					if(this.lst[i].cardPoint == this.lst[i + num - 1].cardPoint)	//! 判断是否是 nums 张相等的牌
					{
						for(j = 0; j < num; ++j)
							_out.addCard(this.lst[i + j]);
						
						i += num - 1;
					}
				}
			}
			
			return;
		}
		
		private function _compare_Up(a:Card, b:Card):int
		{
			if(a.cardType == Card.CARD_TYPE_JOKER)
			{
				if(b.cardType == Card.CARD_TYPE_JOKER)
				{
					if(a.cardPoint > b.cardPoint)
						return 1;
					else
						return -1;
				}				
				return 1;
			}
			
			if(b.cardType == Card.CARD_TYPE_JOKER)
				return -1;
			
			if(a.cardPoint > b.cardPoint)
				return 1;
			else if(a.cardPoint < b.cardPoint)
				return -1;
			
			if(a.cardType > b.cardType)
				return 1;
			else if(a.cardType < b.cardType)
				return -1;
			
			return 0;
		}
		
		// 清理列表
		public function clean():void
		{	
			lst.splice(0, lst.length);
			typeList = T_NULL;
			typeValue = -1;
		}
		
		//! 获取牌的数量
		public function getNum():int
		{
			return lst.length;
		}
		//! 获得自己的牌型
		public function getType():void
		{
			CardListCtrl_DDZ.countMyType(this);
		}
		
		// 添加单牌
		public function addCard(card:Card):void
		{	
			lst.push(card);	
		}
		
		public function addCardEx(point:int, type:int):void
		{
			var c:Card = (ResMgr.singleton.mapRes[poolName] as CardPool).newCard();
			
			c.setCard(point, type);
			
			lst.push(c);
			
			////MainLog.singleton.output("lst.length = " + lst.length);
		}
		
		// 添加列表
		public function addCardList(_lst:CardList):void
		{
			for(var i:int = 0; i < _lst.lst.length; ++i)
				addCardEx(_lst.lst[i].cardPoint,_lst.lst[i].cardType);	
		}
		
		// 删除单牌
		public function subCard(card:Card):void
		{
			for(var i:int = 0; i < lst.length; ++i)
			{
				if(lst[i].cardPoint == card.cardPoint && lst[i].cardType == card.cardType)
				{
					lst.splice(i, 1);	
					return;
				}
			}
		}
		
		public function subCardEx(point:int, type:int):void
		{
			for(var i:int = 0; i < lst.length; ++i)
			{
				if(lst[i].cardPoint == point && lst[i].cardType == type)
				{
					lst.splice(i, 1);
					return;
				}	
			}
		}
		
		// 删除列表
		public function subCardList(_lst:CardList):void
		{
			for(var i:int = 0; i < _lst.lst.length; ++i)
			{
				for(var j:int = 0; j < lst.length; ++j)
					if(lst[j].cardPoint == _lst.lst[i].cardPoint && lst[j].cardType == _lst.lst[i].cardType)
						lst.splice(j, 1);
			}
		}
		
		// 设置能否响应
		public function setCanClick(can:Boolean):void
		{
			for(var i:int = 0; i < lst.length; ++i)
				lst[i].canClick = can;
		}
		
		// 设置选中牌
		public function setSelectList(_lst:CardList):void
		{
			var len:int = _lst.lst.length;
			var len1:int = lst.length;
			for(var i:int = 0; i < len1; ++i)
			{
				for(var j:int = 0; j < len; ++j)
				{
					if(lst[i].cardPoint == _lst.lst[j].cardPoint && lst[i].cardType == _lst.lst[j].cardType)
					{
						lst[i].isClick = true;
//						trace("第" + i + "张牌被选" + " card.point = " + lst[i].cardPoint + "  card.type = " + lst[i].cardType);
					}
//					else
//					{
//						lst[i].isClick = false;
//					}
				}
			}
//			trace("应该有" + len + "张牌背选出   ");
//			for(var j:int = 0; j < len1; ++j)
//			{
//				if(lst[j].isClick)
//					trace("第" + j + "张牌被选" + " card.point = " + lst[j].cardPoint + "  card.type = " + lst[j].cardType);
//			}
		}
		
		// 放下所有牌
		public function AllDown():void
		{
			var len:int = lst.length;
			for(var i:int = 0; i < len; ++i)
				lst[i].isClick = false;
		}
	}
}
