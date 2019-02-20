package myapp.model
{
	import com.app.vo.BaseVo;
	import com.app.vo.ItemVo;
	
	
	public class ItemProxy extends BaseProxy
	{
		public static const NAME:String = "ItemProxy";
		
		public function ItemProxy(data:Object=null)
		{
			super(NAME, data);
			this._configName = "itemInfo";
		}
		
		override protected function newJsonData():BaseVo
		{
			return new ItemVo();
		}
	}
}