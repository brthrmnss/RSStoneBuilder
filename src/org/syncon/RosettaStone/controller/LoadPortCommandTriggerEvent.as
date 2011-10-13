package   org.syncon.RosettaStone.controller
{
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
 
	public class LoadPortCommandTriggerEvent extends Event
	{
		public static const LOAD_PORT:String = 'LOAD_PORT...';
		public var urlReq :  URLRequest;
		
		public var url : String;
		
		public function LoadPortCommandTriggerEvent(type:String   , url : String='' ) 
		{	
			this.url = url
			super(type, true);
		}
		
	 
	}
}