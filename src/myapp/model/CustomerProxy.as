package myapp.model
{
	import com.app.vo.BaseVo;
	import com.app.vo.CustomerVo;
	
	
	public class CustomerProxy extends BaseProxy
	{
		public static const NAME:String = "CustomerProxy";
		
		public function CustomerProxy(data:Object=null)
		{
			super(NAME, data);
			this._configName = "customerInfo";
		}
		override protected function newJsonData():BaseVo
		{
			return new CustomerVo();
		}
	}
}