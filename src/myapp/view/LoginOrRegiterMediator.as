package myapp.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.BorderContainer;
	
	import myapp.global.AppData;
	import myapp.model.UserProxy;
	import myapp.model.vo.User;
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
		
		public function LoginOrRegiterMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
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
			if(_loginPanel && this._loginPanel.parent)return;
			_loginPanel = PopUpManager.createPopUp(mainCanvas, LoginPanel, true) as LoginPanel;
			PopUpManager.centerPopUp(_loginPanel);
			initLoginEvents();
		}
		
		private function openRegistPanel():void
		{
			if(this._registPanel && this._registPanel.parent)return;
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
		}
		
		private function removeRegistEvents():void
		{
			_registPanel.removeEventListener(CloseEvent.CLOSE, onLoginClose);
			_registPanel.sumitBtn.removeEventListener(MouseEvent.CLICK, onLogin);
			_registPanel.loginBtn.removeEventListener(MouseEvent.CLICK, onOpenRegist);
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
			var psw:String = this._loginPanel.psw.text;
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