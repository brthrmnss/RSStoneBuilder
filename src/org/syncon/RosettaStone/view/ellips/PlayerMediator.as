package  org.syncon.RosettaStone.view.ellips
{
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon.popups.controller.CreatePopupEvent;
	
	public class PlayerMediator extends Mediator 
	{
		[Inject] public var ui : Player;
		[Inject] public var model : RSModel;
		private var currentLessonItem: LessonItemVO;
		public var injections : Array =  ['model', RSModel] 
		override public function onRegister():void
		{
			
			/*
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CHANGED_DATE_XML_FILE_DATE, 
			this.onChangedFileDate);		
			*/
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_SET_CHANGED, 
				this.onLessonSetChanged);	
			this.onLessonSetChanged( null ) 
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_ITEM_CHANGED, 
				this.onLessonItemChanged);	
			this.onLessonItemChanged( null ) 
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.HIGHLIGHTED_ITEM_CHANGED, 
				this.onHighlightedLessonItemChanged);	
			this.onHighlightedLessonItemChanged( null ) 
			
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.SELECTED_LESSON_ITEM_CHANGED, 
				this.onSelectedItemChanged);	
			this.onSelectedItemChanged( null ) 		
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.HIGHLIGHTED_ITEM_CHANGED, 
				this.onHighlightedItemChanged);	
			this.onHighlightedItemChanged( null ) 		
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.AUTOMATE_CLEAR, 
				this.onClearForAutomation);	
			this.onClearForAutomation( null ) 					
						
			
				//ellipse doesn' tlike this code 
			//var obj : Object =  this.ui.list.popup 
			this.dispatch( CreatePopupEvent.RegisterExisting( 'PopupSelectionResult', this.ui.list['popup'] ) ) 
			
			/*		
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CORRECT_ITEM, 
			this.onWrongItem);	
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.WRONG_ITEM, 
			this.onCorrectItem);	
			
			*/
			
			this.ui.addEventListener( Player.CLICK_ITEM, this.onClickItem ) 
		}
		/*		
		private function onCorrectItem(e:NightStandModelEvent):void
		{
		
		this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 'PopupSelectionResult', []) ) ; 
		}
		
		private function onWrongItem(e:NightStandModelEvent):void
		{
		this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP,'PopupSelectionResult', []) ) ; 			
		}*/
		
		private function onLessonSetChanged(e:RSModelEvent): void
		{
			var lessonSet : LessonSetVO = this.model.currentLessonSet
			var dp : ArrayCollection; 
			if ( lessonSet != null ) 
			{
				this.model.applyFolderToItems( lessonSet.items.toArray() ) 
				dp =lessonSet.items 
			}
			else
			{
				dp = new ArrayCollection(); 
			}
			
			
			
			this.ui.list['dataProvider'] = dp
			//this.ui.btnSave.enabled = false; 
		}		
		/**
		 * i don't want to alwasy show this ...
		 * */
		private function onLessonItemChanged(e: RSModelEvent): void
		{
			this.currentLessonItem = this.model.currentLessonItem;
			this.ui.prompt.data = this.currentLessonItem
			this.ui.list.selectedIndex = -1 
		}		
		private function onHighlightedLessonItemChanged(e: RSModelEvent): void
		{
			if ( this.model.automating == false ) 
				return; 
			this.currentLessonItem = this.model.currentHighlightedItem;
			this.ui.prompt.data = this.currentLessonItem
			//this.ui.list1.selectedIndex = -1 
		}		
		protected function onClickItem(event:CustomEvent):void
		{
			this.model.selectedItem = event.data as LessonItemVO
			//this.model.playSound2( this.currentLessonItem.sourceSound ) ; 
		}
		
		private function onSelectedItemChanged(e: RSModelEvent): void
		{
			if ( this.model.selectedItem == null ) 
			{
				this.ui.list.selectedIndex = -1
				this.ui.list.selectedItem = null
				return; 
			}
			
			//this.ui.list.selectedItem = this.model.selectedItem; 
			
		}				
		
		
		private function onHighlightedItemChanged(e: RSModelEvent): void
		{
			if ( this.model.currentHighlightedItem == null ) 
			{
				this.ui.list.selectedIndex = -1
				return; 
			}
			
			this.ui.list.selectedItem = this.model.currentHighlightedItem; 
			
		}				
		
		/**
		 * called when goign ot next set ... 
		 * remove the selected index
		 * */
		private function onClearForAutomation(e: RSModelEvent): void
		{
			this.ui.list.selectedIndex = 0; 
			this.ui.list.selectedItem = null
			this.ui.list.selectedIndex = -1
			/* 
			//causes compile errors
			var od : ArrayCollection = this.ui.list.dataProvider as ArrayCollection
			this.ui.list.dataProvider = od ;//as ArrayCollection;
			*/
			return; 
		}	
		

		
	}
}