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
	
	
	
	public class SearchImagesCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:SearchImagesTriggerEvent;
		
		override public function execute():void
		{
			if ( event.type == SearchImagesTriggerEvent.SEARCH_IMAGES ) 
			{
				if( event.service == SearchImagesTriggerEvent.FLICKR ) 
				{
					this.loadFLICKRSound()
				}
				else
				{
				this.loadMSNSound()
				}
			}	
			
			if ( event.type == SearchImagesTriggerEvent.GET_COPYRIGHT ) 
			{
				if( event.search.service == SearchImagesTriggerEvent.FLICKR ) 
				{
					event.preventDefault(); 
					this.loadFlickrCopyright()
				}
			}		
			
			
		}
		
		static private var FLICKR_SECRET : String = 'fb6a661f3ce73c9d'; 
		static private var FLCIKR_APP : String = '13445163b587cd80319e5251ac2d7404' ; 
		private var api_key: String = '13445163b587cd80319e5251ac2d7404'; 
		private function loadFLICKRSound():void
		{
			 var service:FlickrService = new FlickrService( api_key );   FlickrResultEvent
			
			service.addEventListener( FlickrResultEvent.PHOTOS_SEARCH, onPhotosSearch );
			service.photos.search("", event.query, "any", "", null, null, null, null, 7, "")
				/**/
			var url : String = "http://api.flickr.com/services/rest/"
			
			var params : Object = {}; 
			params['method'] = "flickr.photos.search";
			params['api_key'] =  FLCIKR_APP
			params['text'] = event.query
			params['license'] = "1, 5, 7"
			params['format'] ="json"
			params['page'] = event.page; 
			params['nojsoncallback'] = 1; 

			loader = new RequestJSONUrl();
			
			var async : AsyncToken = loader.getUrl( url , params )// , params )
			
			/*this.fxResultHandler = listResultHandler
			this.fxFaultHandler = listFaultHandler*/
			async.returnFx = resultHandlerFLICKR
			async.faultFx =faultHandler
			async.fxNotifyOnBadResult = onResultInvalid 				
			async.parseJSON = true 		
			/*var config : NightStandConfigVO = NightStandConstants.FileLoader.readObjectFromFile( event.url, this.loadConfigPart2, event.path ) as NightStandConfigVO;*/
		}
		
		protected function onPhotosSearch(event:Event):void
		{
			trace('s'); 
		}
		private function resultHandlerFLICKR(data: Object):void
		{
			//pic.source = 'http://static.flickr.com/' + data.server + '/' + data.id + '_' + data.secret + '_m.jpg';
			//trace("source : "+pic.source)
			var results : Array = data.photos.photo;//.Image.Results;
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
				s.user_id = result.owner; 
				s.photo_id = result.id
				//s.copyright_date = 
				s.resultObj = result; 
				s.url =   'http://static.flickr.com/' + result.server + '/' + result.id + '_' + result.secret + '_m.jpg';
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
 
		
		
		
		
		
		
		static private var defaultKey : String = 'perPage61CD1C64F6015A128E51FE1FDFDC3B18D0610A'; 
		static private var key : String = '47DD4652AA776C47A0F33A2A227A647E1A21828E' ; 
		private var loader:  RequestJSONUrl;
		private function loadMSNSound():void
		{
			
			var url : String = "http://api.search.live.net/xml.aspx?Appid=@@@&query="+event.query+"&sources=image"
			url = url.replace('@@@', key ) ; 
			
			url ="http://api.search.live.net/json.aspx" 
			var params : Object = {}; 
			params['Adult'] = 'Strict';
			params['AppId'] = key
			params['Query'] = event.query
			params['Sources'] = "Image"
				var perPage : int = 50
					
			/*	params['ImageRequest.Count'] = perPage;
				params['ImageRequest.Offset'] = perPage*event.page; 
					*/
			params['Image.Count'] = perPage.toString();
			params['Image.Offset'] = perPage*event.page; 
			params['Web.Count'] = perPage;
			params['Web.Offset'] = perPage*event.page; 
/*			params['ImageRequest.Count'] = perPage;
			params['ImageRequest.Offset'] = perPage*event.page; */
/*
			params['image.count'] = perPage;
			params['image.offset'] = perPage*event.page; 
			params['imageRequest.count'] = perPage;
			params['imageRequest.offset'] = perPage*event.page; 
			params['Count'] = perPage;
			params['Offset'] = perPage*event.page; 
			params['Image'] = {Count:perPage, Offset:perPage*event.page} 
			params['ImageRequest'] = {Count:perPage, Offset:perPage*event.page} 
				
			params['adult'] = 'Strict';*/
			

			loader = new RequestJSONUrl();
		 
			var url2 : String = "http://api.bing.net/json.aspx?" + "AppId=" + key
				+ "&Query=" + event.query
				+ "&Sources=Image"
				
				// Common request fields (optional)
				+ "&Version=2.0"
				+ "&Market=en-us"
				+ "&Adult=Strict"
				
				// Image-specific request fields (optional)
				+ "&Image.Count="+perPage
				+ "&Image.Offset="+perPage*event.page; 
			var async : AsyncToken = loader.getUrl( url2  )// , params )
			/* 
			var async : AsyncToken = loader.getUrl( url , params )// , params )
			*/
			
			/*this.fxResultHandler = listResultHandler
			this.fxFaultHandler = listFaultHandler*/
			async.returnFx = resultHandler
			async.faultFx =faultHandler
			async.fxNotifyOnBadResult = onResultInvalid 				
			async.parseJSON = true 		
			/*var config : NightStandConfigVO = NightStandConstants.FileLoader.readObjectFromFile( event.url, this.loadConfigPart2, event.path ) as NightStandConfigVO;*/
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
			/*if ( this.notValidResult() ) return; 
			fxFaultHandler( e ) 
			this.onFault(); this.deReference(e)
			this.deReference(e)	*/		
			trace('GetBibleCommand', 'fault ' ); 
			//need an alert here
			this.model.alert('Could not load the scripture, please try again later'); 
			//if ( this.event.fxFault != null ) this.event.fxFault(e );
		}
		
		private function onResultInvalid(e:Object):void
		{
			/*
			this.deReference(null, false )
			if ( event.currentRetryInvalidAttempt > this.retryInvalidCount ) 
			{
			trace(' gave up invalid' + event.type + ' after ' + this.retryInvalidCount ) ; 
			this.onFault()
			this.fxFault(null) //should we notify things have failed? ... 
			return; 
			}				
			event.currentRetryInvalidAttempt++
			this.timerInvalidRetry = new Timer(20*1000, 0 ) ; 
			this.timerInvalidRetry.addEventListener(TimerEvent.TIMER, this.onRetry_ResultInvalid ) ; 
			this.timerInvalidRetry.start()
			//	this.dispatch( event ) 
			this.execute();  
			*/
		}
		
		
		
	}
}