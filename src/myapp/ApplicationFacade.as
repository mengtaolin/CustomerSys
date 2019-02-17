package myapp
{
	import myapp.controller.StartupCommand;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade
	{
		private static var _instance:ApplicationFacade;
		public static const APPNAME:String = "CustomerSys";
		
		public static const STARTUP:String = "startup";
		
		
		public function ApplicationFacade()
		{
			super(APPNAME);
		}
		
		public static function get instance():ApplicationFacade
		{
			if(_instance == null){
				_instance = new ApplicationFacade();
			}
			return _instance;
		}
		
		public function startUp(app:Object):void
		{
			this.sendNotification(STARTUP, app);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			this.registerCommand(STARTUP, StartupCommand);
		}
	}
}