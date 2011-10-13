package   org.syncon.RosettaStone.controller.Search
{
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
 
	public class SearchPronunciationsTriggerEvent extends Event
	{
		public static const SEARCH_IMAGES:String = 'SEARCH_pronunciations.';
		public var urlReq :  URLRequest;
		
		public var query : String;
		public var fxResult : Function;
		public var fxFault : Function; 
		public function SearchPronunciationsTriggerEvent(type:String   , query : String , fxR : Function=null, fxF : Function = null) 
		{	
			this.query = query
			this.fxResult = fxR
			this.fxFault = fxF; 
			super(type, true);
		}
		
	 
	}
}