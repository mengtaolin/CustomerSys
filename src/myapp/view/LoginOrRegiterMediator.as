package myapp.view
{
	import com.adobe.crypto.MD5;
	import com.app.global.AppData;
	import com.app.global.RegistResultType;
	import com.app.vo.User;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.graphics.codec.JPEGEncoder;
	import mx.managers.PopUpManager;
	
	import spark.components.BorderContainer;
	
	import myapp.loader.ImageFileManager;
	import myapp.model.UserProxy;
	import myapp.operations.ImageChangeOpe;
	import myapp.view.components.LoginPanel;
	import myapp.view.components.RegistPanel;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class LoginOrRegiterMediator extends Mediator
	{
		public static const NAME:String = "LoginOrRegiterMediator";
		public static const START_APP:String = "start_app";
		public static const OPEN_LOGIN_PANEL:String = "open_login_panel";
		public static const OPEN_REGIST_PANEL:String = "open_regist_panel";
		
		private var _loginPanel:LoginPanel;
		private var _registPanel:RegistPanel;
		
		private var _registImgOpe:ImageChangeOpe;
		
		public function LoginOrRegiterMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			this._registImgOpe = new ImageChangeOpe();
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				START_APP,
				OPEN_LOGIN_PANEL,
				OPEN_REGIST_PANEL
			]
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var type:String = notification.getName();
			switch(type){
				case START_APP:
				case OPEN_LOGIN_PANEL:
					this.openLoginPanel();
					break;
				case OPEN_REGIST_PANEL:
					this.openRegistPanel();
					break;
			}
		}
		
		private function openLoginPanel():void
		{
			if(_loginPanel != null && this._loginPanel.stage != null)return;
			_loginPanel = PopUpManager.createPopUp(mainCanvas, LoginPanel, true) as LoginPanel;
			PopUpManager.centerPopUp(_loginPanel);
			initLoginEvents();
		}
		
		private function openRegistPanel():void
		{
			if(this._registPanel != null && this._registPanel.stage != null)return;
			this._registPanel = PopUpManager.createPopUp(mainCanvas, RegistPanel, true) as RegistPanel;
			PopUpManager.centerPopUp(_registPanel);
			initRegistEvents();
		}
		
		private function initLoginEvents():void
		{
			_loginPanel.addEventListener(CloseEvent.CLOSE, onLoginClose);
			_loginPanel.sumitBtn.addEventListener(MouseEvent.CLICK, onLogin);
			_loginPanel.registBtn.addEventListener(MouseEvent.CLICK, onOpenRegist);
			_loginPanel.addEventListener("enter_key", onLogin);
		}
		
		private function removeLoginEvents():void
		{
			_loginPanel.removeEventListener(CloseEvent.CLOSE, onLoginClose);
			_loginPanel.sumitBtn.removeEventListener(MouseEvent.CLICK, onLogin);
			_loginPanel.registBtn.removeEventListener(MouseEvent.CLICK, onOpenRegist);
		}
		
		private function initRegistEvents():void
		{
			_registPanel.addEventListener(CloseEvent.CLOSE, onRegiterClose);
			_registPanel.sumitBtn.addEventListener(MouseEvent.CLICK, onRegist);
			_registPanel.loginBtn.addEventListener(MouseEvent.CLICK, onOpenLogin);
			this._registImgOpe.image = _registPanel.userImg;
		}
		
		private function removeRegistEvents():void
		{
			_registPanel.removeEventListener(CloseEvent.CLOSE, onLoginClose);
			_registPanel.sumitBtn.removeEventListener(MouseEvent.CLICK, onLogin);
			_registPanel.loginBtn.removeEventListener(MouseEvent.CLICK, onOpenRegist);
			this._registImgOpe.removeImageEvent();
		}
		
		protected function onOpenLogin(event:MouseEvent):void
		{
			this.onRegiterClose(event);
			this.openLoginPanel();
		}
		
		protected function onOpenRegist(event:MouseEvent):void
		{
			this.onLoginClose(event);
			this.openRegistPanel();
		}
		
		protected function onLogin(event:Event):void
		{
			var userName:String = this._loginPanel.userName.text;
			var psw:String = MD5.hash(this._loginPanel.psw.text);
			var userProxy:UserProxy = this.facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var user:User = userProxy.login(userName, psw);
			if(user == null){
				Alert.show("登录失败");
			}
			else{
				AppData.user = user;
				this.onLoginClose(null);
				Alert.show("欢迎 " + user.name + " 登录");
			}
		}
		
		protected function onRegist(event:MouseEvent):void
		{
			var userName:String = this._registPanel.userName.text;
			if(userName.length < 2 || userName.length > 10){
				Alert.show("请输入2-10位长度用户姓名");
				return;
			}
			var proxy:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var tmpUser:User = proxy.findDataByName(userName) as User;
			if(tmpUser){
				var tips:String = this.registUserError(RegistResultType.HASUSER_ERROR);
				Alert.show(tips);
				return;
			}
			
			var psw:String = this._registPanel.psw.text;
			if(psw.length < 6){
				Alert.show("请输入最少6位密码");
				return;
			}
			var phoneNo:String  = this._registPanel.phoneNo.text;
			if(phoneNo.length != 11){
				Alert.show("请输入11位手机号码");
				return;
			}
			var index:int = this._registPanel.userType.selectedIndex;
			var typeData:Object = this._registPanel._typeList.source[index];
			var type:int = typeData.value;
			
			var user:User = new User();
			user.id = MD5.hash(getTimer() + userName);
			user.name = userName;
			user.authority = type + "";
			user.type = type;
			user.psw = MD5.hash(psw);
			user.phoneNo = phoneNo;
			var result:int = proxy.addData(user);
			if(result == 0){
				this.saveImg(user);
				this.onRegiterClose(null);
				this.openLoginPanel();
			}
			var alertStr:String = this.registUserError(result);
			Alert.show(alertStr);
		}
		
		private function registUserError(result:int):String
		{
			var tips:String = "用户注册失败！";
			switch(result){
				case RegistResultType.HASUSER_ERROR:
					tips = "该用户已存在，请重新命名";
					break;
				case RegistResultType.OTHER_ERROR:
					tips = "用户注册未知错误！";
					break;
				case RegistResultType.SUCCESS:
					tips = "用户注册成功";
					break;
			}
			return tips;
		}
		
		private function saveImg(user:User):void
		{
			var imgSource:BitmapData = this._registPanel.userImg.bitmapData;
			var encoder:JPEGEncoder = new JPEGEncoder(50);
			var byte:ByteArray = encoder.encode(imgSource);
			ImageFileManager.saveFile(byte, user.id);
		}
		
		protected function onLoginClose(event:Event):void
		{
			this.removeLoginEvents();
			PopUpManager.removePopUp(_loginPanel);
			_loginPanel = null;
		}
		
		protected function onRegiterClose(event:Event):void
		{
			this.removeRegistEvents();
			PopUpManager.removePopUp(this._registPanel);
			_registPanel = null;
		}
		
		private function get mainCanvas():BorderContainer
		{
			var app:CustomerSys = this.viewComponent as CustomerSys;
			return app.mainCanvas;
		}
	}
}