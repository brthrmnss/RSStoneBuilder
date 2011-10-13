package  org.syncon.RosettaStone.controller.Search
{
	
	import mx.core.UIComponent;
	import mx.rpc.AsyncToken;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.SearchVO;
	import org.syncon2.utils.services.utils.RequestJSONUrl;
	
	
	
	public class SearchPronunciationsCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:SearchPronunciationsTriggerEvent;
		
		override public function execute():void
		{
			if ( event.type == SearchPronunciationsTriggerEvent.SEARCH_IMAGES ) 
			{
				this.loadSound()
			}				
			
		}
		static private var defaultKey : String = '5061CD1C64F6015A128E51FE1FDFDC3B18D0610A'; 
		static private var key : String = '9e4e33e80413277d7217be3dfe74d66d' ; 
		private var ui : UIComponent;  
		private var loader:  RequestJSONUrl;
		private function loadSound():void
		{
			
			var url : String = "http://api.search.live.net/xml.aspx?Appid=@@@&query="+event.query+"&sources=image"
			url = url.replace('@@@', key ) ; 
			
			url ="http://apifree.forvo.com/action/word-pronunciations/format/json/word/"
			url += event.query + "/language/en/order/rate-desc/key/"+ key
			var params : Object = {}; 
			loader = new RequestJSONUrl();
			var async : AsyncToken = loader.getUrl( url , params )// , params )
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
			var results : Array = data.items
			var output : Array = [] 
			for each ( var result  : Object in results ) 
			{
				var s : SearchVO = new SearchVO() ; 
				s.name = result.id; 
				s.url = result.pathmp3; 
				s.data = result.sex; 
				output.push(s); 
			}
			
			if ( this.event.fxResult != null ) this.event.fxResult( output  );
			//this.fxResult( data ) ; 
		}
		
		private function faultHandler(e:Object):void
		{
			trace('SearchPronunciationsCommand', 'fault ' ); 
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