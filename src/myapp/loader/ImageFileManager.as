package myapp.loader
{
	import com.app.global.FileType;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class ImageFileManager
	{
		private static var _instance:ImageFileManager
		private var _stream:FileStream;
		private var _nativePath:String;
		public function ImageFileManager()
		{
			this._stream = new FileStream();
			this._nativePath = File.applicationDirectory.nativePath;
		}
		
		public static function get instance():ImageFileManager
		{
			if(_instance == null){
				_instance = new ImageFileManager();
			}
			return _instance;
		}
		
		private function save(byte:ByteArray, fileName:String, fileType:String):Boolean
		{
			var file:File = File.applicationDirectory.resolvePath(_nativePath + "/images/" + fileName + "." + fileType);
			try{
				this._stream.open(file, FileMode.UPDATE);
				this._stream.writeBytes(byte);
				this._stream.close();
				return true;
			}
			catch(e:Error){
				this._stream.close();
				return false;
			}
			return false;
		}
		
		public static function saveFile(byte:ByteArray, fileName:String, fileType:String = FileType.JPG):Boolean
		{
			var isSuccess:Boolean = instance.save(byte, fileName, fileType);
			return isSuccess;
		}
		
		private function getFileByteArray(fileName:String, fileType:String = FileType.JPG):ByteArray
		{
			var byte:ByteArray = null;
			var file:File = File.applicationDirectory.resolvePath(_nativePath + "/images/" + fileName + "." + fileType);
			if(file.exists == false){
				file = File.applicationDirectory.resolvePath(_nativePath + "/images/default/headerImg.png");
			}
			try{
				byte = new ByteArray();
				this._stream.open(file, FileMode.READ);
				this._stream.readBytes(byte);
				this._stream.close();
			}
			catch(e:Error){
				this._stream.close();
				return byte;
			}
			return byte;
		}
		
		public static function getFile(fileName:String, fileType:String = FileType.JPG):ByteArray
		{
			var byte:ByteArray = instance.getFileByteArray(fileName, fileType);
			return byte;
		}
	}
}

