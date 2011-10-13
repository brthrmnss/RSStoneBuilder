package  org.syncon.RosettaStone.controller.Search
{
	
	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.User;
	import com.adobe.webapis.flickr.events.FlickrResultEvent;
	
	import flash.events.Event;
	
	import mx.rpc.AsyncToken;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.SearchResultVO;
	import org.syncon.RosettaStone.vo.SearchVO;
	import org.syncon2.utils.services.utils.RequestJSONUrl;
	import ytfeeds.SimpleFeedGrabberExample;
	
	
	
	public class SearchYoutubeCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:SearchYoutubeCommandTriggerEvent;
		
		override public function execute():void
		{
			if ( event.type == SearchYoutubeCommandTriggerEvent.SEARCH_YOUTUBE ) 
			{
				this.loadFLICKRSound()
			}	
			
			if ( event.type == SearchYoutubeCommandTriggerEvent.GET_COPYRIGHT ) 
			{
				if( event.search.service == SearchYoutubeCommandTriggerEvent.FLICKR ) 
				{
					event.preventDefault(); 
					this.loadFlickrCopyright()
				}
			}		
			
			
		}
		
		static private var FLICKR_SECRET : String = 'fb6a661f3ce73c9d'; 
		static private var FLCIKR_APP : String = '13445163b587cd80319e5251ac2d7404' ; 
		private var api_key: String = '13445163b587cd80319e5251ac2d7404'; 
		
		static private var simpleFeedGrabberExample:SimpleFeedGrabberExample;
		
		private function loadFLICKRSound():void
		{
			if ( simpleFeedGrabberExample == null ) 
				simpleFeedGrabberExample = new SimpleFeedGrabberExample();
			simpleFeedGrabberExample.loadSearch( event.query);
			simpleFeedGrabberExample.addEventListener( SimpleFeedGrabberExample.DONE, this.resultHandlerFLICKR ) 
			
		}
		
		protected function onPhotosSearch(event:Event):void
		{
			trace('s'); 
		}
		private function resultHandlerFLICKR(data: Object=null):void
		{
			simpleFeedGrabberExample.removeEventListener( SimpleFeedGrabberExample.DONE, this.resultHandlerFLICKR ) 
			//pic.source = 'http://static.flickr.com/' + data.server + '/' + data.id + '_' + data.secret + '_m.jpg';
			//trace("source : "+pic.source)
			var results : Array =   simpleFeedGrabberExample.ytVideoDetailsArrayCollection.toArray(); 
			var resultSet :  SearchResultVO = new SearchResultVO(); 
			var output : Array = [] 
			for each ( var result  : Object in results ) 
			{
				var s : SearchVO = new SearchVO() ; 
				s.service = event.service; 
				/*s.name = result.Title; 
				s.url = result.Url; 
				s.data = result.MediaUrl; 
				s.url = result.Thumbnail.Url; */
				//s.user_id = result.owner; 
				//s.photo_id = result.id
				//s.copyright_date = 
				s.resultObj = result; 
				s.data = "http://www.youtube.com/watch?v="+ result.urlID; 
				s.url =  result.thumb; //  'http://static.flickr.com/' + result.server + '/' + result.id + '_' + result.secret + '_m.jpg';
				output.push(s); 
			}
			resultSet.results = output; 
			resultSet.page = this.event.page; 
			if ( this.event.fxResult != null ) this.event.fxResult( resultSet  );
		}
		
		private function loadFlickrCopyright():void
		{
			var service:FlickrService = new FlickrService( api_key );    
			
			service.addEventListener( FlickrResultEvent.PEOPLE_GET_INFO, onPeopleGetInfo );
			service.people.getInfo( event.search.user_id ) ; 
		}
		
		protected function onPeopleGetInfo(event:FlickrResultEvent):void
		{
			//this.event.search.copyright; 
			var user : User = event.data.user as User
			this.event.search.copyright_link = user.profileUrl; 
			this.event.search.copyright_author = user.fullname
			
			if ( this.event.fxResult != null ) this.event.fxResult( null  );
			trace('s'); 
		}
		
		
		
		
		
		
		
		private function resultHandler(data: Object):void
		{
			var results : Array = data.SearchResponse.Image.Results;
			var output : Array = [] 
			var resultSet :  SearchResultVO = new SearchResultVO(); 
			for each ( var result  : Object in results ) 
			{
				var s : SearchVO = new SearchVO() ; 
				s.name = result.Title; 
				s.url = result.Url; 
				s.data = result.MediaUrl; 
				s.url = result.Thumbnail.Url; 
				output.push(s); 
			}
			resultSet.results = output
			resultSet.service = event.service; 
			resultSet.page = this.event.page; 
			if ( this.event.fxResult != null ) this.event.fxResult( resultSet  );
			//this.fxResult( data ) ; 
		}
		
		private function faultHandler(e:Object):void
		{
			trace('GetBibleCommand', 'fault ' ); 
			//need an alert here
			this.model.alert('Could not load the scripture, please try again later'); 
			//if ( this.event.fxFault != null ) this.event.fxFault(e );
		}
		
		
		
		
	}
}