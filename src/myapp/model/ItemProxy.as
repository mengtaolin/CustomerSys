package myapp.model
{
	import myapp.model.vo.ItemVo;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class ItemProxy extends Proxy implements IProxyParser
	{
		public static const NAME:String = "ItemProxy";
		
		private var _itemList:Vector.<ItemVo>;
		public function ItemProxy(data:Object=null)
		{
			super(NAME, data);
			this._itemList = new Vector.<ItemVo>();
		}
		
		public function parseInfos(data:String):void
		{
			trace(data);
			return;
		}
	}
}