package myapp.model.vo
{
	public class TradeVo implements IJson
	{
		public var id:String;
		public var date:String;
		public var soldItemList:Vector.<SoldItemVo>
		public function TradeVo()
		{
			this.soldItemList = new Vector.<SoldItemVo>();
		}
		
		public function toJson():String
		{
			return JSON.stringify(this);
		}
		
		public function parseJson(jsonStr:String):void
		{
			var json:Object = JSON.parse(jsonStr);
			for(var key:String in json){
				if(key == "soldItemList"){
					var vo:SoldItemVo = new SoldItemVo();
					vo.parseJson(json[key]);
					this.soldItemList.push(vo);
				}
				this[key] = json[key];
			}
		}
	}
}