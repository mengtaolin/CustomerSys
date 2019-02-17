package myapp.loader
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import myapp.model.vo.ConfigFileLoaderVo;

	public class ConfigFileLoader
	{
		private var _vo:ConfigFileLoaderVo;
		private var _loader:URLLoader;
		
		public function ConfigFileLoader()
		{
		}
		
		public function load(vo:ConfigFileLoaderVo):void
		{
			this._vo = vo;
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_loader.load(new URLRequest("configs/" + _vo.url));
		}
		
		protected function onSecurityError(event:SecurityErrorEvent):void
		{
			this.removeEvents();
			if(this._vo && this._vo.securityFunc != null){
				this._vo.securityFunc(_vo.type);
			}
		}
		
		protected function onIoError(event:IOErrorEvent):void
		{
			this.removeEvents();
			if(this._vo && this._vo.ioErrorFunc != null){
				this._vo.ioErrorFunc(_vo.type);
			}
		}
		
		protected function onComplete(event:Event):void
		{
			if(this._vo && this._vo.complateFunc != null){
				this._vo.complateFunc(_loader.data as String, _vo.proxyName);
			}
			this.removeEvents();
		}
		
		private function removeEvents():void
		{
			_loader.removeEventListener(Event.COMPLETE, onComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			this._loader.close();
			this._loader = null;
			if(this._vo){
				this._vo.dispose();
			}
			this._vo = null;
		}
	}
}