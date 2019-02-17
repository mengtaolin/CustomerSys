package myapp.view
{
	import mx.controls.MenuBar;
	import mx.events.MenuEvent;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MenuMediator extends Mediator
	{
		private static const NAME:String = "MenuMediator";
		
		public function MenuMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			this.menuBar.addEventListener(MenuEvent.ITEM_CLICK, onItemClick);
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
					break;
				case "addCustomer":
					this.sendNotification(NewCustomerMediator.OPEN_NEW_CUSTOMER_PANEL);
					break;
				case "addTrade":
					break;
				case "exit":
					break;
				case "help":
					break;
				case "about":
					break;
			}
			
		}
		
		public function get menuBar():MenuBar
		{
			var app:CustomerSys = this.viewComponent as CustomerSys;
			return app.menuBar;
		}
	}
}