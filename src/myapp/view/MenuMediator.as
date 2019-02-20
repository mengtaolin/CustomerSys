package myapp.view
{
	import com.app.interfaces.IAppModule;
	import com.app.interfaces.IAppModuleData;
	import com.app.vo.ModuleLoadVo;
	
	import mx.controls.MenuBar;
	import mx.events.MenuEvent;
	
	import myapp.loader.ModuleLoaderManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MenuMediator extends Mediator
	{
		private static const NAME:String = "MenuMediator";
		/**
		 * 打印操作
		 */
		public static const PRINT:String = "print";
		
		public function MenuMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			this.menuBar.addEventListener(MenuEvent.ITEM_CLICK, onItemClick);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				PRINT	
			]
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var type:String = notification.getName();
			switch(type){
				case PRINT:
					this.loadPrintModule();
					break;
			}
		}
		
		protected function onItemClick(event:MenuEvent):void
		{
			if(event.item == null && (event.item is XML) == false){
				return;
			}
			var itemName:String = event.item.@name;
			switch(itemName){
				case "login":
					sendNotification(LoginOrRegiterMediator.OPEN_LOGIN_PANEL);
					break;
				case "regist":
					sendNotification(LoginOrRegiterMediator.OPEN_REGIST_PANEL);
					break;
				case "addItem":
					this.sendNotification(AddItemMediator.OPEN_ITEM_PANEL);
					break;
				case "addCustomer":
					this.sendNotification(AddCustomerMediator.OPEN_NEW_CUSTOMER_PANEL);
					break;
				case "addTrade":
					break;
				case PRINT:
					this.loadPrintModule()
					break;
				case "exit":
					break;
				case "help":
					break;
				case "about":
					break;
			}
			
		}
		
		private function loadPrintModule():void
		{
			var vo:ModuleLoadVo = new ModuleLoadVo();
			vo.complete = loadComplete;
			vo.url = "Printer.swf";
			ModuleLoaderManager.load(vo);
		}
		
		private function loadComplete(module:IAppModule, data:IAppModuleData):void
		{
			module.startup(data);
		}
		
		public function get menuBar():MenuBar
		{
			var app:CustomerSys = this.viewComponent as CustomerSys;
			return app.menuBar;
		}
	}
}