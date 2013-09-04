package ronco.ui
{
	import fl.controls.TextArea;
	//////////////////////////////////////////
	//
	// 功能说明：主要重写TextArea方法.灵活开发需求
	//
	//
	//		1：每次添加文本信息，滚动条自动移至最低端
	//
	//
	//////////////////////////////////////
	
	public class TextAreaOver extends TextArea
	{
		public function TextAreaOver()
		{
			super();
		}
		
		override public function set htmlText(arg0:String):void
		{
			super.htmlText = arg0;
			
			this.validateNow();
			
			if(textField)
			{
				this.verticalScrollPosition = textField.maxScrollV;
			}
		}
		
//		override public function set text(arg0:String):void
//		{
//			super.htmlText = arg0;
//			
//			this.validateNow();
//			
//			if(textField)
//			{
//				this.verticalScrollPosition = textField.maxScrollV;
//			}
//		}
	}
}