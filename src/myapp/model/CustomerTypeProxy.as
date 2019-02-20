package myapp.model
{
	import com.app.vo.BaseVo;
	import com.app.vo.CustomerTypeVo;

	public class CustomerTypeProxy extends BaseProxy
	{
		public static const NAME:String = "CustomerTypeProxy";
		
		public function CustomerTypeProxy(data:Object=null)
		{
			super(NAME, data);
			this._configName = "types/customerTypes";
		}
		
		override protected function newJsonData():BaseVo
		{
			return new CustomerTypeVo();
		}
	}
}