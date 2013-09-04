package ronco.ui
{
	public class UICtrl
	{
		public static var KEY_STATE_NORMAL:int		=	0;
		public static var KEY_STATE_DOWN_SOON:int		=	1;
		public static var KEY_STATE_DOWN:int			=	2;
		public static var KEY_STATE_UP:int			=	3;
		public static var KEY_STATE_CLICK:int			=	4;
		public static var KEY_STATE_DOUBLECLICK:int	=	5;
		
		public var mx:int;
		public var my:int;
		public var delta:int = 0;
		
		public var stagex:int;
		public var stagey:int;
		
		public var lBtn:int;
		public var lBtnDown:Boolean;
		
		public function UICtrl()
		{
		}
	}
}