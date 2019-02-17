package myapp.model.vo
{
	public class ConfigFileLoaderVo
	{
		public var type:int;
		public var url:String;
		public var proxyName:String;
		public var complateFunc:Function;
		public var ioErrorFunc:Function;
		public var securityFunc:Function;
		
		public function ConfigFileLoaderVo()
		{
		}
		
		public function dispose():void
		{
			this.url = null;
			this.complateFunc = null;
			this.ioErrorFunc = null;
			this.securityFunc = null;
		}
	}
}