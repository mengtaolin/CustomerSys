package myapp.model
{
	import myapp.model.vo.User;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class UserProxy extends Proxy implements IProxyParser
	{
		public static const NAME:String = "UserProxy";
		private var _userList:Vector.<User>;
		
		public function UserProxy(data:Object=null)
		{
			super(NAME, data);
			_userList = new Vector.<User>();
		}
		
		public function parseInfos(data:String):void
		{
			trace(data);
			return;
			var root:User = this.createRootUser();
			this._userList.push(root);
			if(data == null || data.length == 0){
				return;
			}
			var json:Object = JSON.parse(data);
			var list:Array = json._userList;
			var len:int = list.length;
			for(var i:int = 0;i< len;i ++){
				var user:User = new User();
				user.parseJson(list[i]);
				this._userList.push(user);
			}
		}
		
		public function addUser(value:User):Boolean
		{
			if(this.findUser(value.id) == null){
				this._userList.push(value);
				this.saveUsers();
				return true;
			}
			return false;
		}
		
		private function saveUsers():void
		{
			var jsonStr:String = JSON.stringify(this._userList);
			
		}
		
		public function deleteUser(id:String):Boolean
		{
			var user:User = this.findUser(id);
			if(user){
				var index:int = this._userList.indexOf(user);
				if(index != -1){
					this._userList.splice(index, 1);
					return true;
				}
				else{
					return false;
				}
			}
			return false;
		}
		
		public function modifierUser(value:User):Boolean
		{
			var user:User = this.findUser(value.id);
			if(user){
				user.cloneFromeOther(value);
				return true;
			}
			return false;
		}
		
		public function findUser(id:String):User
		{
			var len:int = _userList.length;
			for(var i:int = 0;i < len;i ++){
				var user:User = _userList[i];
				if(user.id == id){
					return user;
				}
			}
			return null;
		}
		
		public function findUserByName(userName:String):User
		{
			var len:int = _userList.length;
			for(var i:int = 0;i < len;i ++){
				var user:User = _userList[i];
				if(user.name == userName){
					return user;
				}
			}
			return null;
		}
		
		public function login(userName:String, psw:String):User
		{
//			if(this.rootCheck(userName, psw))return true;
			var user:User = this.findUserByName(userName);
			if(user){
				if(user.psw == psw){
					return user;
				}
			}
			return null;
		}
		
		private function rootCheck(userName:String, psw:String):Boolean
		{
			return userName == "root" && psw == "httpslin";
		}
		
		public function get userList():Vector.<User>
		{
			return this._userList;
		}
		
		public function createRootUser():User
		{
			var root:User = new User();
			root.name = "root";
			root.psw = "httpslin";
			root.authority = "1000";
			root.type = 1000;
			return root;
		}
	}
}