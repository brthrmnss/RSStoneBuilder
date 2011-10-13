package  org.syncon.RosettaStone.controller.Search
{
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.SearchVO;
	import org.syncon2.utils.data.GoThroughEach;
	import org.syncon2.utils.services.utils.GetDivParser;
	
	
	
	public class SearchDictionaryMultipleCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:SearchDictionaryMultipleTriggerEvent;
		
		private var pronunciations:Array;
		private var sounds:Array;
		
		override public function execute():void
		{
			if ( event.type == SearchDictionaryMultipleTriggerEvent.SEARCH_DICTIONARY_MULTIPLE ) 
			{
				this.loadMultipleDictionary()
			}				
		}
		
 
		//called when user presses the button to load feed
		private function loadMultipleDictionary():void
		{
			var split : Array =  event.query.split(" ")
			if ( split.length == 0 )
			{
				this.fxResult(null)
				return;
			}
			pronunciations = [] 
			sounds = [] ; 
			go.go( split ,this.onNextWord, this.onProcessingWordsComplete,20 ) ; 
		}
		public var go : GoThroughEach = new GoThroughEach()		

		public function onNextWord(word : String) : void
		{
			if ( word == null || word == '' ) 
				this.go.next(); 
			this.dispatch( new SearchDictionaryTriggerEvent(  
				SearchDictionaryTriggerEvent.SEARCH_DICTIONARY,  word 
				, this.fxInternalRequestResult, fxInternalRequestFault ) ) 
			 
		}
		
		public function onProcessingWordsComplete( ) : void
		{
			var s : SearchVO = new SearchVO()
			s.name = event.query; 
			s.data = pronunciations.join(' '); 
			s.url = sounds.join(' '); 
			this.fxResult( s )
		}
		
		/**
		 * called when internal comand completes
		 * */
		private function fxInternalRequestResult(e:  SearchVO):void
		{
			pronunciations.push( e.data ) 
			sounds.push( e.url ) 	
			this.go.next()
			//if ( this.event.fxResult != null ) this.event.fxResult(e  );
		}
		
		private function fxInternalRequestFault(e: Object):void
		{
			trace('', 'fxInternalRequestFault', 'word', event.query )
			if ( this.event.fxFault != null ) this.event.fxFault(e );
		}		
		
		private function fxResult(e: Object):void
		{
			//e.loaded = true; 
			if ( this.event.fxResult != null ) this.event.fxResult(e  );
		}
		
		private function fxFault(e: Object):void
		{
			if ( this.event.fxFault != null ) this.event.fxFault(e );
		}		
		
		
		
		
	}
}