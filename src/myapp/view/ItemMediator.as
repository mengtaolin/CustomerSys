package myapp.view
{
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.BorderContainer;
	
	import myapp.view.components.ItemRecordPanel;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**
	 * 物品
	 * @author linmentao
	 * 
	 */
	public class ItemMediator extends Mediator
	{
		public static const NAME:String = "ItemMediator";
		public static const OPEN_ITEM_PANEL:String = "open_item_panel";
		
		
		private var _panel:ItemRecordPanel;
		
		public function ItemMediator(viewComponent:Object=null)
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
			if(this._panel && this._panel.parent)return;
			this._panel = PopUpManager.createPopUp(mainCanvas, ItemRecordPanel, true) as ItemRecordPanel;
			PopUpManager.centerPopUp(_panel);
			initEvents();
		}
		
		private function initEvents():void
		{
			this._panel.addEventListener(CloseEvent.CLOSE, onClose);
		}
		
		protected function onClose(event:CloseEvent):void
		{
			
		}		
		
		private function get mainCanvas():BorderContainer
		{
			var app:CustomerSys = this.viewComponent as CustomerSys;
			return app.mainCanvas;
		}
	}
}