package myapp.loader
{
	import com.app.global.FileType;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	
	import myapp.util.Base64;

	/**
	 * 配置文件内容读取和增删改查操作
	 * @author linmengtao
	 * 
	 */
	public class ConfigFileManager
	{
		private static var _instance:ConfigFileManager;
		
		private var _stream:FileStream;
		private var _nativePath:String;
		private var _decoder:Base64Decoder;
		private var _encoder:Base64Encoder;
		
		public function ConfigFileManager()
		{
			this._stream = new FileStream();
			this._nativePath = File.applicationDirectory.nativePath;
			this._decoder = new Base64Decoder();
			this._encoder = new Base64Encoder();
		}
		
		private static function get instance():ConfigFileManager
		{
			if(_instance == null){
				_instance = new ConfigFileManager();
			}
			return _instance;
		}
		
		private function loadFileByUrl(url:String):String
		{
			var file:File = File.applicationDirectory.resolvePath(_nativePath + "/configs/" + url + "." + FileType.CONFIG_TYPE);
			var jsonStr:String = "";
			if(file.exists){
				try{
					_stream.open(file, FileMode.READ);
					if(_stream.bytesAvailable > 0){
						_stream.position = 0;
						var byte:ByteArray = new ByteArray();
						_stream.readBytes(byte);
						_stream.close();
						byte.uncompress();
						jsonStr = byte.readUTFBytes(byte.bytesAvailable);
						jsonStr = Base64.decodeToStr(jsonStr);
					}
				}
				catch(e:Error){
					_stream.close();
					return jsonStr;
				}
			}
			return jsonStr;
		}
		
		public static function load(url:String):String
		{
			var data:String = instance.loadFileByUrl(url);
			return data;
		}
		
		private function saveData(url:String, data:Object):Boolean
		{
			var jsonStr:String = JSON.stringify(data);
			var file:File = File.applicationDirectory.resolvePath(_nativePath + "/configs/" + url + "." + FileType.CONFIG_TYPE);
			if(file.exists){
				try{
					jsonStr = Base64.encodeStr(jsonStr);
					var byte:ByteArray = new ByteArray();
					byte.writeUTFBytes(jsonStr);
					byte.compress();
					_stream.open(file, FileMode.WRITE);
					_stream.position = 0;
					_stream.writeBytes(byte);
					return true;
				}
				catch(e:Error){
					_stream.close();
					return false;
				}
			}
			return false;
		}
		
		public static function save(url:String, data:Object):Boolean
		{
			var isSuccess:Boolean = instance.saveData(url, data);
			return isSuccess;
		}
	}
}