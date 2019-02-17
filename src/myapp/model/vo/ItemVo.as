package myapp.model.vo
{
	/**
	 * 商品数据结构
	 * @author linmengtao
	 * 
	 */
	public class ItemVo implements IJson
	{
		public var id:String;
		/**
		 * 商品名字
		 */
		public var name:String;
		/**
		 * 出货价
		 */
		public var outPrice:Number = 1.0;
		/**
		 * 进货价
		 */
		public var inPrice:Number = 1.0;
		/**
		 * 折扣
		 */
		public var discount:Number = 1.0;
		/**
		 * 临时定价
		 */
		public var tempPrice:Number = 1.0;
		/**
		 * 出货定价类型，0为一般价格，1为折扣价，2为临时价格
		 */
		public var priceType:int;
		/**
		 * 商品类型
		 */
		public var type:int;
		/**
		 * 生产日期  年-月-日
		 */
		public var productionDate:String;
		/**
		 * 批次，此处暂时作为数据保留
		 */
		public var batchNo:String;
		/**
		 * 保存录入的日期  到天
		 */
		public var createDate:String;
		/**
		 * 保存录入的时间  时：分：秒
		 */
		public var createTime:String;
		
		public function ItemVo()
		{
		}
		
		public function toJson():String
		{
			return JSON.stringify(this);
		}
		
		public function parseJson(jsonStr:String):void
		{
			var json:Object = JSON.parse(jsonStr);
			for(var key:String in json){
				this[key] = json[key];
			}
		}
	}
}