package  	org.syncon.RosettaStone.view.popup.rs 
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.AutomateEvent;
	import org.syncon.RosettaStone.controller.Import.UpdateLessonItemBulkCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.Places;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.PromptDefinitionVO;
	
	public class  PopupSearchWordMediator extends Mediator
	{
		[Inject] public var ui:PopupSearchWord;
		[Inject] public var model : RSModel;
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		private var currentLessonItem:LessonItemVO;
		private var selectedItems:ArrayCollection;
		private var selectedIndex:int;
		private var ignoreClickOn:Object;
		
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
			this.ev.addEv(PopupSearchWord.ALL, this.onAllItemsList )				
			this.ev.addEv(PopupSearchWord.CHANGE_PROMPT, this.onChangePrompt )				
			
			this.ev.addEv(PopupSearchWord.AUTOMATE, this.onAutomate )	
			
			this.mediatorMap.createMediator( this.ui.searchDictionary ) ; 
			this.mediatorMap.createMediator( this.ui.searchPic ) ; 
			this.mediatorMap.createMediator( this.ui.searchSounds ) ; 			
			this.mediatorMap.createMediator( this.ui.searchYoutube ) ; 	
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_ITEM_CHANGED, 
				this.onLessonItemChanged);	
			this.onLessonItemChanged( null ) 
			
			this.ui.addEventListener( ItemBulkRenderer.PLAY_ITEM, this.onPlayItem )  
			//this.ui.addEventListener(  ItemPromptViewerBulk.PLAY, this.onPlayItem2 )
				
			this.ui.addEventListener(PopupUpdateMultipleItemBulkRenderer.IGNORE, this.onIgnoreClickOnItem  )  
		}
		
		protected function onIgnoreClickOnItem(event:CustomEvent):void
		{
			this.ignoreClickOn = event.data as LessonItemVO; 
		}
		public function onPlayItem2(e:CustomEvent):void
		{
			var item : LessonItemVO = e.data[0] as LessonItemVO
			var url : String = e.data[1] as String
			this.model.playLessonItem(item, null, url ); 
		}	
		public function onPlayItem(e:CustomEvent):void
		{
			var item : LessonItemVO = e.data as LessonItemVO
			this.model.playLessonItem(item); 
		}
		
		private function onAutomate(e:Event):void
		{
			/*this.model.currentPromptDefinition = this.ui.boxCombo.selectedItem as PromptDefinitionVO; 
			this.viewer.data = this.currentLessonItem; */
			
			if ( this.model.currentLesson.currentPromptDef == null ) 
				throw 'only works for prompts' 
				//only get teh selected ones 
			this.dispatch( new  UpdateLessonItemBulkCommandTriggerEvent ( 
				UpdateLessonItemBulkCommandTriggerEvent.UPDATE_ITEMS, 
				this.model.currentLesson, 
				this.ui.list.dataProvider.toArray(), this.onDoneAutomating,
				[this.model.currentLesson.currentPromptDef], true,
				this.ui.txtQueryPre.text, 0  
			) ) ; 
		}
		
		private function onDoneAutomating(e:Event=null):void
		{
			trace('PopupSearchWordMediator', 'onDoneAutomating') 
			this.model.saveLesson()
			return; 
		}
		
		private function onChangePrompt(e:Event):void
		{
			var p : PromptDefinitionVO = this.ui.boxCombo.selectedItem as PromptDefinitionVO; 
			if ( p.id == -1 ) 
				p = null; 
			this.model.currentPromptDefinition = p;
			this.ui.viewer.data = this.currentLessonItem; 
		}
		
		private function onAllItemsList(e:Event):void
		{
			// TODO Auto Generated method stub
			this.ui.list.dataProvider = new ArrayCollection(this.model.currentLesson.items ) 
			this.updatelIST()
		}
		private function onChangeItem(e: CustomEvent): void
		{
			if ( ignoreClickOn == e.data  ) 
			{
				this.ignoreClickOn = null 
				return; 
			}
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
			this.ui.viewer.data = this.currentLessonItem; 
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
			
			var options : Array = this.model.currentLesson.getPrompts().toArray()
			var allOpt : PromptDefinitionVO = new  PromptDefinitionVO()
			allOpt.id = -1 
			allOpt.name = 'none' 
			options.unshift( allOpt ) 
			
			this.ui.boxCombo.dataProvider= new ArrayCollection( options )
			this.ui.boxCombo.selectedItem = this.model.currentLesson.currentPromptDef; 
			if ( this.model.currentLesson.currentPromptDef == null ) 
				this.ui.boxCombo.selectedIndex = 0 ; 
			//this.ui.txtLessonName.text = this.model.currentLessonPlan.name;
			this.onLessonItemChanged(null); 
			this.updatelIST()
		}
		
		private function updatelIST():void
		{
			// TODO Auto Generated method stub
			if  ( this.ui.holderList.visible ) 
			{
				this.selectedItems = new ArrayCollection(	this.ui.list.dataProvider.toArray() )
				this.currentLessonItem = this.selectedItems.getItemAt( 0 ) as LessonItemVO; 
				this.ui.list.selectedItem = this.currentLessonItem; 
				this.selectedIndex = 0; 
				this.model.currentLessonItem = this.currentLessonItem
				
				this.ui.viewer.includeInLayout = true; 
				this.ui.viewer.visible = true; 
				
				this.ui.viewer.data = this.currentLessonItem; 
			} 
			else
			{
				this.ui.viewer.includeInLayout = false; 
				this.ui.viewer.visible = false; 				
			}
		}		
		
		
		
		private function onCancel(e:Event) : void
		{
			this.ui.hide();
		}				
		
		
	}
}