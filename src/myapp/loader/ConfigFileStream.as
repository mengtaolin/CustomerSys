package myapp.loader
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import myapp.model.vo.ConfigFileLoaderVo;

	public class ConfigFileStream
	{
		private var _vo:ConfigFileLoaderVo;
		
		public function ConfigFileStream()
		{
		}
		
		public function load(vo:ConfigFileLoaderVo):void
		{
			this._vo = vo;
			var path:String = File.applicationDirectory.nativePath + "/configs/" + vo.url;
			try{
				
				var file:File = File.applicationDirectory.resolvePath(path);
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.READ);
				stream.position = 0;
				var jsonStr:String = "";
				if(stream.bytesAvailable > 0){
					jsonStr = stream.readUTFBytes(stream.bytesAvailable);
				}
				if(vo.complateFunc != null){
					vo.complateFunc(jsonStr, vo.proxyName);
				}
			}
			catch(e:Error){
				if(_vo.ioErrorFunc != null){
					_vo.ioErrorFunc(_vo.type);
				}
			}
			stream.close();
			stream = null;
		}
		
		public function updateFile(vo:ConfigFileLoaderVo):void
		{
			
		}
	}
}