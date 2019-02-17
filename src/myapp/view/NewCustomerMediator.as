package myapp.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.BorderContainer;
	
	import myapp.view.components.NewCustomerPanel;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class NewCustomerMediator extends Mediator
	{
		private static const NAME:String = "NewCustomerMediator";
		/**
		 * 打开新建用户界面
		 */
		public static const OPEN_NEW_CUSTOMER_PANEL:String = "open_new_customer_panel";
		/**
		 * 新建客户界面
		 */
		private var _panel:NewCustomerPanel;
		
		public function NewCustomerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				OPEN_NEW_CUSTOMER_PANEL
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var notifyName:String = notification.getName();
			switch(notifyName){
				case OPEN_NEW_CUSTOMER_PANEL:
					_panel = PopUpManager.createPopUp(mainCanvas, NewCustomerPanel, true) as NewCustomerPanel;
					PopUpManager.centerPopUp(_panel);
					initEvents();
					break;
			}
		}
		
		private function initEvents():void
		{
			_panel.addEventListener(CloseEvent.CLOSE, onClose);
			_panel.sumitBtn.addEventListener(MouseEvent.CLICK, onSumit);
			_panel.cancelBtn.addEventListener(MouseEvent.CLICK, onClose);
		}
		
		private function removeEvents():void
		{
			_panel.removeEventListener(CloseEvent.CLOSE, onClose);
			_panel.sumitBtn.removeEventListener(MouseEvent.CLICK, onSumit);
			_panel.cancelBtn.removeEventListener(MouseEvent.CLICK, onClose);
		}
		
		protected function onSumit(event:MouseEvent):void
		{
			
		}
		
		protected function onClose(event:Event):void
		{
			this.removeEvents();
			PopUpManager.removePopUp(_panel);
			_panel = null;
		}
		
		private function get mainCanvas():BorderContainer
		{
			var app:CustomerSys = this.viewComponent as CustomerSys;
			return app.mainCanvas;
		}
	}
}