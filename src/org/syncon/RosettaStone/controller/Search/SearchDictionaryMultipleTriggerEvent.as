package   org.syncon.RosettaStone.controller.Search
{
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
 
	public class SearchDictionaryMultipleTriggerEvent extends Event
	{
		public static const SEARCH_DICTIONARY_MULTIPLE:String = 'SEARCH_dict_ult.';
		public var urlReq :  URLRequest;
		
		public var query : String;
		public var fxResult : Function;
		public var fxFault : Function; 
		public function SearchDictionaryMultipleTriggerEvent(type:String   , query : String , fxR : Function=null, fxF : Function = null) 
		{	
			this.query = query
			this.fxResult = fxR
			this.fxFault = fxF; 
			super(type, true);
		}
		
	 
	}
}