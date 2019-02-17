package myapp.model
{
	import myapp.loader.ConfigFileStream;
	import myapp.model.vo.ConfigFileLoaderVo;
	import myapp.view.LoginOrRegiterMediator;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class FileProxy extends Proxy
	{
		public static const NAME:String = "FileProxy";
		private var _count:int = 0;
		private var _appInited:Boolean = false;
		private var _hasLoginOpen:Boolean = false;
		
		public function FileProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function loadFiles():void
		{
			this._count = 4;
			this.load("userInfo.lin", 0, UserProxy.NAME, onInfoComplete);
			this.load("customerInfo.lin", 1, CustomerProxy.NAME, onInfoComplete);
			this.load("itemInfo.lin", 2, ItemProxy.NAME, onInfoComplete);
			this.load("tradeInfo.lin", 3, TradeProxy.NAME, onInfoComplete);
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
		
		private function load(url:String, type:int, proxyName:String, completeFunc:Function):void
		{
			var vo:ConfigFileLoaderVo = new ConfigFileLoaderVo();
			vo.type = type;
			vo.url = url;
			vo.proxyName = proxyName;
			vo.complateFunc = completeFunc;
			vo.ioErrorFunc = this.onIoError;
			vo.securityFunc = this.onSecurityError;
			var loader:ConfigFileStream = new ConfigFileStream();
			loader.load(vo);
		}
	}
}