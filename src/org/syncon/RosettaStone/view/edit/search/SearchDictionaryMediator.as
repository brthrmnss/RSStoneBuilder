package  org.syncon.RosettaStone.view.edit.search
{
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mx.events.FlexEvent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.Search.SearchDictionaryTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.utils.PlaySound;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.SearchVO;
	import org.syncon2.utils.data.GoThroughEach;
	
	public class SearchDictionaryMediator extends Mediator 
	{
		[Inject] public var ui :    SearchDictionary;
		[Inject] public var model : RSModel;
		private var currentLessonItem: LessonItemVO;
		public var goThroughUrlsToSaved : GoThroughEach = new GoThroughEach()	
		/**
		 * stores words as we go through urls 
		 * */
		private var wordsSplit:Array;
		private var soundsDownloadLocationsBulk : Array = [] ; 
		
		public var goThroughEachWordOnServer : GoThroughEach = new GoThroughEach()	
		private var lastFaultText:String;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_ITEM_CHANGED, 
				this.onLessonItemChanged);	
			this.onLessonItemChanged( null ) 
			
			this.ui.addEventListener( FlexEvent.SHOW, this.onLessonItemChanged_ ) ; 
			this.ui.addEventListener( SearchDictionary.ENABLED_SEARCH,  this.onEnableSearch);	
			this.ui.addEventListener( SearchDictionary.SEARCH_TEXT_CHANGED,  this.onSearchText);	
			this.ui.addEventListener( SearchDictionary.SELECT_IT,  this.onSelectIt);				
			this.ui.addEventListener( SearchDictionary.PLAY,  this.onPlay);	 
			
		}
		
		protected function onPlay(event: CustomEvent):void
		{
			var url : String = event.data.toString()
			var v :  PlaySound = new PlaySound()
			if ( NightStandConstants.flex ) 
			{
				var un : String = unescape(url); 
				url = url.replace( new RegExp("%25", 'gi' ) , '%' ); 
				if ( un.indexOf(' ') == -1 ) 
				{
					var urlReq : URLRequest =   PlaySound.getProxy( un )
				}
				else
				{
					this.playBulkSound( un ) ; 
				}
			}
			this.model.playSound2( url ,1, urlReq ) ; 
		}
		
		private function playBulkSound(un:String):void
		{
			var arr : Array = un.split( ' ') ; 
			goThroughEachWordOnServer.go( arr, this.playNextSound, this.onDonePlayingSounds, 20 ) ; 
		}		
		
		private function playNextSound(url : String):void
		{
			if ( NightStandConstants.flex ) 
			{
				var urlReq : URLRequest =   PlaySound.getProxy( url )
			}
			this.model.playSound2( url ,1, urlReq, this.goThroughEachWordOnServer.next ) ; 
		}
		
		private function onDonePlayingSounds():void
		{
			trace('done'); 
		}		
		
		
		
		
		
		
		
		protected function onSelectIt(event:Event):void
		{
			/**
			 save sound
			 save pronunciation 
			 */
			
			//make suure this is the converted version ... 
			this.currentLessonItem.pronunciation = this.ui.viewer2.txtPro.text; 
			//pic #
			
			var searchDicResult : SearchVO = this.ui.viewer.data as SearchVO; 
			if ( searchDicResult.url.indexOf(' ') == -1 ) 
			{
				var url : String = unescape(searchDicResult.url)
				NightStandConstants.FileLoader.downloadFileTo(url, this.model.lessonDir(), 
					this.currentLessonItem.name+'.***', this.onSavedSound , true )
			}
			else
			{
				this.downloadBulkWords()
				
			}
		}
		
		
		public function onSavedSound(filename:String):void
		{
			this.currentLessonItem.sound =  filename;
			this.currentLessonItem.update()
			this.model.saveLesson()
		}
		
		
		
		private function downloadBulkWords():void
		{
			var searchDicResult : SearchVO = this.ui.viewer.data as SearchVO; 
			//split into strings, unescap all,  setup go through each to save each one, 
			//merging on arry, then strip back down to normal sound 
			//var url : String = unescape(searchDicResult.url)
			var split : Array =  searchDicResult.url.split(" ")
			this.wordsSplit = searchDicResult.name.split(" ")
			var urls : Array = []; 
			for each ( var url_ : String in split ) 
			{
				url_ = unescape(url_)
				urls.push( url_ )
			}
			goThroughUrlsToSaved.go( urls ,this.onNext_SaveSound, this.onProcessingWordsComplete ) ; 
			
		}
		
		public function onNext_SaveSound(url : String) : void
		{
			if ( url == null || url == '' ) 
				this.goThroughUrlsToSaved.next();
			var word : String = wordsSplit[this.goThroughUrlsToSaved.index] 
			NightStandConstants.FileLoader.downloadFileTo(url, this.model.lessonDir(), 
				word+'.***', this.onSavedSound_Bulk , true )
		}
		
		
		/**
		 * called when internal comand completes
		 * */
		private function onSavedSound_Bulk(filename:String):void
		{
			soundsDownloadLocationsBulk.push( filename ) 	
			this.goThroughUrlsToSaved.next()
		}
		
		public function onProcessingWordsComplete( ) : void
		{
			var soundsJoined : String = soundsDownloadLocationsBulk.join(' '); 
			this.currentLessonItem.sound = soundsJoined ;
			this.currentLessonItem.update()
			this.model.saveLesson()
		}
		
		
		
		protected function onSearchText(event:Event):void
		{
			var txt : String = this.ui.txtSearch.text; 
			this.dispatch( new SearchDictionaryTriggerEvent(  
				SearchDictionaryTriggerEvent.SEARCH_DICTIONARY,  txt 
				, this.onImagesReturned2, this.onFault  ) ) 
			this.lastFaultText = ''; 
		}
		
		public function onFault(e : Object ) : void
		{
			if ( this.lastFaultText == this.ui.txtSearch.text )
			{
				return; 
			}
			this.lastFaultText = this.ui.txtSearch.text; 
			var txt : String = this.ui.txtSearch.text; 
			this.dispatch( new SearchDictionaryTriggerEvent(  
				SearchDictionaryTriggerEvent.SEARCH_DICTIONARY,  txt 
				, this.onImagesReturned2, this.onFault, true  ) ) 
			
			
		}
		
		private function onImagesReturned2(e:Object):void
		{
			this.ui.viewer.data = e; 
			this.ui.viewer2.data = e; 
			return; 
		}
		
		
		protected function onEnableSearch(event:Event):void
		{
			// TODO Auto-generated method stub
		}
		/**
		 * Redirect 
		 * */
		private function onLessonItemChanged_(e: Event): void
		{
			if ( this.currentLessonItem == this.model.currentLessonItem ) 
				return
			onLessonItemChanged(null)
		}
		private function onLessonItemChanged(e: RSModelEvent): void
		{
			if ( this.ui.visible == false ) 
				return; 
			currentLessonItem = this.model.currentLessonItem; 
			if ( this.ui.chkEnabled.enabled == false )
				return; 
			if ( this.currentLessonItem == null ) 
				return; 
			if ( this.model.automating )
				return;
			if ( this.ui.visible == false ||  this.ui.parentDocument.visible  == false ) 
				return; 
			this.ui.txtSearch.text = currentLessonItem.name; 
			
			this.onSearchText(null)
		}		
		
	}
}