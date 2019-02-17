package myapp.model.vo
{
	public interface IJson
	{
		function toJson():String;
		function parseJson(jsonStr:String):void;
	}
}