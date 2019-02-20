package myapp.operations
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;
	
	import spark.components.Image;
	
	import myapp.loader.ImageFileManager;

	public class ImageSaveOpe
	{
		private static var _instance:ImageSaveOpe;
		
		public function ImageSaveOpe()
		{
		}
		
		private static function get instance():ImageSaveOpe
		{
			if(_instance == null){
				_instance = new ImageSaveOpe();
			}
			return _instance;
		}
		
		private function saveImage(id:String, image:Image):void
		{
			var imgSource:BitmapData = image.bitmapData;
			var encoder:JPEGEncoder = new JPEGEncoder(50);
			var byte:ByteArray = encoder.encode(imgSource);
			ImageFileManager.saveFile(byte, id);
		}
		
		public static function saveImage(id:String, image:Image):void
		{
			instance.saveImage(id, image);
		}
	}
}