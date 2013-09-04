package ronco.ui
{
	import fl.events.InteractionInputType;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.ui.*;
	
	public class MovieClipSWF extends UIElement
	{
		public static const STAT_PLAYING:int	=	1;  //! flash状态 播放中
		public static const STAT_STOP:int		=	2;	//! flash状态 停止
		private var movieClip:MovieClip;
		private var isOnceFrame:Boolean=false;		//是否添加帧监听事件<处理影片是否只播放一次>
		private var proc:ListenerMovieClip = null;	//处理监听
		private var pname:String = null;				//动画标签
		public var state:int = STAT_STOP;				//状态
		//		
		private var curtimer:Number;
		private var begintimer:Number;
		private var maxTime:Number;
		
		//		/**
		//		 * 播放结束时调用
		//		 * 函数定义如下：onStop():void
		//		 **/ 
		//		public var funcOnStop:Function;
		
		public function MovieClipSWF(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_MOVIESWF, _name, _parent);
		}
		
		/**
		 * 注意，必须用这个接口设置坐标
		 **/ 
		public function setXY(_x:int, _y:int):void
		{
			x = _x;
			y = _y;
			
			//			if(movieClip != null)
			//			{
			//				movieClip.x = getRealX();
			//				movieClip.y = getRealY();
			//			}
		}
		
		// 数据初始化  返回false 表示初始化失败
		public function init(_res:Class,_isOnceFrame:Boolean=false):Boolean
		{
			movieClip = new _res as MovieClip;
			
			if(movieClip != null)
			{
				movieClip.stop();
				addChild(movieClip);
				
				if(_isOnceFrame)
				{
					isOnceFrame = _isOnceFrame;
					movieClip.addEventListener(Event.ENTER_FRAME,onStopFrame);
				}
			}				
			
			lw = movieClip.width;
			lh = movieClip.height;
			
			return movieClip!=null;
		}
		
		public function stop(_frame:int=0):void	
		{
			//			movieClip.gotoAndStop(_frame);
			stopFrame(movieClip, _frame);
			state = STAT_STOP;
			
			procUINotify(this, UIDef.NOTIFY_SWF_ANISTOP);
			//			if(funcOnStop != null)
			//				funcOnStop();
		}
		
		private function stopFrame(m:MovieClip, _frame:int):void
		{
			m.gotoAndStop(_frame);
			for(var i:int = 0; i < m.numChildren; ++i)
			{
				var o:MovieClip = m.getChildAt(i) as MovieClip;
				if(o == null)
					continue;
				
				stopFrame(o, _frame);
			}
		}
		
		public function start(_frame:int=0):void
		{
			playFrame(movieClip, _frame);
			//			movieClip.gotoAndPlay(_frame);
			state = STAT_PLAYING;
		}
		
		private function playFrame(m:MovieClip, _frame:int):void
		{
			m.gotoAndPlay(_frame);
			for(var i:int = 0; i < m.numChildren; ++i)
			{
				var o:MovieClip = m.getChildAt(i) as MovieClip;
				if(o == null)
					continue;
				
				playFrame(o, _frame);
			}
		}
		
		public function getInstance():MovieClip
		{
			return movieClip;
		}
		
		public function onStopFrame(evt:Event):void
		{
			if(state == STAT_STOP)
				return;
			if(movieClip.currentFrame == movieClip.totalFrames)
				//movieClip.stop();
				stop(movieClip.currentFrame);
		}
		
		public function statrOnce(_frame:int = 0):void
		{
			movieClip.addEventListener(Event.ENTER_FRAME,onStopFrame);
			start(_frame);
		}
		
		public function startOnceProc(listener:ListenerMovieClip, _name:String, _frame:int = 0):void
		{
			proc = listener;
			pname = _name;
			this.visible = true;
			movieClip.addEventListener(Event.ENTER_FRAME,onStopFrameProc);
			start(_frame);
		}
		
		public function onStopFrameProc(evt:Event):void
		{
			if(state == STAT_STOP)
				return;
			if(movieClip.currentFrame == movieClip.totalFrames)
			{
				//movieClip.stop();
				stop(movieClip.currentFrame);
				this.visible = false;
				if(proc != null && pname != null)
				{
					proc.MovieClipOver(pname);
					pname = null;
					proc = null;
				}	
			}
		}
		
		public function startOnceTimeProc(listener:ListenerMovieClip, _name:String, _maxTime:int, _frame:int = 0):void
		{
			proc = listener;
			pname = _name;
			maxTime = _maxTime;
			this.visible = true;
			movieClip.addEventListener(Event.ENTER_FRAME,onStopFrameTimeProc);
			
			begintimer = (new Date()).time;
			start(_frame);
		}
		//! 中断处理
		public function suspendProc():void
		{
			stop();
			this.visible = false;
			if(proc != null && pname != null)
			{
				proc.MovieClipOver(pname);
				pname = null;
				proc = null;
			}
		}
		
		public function onStopFrameTimeProc(evt:Event):void
		{
			curtimer = (new Date()).time;
			if(curtimer - begintimer >= maxTime)
			{
				stop();
				this.visible = false;
				if(proc != null && pname != null)
				{
					proc.MovieClipOver(pname);
					pname = null;
					proc = null;
				}
				return;
			}
			if(state == STAT_STOP)
				return;
			if(movieClip.currentFrame == movieClip.totalFrames)
			{
				//movieClip.stop();
				stop(movieClip.currentFrame);
				this.visible = false;
				if(proc != null && pname != null)
				{
					proc.MovieClipOver(pname);
					pname = null;
					proc = null;
				}	
			}			
		}
		
		public override function onCtrl(ctrl:UICtrl):Boolean
		{
			if(!enable)
				return false;
			
			if(isIn(ctrl.mx, ctrl.my))
			{
				Mouse.cursor = MouseCursor.BUTTON;
				
				if(ctrl.lBtn == UICtrl.KEY_STATE_DOWN_SOON)
				{
					procUINotify(this, UIDef.NOTIFY_CLICK_MCSWF);
				}
				
				return true;
			}
			else
			{
				Mouse.cursor = MouseCursor.AUTO;
			}
			
			return false;
		}
		
	}
}