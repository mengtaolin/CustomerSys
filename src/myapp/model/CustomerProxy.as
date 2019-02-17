package myapp.model
{
	import myapp.model.vo.CustomerVo;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class CustomerProxy extends Proxy implements IProxyParser
	{
		public static const NAME:String = "CustomerProxy";
		
		private var _customerList:Vector.<CustomerVo>;
		public function CustomerProxy(data:Object=null)
		{
			super(NAME, data);
			this._customerList = new Vector.<CustomerVo>();
		}
		
		public function parseInfos(data:String):void
		{
			trace(data);
			return;
		}
	}
}