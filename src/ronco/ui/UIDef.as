package ronco.ui
{
	public class UIDef
	{
		public static var UI_BUTTON:int			=	1;		//! 按钮
		public static var UI_MODULE:int			=	2;		//! 模块
		public static var UI_IMAGE:int			=	3;		//! 图片
		public static var UI_IMGNUMBER:int		=	4;		//! 数字图片
		public static var UI_TEXTINPUT:int  		=	5;		//! 输入控件
		public static var UI_CHECKBOX:int			=	6;		//! 单选按钮
		public static var UI_LABEL:int			=	7; 		//! 文本显示
		public static var UI_SECTOR:int  			= 	8;  	//! 扇形控件
		public static var UI_TEXTAREA:int			= 	9;   	//! 输出框显示
		public static var UI_MC_BUTTON:int		=	10;		//! 动画按钮（未完成）
		public static var UI_STATE_NUM:int		=	11;		//! 带状态数字图片（可以做固定位置钟使用）
		public static var UI_CARDLIST:int			=	12;		//! 牌序列（所有的牌类游戏可以共用）
		public static var UI_SCROLLLABEL:int		=	13;		//! 字体滚动
		public static var UI_IMAGECHANGE:int		=	14;		//! 帧动画
		public static var UI_SCROLLBAR:int		=	15;		//! 滚动条
		public static var UI_MOVIESWF:int			=	16;		//! swf动画
		public static var UI_DATAGRID:int			=	17;		//! 列表
		public static var UI_EMPTY:int			=	18;		//! Empty，一般作为临时节点或框架节点
		public static var UI_STATEIMG:int			=	19;		//! 可以根据状态切换显示图片的控件
		public static var UI_IMGNUMBER2:int		=	20;		//! 修改过的ImgNumber(邓忠)
		public static var UI_STATESWF:int			=	21;		//! SWF状态动画
		public static var UI_DLGMODULE:int		=	22;		//! 对话框模块
		public static var UI_SCROLLLABEL2:int		=	23;		//! 滚动label 2
		public static var UI_SCROLLLABELV:int		=	24;		//! 滚动label 垂直
		public static var UI_IMGNUMBER3:int		=	25;		
		public static var UI_SENDCARDLIST:int		=	26;		//! 出的牌	
		public static var UI_SENDCARDLIST2:int	=	27;		//! 发的牌
		public static var UI_IMGCONTAINER:int		=	28;		//! 图片容器
		public static var UI_ELECONTAINER:int		=	29;		//! Element容器，用来当列表控件
		public static var UI_MOVEIMAGE:int		=	30;		//! 移动的图片
		public static var UI_TREE:int				=	31;		//! Tree控件
		public static var UI_TEXTEX:int			=	32; 	//! 文本显示
		public static var UI_CD:int				=	33; 	//! CD
		public static var UI_CLICKOBJ:int			=	34; 	//! 鼠标点击对象
		public static var UI_RICHTEXTAREA:int		=	35; 	//! 图文混排文字框
		public static var UI_HOTSPOT:int			=	36; 	//! 热点区域
		public static var UI_COMBOBOX:int			=	37; 	//! 下拉框
		public static var UI_MULTEXTINPUT:int		=	38; 	//! 多行输入框
		public static var UI_SCROLLBAR_RTA:int	=	39;		//! richtextarea滚动条
		public static var UI_GIF:int				=	40;		//! UI_GIF
		public static var UI_COMBOBOXEX:int		=	41; 	//! 下拉框
		public static var UI_MENU:int				=	42; 	//! 弹出菜单
		public static var UI_TABTEXT:int			=	43; 	//! 列表方式显示的文本框
		public static var UI_LABEL2:int			=	44; 		//! 文本显示
		public static var UI_LABEL3:int			=	45; 		//! 文本显示
		
		
		public static var NOTIFY_CLICK_BTN:int					=	1;	//! UI侦听通知，按钮被按下
		public static var NOTIFY_MOUSEIN_BTN:int					=	2;	//! UI侦听通知，鼠标移入按钮区域
		public static var NOTIFY_CLOCK_OVER:int					=	3;	//! 钟时间到0事件
		public static var NOTIFY_MOUSEOUT_BTN:int					=	4; 	//! UI侦听通知，鼠标移出按钮区域
		public static var NOTIFY_CLICK_IMG:int					=	5; 	//! UI侦听通知，鼠标点击图片
		public static var NOTIFY_CLICK_LABEL:int					=	6; 	//! UI侦听通知，鼠标点击文字
		public static var NOTIFY_DOUBLECLICK_IMG:int				=	7;	//! UI侦听通知，双击图片
		public static var NOTIFY_KEY_ENTER:int					=	8;	//! UI侦听通知，双击图片
		public static var NOTIFY_KEY_TAB:int						=	9;	//! UI侦听通知，双击图片
		public static var NOTIFY_KEY_ESC:int						=	10;	//! UI侦听通知，双击图片
		public static var NOTIFY_FOCUS_GET:int					=	11;	//! UI侦听通知，双击图片
		public static var NOTIFY_CLICK_IMGCONTAINER:int			=	12;	//! UI侦听通知，鼠标点击图片容器区域
		public static var NOTIFY_SWAP_IMGCONTAINER:int			=	13;	//! UI侦听通知，图片交换		
		public static var NOTIFY_IN_IMGCONTAINER:int				=	14;	//! UI侦听通知，鼠标移上	
		public static var NOTIFY_OUT_IMGCONTAINER:int				=	15;	//! UI侦听通知，鼠标移出
		public static var NOTIFY_UP_IMGCONTAINER:int				=	16;	//! UI侦听通知，抓起图片	
		public static var NOTIFY_CHANGE:int						=	17; //! UI侦听通知，textInput change	
		public static var NOTIFY_CLICK_DISABLE_IMGCONTAINER:int	=	18; //! UI侦听通知，鼠标点击灰色图片容器区域
		public static var NOTIFY_CLICK_CLICKOBJ:int				=	19; 	//! UI侦听通知，鼠标点击图片
		public static var NOTIFY_FREE_IMGCONTAINER:int			=	20;	//! UI侦听通知，在控件外面松开鼠标
		public static var NOTIFY_DROP_IMGCONTAINER:int			=	21;	//! UI侦听通知，在控件外面松开鼠标，所有对话框和控件外面
		public static var NOTIFY_IN_HOTSPOT:int					=	22;	//! UI侦听通知，鼠标移上	
		public static var NOTIFY_OUT_HOTSPOT:int					=	23;	//! UI侦听通知，鼠标移出
		public static var NOTIFY_CLICK_HOTSPOT:int				=	24;	//! UI侦听通知，点击热点区域
		public static var NOTIFY_CMBBOX_CHANGE:int				=	25;	//! 下拉框改变
		public static var NOTIFY_DLG_OUTDOWNSOON:int				=	26;	//! 在对话框外面按下鼠标
		public static var NOTIFY_SWF_ANISTOP:int					=	27;	//! swf动画结束
		public static var NOTIFY_EDIT_FORCEIN:int					=	28;	//! edit控件获得焦点
		public static var NOTIFY_CLICK_MCSWF:int					=	29;	//! 点击动画
		public static var NOTIFY_DOUBLECLICK_IMGCONTAINER:int		=	30;	//! UI侦听通知，双击图片容器
		public static var NOTIFY_CLICK_GIF:int					=	31;	//! 点击GIF
		public static var NOTIFY_DBCLICK_HOTSPOT:int				=	32;	//! UI侦听通知，双击热点区域
		public static var NOTIFY_IN_MOD:int					=	33;	//! UI侦听通知，双击热点区域
		
		public function UIDef()
		{
		}
	}
}