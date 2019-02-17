package myapp.global
{
	import myapp.model.vo.User;

	public class AppData
	{
		private static var _user:User;
		public function AppData()
		{
		}
		
		public static function set user(value:User):void
		{
			_user = value;
		}
		
		public static function get hasLogin():Boolean
		{
			return _user != null;
		}
	}
}