package myapp.view
{
	import com.app.global.AppData;
	
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.BorderContainer;
	
	import myapp.view.components.AddItemPanel;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**
	 * 物品
	 * @author linmentao
	 * 
	 */
	public class AddItemMediator extends Mediator
	{
		public static const NAME:String = "ItemMediator";
		public static const OPEN_ITEM_PANEL:String = "open_item_panel";
		
		
		private var _panel:AddItemPanel;
		
		public function AddItemMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				OPEN_ITEM_PANEL
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var type:String = notification.getName();
			switch(type){
				case OPEN_ITEM_PANEL:
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
			this._panel = PopUpManager.createPopUp(mainCanvas, AddItemPanel, true) as AddItemPanel;
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