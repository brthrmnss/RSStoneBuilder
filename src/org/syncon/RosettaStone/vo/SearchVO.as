package  org.syncon.RosettaStone.vo
{
	import flash.events.EventDispatcher;
	import mx.collections.ArrayList;
	
	/**
	 * Used by searchers to display output
	 * */
	
	[RemoteClass]
	public class SearchVO  extends EventDispatcher
	{
		public var name :  String = ''; // = true
	 
		public var url : String = ''; 
		public var data:String;
		public var resultObj:Object;
		public var user_id:String;
		public var service:String;
		public var photo_id:Object;
		public var copyright_author:String;
		public var copyright_link:String;
		
	}
}