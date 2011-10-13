package   org.syncon.RosettaStone.controller.Search
{
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.syncon.RosettaStone.vo.SearchVO;
 
	public class SearchImagesTriggerEvent extends Event
	{
		public static const SEARCH_IMAGES:String = 'SEARCH_IMAGES...';
		public static const GET_COPYRIGHT:String = 'GET_COPYRIGHT...';
		public var urlReq :  URLRequest;
		
		public var query : String;
		public var fxResult : Function;
		public var fxFault : Function; 
		
		static public const FLICKR : String = 'FLICKR'; 
		
		static public const MSN : String = 'MSN'; 
		public var service:String;
		public var page:int;
		public var search : SearchVO; /**
		 * search result return earlier, to pull copy right 
		 * */
		public function SearchImagesTriggerEvent(type:String   , query : String , fxR : Function=null, 
												 fxF : Function = null, service : String =
		 MSN, page : int = 0 ) 
		{	
			this.query = query
			this.fxResult = fxR
			this.fxFault = fxF; 
			this.service = service; 
			this.page = page; 
			super(type, true);
		}
		static public function GetCopyright(  search : SearchVO , fxR : Function=null 
		) : SearchImagesTriggerEvent
		{	
			var event : SearchImagesTriggerEvent = new SearchImagesTriggerEvent(
				SearchImagesTriggerEvent.GET_COPYRIGHT, '', fxR, null, null, 0);
			event.search = search
			return event; 
		}
		
	}
}