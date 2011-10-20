package  org.syncon.RosettaStone.view.edit.search
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.Search.SearchImagesTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon.RosettaStone.vo.SearchResultVO;
	import org.syncon.RosettaStone.vo.SearchVO;
	import org.syncon2.utils.MakeVOs;
	
	import spark.components.Button;
	
	public class SearchPicsMediator extends Mediator 
	{
		[Inject] public var ui : SearchPics;
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
			
			this.ui.addEventListener( SearchPics.CHANGE_ITEM,  this.onChangeItem);	
			this.ui.addEventListener( SearchPics.ENABLED_SEARCH,  this.onEnableSearch);	
			this.ui.addEventListener( SearchPics.SEARCH_TEXT_CHANGED,  this.onSearchText);	
			this.ui.addEventListener( SearchPics.SELECT_IT,  this.onSelectIt);				
			this.ui.addEventListener( SearchPics.NEXT_PAGE,  this.onNext);			
			
			this.ui.addEventListener( SearchPics.SWITCH_PROVIDER,  this.onSiwtchProvider);	
			
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
			this.dispatch( new SearchImagesTriggerEvent(  
				SearchImagesTriggerEvent.SEARCH_IMAGES,
				txt , this.onImagesReturned,
				null, lastResult.service, lastResult.page+1 ) ) 
		}
		
		protected function onSelectIt(event:Event):void
		{
			this.onCollect(null);
		}
		
		protected function onSearchText(event:Event):void
		{
			var txt : String = this.ui.txtSearch.text; 
			this.dispatch( new SearchImagesTriggerEvent(  
				SearchImagesTriggerEvent.SEARCH_IMAGES,  txt , this.onImagesReturned, null,
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
		
		protected function onChangeItem(event:Event):void
		{
			this.setOnce =  true
			//this.ui.viewer.data = this.ui.list1.selectedItem 
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
			
			if ( this.ui.visible == false ||    this.ui.parentDocument.visible == false ) 
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
					throw 'no results found', 'onCollect', 'SearchPicsMediator'
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
			NightStandConstants.FileLoader.downloadFileTo( s.url, this.model.lessonDir(), 
				this.currentLessonItem.name+'.***', this.onSaved, true  )
		}
		
		public function onSaved(e:Object):void
		{
			trace('need the name', e ) ; 
			var s : SearchVO = this.ui.selectedItem  as SearchVO; 
			if ( this.currentLessonItem.currentPrompt == null ) 
			{
				this.currentLessonItem.pic =  e.toString();
				//this.currentLessonItem.image_copyright = s.copyright; 
				this.currentLessonItem.image_attribution = s.copyright_link;
				this.currentLessonItem.image_author = s.copyright_author;
				this.currentLessonItem.update()
				
			}
			else
			{
				this.currentLessonItem.currentPrompt.data =  e.toString();
				this.currentLessonItem.currentPrompt.image_attribution = s.copyright_link;
				this.currentLessonItem.currentPrompt.image_author = s.copyright_author;
				this.currentLessonItem.update()
			}
			this.model.saveLesson()
		}
		
		
	}
}