package   org.syncon.RosettaStone.controller.Search
{
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
 
	public class SearchDictionaryTriggerEvent extends Event
	{
		public static const SEARCH_DICTIONARY:String = 'SEARCH_dict.';
		public var urlReq :  URLRequest;
		
		public var query : String;
		public var fxResult : Function;
		public var fxFault : Function; 
		public var dontBreakWords:Boolean;
		public function SearchDictionaryTriggerEvent(type:String   , query : String , fxR : Function=null, fxF : Function = null, 
		dontBreakWordsAtSpaces:Boolean  = false) 
		{	
			this.query = query
			this.fxResult = fxR
			this.fxFault = fxF; 
			this.dontBreakWords = dontBreakWordsAtSpaces
			super(type, true);
		}
		
	 
	}
}