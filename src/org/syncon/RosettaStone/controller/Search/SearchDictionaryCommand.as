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
	import org.syncon2.utils.services.utils.GetDivParser;
	
	
	
	public class SearchDictionaryCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:SearchDictionaryTriggerEvent;
		
		override public function execute():void
		{
			if ( event.type == SearchDictionaryTriggerEvent.SEARCH_DICTIONARY ) 
			{
				this.loadRSS()
			}				
			
		}
		
		
		import com.adobe.utils.XMLUtil;
		
		import flash.events.Event;
		import flash.events.IOErrorEvent;
		import flash.events.SecurityErrorEvent;
		import flash.net.URLLoader;
		import flash.net.URLRequest;
		import flash.net.URLRequestMethod;
		
		private var loader:URLLoader;
		
		//url of rss 2.0 feed
		private static const RSS_URL:String = "http://feeds.feedburner.com/MikeChambers/";
		
		//called when user presses the button to load feed
		private function loadRSS():void
		{
			if ( event.query.indexOf(' ') == -1 || event.dontBreakWords ) 
			{
				
			}
			else
			{
				this.dispatch( new SearchDictionaryMultipleTriggerEvent(  
					SearchDictionaryMultipleTriggerEvent.SEARCH_DICTIONARY_MULTIPLE,  event.query ,
					this.event.fxResult,this.event.fxFault ) ) 
				return;
			}
			loader = new URLLoader();
			
			var url : String = "http://dictionary.reference.com/browse/"+event.query; //foot
			//request pointing to feed
			var request:URLRequest = new URLRequest(  url );
			request.method = URLRequestMethod.GET;
			
			//load the feed data
			loader.load(request);
			
			//listen for when the data loads
			loader.addEventListener(Event.COMPLETE, onDataLoad);
			
			//listen for error events
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			
		}
		
		//called once the data has loaded from the feed
		private function onDataLoad(e:Event):void
		{
			//get the raw string data from the feed
			var rawRSS:String = URLLoader(e.target).data;
			if ( rawRSS == null ) 
			{
				this.model.alert( "Could not read devotional","Parsing Error"  ) 
				return; 
			}
			try {
				//parse it as RSS
				parseRSS(rawRSS);
			}
			catch ( e: Error  )
			{
				this.model.alert( "Could not read devotional","Parsing Error"  ) 
				parseRSS(rawRSS);
				//this.model.alert( "Could not read devotional","Parsing Error"  ) 
			}
		}
		
		//parses RSS 2.0 feed and prints out the feed titles into
		//the text area
		private function parseRSS(htmlString:String):void
		{
			var starter : String = '<div id="midRail">'
			var end : String = '<div id="rightRail">'; 
			var dbg : Array =[htmlString.indexOf(starter), htmlString.indexOf(end) ] ; 
			//	data = data.slice( dbg[0], dbg[1] ) ;
			var g: GetDivParser = new GetDivParser()
			var content:String = g.get(htmlString, starter) ; 
			/*
			var scripture:String = g.get(htmlString, '<div class="odb-box" id="passage-box">') ; 
			
			var keyVerseBox:String = g.get(htmlString, '<div class="odb-box" id="key-verse-box">') ; 
			*/
			var sound:String = g.getContentBetween(htmlString, "soundUrl=", '&' ) ; 
			
			var pron:String = g.getContentBetween(htmlString, '<span class="pron">', '</span>')//</span>') ;
			pron = pron.replace("<img class='luna-Img' border='0' src='http://sp.dictionary.com/dictstatic/dictionary/graphics/luna/thinsp.png' alt=''/>", '' ); 
			
			pron = pron.replace("'", '' ); 
			var removeThing : String = "ˈ"
			pron = pron.replace(removeThing, '' );
			
			pron = g.getContentBetween(htmlString, '<span style="display: inline;" class="show_ipapr">' ,
				'<a target="_blank" href="/help/luna/IPA_pron_key.html">')//</span>') ;
			pron = g.getContentBetween(htmlString, ' class="show_ipapr"' ,
				'<a target="_blank" href="/help/luna/IPA_pron_key.html">')//</span>') ;
			pron = g.getContentBetween(pron, '<span class="pron">','</span>')
			//why do i have to do this twic? what is the point of 106?
			pron = pron.replace("<img class='luna-Img' border='0' src='http://sp.dictionary.com/dictstatic/dictionary/graphics/luna/thinsp.png' alt=''/>", '' )
			pron = pron.replace("'", '' ); 
			pron = pron.replace(removeThing, '' );
			//	pron = pron.replace("<img class='luna-Img' border='0' src='http://sp.dictionary.com/dictstatic/dictionary/graphics/luna/thinsp.png' alt=''/>", '' ); 
			///	pron = pron.replace("'", '' ); 
			//var removeThing : String = "ˈ"
			//pron = pron.replace(removeThing, '' );
			
			
			var s : SearchVO = new SearchVO()
			s.name = event.query; 
			s.data = pron
			s.url = sound
			if ( pron.indexOf( 'HTML 4.01 Transitional' ) ==  0 ) 
			{
				fxFault( event.query ) ; 
				return; 
			}
			fxResult( s  ) ; 
		}
		
		private function onIOError(e:IOErrorEvent):void
		{
			trace('GetODBVOCommand',"IOError : " + e.text);
			this.model.alert( e.text,"IOError : "  ) 
			fxFault( e ) ; 
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			trace('GetODBVOCommand',"SecurityError : " + e.text);
			this.model.alert( e.text,"SecurityError : "  ) 
			fxFault( e ) ; 
		}
		
		private function fxResult(e:   Object):void
		{
			//e.loaded = true; 
			this.cleanUp()
			if ( this.event.fxResult != null ) this.event.fxResult(e  );
		}
		
		private function fxFault(e: Object):void
		{
			trace('failed at :', event.query ) 
			this.cleanUp()
			if ( this.event.fxFault != null ) this.event.fxFault(e );
		}		
		
		private function cleanUp():void
		{
			if ( loader != null ) 
			{
				
				//listen for when the data loads
				loader.removeEventListener(Event.COMPLETE, onDataLoad);
				
				//listen for error events
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				loader = null; 
			}
		}		
		
		
		
	}
}