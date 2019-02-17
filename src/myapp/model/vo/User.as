package myapp.model.vo
{
	public class User implements IJson
	{
		public var id:String;
		/**
		 * 名称
		 */
		public var name:String;
		public var psw:String;
		/**
		 * 手机号码
		 */
		public var phoneNo:String;
		/**
		 * 类型
		 */
		public var type:int;
		/**
		 * 权限
		 */
		public var authority:String;
		
		public function User()
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
		
		public function cloneFromeOther(value:User):void
		{
			this.id = value.id;
			this.name = value.name;
			this.psw = value.psw;
			this.phoneNo = value.phoneNo;
			this.type = value.type;
			this.authority = value.authority;
		}
		
		public function clone():User
		{
			var user:User = new User();
			var json:Object = JSON.parse(this.toJson());
			for(var key:String in json){
				user[key] = json[key];
			}
			return user;
		}
	}
}