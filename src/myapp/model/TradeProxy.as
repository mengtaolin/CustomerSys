package myapp.model
{
	import com.app.vo.BaseVo;
	import com.app.vo.TradeVo;

	public class TradeProxy extends BaseProxy
	{
		public static const NAME:String = "TradeProxy";
		
		public function TradeProxy(data:Object=null)
		{
			super(NAME, data);
			this._configName = "tradeInfo";
		}
		
		override protected function newJsonData():BaseVo
		{
			return new TradeVo();
		}
	}
}