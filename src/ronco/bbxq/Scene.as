package ronco.bbxq
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.*;
	
	import ronco.base.*;
	import ronco.ui.*;

	///////////////////////////////////////////////////////////////
	// 场景类
	// 一张场景底图，并管理场景内所有对象
	//////////////////////////////////////////////////////////////		
	public class Scene extends Sprite implements ListenerCtrl
	{
		public var back:Bitmap;
		public var backRect:Rectangle = new Rectangle;
		
		public var imgMask:Bitmap;
		
		public var layerShadow:Sprite = new Sprite;
		public var layerBottom:Sprite = new Sprite;
		public var layerDyn:Sprite = new Sprite;
		public var layerTop:Sprite = new Sprite;
		
		public var lstBottom:Vector.<BaseObj> = new Vector.<BaseObj>;
		public var lstDyn:Vector.<BaseObj> = new Vector.<BaseObj>;
		public var lstTop:Vector.<BaseObj> = new Vector.<BaseObj>;
		
		public var lstMapArea:Vector.<BaseObj> = new Vector.<BaseObj>;
		//public var lstDynSort:Vector.<BaseObj> = new Vector.<BaseObj>;
		
		//public var lstObj:Array = new Array;
		//public var lstPerson:Array = new Array;
		
		public var curPlayer:Person;
		
		public var grid:AStar_Grid = new AStar_Grid;
		
		public var curObj:BaseObj;						// 当前点中的对象
		
		public var listener:SceneLogicListener;
		
		//public var timerid:uint = 0;
		
		public var aniClick:MovieClip;
		
		
		public function Scene(resBack:Class, resMask:Class)
		{
			super();
			
			back = new resBack as Bitmap;
			imgMask = new resMask as Bitmap;
			
			grid.makeWithBitmap(imgMask.bitmapData);
			
			addChild(back);
			
			//addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			//addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			addChild(layerShadow);
			addChild(layerBottom);
			addChild(layerDyn);
			addChild(layerTop);
		}
		
		public function setClickAni(res:Class):void
		{
			if(aniClick != null)
			{
				removeChild(aniClick);
				
				aniClick = null;
			}
			
			aniClick = new res as MovieClip;
			
			addChild(aniClick);
			
			aniClick.visible = false;
		}
		
		public function endScene():void
		{
			var i:int;
			for(i = 0; i < lstDyn.length; )
			{
				if(lstDyn[i] as Person)
				{
					(lstDyn[i] as Person).stopMove();
					
					Base.safeRemoveChild(layerDyn, lstDyn[i]);
					
					lstDyn.splice(i, 1);
				}
				else
					++i;
			}
			
			if(curPlayer != null)
				curPlayer.stopMove();
			
			removePerson(curPlayer);
			
			curPlayer = null;
			
			parent.removeChild(this);
			
//			if(timerid != 0)
//			{
//				clearTimeout(timerid);
//				
//				timerid = 0;
//			}
			
			visible = false;
		}
		
		public function beginScene(layer:DisplayObjectContainer):void
		{
			layer.addChild(this);
			
			visible = true;
			
			//timerid = setTimeout(onTimer, BaseDef.SCENE_UPDATE_TIME);
		}
		
		public function addBottomObj(obj:BaseObj, x:int, y:int):void
		{
			obj.setXY(x, y);
			
			lstBottom.push(obj);
			
			layerBottom.addChild(obj);
			
			obj.scene = this;
		}
		
		public function addDynObj(obj:BaseObj, x:int, y:int):void
		{
			obj.setXY(x, y);
			
			lstDyn.push(obj);
			
			layerDyn.addChild(obj);
			
			obj.scene = this;
		}
		
		public function addPerson(person:Person, x:int, y:int):void
		{
			person.stopMove();
			
			removePerson(person);
			
			person.setXY(x, y);
			
			lstDyn.push(person);
			
			layerDyn.addChild(person);
			
			person.scene = this;
		}
		
		public function removePerson(person:Person):void
		{
			var i:int;
			for(i = 0; i < lstDyn.length; ++i)
			{
				if(lstDyn[i] == person)
				{
					lstDyn.splice(i, 1);
					
					break;
				}
			}
			
			Base.safeRemoveChild(layerDyn, person);
			
			if(curPlayer == person)
				curPlayer = null;
		}
		
		public function setActPlayer(person:Person):void
		{
			curPlayer = person;
		}
		
		public function addTopObj(obj:BaseObj, x:int, y:int):void
		{
			obj.setXY(x, y);
			
			lstTop.push(obj);
			
			layerTop.addChild(obj);
			
			obj.scene = this;
		}
		
		public function addShadow(obj:BaseObj, resname:String):void
		{
			obj.setShadow(layerShadow, resname);
		}
		
		public function onTimer(offtime:int):void
		{
			//timerid = 0;
			
			if(!visible)
				return ;
			
			if(listener != null)
				listener.onUpdate(offtime);
			
			var i:int;
			
			for(i = 0; i < lstTop.length; ++i)
			{
				if(lstTop[i] as BaseObj)
					(lstTop[i] as BaseObj).onUpdateAni(offtime);
			}
			
			for(i = 0; i < lstDyn.length; ++i)
			{
				if(lstDyn[i] as BaseObj)
					(lstDyn[i] as BaseObj).onUpdateAni(offtime);
			}
			
			for(i = 0; i < lstBottom.length; ++i)
			{
				if(lstBottom[i] as BaseObj)
					(lstBottom[i] as BaseObj).onUpdateAni(offtime);
			}
			
			onUpdate();
			
			//timerid = setTimeout(onTimer, BaseDef.SCENE_UPDATE_TIME);
		}
		
		public function onMouseOver(e:MouseEvent):Boolean
		{
			var i:int = 0;
			
			for(i = 0; i < lstTop.length; ++i)
			{
				if((lstTop[lstTop.length - i - 1] as BaseObj) &&
					(lstTop[lstTop.length - i - 1] as BaseObj).isProcMouseInOut() &&
					!(lstTop[lstTop.length - i - 1] as BaseObj).isIn(e.stageX, e.stageY))
				{
					if((lstTop[lstTop.length - i - 1] as BaseObj).isMouseIn)
						(lstTop[lstTop.length - i - 1] as BaseObj).onMouseOut(e);
				}
			}
			
			for(i = 0; i < lstDyn.length; ++i)
			{
				if((lstDyn[lstDyn.length - i - 1] as BaseObj) &&
					(lstDyn[lstDyn.length - i - 1] as BaseObj).isProcMouseInOut() &&
					!(lstDyn[lstDyn.length - i - 1] as BaseObj).isIn(e.stageX, e.stageY))
				{
					if((lstDyn[lstDyn.length - i - 1] as BaseObj).isMouseIn)
						(lstDyn[lstDyn.length - i - 1] as BaseObj).onMouseOut(e);
				}
			}
			
			for(i = 0; i < lstBottom.length; ++i)
			{
				if((lstBottom[lstBottom.length - i - 1] as BaseObj) &&
					(lstBottom[lstBottom.length - i - 1] as BaseObj).isProcMouseInOut() &&
					!(lstBottom[lstBottom.length - i - 1] as BaseObj).isIn(e.stageX, e.stageY))
				{
					if((lstBottom[lstBottom.length - i - 1] as BaseObj).isMouseIn)
						(lstBottom[lstBottom.length - i - 1] as BaseObj).onMouseOut(e);
				}
			}			
			
			for(i = 0; i < lstTop.length; ++i)
			{
				if((lstTop[lstTop.length - i - 1] as BaseObj) && 
					(lstTop[lstTop.length - i - 1] as BaseObj).isProcMouseInOut() &&
					(lstTop[lstTop.length - i - 1] as BaseObj).isIn(e.stageX, e.stageY))
				{
					if(!(lstTop[lstTop.length - i - 1] as BaseObj).isMouseIn)
						(lstTop[lstTop.length - i - 1] as BaseObj).onMouseIn(e);
					
					return false;
				}
			}
			
			for(i = 0; i < lstDyn.length; ++i)
			{
				if((lstDyn[lstDyn.length - i - 1] as BaseObj) &&
					(lstDyn[lstDyn.length - i - 1] as BaseObj).isProcMouseInOut() &&
					(lstDyn[lstDyn.length - i - 1] as BaseObj).isIn(e.stageX, e.stageY))
				{
					if(!(lstDyn[lstDyn.length - i - 1] as BaseObj).isMouseIn)
						(lstDyn[lstDyn.length - i - 1] as BaseObj).onMouseIn(e);
					
					return false;
				}
			}
			
			for(i = 0; i < lstBottom.length; ++i)
			{
				if((lstBottom[lstBottom.length - i - 1] as BaseObj) &&
					(lstBottom[lstBottom.length - i - 1] as BaseObj).isProcMouseInOut() &&
					(lstBottom[lstBottom.length - i - 1] as BaseObj).isIn(e.stageX, e.stageY))
				{
					if(!(lstBottom[lstBottom.length - i - 1] as BaseObj).isMouseIn)
						(lstBottom[lstBottom.length - i - 1] as BaseObj).onMouseIn(e);
					
					return false;
				}
			}		
			
			return false;
		}		
		
		public function onMouseDown(e:MouseEvent):Boolean
		{	
			if(UIMgr.singleton.lstModal.length > 0)
				return false;
			
			if(e.stageX <= 0 || e.stageX >= 960 || e.stageY <= 0 || e.stageY >= 560)
				return false;
			
			if(curPlayer != null)
			{
				curPlayer.moveTo(e.stageX, e.stageY + 10);
				
				if(listener != null)
				{
					listener.onIMove(e.stageX, e.stageY + 10);
				}
				
				if(aniClick != null && curPlayer.astar.path.length > 0)
				{
					var _x:int = curPlayer.astar.path[curPlayer.astar.path.length - 1].x * 15;
					var _y:int = curPlayer.astar.path[curPlayer.astar.path.length - 1].y * 15;
					
					aniClick.visible = true;
					
					aniClick.x = _x - aniClick.width / 2;
					aniClick.y = _y - aniClick.height / 2;
				}
			}
			
			return false;
		}
		
		public function onMouseWheel(e:MouseEvent):Boolean
		{	
			return false;	
		}
		
		public function onKeyDown(e:KeyboardEvent):Boolean
		{	
			return false;
		}
		
		public function onDoubleClick(e:MouseEvent):Boolean
		{	
			return false;
		}
		
		private function onUpdate():void
		{
			var i:int;
			var j:int;
			var bChg:Boolean = false;
			var tmp:BaseObj;
			
			if(lstDyn.length >= 2)
			{
				for(i = 0; i < lstDyn.length - 1; ++i)
				{
					for(j = i + 1; j < lstDyn.length; ++j)
					{
						if(lstDyn[i].ly > lstDyn[j].ly)
						{
							tmp = lstDyn[i];
							lstDyn[i] = lstDyn[j];
							lstDyn[j] = tmp;
							
							bChg = true;
						}
					}
				}
			}
			
			if(bChg)
			{
				while(layerDyn.numChildren > 0)
					layerDyn.removeChildAt(0);		
				
				for(j = 0; j < lstDyn.length; ++j)
				{
					layerDyn.addChild(lstDyn[j]);
				}					
			}
			
			if(curObj != null && curPlayer != null)
			{
				if(Math.abs(curObj.lx - curPlayer.lx) <= curPlayer.lw * 2 && 
					Math.abs(curObj.ly - curPlayer.ly) <= curPlayer.lw * 2)
				{
					curObj.onClick();
					
					curObj = null;
				}
			}
			
			if(curPlayer != null)
			{
				for(i = 0; i < lstMapArea.length; ++i)
				{
					if(lstMapArea[i].isIn(curPlayer.lx, curPlayer.ly))
					{
						if(listener != null)
						{
							listener.onInMapArea(lstMapArea[i]);
						}
						
						(lstMapArea[i] as BaseObj_MapArea).isPlayerIn = true;
						
						break;
					}
					else
						(lstMapArea[i] as BaseObj_MapArea).isPlayerIn = false;
				}
			}
		}
		
		public function _compare(a:BaseObj, b:BaseObj):int
		{	
			return a.ly >= b.ly ? 1 : -1;
		}
		
		public function onMouseUp(e:MouseEvent):Boolean
		{
			//MainLog.singleton.output("onMouseUp " + e.stageX + " " + e.stageY);
			
			var i:int = 0;
			
			for(i = 0; i < lstTop.length; ++i)
			{
				if((lstTop[lstTop.length - i - 1] as BaseObj) && 
					(lstTop[lstTop.length - i - 1] as BaseObj).isIn(e.stageX, e.stageY) &&
					(lstTop[lstTop.length - i - 1] as BaseObj).listener != null)
				{
					if((lstTop[lstTop.length - i - 1] as BaseObj).isPersonNear)
						curObj = (lstTop[lstTop.length - i - 1] as BaseObj); 
					else
						(lstTop[lstTop.length - i - 1] as BaseObj).onMouseUp(e);
					
					return false;
				}
			}
			
			for(i = 0; i < lstDyn.length; ++i)
			{
				if((lstDyn[lstDyn.length - i - 1] as BaseObj) && 
					(lstDyn[lstDyn.length - i - 1] as BaseObj).isIn(e.stageX, e.stageY) &&
					(lstDyn[lstDyn.length - i - 1] as BaseObj).listener != null)
				{
					if((lstDyn[lstDyn.length - i - 1] as BaseObj).isPersonNear)
						curObj = (lstDyn[lstDyn.length - i - 1] as BaseObj); 
					else
						(lstDyn[lstDyn.length - i - 1] as BaseObj).onMouseUp(e);
					
					return false;
				}
			}
			
			for(i = 0; i < lstBottom.length; ++i)
			{
				if((lstBottom[lstBottom.length - i - 1] as BaseObj) && 
					(lstBottom[lstBottom.length - i - 1] as BaseObj).isIn(e.stageX, e.stageY) &&
					(lstBottom[lstBottom.length - i - 1] as BaseObj).listener != null)
				{
					if((lstBottom[lstBottom.length - i - 1] as BaseObj).isPersonNear)
						curObj = (lstBottom[lstBottom.length - i - 1] as BaseObj); 
					else
						(lstBottom[lstBottom.length - i - 1] as BaseObj).onMouseUp(e);
					
					return false;
				}
			}
			
			return false;
		}		
		
		public function onMouseOut(e:MouseEvent):Boolean
		{
			return false;
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
		
		public function findObj(_name:String):BaseObj
		{
			var i:int = 0;
			
			for(i = 0; i < lstTop.length; ++i)
			{
				if((lstTop[i] as BaseObj) && (lstTop[i] as BaseObj).objName == _name)
					return (lstTop[i] as BaseObj); 
			}			
			
			for(i = 0; i < lstDyn.length; ++i)
			{
				if((lstDyn[i] as BaseObj) && (lstDyn[i] as BaseObj).objName == _name)
					return (lstDyn[i] as BaseObj); 
			}			
			
			for(i = 0; i < lstBottom.length; ++i)
			{
				if((lstBottom[i] as BaseObj) && (lstBottom[i] as BaseObj).objName == _name)
					return (lstBottom[i] as BaseObj); 
			}	
			
			return null;
		}
	}
}
