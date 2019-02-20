package myapp.model
{
	import com.adobe.crypto.MD5;
	import com.app.global.RegistResultType;
	import com.app.vo.BaseVo;
	import com.app.vo.User;
	
	import myapp.loader.ConfigFileManager;
	
	public class UserProxy extends BaseProxy
	{
		public static const NAME:String = "UserProxy";
		private var _root:User;
		
		public function UserProxy(data:Object=null)
		{
			super(NAME, data);
			this._configName = "userInfo";
		}
		
		override public function parseInfos(data:String):void
		{
			_root = this.createRootUser();
			super.parseInfos(data);
		}
		
		override public function addData(value:BaseVo):int
		{
			if(this.findData(value.id) == null){
				if(this.findDataByName(value.name) != null){
					return RegistResultType.HASUSER_ERROR;
				}
				this._dataList.push(value);
				var isSuccess:Boolean = ConfigFileManager.save("userInfo", _dataList);
				return RegistResultType.SUCCESS;
			}
			return RegistResultType.OTHER_ERROR;
		}
		
		public function login(userName:String, psw:String):User
		{
			if(this.rootCheck(userName, psw))return _root;
			var user:User = this.findDataByName(userName) as User;
			if(user){
				if(user.psw == psw){
					return user;
				}
			}
			return null;
		}
		
		private function rootCheck(userName:String, psw:String):Boolean
		{
			return userName == _root.name && psw == _root.psw;
		}
		
		public function createRootUser():User
		{
			var root:User = new User();
			root.name = "root";
			root.psw = MD5.hash("httpslin");
			root.authority = "1000";
			root.type = 1000;
			return root;
		}
		
		override protected function newJsonData():BaseVo
		{
			return new User();
		}
	}
}