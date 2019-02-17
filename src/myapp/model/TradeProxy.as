package myapp.model
{
	import myapp.model.vo.TradeVo;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class TradeProxy extends Proxy implements IProxyParser
	{
		public static const NAME:String = "TradeProxy";
		
		private var _tradeList:Vector.<TradeVo>;
		public function TradeProxy(data:Object=null)
		{
			super(NAME, data);
			this._tradeList = new Vector.<TradeVo>();
		}
		
		public function parseInfos(data:String):void
		{
			trace(data);
			return;
		}
	}
}