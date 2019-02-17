package myapp.model.vo
{
	public class CustomerModefierVo implements IJson
	{
		public var id:String;
		/**
		 * 最后修改时间  年-月-日 时：分：秒
		 */
		public var modifierTime:String;
		/**
		 * 谁修改了
		 */
		public var whoModifier:String;
		
		public function CustomerModefierVo()
		{
		}
		
		public function toJson():String
		{
			return JSON.stringify(this);
		}
		
		public function parseJson(jsonStr:String):void
		{
		}
	}
}