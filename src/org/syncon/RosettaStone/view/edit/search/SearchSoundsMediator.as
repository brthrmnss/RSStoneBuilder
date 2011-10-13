package  org.syncon.RosettaStone.view.edit.search
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.Search.SearchDictionaryTriggerEvent;
	import org.syncon.RosettaStone.controller.Search.SearchImagesTriggerEvent;
	import org.syncon.RosettaStone.controller.Search.SearchPronunciationsTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon2.utils.MakeVOs;
	
	public class SearchSoundsMediator extends Mediator 
	{
		[Inject] public var ui :  SearchSounds;
		[Inject] public var model : RSModel;
		private var currentLessonItem: LessonItemVO;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_ITEM_CHANGED, 
				this.onLessonItemChanged);	
			this.onLessonItemChanged( null ) 
			
			this.ui.addEventListener( SearchSounds.CHANGE_ITEM,  this.onChangeItem);	
			this.ui.addEventListener( SearchSounds.ENABLED_SEARCH,  this.onEnableSearch);	
			this.ui.addEventListener( SearchSounds.SEARCH_TEXT_CHANGED,  this.onSearchText);	
			this.ui.addEventListener( SearchSounds.SELECT_IT,  this.onSelectIt);				
			this.ui.addEventListener( SearchSoundsItemRenderer.PLAY,  this.onPlay);	 
			
		}
		
		protected function onPlay(event: CustomEvent):void
		{
			var url : String = event.data.toString() 
			this.model.playSound2( url  ) ; 
		}
		
		protected function onSelectIt(event:Event):void
		{
			this.currentLessonItem.pic = ' boo'
		}
		
		protected function onSearchText(event:Event):void
		{
			var txt : String = this.ui.txtSearch.text; 
			this.dispatch( new SearchPronunciationsTriggerEvent(  SearchPronunciationsTriggerEvent.SEARCH_IMAGES,  txt , this.onImagesReturned ) )
		}	
 
		private function onImagesReturned(e: Array):void
		{
			this.ui.list1.dataProvider =  new ArrayCollection( e ) 
			return; 
		}
		
		protected function onEnableSearch(event:Event):void
		{
			// TODO Auto-generated method stub
		}
		
		protected function onChangeItem(event:Event):void
		{
			this.ui.viewer.data = this.ui.list1.selectedItem 
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