package myapp.model
{
	import com.app.interfaces.IProxyParser;
	
	import myapp.loader.ConfigFileManager;
	import myapp.view.LoginOrRegiterMediator;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class FileProxy extends Proxy
	{
		public static const NAME:String = "FileProxy";
		private var _appInited:Boolean = false;
		private var _hasLoginOpen:Boolean = false;
		
		public function FileProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function loadFiles():void
		{
			var userStr:String = ConfigFileManager.load("userInfo");
			this.onInfoComplete(userStr, UserProxy.NAME);
			
			var customerStr:String = ConfigFileManager.load("customerInfo");
			this.onInfoComplete(customerStr, CustomerProxy.NAME);
			
			var itemInfoStr:String = ConfigFileManager.load("itemInfo");
			this.onInfoComplete(itemInfoStr, ItemProxy.NAME);
			
			var tradeInfoStr:String = ConfigFileManager.load("tradeInfo");
			this.onInfoComplete(tradeInfoStr, TradeProxy.NAME);
		}
		
		protected function onInfoComplete(data:String, proxyName:String):void
		{
			var proxy:IProxyParser = this.facade.retrieveProxy(proxyName) as IProxyParser;
			proxy.parseInfos(data);
		}
		
		protected function onIoError(type:int):void
		{
			var fileName:String = this.getFileNameByType(type);
			trace(fileName + "加载失败");
		}
		
		protected function onSecurityError(type:int):void
		{
			var fileName:String = this.getFileNameByType(type);
			trace(fileName + "加载安全沙箱冲突");
		}
		
		private function getFileNameByType(type:int):String
		{
			var fileName:String = "";
			switch(type){
				case 0:
					fileName = "用户信息";
					break;
				case 1:
					fileName = "客户信息";
					break;
				case 2:
					fileName = "商品信息";
					break;
				case 3:
					fileName = "交易信息";
					break;
			}
			return fileName;
		}
		
		public function set appInit(value:Boolean):void
		{
			this._appInited = value;
			sendNotification(LoginOrRegiterMediator.START_APP);
		}
	}
}