package org.syncon.RosettaStone.controller.Import
{
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.controller.Search.SearchDictionaryTriggerEvent;
	import org.syncon.RosettaStone.controller.Search.SearchImagesTriggerEvent;
	import org.syncon.RosettaStone.controller.Search.SearchYoutubeCommandTriggerEvent;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon.RosettaStone.vo.PromptDefinitionVO;
	import org.syncon.RosettaStone.vo.PromptVO;
	import org.syncon.RosettaStone.vo.SearchResultVO;
	import org.syncon.RosettaStone.vo.SearchVO;
	import org.syncon2.utils.MakeVOs;
	import org.syncon2.utils.data.GoThroughEach;
	
	
	
	public class UpdateLessonItemBulkCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:UpdateLessonItemBulkCommandTriggerEvent;
		private var currentLessonItem: LessonItemVO;
		public var goThroughAllSelectedItems : GoThroughEach = new GoThroughEach(); 
		
		public var goThroughAllTypes : GoThroughEach = new GoThroughEach(); 
		
		override public function execute():void
		{
			if ( event.type == UpdateLessonItemBulkCommandTriggerEvent.UPDATE_ITEMS ) 
			{
				this.startSetup()
			}				
		}
 
		public function startSetup( ) : void
		{
			this.goThroughAllSelectedItems.go( this.event.items, this.onNextLessonItem, this.onLessonItemsDone ) 	
		}
		
		
		private function onNextLessonItem(i : LessonItemVO):void
		{
			this.currentLessonItem = i; 
			this.goThroughAllTypes.go( this.collectOptions(), this.onProcessUpdate, this.onProcesingItemUpdateDone,1000 )
			//this.onProcessUpdate()
			return;//
		}		
		
		
		private function onLessonItemsDone( ):void
		{
			if ( this.event.fxResult != null ) 
				this.event.fxResult(   ) ; 
		}
		
		
		
		
		private function onProcessUpdate( actionOrPrompt : Object ):void
		{
			if ( actionOrPrompt is String ) 
			{
				var action : String = actionOrPrompt.toString(); 
			}
			if ( actionOrPrompt is PromptDefinitionVO ) 
			{
				//	this.currentItem.currentPrompt = actionOrPrompt as PromptVO
				this.currentLessonItem.setPromptDefinition( actionOrPrompt as PromptDefinitionVO,
					true, event.lesson.clonePrompts )
			}
			this.dispatch( new UpdateLessonItemCommandTriggerEvent
				(UpdateLessonItemCommandTriggerEvent.UPDATE_ITEM, '',
					this.currentLessonItem, this.goThroughAllTypes.next, action, 
					true, '', this.event.queryPost,  this.event.searchResultNum ) ) ; 
			return;//
		}		
		public function collectOptions () : Array
		{
			return this.event.actions; // [UpdateLessonItemCommandTriggerEvent.PIC, this.promptDefs(PIC) ];
		}
		
		
		private function onProcesingItemUpdateDone( ):void
		{
			this.goThroughAllSelectedItems.next(); 
		}		
		
		
		
		
	}
}