package ronco.ui
{// 绘制扇形
	public class Sector extends UIElement
	{
		
		public var m_r:Number; //圆半径
		private var m_x0:Number; //圆心横坐标
		private var m_y0:Number; //圆心纵坐标
		private var m_a0:Number; //起始角度 0度开始顺时针方向
		private var m_lineWidth:Number; //线条宽度
		private var m_lineColor:Number; //线条颜色
		private var m_fillColor:Number; //填充颜色
		
		public function Sector(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_SECTOR, _name, _parent);
		}
		
		// 初始化信息
		public function init(_x:Number,_y:Number,_r:Number,_a0:Number,_a:Number,_lineWidth:Number=1,_lineColor:Number=0x906A26,_fillColor:Number=0x9D7B2B):void
		{
			m_x0 = _x;
			m_y0 = _y;
			m_r = _r;
			m_a0 = _a0*Math.PI/180;
			m_lineWidth = _lineWidth;
			m_lineColor = _lineColor;
			m_fillColor = _fillColor;
			if(_a>0&&_a<=360) 
			{
				drawSector(_a);
			}
		}
		
		private function drawSector(_angle:Number):void
		{
			this.graphics.lineStyle(m_lineWidth,m_lineColor);
			this.graphics.beginFill(m_fillColor);
			this.graphics.moveTo(m_x0,m_y0);
			this.graphics.lineTo(m_x0+m_r*Math.cos(m_a0),m_y0+m_r*Math.sin(m_a0)); //曲线绘制起始点
			
			var n:uint = Math.floor(_angle/45); //分段绘制接近Bezier曲线的曲线，分段越细，曲线越接近真实圆弧线
			var _a0:Number = m_a0; //记录初始角度
			while(n-->0){
				_a0+=Math.PI/4;
				this.graphics.curveTo(m_x0+m_r/Math.cos(Math.PI/8)*Math.cos(_a0-Math.PI/8),m_y0+m_r/Math.cos(Math.PI/8)*Math.sin(_a0-Math.PI/8),m_x0+m_r*Math.cos(_a0),m_y0+m_r*Math.sin(_a0));			
			}
			if(_angle%45){
				var am:Number = _angle%45*Math.PI/180;
				this.graphics.curveTo(m_x0+m_r/Math.cos(am/2)*Math.cos(_a0+am/2),m_y0+m_r/Math.cos(am/2)*Math.sin(_a0+am/2),m_x0+m_r*Math.cos(_a0+am),m_y0+m_r*Math.sin(_a0+am));
			}
			this.graphics.lineTo(m_x0,m_y0);
			this.graphics.endFill();
		}
		
		// 半径   /   初始角度   /   角度增量
		public function drawSec(_r:Number,_angle:Number,_ainc:Number):void
		{
			if(_ainc>0 && _ainc<=360){
				m_r = _r;
				m_a0 = _angle*Math.PI/180;
				this.graphics.clear();
				drawSector(_ainc);
			}
		}
		
		// 清理信息
		public function clear():void
		{
			this.graphics.clear();
		}
		
		// 设置填充色度
		public function setFillColor(_color:uint):void
		{
			m_fillColor = _color;
		}
		
		public function setLineColor(_color:uint):void
		{
			m_lineColor = _color;
		}
		
		public function setLineWidth(_color:uint):void
		{
			m_lineWidth = _color;
		}
	}
}