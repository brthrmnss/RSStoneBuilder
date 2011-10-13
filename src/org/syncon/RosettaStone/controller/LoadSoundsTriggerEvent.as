package   org.syncon.RosettaStone.controller
{
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
 
	public class LoadSoundsTriggerEvent extends Event
	{
		public static const LOAD_SOUNDS:String = 'LOAD_SOUNDS...';
		public var urlReq :  URLRequest;
		
		public var url : String;
		
		public function LoadSoundsTriggerEvent(type:String   , url : String='' ) 
		{	
			this.url = url
			super(type, true);
		}
		
	 
	}
}