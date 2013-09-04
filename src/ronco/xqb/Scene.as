package ronco.xqb
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.*;

	///////////////////////////////////////////////////////////////
	// 场景类
	// 一张场景底图，并管理场景内所有对象
	//////////////////////////////////////////////////////////////		
	public class Scene extends Sprite
	{
		public var back:Bitmap;
		public var backRect:Rectangle = new Rectangle;
		
		public var imgMask:Bitmap;
		
		public var layerBottom:Sprite = new Sprite;
		public var layerDyn:Sprite = new Sprite;
		public var layerTop:Sprite = new Sprite;
		
		public var lstBottom:Array = new Array;
		public var lstDyn:Array = new Array;
		public var lstTop:Array = new Array;
		
		public var lstObj:Array = new Array;
		public var lstPerson:Array = new Array;
		
		public var curPlayer:Person;
		
		
		public function Scene(resBack:Class, resMask:Class)
		{
			super();
			
			back = new resBack as Bitmap;
			imgMask = new resMask as Bitmap;
			
			addChild(back);
			
			setTimeout(onTimer, BaseDef.SCENE_UPDATE_TIME);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			addChild(layerBottom);
			addChild(layerDyn);
			addChild(layerTop);
		}
		
		public function addBottomObj(obj:BaseObj, x:int, y:int):void
		{
			obj.setXY(x, y);
			
			lstBottom.push(obj);
			
			layerBottom.addChild(obj);
		}
		
		public function addDynObj(obj:BaseObj, x:int, y:int):void
		{
			obj.setXY(x, y);
			
			lstDyn.push(obj);
			
			layerDyn.addChild(obj);
			
//			lstPerson.push(person);
//			
//			person.x = x;
//			person.y = y;
//			
//			addChild(person);
//			
//			if(person as Person)
//				curPlayer = person as Person;
		}
		
		public function addPerson(person:Person, x:int, y:int):void
		{
			person.setXY(x, y);
			
			lstDyn.push(person);
			
			layerDyn.addChild(person);
			
			curPlayer = person;
			
			person.scene = this;
		}		
		
		public function addTopObj(obj:BaseObj, x:int, y:int):void
		{
			obj.setXY(x, y);
			
			lstTop.push(obj);
			
			layerTop.addChild(obj);
		}		
		
		public function onTimer():void
		{
			var i:int;
			
			for(i = 0; i < lstTop.length; ++i)
			{
				if(lstTop[i] as BaseObj)
					(lstTop[i] as BaseObj).onUpdateAni(BaseDef.SCENE_UPDATE_TIME);
			}
			
			for(i = 0; i < lstDyn.length; ++i)
			{
				if(lstDyn[i] as BaseObj)
					(lstDyn[i] as BaseObj).onUpdateAni(BaseDef.SCENE_UPDATE_TIME);
			}
			
			for(i = 0; i < lstBottom.length; ++i)
			{
				if(lstBottom[i] as BaseObj)
					(lstBottom[i] as BaseObj).onUpdateAni(BaseDef.SCENE_UPDATE_TIME);
			}
			
			onUpdate();
			
			setTimeout(onTimer, BaseDef.SCENE_UPDATE_TIME);
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
		}		
		
		private function onMouseDown(e:MouseEvent):void
		{	
			if(curPlayer != null && canWalk(e.stageX, e.stageY + 10))
				curPlayer.moveTo(e.stageX, e.stageY + 10);
		}
		
		private function onUpdate():void
		{
			var i:int;
			
//			for(i = 0; i < lstPerson.length; ++i)
//			{
//				removeChild(lstPerson[i]);
//			}
//			
			for(i = 0; i < lstDyn.length; ++i)
			{
				layerDyn.removeChild(lstDyn[i]);
			}
			
			lstDyn.sort(_compare);
			
			for(i = 0; i < lstDyn.length; ++i)
			{
				layerDyn.addChild(lstDyn[i]);
			}
//			
//			for(i = 0; i < lstObj.length; ++i)
//			{
//				addChild(lstObj[i]);
//			}			
		}
		
		public function _compare(a:BaseObj, b:BaseObj):int
		{	
			return a.ly > b.ly ? 1 : -1;
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			MainLog.log.output("onMouseUp " + e.stageX + " " + e.stageY);
			
			var i:int = 0;
			
			for(i = 0; i < lstTop.length; ++i)
			{
				if((lstTop[lstTop.length - i - 1] as BaseObj) && 
					(lstTop[lstTop.length - i - 1] as BaseObj).isIn(e.stageX, e.stageY))
				{
					(lstTop[lstTop.length - i - 1] as BaseObj).onMouseUp(e);
					
					return ;
				}
			}
			
			for(i = 0; i < lstDyn.length; ++i)
			{
				if((lstDyn[lstDyn.length - i - 1] as BaseObj) && 
					(lstDyn[lstDyn.length - i - 1] as BaseObj).isIn(e.stageX, e.stageY))
				{
					(lstDyn[lstDyn.length - i - 1] as BaseObj).onMouseUp(e);
					
					return ;
				}
			}
			
			for(i = 0; i < lstBottom.length; ++i)
			{
				if((lstBottom[lstBottom.length - i - 1] as BaseObj) && 
					(lstBottom[lstBottom.length - i - 1] as BaseObj).isIn(e.stageX, e.stageY))
				{
					(lstBottom[lstBottom.length - i - 1] as BaseObj).onMouseUp(e);
					
					return ;
				}
			}			
			
//			++clickNums;
//			
//			MainLog.log.output("onMouseUp ");
//			
//			if(listener != null)
//				listener.onClick(this, objName, clickNums);
		}		
		
		public function canWalk(_x:int, _y:int):Boolean
		{
			if(imgMask != null)
			{
				var sx:int = int(_x / 15);
				var sy:int = int(_y / 15);
				
				return ((imgMask.bitmapData.getPixel32(sx, sy) >> 24) & 0xff) > 25;
			}
			
			return true;
		}
	}
}
