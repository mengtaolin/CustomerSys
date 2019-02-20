package myapp.view
{
	import com.adobe.crypto.MD5;
	import com.app.global.ProxyResultType;
	import com.app.vo.CustomerTypeVo;
	import com.app.vo.CustomerVo;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.BorderContainer;
	
	import myapp.model.CustomerProxy;
	import myapp.model.CustomerTypeProxy;
	import myapp.operations.ImageChangeOpe;
	import myapp.operations.ImageSaveOpe;
	import myapp.view.components.AddCustomerPanel;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class AddCustomerMediator extends Mediator
	{
		private static const NAME:String = "NewCustomerMediator";
		/**
		 * 打开新建用户界面
		 */
		public static const OPEN_NEW_CUSTOMER_PANEL:String = "open_new_customer_panel";
		/**
		 * 新建客户界面
		 */
		private var _panel:AddCustomerPanel;
		private var _imgOpe:ImageChangeOpe;
		private var _typeVo:CustomerTypeVo;
		
		public function AddCustomerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			this._imgOpe = new ImageChangeOpe();
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
					this.openPanel();
					break;
			}
		}
		
		private function openPanel():void
		{
			if(this._panel != null && this._panel.stage != null)return;
			_panel = PopUpManager.createPopUp(mainCanvas, AddCustomerPanel, true) as AddCustomerPanel;
			PopUpManager.centerPopUp(_panel);
			initEvents();
		}
		
		private function initEvents():void
		{
			_panel.addEventListener(CloseEvent.CLOSE, onClose);
			_panel.sumitBtn.addEventListener(MouseEvent.CLICK, onSumit);
			_panel.cancleBtn.addEventListener(MouseEvent.CLICK, onClose);
//			_panel.addTypeBtn.addEventListener(MouseEvent.CLICK, onAddType);
			_panel.customerType.addEventListener(FocusEvent.FOCUS_OUT, onTypeFocusOut);
			this._imgOpe.image = this._panel.customerImg;
		}
		
		private function removeEvents():void
		{
			_panel.removeEventListener(CloseEvent.CLOSE, onClose);
			_panel.sumitBtn.removeEventListener(MouseEvent.CLICK, onSumit);
			_panel.cancleBtn.removeEventListener(MouseEvent.CLICK, onClose);
//			_panel.addTypeBtn.removeEventListener(MouseEvent.CLICK, onAddType);
			_panel.customerType.removeEventListener(FocusEvent.FOCUS_OUT, onTypeFocusOut);
			this._imgOpe.removeImageEvent();
		}
		
		protected function onSumit(event:MouseEvent):void
		{
			var name:String = this._panel.customerName.text;
			if(name.length < 2 || name.length > 10){
				Alert.show("请输入2-10位长度用户姓名");
				return;
			}
			var phone:String = this._panel.phoneNo.text;
			if(phone.length < 10 || phone.length > 11){
				Alert.show("请输入10-11位联系电话");
				return;
			}
			if(this._panel.dataList.length == 0){
				Alert.show("请选择客户类型！");
				return;
			}
			
			var index:int = this._panel.customerType.selectedIndex;
			var typeData:CustomerTypeVo = this._panel.dataList[index] as CustomerTypeVo;
			if(typeData.name == null || typeData.name.length == 0){
				Alert.show("请选择客户类型！");
				return;
			}
			var type:int = typeData.value;
			var addr:String = this._panel.customerAddr.text;
			var customer:CustomerVo = new CustomerVo();
			customer.createTime = getTimer() + "";
			customer.id = MD5.hash(customer.createTime + name);
			customer.name = name;
			customer.phoneNo = phone;
			customer.type = type;
			customer.address = addr;
			customer.typeVo = typeData;
			
			var proxy:CustomerProxy = facade.retrieveProxy(CustomerProxy.NAME) as CustomerProxy;
			var result:int = proxy.addData(customer);
			if(result == ProxyResultType.SUCCESS){
				ImageSaveOpe.saveImage(customer.id, this._panel.customerImg);
				this.onClose(null);
			}
			var tips:String = this.getResultTips(result);
			Alert.show(tips);
		}
		
		protected function onTypeFocusOut(event:FocusEvent):void
		{
			if(this._typeVo == null)return;
			if(this._typeVo.name == null && this._typeVo.name.length == 0)
			{
				var index:int = this._panel.dataList.indexOf(this._typeVo);
				if(index != -1){
					this._panel.dataList.splice(index, 1);
				}
				return; 
			}
			var proxy:CustomerTypeProxy = facade.retrieveProxy(CustomerTypeProxy.NAME) as CustomerTypeProxy;
			proxy.addData(this._typeVo);
			this._panel.customerType.textInput.editable = false;
			this._typeVo = null;
		}
		
		private function getResultTips(result:int):String
		{
			var tips:String = "添加客户失败！";
			switch(result){
				case ProxyResultType.SUCCESS:
					tips = "添加客户成功！";
					break;
				case ProxyResultType.HAS_DATA_ERROR:
					tips = "该客户已存在！";
					break;
				case ProxyResultType.OTHER_ERROR:
					tips = "添加客户错误！";
					break;
			}
			return tips;
		}
		
		protected function onAddType(event:MouseEvent):void
		{
			this._panel.customerType.textInput.editable = true;
			_typeVo = new CustomerTypeVo();
			_typeVo.id = this._panel.dataList.length + "";
			_typeVo.value = int(_typeVo.id);
			this._panel.dataList.push(_typeVo);
			if(this._panel.stage){
				this._panel.stage.focus = this._panel.customerType.textInput;
			}
			this._panel.customerType.selectedIndex = this._panel.dataList.length - 1;
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