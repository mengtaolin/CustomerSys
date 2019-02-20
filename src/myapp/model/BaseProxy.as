package myapp.model
{
	import com.app.global.ProxyResultType;
	import com.app.interfaces.IDataProxy;
	import com.app.interfaces.IProxyParser;
	import com.app.vo.BaseVo;
	
	import myapp.loader.ConfigFileManager;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class BaseProxy extends Proxy implements IDataProxy, IProxyParser
	{
		protected var _dataList:Vector.<BaseVo>;
		protected var _configName:String = "";
		
		public function BaseProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
			_dataList = new Vector.<BaseVo>();
		}
		
		public function parseInfos(data:String):void
		{
			if(data == null || data.length == 0){
				return;
			}
			var json:Object = JSON.parse(data);
			var len:int = json.length;
			for(var i:int = 0;i< len;i ++){
				var vo:BaseVo = this.newJsonData();
				vo.parseJsonObj(json[i]);
				this._dataList.push(vo);
			}
		}
		
		public function addData(data:BaseVo):int
		{
			if(this.findData(data.id) == null){
				this._dataList.push(data);
				var isSuccess:Boolean = ConfigFileManager.save(_configName, _dataList);
				if(isSuccess){
					return ProxyResultType.SUCCESS;
				}
				else{
					return ProxyResultType.OTHER_ERROR;
				}
			}
			return ProxyResultType.HAS_DATA_ERROR;
		}
		
		public function deleteData(id:String):Boolean
		{
			var index:int = findIndex(id);
			if(index != -1){
				this._dataList.splice(index, 1);
				return true;
			}
			return false;
		}
		
		public function modifierData(data:BaseVo):Boolean
		{
			var vo:BaseVo = this.findData(data.id);
			if(vo){
				vo.cloneFromeOther(data);
				return true;
			}
			return false;
		}
		
		public function findData(id:String):BaseVo
		{
			var resultVo:BaseVo = null;
			var len:int = _dataList.length;
			for(var i:int = 0;i < len;i ++){
				var vo:BaseVo = _dataList[i];
				if(vo.id == id){
					resultVo = vo;
					break;
				}
			}
			return resultVo;
		}
		
		protected function findIndex(id:String):int
		{
			var index:int = -1;
			var len:int = _dataList.length;
			for(var i:int = 0;i < len;i ++){
				var vo:BaseVo = _dataList[i];
				if(vo.id == id){
					index = i;
					break;
				}
			}
			return index;
		}
		
		public function findDataByName(name:String):BaseVo
		{
			var resultVo:BaseVo = null;
			var len:int = _dataList.length;
			for(var i:int = 0;i < len;i ++){
				var vo:BaseVo = _dataList[i];
				if(vo.name == name){
					resultVo = vo;
					break;
				}
			}
			return resultVo;
		}
		
		public function get dataList():Vector.<BaseVo>
		{
			return this._dataList;
		}
		
		protected function newJsonData():BaseVo
		{
			return new BaseVo();
		}
	}
}