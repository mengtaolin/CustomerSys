package myapp.model
{
	import com.app.vo.BaseVo;
	import com.app.vo.ItemTypeVo;

	public class ItemTypeProxy extends BaseProxy
	{
		public static const NAME:String = "ItemTypeProxy";
		
		public function ItemTypeProxy(data:Object=null)
		{
			super(NAME, data);
			this._configName = "types/itemTypes";
		}
		
		override protected function newJsonData():BaseVo
		{
			return new ItemTypeVo();
		}
	}
}