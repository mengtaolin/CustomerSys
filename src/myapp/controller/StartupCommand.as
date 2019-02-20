package myapp.controller
{
	import myapp.model.CustomerProxy;
	import myapp.model.CustomerTypeProxy;
	import myapp.model.FileProxy;
	import myapp.model.ItemProxy;
	import myapp.model.TradeProxy;
	import myapp.model.UserProxy;
	import myapp.view.AddCustomerMediator;
	import myapp.view.AddItemMediator;
	import myapp.view.AddTradeMediator;
	import myapp.view.LoginOrRegiterMediator;
	import myapp.view.MenuMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class StartupCommand extends SimpleCommand
	{
		public function StartupCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			trace("StartupCommand execute");
			super.execute(notification);
			var app:CustomerSys = notification.getBody() as CustomerSys;
			var appName:String = notification.getName();
			this.facade.registerProxy(new FileProxy());
			this.facade.registerProxy(new UserProxy());
			this.facade.registerProxy(new CustomerProxy());
			this.facade.registerProxy(new CustomerTypeProxy());
			this.facade.registerProxy(new ItemProxy());
			this.facade.registerProxy(new TradeProxy());
			this.facade.registerMediator(new MenuMediator(app));
			this.facade.registerMediator(new AddCustomerMediator(app));
			this.facade.registerMediator(new LoginOrRegiterMediator(app));
			this.facade.registerMediator(new AddItemMediator(app));
			this.facade.registerMediator(new AddTradeMediator(app));
			
			this.initApp();
		}
		
		private function initApp():void
		{
			var fileProxy:FileProxy = facade.retrieveProxy(FileProxy.NAME) as FileProxy;
			fileProxy.loadFiles();
		}
	}
}