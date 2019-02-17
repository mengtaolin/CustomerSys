package myapp.model.vo
{
	public class SoldItemVo implements IJson
	{
		public var id:String;
		public var name:String;
		public var count:int;
		public var price:Number = 0.0;
		public var productionDate:String;
		public var type:int;
		
		public function SoldItemVo()
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