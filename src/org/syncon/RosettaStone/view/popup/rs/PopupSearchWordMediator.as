package  	org.syncon.RosettaStone.view.popup.rs 
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.AutomateEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.Places;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	
	public class  PopupSearchWordMediator extends Mediator
	{
		[Inject] public var ui:PopupSearchWord;
		[Inject] public var model : RSModel;
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		private var currentLessonItem:LessonItemVO;
		private var selectedItems:ArrayCollection;
		private var selectedIndex:int;
		
		override public function onRemove():void
		{
			ev.unmapAll(); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			ev.init( this.ui ) ; 
			this.ev.addEv(PopupSearchWord.CANCEL, this.onCancel )
			this.ev.addEv( PopupSearchWord.SETUP, this.onSetup ) ; 
			
			this.ev.addEv( PopupSearchWord.NEXT_ITEM, this.onNextItem ) ; 
			
			this.ev.addEv(PopupSearchWord.CHANGE_ITEM, this.onChangeItem )				
			
			this.mediatorMap.createMediator( this.ui.searchDictionary ) ; 
			this.mediatorMap.createMediator( this.ui.searchPic ) ; 
			this.mediatorMap.createMediator( this.ui.searchSounds ) ; 			
			this.mediatorMap.createMediator( this.ui.searchYoutube ) ; 	
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_ITEM_CHANGED, 
				this.onLessonItemChanged);	
			this.onLessonItemChanged( null ) 
			
		}
		private function onChangeItem(e: CustomEvent): void
		{
			this.model.currentLessonItem = e.data as LessonItemVO; 
			this.currentLessonItem = this.model.currentLessonItem; 
			this.selectedIndex = this.selectedItems.getItemIndex( this.model.currentLessonItem  ) ; 
		}
		
		private function onLessonItemChanged(e: RSModelEvent): void
		{
			if ( this.ui.visible == false ) 
				return; 
			currentLessonItem = this.model.currentLessonItem; 
			/*if ( this.ui.chkEnabled.enabled == false )
			return; */
			if ( this.currentLessonItem == null ) 
				return; 
			if ( this.model.automating )
				return;
			if ( this.ui.visible == false ||  this.ui.parent.visible  == false ) 
				return; 
			//this.ui.txtSearch.text = currentLessonItem.name; 
			this.ui.list.selectedItem = this.currentLessonItem; 
			//this.onSearchText(null)
		}	
		
		
		protected function onRepeat(event:Event=null):void
		{
			this.dispatch( new AutomateEvent(AutomateEvent.START_LESSON, this.ui.lesson )) 
			this.ui.hide(); 
		}
		
		protected function onNextItem(event:Event=null):void
		{
			this.selectedIndex++
			if ( this.selectedIndex == this.selectedItems.length ) 
				this.selectedIndex = 0 ; 
			
			this.currentLessonItem = this.selectedItems.getItemAt( this.selectedIndex )  as LessonItemVO; 
			this.model.currentLessonItem = this.currentLessonItem; 
			//this.onLessonItemChanged(null)
		}
		
		protected function noHome(event:Event=null):void
		{
			this.dispatch( new NavigateCommandTriggerEvent(NavigateCommandTriggerEvent.PUSH, 
				Places.HOME	) ) ; 
			this.ui.hide(); 
		}		
		
		
		protected function onSetup(event:Event):void
		{
			this.selectedItems = new ArrayCollection()
			//this.ui.txtLessonName.text = this.model.currentLessonPlan.name;
			this.onLessonItemChanged(null); 
			if  ( this.ui.holderList.visible ) 
			{
				this.selectedItems = new ArrayCollection(	this.ui.list.dataProvider.toArray() )
					this.currentLessonItem = this.selectedItems.getItemAt( 0 ) as LessonItemVO; 
				this.ui.list.selectedItem = this.currentLessonItem; 
				this.selectedIndex = 0; 
				this.model.currentLessonItem = this.currentLessonItem
			} 
		}
		
		
		
		
		private function onCancel(e:Event) : void
		{
			this.ui.hide();
		}				
		
		
	}
}