package ronco.qp_core
{
	import flash.display.Bitmap;
	
	import ronco.base.ResMgr;

	public class CardPool
	{
		public static var pool:CardPool = new CardPool;
		private var resName:String;
		
		private var lst:Vector.<Card> = new Vector.<Card>;
		
		public function initPool(_resName:String):void
		{
			resName = _resName;
		}
		
		public function CardPool()
		{
		}
		
		public function newCard():Card
		{
			if(lst.length > 0)
			{
				var c:Card = lst[lst.length - 1];
				
				lst.pop();
				
				return c;
			}
			
			return new Card((new ResMgr.singleton.mapRes[resName] as Bitmap).bitmapData);
		}
		
		public function deleteCard(c:Card):void
		{
			lst.push(c);
		}
	}
}