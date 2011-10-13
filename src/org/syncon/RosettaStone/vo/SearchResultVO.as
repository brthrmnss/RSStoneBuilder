package  org.syncon.RosettaStone.vo
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayList;
	
	/**
	 * Used by searchers
	 * */
	
	[RemoteClass]
	public class SearchResultVO  extends EventDispatcher
	{
		public var name :  String = ''; // = true
	 
		public var url : String = ''; 
		public var data:String;
		public var results : Array = []; 
		public var page : int = 0 ; 
		public var service:String;
		
	}
}