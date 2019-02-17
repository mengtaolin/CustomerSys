package myapp.model.vo
{
	public class CustomerVo implements IJson
	{
		public var id:String;
		public var name:String;
		public var phoneNo:String;
		public var address:String;
		public var picUrl:String;
		public var type:int;
		public var tradeInfoList:Vector.<TradeVo>;
		/**
		 * 创建的时间   年-月-日 时：分：秒
		 */
		public var createTime:String;
		public var modifierList:Vector.<CustomerModefierVo>;
		
		public function CustomerVo()
		{
			tradeInfoList = new Vector.<TradeVo>();
			modifierList = new Vector.<CustomerModefierVo>();
		}
		
		public function toJson():String
		{
			return JSON.stringify(this);
		}
		
		public function parseJson(jsonStr:String):void
		{
			var json:Object = JSON.parse(jsonStr);
			for(var key:String in json){
				if(key == ""){
					var tradeInfo:TradeVo = new TradeVo();
					tradeInfo.parseJson(json[key]);
				}
				else{
					this[key] = json[key];
				}
			}
		}
	}
}