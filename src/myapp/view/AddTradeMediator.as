package myapp.view
{
	import com.app.global.AppData;
	
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.BorderContainer;
	
	import myapp.view.components.AddTradePanel;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class AddTradeMediator extends Mediator
	{
		public static const NAME:String = "TradeMediator";
		
		public static const OPEN_TRADE_PANEL:String = "open_trade_panel";
		
		private var _panel:AddTradePanel;
		
		public function AddTradeMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				OPEN_TRADE_PANEL
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var type:String = notification.getName();
			switch(type){
				case OPEN_TRADE_PANEL:
					this.openPanel();
					break;
			}
		}
		
		private function openPanel():void
		{
			if(AppData.user == null){
				sendNotification(LoginOrRegiterMediator.OPEN_LOGIN_PANEL);
				return;
			}
			if(this._panel && this._panel.parent)return;
			this._panel = PopUpManager.createPopUp(mainCanvas, AddTradePanel, true) as AddTradePanel;
			PopUpManager.centerPopUp(_panel);
			initEvents();
		}
		
		private function initEvents():void
		{
			this._panel.addEventListener(CloseEvent.CLOSE, onClose);
		}
		
		protected function onClose(event:CloseEvent):void
		{
			this.removeLoginEvents();
			PopUpManager.removePopUp(_panel);
			_panel = null;
		}
		
		private function removeLoginEvents():void
		{
			this._panel.removeEventListener(CloseEvent.CLOSE, onClose);
		}
		
		private function get mainCanvas():BorderContainer
		{
			var app:CustomerSys = this.viewComponent as CustomerSys;
			return app.mainCanvas;
		}
	}
}