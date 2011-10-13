package  org.syncon.RosettaStone.view.edit.search
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.Import.UpdateLessonItemCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.Search.SearchImagesTriggerEvent;
	import org.syncon.RosettaStone.controller.Search.SearchYoutubeCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.SearchResultVO;
	import org.syncon.RosettaStone.vo.SearchVO;
	
	import spark.components.Button;
	
	public class SearchYoutubeMediator extends Mediator 
	{
		[Inject] public var ui : SearchYoutube;
		[Inject] public var model : RSModel;
		private var currentLessonItem: LessonItemVO;
		private var lastResult:SearchResultVO;
		private var setOnce:Boolean;
		private var  searchProvider : String =  SearchImagesTriggerEvent.MSN; 
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_ITEM_CHANGED, 
				this.onLessonItemChanged);	
			this.onLessonItemChanged( null ) 
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_PROMPT_CHANGED, 
				this.onLessonItemChanged);	
			//this.onCurrentPromptChanged( null ) 
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.COLLECT, 
				this.onCollect);	
			
			this.ui.addEventListener( SearchYoutube.CHANGE_ITEM,  this.onChangeItem);	
			this.ui.addEventListener( SearchYoutube.ENABLED_SEARCH,  this.onEnableSearch);	
			this.ui.addEventListener( SearchYoutube.SEARCH_TEXT_CHANGED,  this.onSearchText);	
			this.ui.addEventListener( SearchYoutube.SELECT_IT,  this.onSelectIt);				
			this.ui.addEventListener( SearchYoutube.NEXT_PAGE,  this.onNext);			
			
			this.ui.addEventListener( SearchYoutube.SWITCH_PROVIDER,  this.onSiwtchProvider);	
			
			for each (  var j : String in [SearchImagesTriggerEvent.FLICKR, SearchImagesTriggerEvent.MSN] )
			{
				var btn  : Button = new Button()
				btn.label = j
				btn.addEventListener(MouseEvent.CLICK, this.onClickChangeProvidder ) 
				this.ui.holderProviders.addElement( btn ) 
			}
			
			
			
		}
		protected function onClickChangeProvidder(event:Event):void
		{
			this.searchProvider = event.currentTarget.label.toString() 
			this.onSearchText(null); 
			
		}
		protected function onSiwtchProvider(event:CustomEvent):void
		{
			this.searchProvider = event.data.toString() 
			this.onSearchText(null); 
			
		}
		
		protected function onNext(event:Event):void
		{
			var txt : String = this.ui.txtSearch.text; 
			this.dispatch( new SearchYoutubeCommandTriggerEvent(  
				SearchYoutubeCommandTriggerEvent.SEARCH_YOUTUBE,
				txt , this.onImagesReturned,
				null, lastResult.service, lastResult.page+1 ) ) 
		}
		
		protected function onSelectIt(event:Event):void
		{
			this.onCollect(null);
		}
		
		protected function onSearchText(event:Event):void
		{
			var txt : String = ''
			if ( this.ui.queryPreText != null && this.ui.queryPreText != '' ) 
			{
				txt += this.ui.queryPreText + ' ' 
			}
			txt += this.ui.txtSearch.text; 
			this.dispatch( new SearchYoutubeCommandTriggerEvent(  
				SearchYoutubeCommandTriggerEvent.SEARCH_YOUTUBE,  txt , this.onImagesReturned, null,
				this.searchProvider) ) 
		}
		
		private function onImagesReturned(e:  SearchResultVO ):void
		{
			lastResult = e
			this.ui.dataProvider =  new ArrayCollection( e.results ) 
			return; 
		}
		
		protected function onEnableSearch(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		private static const YOUTUBE_EMBED_URL:String = "http://www.youtube.com/v/{0}?version=3&autoplay={1}&fs={2}&rel={3}";
		
		private static const YOUTUBE_EXTERNAL_URL:String = "http://www.youtube.com/watch?v=";
		
		protected function onChangeItem(event:CustomEvent):void
		{
			this.setOnce =  true
			//this.ui.viewer.data = this.ui.list1.selectedItem 
			if ( this.ui.chkAutoPlay.selected ) 
			{
				var s : SearchVO = event.data as SearchVO
				this.ui.swfLoader.unloadAndStop();
				//currentIndex = (currentIndex + dx) % videoIds.length;
				var videoId:String = s.resultObj.urlID
				
				var videoUrl : String = StringUtil.substitute(YOUTUBE_EMBED_URL, videoId, 1, 0);
				var youTubeUrl  : String= YOUTUBE_EXTERNAL_URL + videoId;
				this.ui.swfLoader.source = videoUrl; 
			}
		}
		
		
		
		private function onLessonItemChanged(e: RSModelEvent): void
		{
			currentLessonItem = this.model.currentLessonItem; 
			if ( this.ui.chkEnabled.enabled == false )
				return; 
			if ( this.currentLessonItem == null ) 
				return; 
			if ( this.model.automating )
				return;
			
			if ( this.ui.visible == false ||     this.ui.parentDocument.visible == false ) 
				return; 
			this.ui.txtSearch.text = currentLessonItem.name; 
			if ( this.currentLessonItem.currentPrompt != null ) 
			{
				//use the name still ... 
				//this.ui.txtSearch.text = currentLessonItem.currentPrompt.name; 
				this.ui.lblPrompt.visible = true; 
				this.ui.lblPrompt.text = 'Prompt: ' + this.currentLessonItem.currentPrompt.name; 
			}
			//this.ui.viewer.data = null; 
			this.ui.selectedItem = null; 
			this.setOnce = false;//would be easier to use list  
			this.onSearchText(null)
			this.ui.swfLoader.unloadAndStop();
			
		}		
		
		/**
		 * save to file ... and call save on server ... pretend sync don't matter
		 * */
		private function onCollect(e: RSModelEvent): void
		{
			//pic #
			if ( this.setOnce == false ) 
			{
				if ( this.lastResult.results.length == 0 ) 
					throw 'no results found', 'onCollect', 'SearchYoutubeMediator'
				this.ui.selectedItem = this.lastResult.results[0]
			}
			
			var s : SearchVO = this.ui.selectedItem as SearchVO; 
			//try to get copy right
			/*if (   ) 
			{*/
			
			var evente :  SearchImagesTriggerEvent = 
				SearchImagesTriggerEvent.GetCopyright( s , this.onRecieveCopyRight ) 
			this.dispatch(evente ) 
			/*	}*/
			if ( evente.isDefaultPrevented() ) 
			{
				return; 
			}
			onRecieveCopyRight()
			
		}	
		
		/**
		 * setp 2 is to try to get the copy right
		 * */
		public function onRecieveCopyRight(ss : SearchVO=null) : void
		{
			var s : SearchVO = this.ui.selectedItem as SearchVO; 
			if ( this.ui.chkAudioOnly.selected == false ) 
			{
				this.dispatch(   UpdateLessonItemCommandTriggerEvent.UpdateLessonTo(
					this.currentLessonItem, s.data, onSaveLessonItem,
					UpdateLessonItemCommandTriggerEvent.VIDEO
				) ) 
			}
			else
			{
				this.dispatch(   UpdateLessonItemCommandTriggerEvent.UpdateLessonTo(
					this.currentLessonItem, s.data, onSaveLessonItem,
					UpdateLessonItemCommandTriggerEvent.AUDIO
				) ) 
			}
			
			/*	NightStandConstants.FileLoader.downloadFileTo( s.url, this.model.lessonDir(), 
			this.currentLessonItem.name+'.***', this.onSaved, true  )*/
		}
		/*		
		public function onSaved(e:Object):void
		{
		trace('need the name', e ) ; 
		var s : SearchVO = this.ui.selectedItem  as SearchVO; 
		/*if ( this.currentLessonItem.currentPrompt == null ) 
		{
		this.currentLessonItem.pic =  e.toString();
		//this.currentLessonItem.image_copyright = s.copyright; 
		this.currentLessonItem.image_attribution = s.copyright_link;
		this.currentLessonItem.image_author = s.copyright_author;
		this.currentLessonItem.update()
		
		}
		else
		{
		this.currentLessonItem.currentPrompt.image =  e.toString();
		this.currentLessonItem.currentPrompt.image_attribution = s.copyright_link;
		this.currentLessonItem.currentPrompt.image_author = s.copyright_author;
		this.currentLessonItem.update()
		} 
		this.dispatch(   UpdateLessonItemCommandTriggerEvent.UpdateLessonTo(
		this.currentLessonItem, e, onSaveLessonItem,
		UpdateLessonItemCommandTriggerEvent.VIDEO
		) ) 
		}*/
		public function onSaveLessonItem(e:Object=null):void
		{
			
			this.model.saveLesson()
		}
		
		
	}
}