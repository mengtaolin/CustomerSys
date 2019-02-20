package myapp.operations
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import mx.controls.Alert;
	
	import spark.components.Image;

	/**
	 * 专门用户图片更换操作的业务逻辑处理类。<br/>
	 * 将用于封装该业务，哪里需要放哪里
	 * @author linmengtao
	 * 
	 */
	public class ImageChangeOpe
	{
		private var _image:Image;
		private var _fileRef:FileReference;
		private var _fileFilter:FileFilter = new FileFilter("选择头像,*.png,*.jpg,*.JPG", "*.png;*jpg;*JPG");
		private var _isSelecting:Boolean = false;
		
		public function ImageChangeOpe()
		{}
		
		public function set image(value:Image):void
		{
			if(this._image){
				this._image.removeEventListener(MouseEvent.CLICK, onImageClick);
			}
			this._image = value;
			this._image.addEventListener(MouseEvent.CLICK, onImageClick);
		}
		
		protected function onImageClick(event:MouseEvent):void
		{
			if(this._isSelecting == true){
				return;
			}
			if(_fileRef == null){
				_fileRef = new FileReference();
			}
			_fileRef.addEventListener(Event.SELECT, onImgSelect);
			_fileRef.addEventListener(Event.CANCEL, onSelectFileCancel);
			_fileRef.addEventListener(Event.COMPLETE, onFileComplete);
			_fileRef.addEventListener(IOErrorEvent.IO_ERROR, onFileIoErorr);
			_fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFileSecurityError);
			this._isSelecting = true;
			_fileRef.browse([_fileFilter]);
		}
		
		protected function onImgSelect(event:Event):void
		{
			var size:int = this._fileRef.size;
			if(size / 1024 / 1024 > 2){
				this.removeFileEvents();
				Alert.show("请选择小于2M的图片");
				return;
			}
			this._fileRef.load();
		}
		
		protected function onFileIoErorr(event:IOErrorEvent):void
		{
			this.removeFileEvents();
		}
		
		protected function onFileComplete(event:Event):void
		{
			this.removeFileEvents();
			this._image.source = _fileRef.data;
		}
		
		protected function onSelectFileCancel(event:Event):void
		{
			this.removeFileEvents();
		}
		
		protected function onFileSecurityError(event:SecurityErrorEvent):void
		{
			this.removeFileEvents();
		}
		
		private function removeFileEvents():void
		{
			_fileRef.removeEventListener(Event.SELECT, onImgSelect);
			_fileRef.removeEventListener(Event.CANCEL, onSelectFileCancel);
			_fileRef.removeEventListener(Event.COMPLETE, onFileComplete);
			_fileRef.removeEventListener(IOErrorEvent.IO_ERROR, onFileIoErorr);
			_fileRef.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onFileSecurityError);
			this._isSelecting = false;
		}
		
		public function removeImageEvent():void
		{
			if(this._image){
				this._image.removeEventListener(MouseEvent.CLICK, onImageClick);
			}
			this._image = null;
		}
		
		public function dispose():void
		{
			this.removeImageEvent();
			_fileRef = null;
			_fileFilter = null;
		}
	}
}