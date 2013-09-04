package ronco.ui
{
	import fl.controls.DataGrid;
	import fl.controls.dataGridClasses.DataGridColumn;

	public class DataGrid extends UIElement
	{
		private var datagrid:fl.controls.DataGrid = new fl.controls.DataGrid();
		
		public function DataGrid(_name:String, _parent:UIElement)
		{
			super(UIDef.UI_DATAGRID, _name, _parent);
		}
		
		/***
		 * @ 初始化列表数据
		 * 
		 * @ _columns -- 列表头数据
		 * 
		 * @ _row -- 显示行数
		 * 
		 * @ _w -- 列表宽度
		 * 
		 * */
		public function init(_columns:Array,_rowCount:uint,_w:Number):void
		{
			datagrid.width = _w;
			datagrid.columns = _columns;
			datagrid.rowCount = _rowCount;
			
			datagrid.resizableColumns = false;//无法更改列长
			datagrid.sortableColumns = false;//无法排序

			addChild(datagrid);
		}
		
		// 控件换肤
		public function setStyle(style:Object):void
		{
			if(style["downArrowDisabledSkin"] != null)
				datagrid.setStyle("downArrowDisabledSkin", style["downArrowDisabledSkin"]);
			
			if(style["downArrowDownSkin"] != null)
				datagrid.setStyle("downArrowDownSkin", style["downArrowDownSkin"]);
			
			if(style["downArrowOverSkin"] != null)
				datagrid.setStyle("downArrowOverSkin", style["downArrowOverSkin"]);
			
			if(style["downArrowUpSkin"] != null)
				datagrid.setStyle("downArrowUpSkin", style["downArrowUpSkin"]);
			
			if(style["upArrowDisabledSkin"] != null)
				datagrid.setStyle("upArrowDisabledSkin", style["upArrowDisabledSkin"]);
			
			if(style["upArrowDownSkin"] != null)
				datagrid.setStyle("upArrowDownSkin", style["upArrowDownSkin"]);
			
			if(style["upArrowOverSkin"] != null)
				datagrid.setStyle("upArrowOverSkin", style["upArrowOverSkin"]);
			
			if(style["upArrowUpSkin"] != null)
				datagrid.setStyle("upArrowUpSkin", style["upArrowUpSkin"]);
			
			if(style["thumbDisabledSkin"] != null)
				datagrid.setStyle("thumbDisabledSkin", style["thumbDisabledSkin"]);
			
			if(style["thumbDownSkin"] != null)
				datagrid.setStyle("thumbDownSkin", style["thumbDownSkin"]);
			
			if(style["thumbOverSkin"] != null)
				datagrid.setStyle("thumbOverSkin", style["thumbOverSkin"]);
			
			if(style["thumbUpSkin"] != null)
				datagrid.setStyle("thumbUpSkin", style["thumbUpSkin"]);
			
			if(style["trackDisabledSkin"] != null)
				datagrid.setStyle("trackDisabledSkin", style["trackDisabledSkin"]);
			
			if(style["trackDownSkin"] != null)
				datagrid.setStyle("trackDownSkin", style["trackDownSkin"]);
			
			if(style["trackOverSkin"] != null)
				datagrid.setStyle("trackOverSkin", style["trackOverSkin"]);
			
			if(style["trackUpSkin"] != null)
				datagrid.setStyle("trackUpSkin", style["trackUpSkin"]);

			if(style["headerTextFormat"] != null)
				datagrid.setStyle("headerTextFormat", style["headerTextFormat"]);
			
			if(style["headerTextPadding"] != null)
				datagrid.setStyle("headerTextPadding", style["headerTextPadding"]);
			
			if(style["skin"] != null)
				datagrid.setStyle("skin", style["skin"]);
			
			if(style["cellRenderer"] != null)
				datagrid.setStyle("cellRenderer", style["cellRenderer"]);
			
			if(style["headerRenderer"] != null)
				datagrid.setStyle("headerRenderer", style["headerRenderer"]);
			
		}
		
		public function getInstance():fl.controls.DataGrid
		{
			return datagrid;
		}
		
		// 设置大小
		public function setSize(_w:int,_h:int):void
		{
			datagrid.width = _w;
			datagrid.height = _h;
		}
		
		// 设置标题栏高度
		public function setHeadHeight(_h:Number):void
		{
			datagrid.headerHeight = _h;
		}
		
		// 获取索引下 列
		public function getColumnAt(_arg0:uint):DataGridColumn
		{
			return datagrid.getColumnAt(_arg0);
		}
		
		public function addItem(_arg0:Object):void
		{
			datagrid.addItem(_arg0);
			
		}
		
		public function removeItem(_arg0:Object):void
		{
			datagrid.removeItem(_arg0);	
		}
		
		public function removeItemat(_arg0:uint):void
		{
			datagrid.removeItemAt(_arg0);
		}
		
		// 能否排序
		public function sortableColumns(arg0:Boolean):void
		{
			datagrid.sortableColumns = arg0;
		}
		
		// 能否更改列的长度
		public function resizableColumns(arg0:Boolean):void
		{
			datagrid.resizableColumns = arg0;
		}
	}
}