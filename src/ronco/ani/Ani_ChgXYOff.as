package ronco.ani
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	import mx.utils.ObjectUtil;
	
	/**
	 * 每间隔一段时间改变/还原对象坐标
	 **/ 
	public class Ani_ChgXYOff extends Ani
	{
		/**
		 * 改变时间
		 **/ 
		public var timeChg:int;
		
		/**
		 * x off 正数
		 **/ 
		public var xOff:Number;
		/**
		 * y off 正数
		 **/ 
		public var yOff:Number;		
		
		/**
		 * 移动到x
		 **/ 
		public var toX:Number;
		/**
		 * 移动到y
		 **/ 
		public var toY:Number;		
		
		/**
		 * 动画改变的对象
		 **/ 
		public var obj:Bitmap;
		
		/**
		 * construct _off 正数
		 **/ 
		public function Ani_ChgXYOff(_timeChg:int, _off:Number, _ox:Number, _oy:Number, _obj:Bitmap, _objx:Number, _objy:Number)
		{
			super();
			
			timeChg = _timeChg;
			obj = new Bitmap(_obj.bitmapData);
			obj.x = _objx;
			obj.y = _objy;
			
			toX = _ox;
			toY = _oy;
			
			if(Math.abs(toX - obj.x) > Math.abs(toY - obj.y))
			{
				xOff = _off;
				yOff = _off * (Math.abs(toY - obj.y) / Math.abs(toX - obj.x));
			}
			else
			{
				yOff = _off;
				xOff = _off * Math.abs(toX - obj.x) / (Math.abs(toY - obj.y));
			}
			
			if(obj.x > toX)
				xOff = -xOff;

			if(obj.y > toY)
				yOff = -yOff;
		}
		
		/**
		 * 每帧调用
		 **/ 		
		public override function onUpdate(offtime:int):void
		{
			timeCur += offtime;
			
			if(timeCur >= timeChg)
			{
				if(Math.abs(toX - obj.x) > Math.abs(xOff))
				{
					obj.x += xOff;
					obj.y += yOff;
				}
				else
				{
					obj.x = toX;
					obj.y = toY;
					
					isNeedErase = true;
					//AniMgr.singleton.removeAni(this);
				}
				
//				xOff = -xOff;
//				yOff = -yOff;
				
			}
			timeCur -= timeChg;
		}			
		
		/**
		 * 停止时调用
		 **/ 
		public override function onStop():void
		{
			obj.visible = false;
			
			super.onStop();
		}
	}
}
