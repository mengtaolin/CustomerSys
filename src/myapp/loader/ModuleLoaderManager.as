package myapp.loader
{
	import com.app.interfaces.IAppModule;
	import com.app.vo.ModuleLoadVo;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;

	public class ModuleLoaderManager
	{
		private static var _instance:ModuleLoaderManager;
		private var _loader:Loader;
		private var _vo:ModuleLoadVo;
		private var _isLoading:Boolean = false;
		private var _waitList:Vector.<ModuleLoadVo>;
		
		public function ModuleLoaderManager()
		{
			_loader = new Loader();
			_waitList = new Vector.<ModuleLoadVo>();
		}
		
		private static function get instance():ModuleLoaderManager
		{
			if(_instance == null){
				_instance = new ModuleLoaderManager();
			}
			return _instance;
		}
		
		public static function load(vo:ModuleLoadVo):void
		{
			instance.load(vo);
		}
		
		private function load(vo:ModuleLoadVo):void
		{
			if(this._isLoading){
				addIntoWaitList(vo);
				return;
			}
			this._vo = vo;
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurity);
			this._loader.load(new URLRequest(encodeURI(_vo.url)));
		}
		
		protected function onComplete(event:Event):void
		{
			trace(event);
			var module:IAppModule = event.currentTarget.content as IAppModule;
			if(_vo && _vo.complete != null){
				_vo.complete(module, _vo.params);
			}
			this.removeEvents();
			if(this._waitList.length > 0){
				this.load(_waitList.shift());//先进先出的顺序
			}
		}
		
		private function removeEvents():void
		{
			this._isLoading = false;
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurity);
		}
		
		protected function onIoError(event:IOErrorEvent):void
		{
			if(this._vo && this._vo.ioError != null){
				this._vo.ioError(_vo);
			}
			this.removeEvents();
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			if(this._vo && this._vo.progress != null){
				this._vo.progress(event.bytesTotal, event.bytesLoaded);
			}
		}
		
		protected function onSecurity(event:SecurityErrorEvent):void
		{
			if(this._vo && this._vo.securityError != null){
				this._vo.securityError(_vo);
			}
			this.removeEvents();
		}
		
		private function addIntoWaitList(vo:ModuleLoadVo):void
		{
			var len:int = this._waitList.length;
			var canAdd:Boolean = true;
			for(var i:int = 0;i < len;i ++){
				var tmpVo:ModuleLoadVo = this._waitList[i];
				if(tmpVo.url == vo.url){
					canAdd = false;
					break;
				}
			}
			if(canAdd){
				this._waitList.push(vo);
			}
		}
	}
}