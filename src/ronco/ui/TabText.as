package ronco.ui
{
	import fl.controls.Label;
	
	import flash.filters.*;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.*;
	
	
	/**
	 * 列表方式显示的一组文本框，不含滚动条和边框，只有文字
	 **/ 
	public class TabText extends UIElement
	{
		/**
		 * 横向的数量，列数量
		 **/ 
		public var wnums:int;
		/**
		 * 行高
		 **/ 
		public var lineHeight:int;
		/**
		 * 每列的对齐
		 **/ 
		public var lstAlign:Vector.<String> = new Vector.<String>;
		/**
		 * 每列的宽度
		 **/ 
		public var lstWidth:Vector.<int> = new Vector.<int>;		
		/**
		 * 列表
		 **/ 
		public var lst:Vector.<Vector.<fl.controls.Label>> = new Vector.<Vector.<fl.controls.Label>>;
		/**
		 * 默认文字属性
		 **/ 
		private var format:TextFormat = new TextFormat(null, 12, 0xffffff);
		
		public var filterDropShadow:DropShadowFilter;
		
		/**
		 * construct
		 **/ 
		public function TabText(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_TABTEXT, _name, _parent);
		}
		
		/**
		 * 初始化 
		 **/ 
		public function init(_w:int, _bw:int, _lh:int):void
		{
			wnums = _w;
			lineHeight = _lh;
			
			var i:int = 0;
			while(i < _w)
			{
				lstAlign.push(TextFieldAutoSize.LEFT);
				lstWidth.push(_bw);
				++i;
			}
		}
		
		/**
		 * 清空数据
		 **/ 
		public function clear():void
		{
			var len:int = lst.length;
			
			var lstRow:Vector.<fl.controls.Label>;
			
			var i:int = 0;
			var j:int = 0;
			var maxj:int;

			while(i < len)
			{
				lstRow = lst[i];
				
				j = 0;
				maxj = lstRow.length;
				while(j < maxj)
				{
					lstRow[j].parent.removeChild(lstRow[j]);
					
					++j;
				}
				
				lstRow.splice(0, maxj);
				
				++i;
			}
			
			lst.splice(0, len);
		}
		
		/**
		 * 设置每列的对齐
		 **/ 
		public function setAlign(index:int, align:String = TextFieldAutoSize.LEFT):void
		{
			if(index >= 0 && index < wnums)
				lstAlign[index] = align;
		}
		
		/**
		 * 设置每列的宽度
		 **/ 
		public function setBlockWidth(index:int, bw:int):void
		{
			if(index >= 0 && index < wnums)
				lstWidth[index] = bw;
		}		
		
		/**
		 * 增加一行，返回该行的索引
		 **/ 
		public function addLine():int
		{
			var l:int = lst.length;
			
			var lstRow:Vector.<fl.controls.Label> = new Vector.<fl.controls.Label>;
			lst.push(lstRow);
			
			var i:int = 0;
			var tmpx:int = 0;
			
			while(i < wnums)
			{
				var lab:fl.controls.Label = new fl.controls.Label;
				
				lab.text = " ";
				
				lab.x = tmpx;
				tmpx += lstWidth[i];
				
				lab.y = l * lineHeight;
				var tf:TextFormat = new TextFormat;
				tf.color = format.color;
				tf.font = format.font;
				tf.size = format.size;
				tf.underline = format.underline;
				tf.bold = format.bold;
				lab.setStyle("textFormat", tf);
				lab.autoSize = lstAlign[i];
						
				lstRow.push(lab);
				
				addChild(lab);
				
				++i;
			}
			
			return l;
		}
		
		/**
		 * 设置字符串
		 **/ 
		public function setString(_bx:int, _by:int, _str:String):void
		{
			lst[_by][_bx].text = _str;
		}
		
		/**
		 * 设置默认字体颜色
		 **/ 
		public function setFontColor(_bx:int, _by:int, _color:uint):void
		{	
			var tf:TextFormat = lst[_by][_bx].getStyle("textFormat") as TextFormat;
			if(tf != null)
			{
				tf.color = _color;
				
				lst[_by][_bx].setStyle("textFormat", tf);
			}
		}		
		
		/**
		 * 设置默认字体颜色
		 **/ 
		public function setDefaultFontColor(_color:uint):void
		{	
			format.color = _color;
		}	
		
		/** 
		 * 设置字体和大小
		 **/
		public function setDefaultFont(_font:String, _fontsize:int):void
		{
			format.font = _font;
			format.size = _fontsize;
		}
		
		/** 
		 * 设置下划线
		 **/ 
		public function setDefaultUnderLine(bUseUnderLine:Boolean):void
		{
			format.underline = bUseUnderLine;			
		}
		
		/** 
		 * 设置粗体
		 **/ 
		public function setDefaultBold(bBold:Boolean):void
		{
			format.bold = bBold;
		}	
		
		/**
		 * 设置是否有描边
		 **/ 
		public function setBorder(_hasBorder:Boolean, _color:uint):void
		{
			var _lst:Array;
			
			if(_hasBorder)
			{
				_lst = filters;
				if(_lst == null)
					_lst = new Array;
				
				if(filterDropShadow != null)
					filterDropShadow.color = _color;
				else
					filterDropShadow = new DropShadowFilter(0, 0, _color, 1, 2, 2, 255);					
				
				_lst.push(filterDropShadow);
				
				filters = _lst;
			}
			else
			{
				_lst = filters;
				if(_lst != null)	
				{
					for(var i:int = 0; i < _lst.length; ++i)
					{
						if(_lst[i] == filterDropShadow)
						{
							_lst.splice(i, 1);
							
							break;
						}
					}
				}
				
				filters = _lst;
			}
		}		
	}
}
