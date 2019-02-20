package myapp.events
{
	import flash.events.Event;
	
	public class AppEvent extends Event
	{
		/**
		 * 添加类型  add_type
		 */
		public static const ADD_TYPE:String = "add_type";
		
		
		public var data:Object = null;
		public function AppEvent(type:String, $data:Object = null)
		{
			super(type, false, false);
			this.data = $data;
		}
	}
}