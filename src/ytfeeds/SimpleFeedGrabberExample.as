/**
 * SimpleFeedGrabberExample v0.1 Coded by dehash.com June 2008 based on ca.newcommerce.youtube.SearchSample
 */

package ytfeeds {
	
	/********** IMPORTS **********/
	import ca.newcommerce.youtube.data.ThumbnailData;
	import ca.newcommerce.youtube.data.VideoData;
	import ca.newcommerce.youtube.events.StandardVideoFeedEvent;
	import ca.newcommerce.youtube.events.VideoFeedEvent;
	import ca.newcommerce.youtube.feeds.VideoFeed;
	import ca.newcommerce.youtube.iterators.ThumbnailIterator;
	import ca.newcommerce.youtube.reference.SearchType;
	import ca.newcommerce.youtube.webservice.YouTubeFeedClient;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	import ytfeeds.YouTubeDataVO;
	
	
	public class SimpleFeedGrabberExample extends EventDispatcher {
		
		/********** CONSTANTS **********/	
		public static const LOAD_TOP_RATED:String = "loadTopRated";
		public static const LOAD_MOST_VIEWED:String = "loadMostViewed";
		public static const LOAD_RECENTLY_FEATURED:String = "loadRecentlyFeatured";
		public static const LOAD_SEARCH:String = "loadSearch";
		
		/********** VARIABLES **********/	
		[Bindable]
		public var ytVideoDetailsArrayCollection:ArrayCollection; 
		
		private var maxFeedLength:Number = 20;
		protected var _ws:YouTubeFeedClient;		
		protected var _requestId:Number;
		
		static public var DONE : String  = 'done'; 
		
		/********** CONSTRUCTOR **********/	
		public function SimpleFeedGrabberExample() {
			trace("SimpleFeedGrabberExample");
			ytVideoDetailsArrayCollection= new ArrayCollection();
			_ws = YouTubeFeedClient.getInstance();
			_ws.addEventListener(VideoFeedEvent.VIDEO_DATA_RECEIVED, doSearchResults);
			_ws.addEventListener(StandardVideoFeedEvent.STANDARD_VIDEO_DATA_RECEIVED, doSearchResults);
		}
		
		
		/********** PUBLIC METHODS **********/	
		public function loadTopRated():void {
			_requestId = _ws.getStandardFeed(SearchType.STD_TOP_RATED, "", 1, maxFeedLength);	
		}
		public function loadMostViewed():void {
			_requestId = _ws.getStandardFeed(SearchType.STD_MOST_VIEWED, "", 1, maxFeedLength);	
		}
		public function loadRecentlyFeatured():void {
			_requestId = _ws.getStandardFeed(SearchType.STD_RECENTLY_FEATURED,"", 1, maxFeedLength);	
		}
		public function loadSearch(search:String):void {
			var searchTerm:String = "Music"; // set a default 
			if ( search !="")	{ searchTerm = search; } 
			_requestId = _ws.getVideos(searchTerm,"", null, null, null, null,"relevance", "exclude", 1, maxFeedLength);	
		}
		
		
		/********** PARSE YOUTUBE DATA INTO ARRAYCOLLECTION **********/	
		
		protected function doSearchResults(evt:*):void {
			if (_requestId == evt.requestId ) {
				trace("doSearchResults");
				
				ytVideoDetailsArrayCollection.removeAll();
				
				// try/catch because 0 results triggers a runtime error
				try {
					var feed:VideoFeed = evt.feed;	
					feed.count;
				}catch (e:Error)
				{
					trace('No results for that search'); return;
				}
				
				var video:VideoData;	
				
				while(video = feed.next()) {
					var tnIt:ThumbnailIterator = video.media.thumbnails;
					var tn:ThumbnailData;
					var thumbArray:Array = [];
					
					while(tn = tnIt.next() ) {
						thumbArray.push(tn.url);
					}
					
					var ytVideoData:YouTubeDataVO = new YouTubeDataVO(video.title, thumbArray[0], video.actualId);
					ytVideoDetailsArrayCollection.addItem( ytVideoData ); 
				}
			} 
			else 
			{
				trace("this call:"+evt.requestId+" isn't ours. We'll wait for the next one...");
			}
			
			this.dispatchEvent( new Event( DONE ) ) ; 
			
		}
	}	
}

