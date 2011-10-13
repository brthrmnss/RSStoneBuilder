package org.syncon.RosettaStone.view.edit
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.PromptVO;
	
	public class ItemPromptViewerMediator extends Mediator 
	{
		[Inject] public var ui : ItemPromptViewer;
		[Inject] public var model : RSModel;
		private var currentLessonItem: LessonItemVO;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_ITEM_CHANGED, 
				this.onLessonItemChanged);	
			this.onLessonItemChanged( null ) 
			this.ui.addEventListener( ItemPromptViewer.PLAY, this.onPlay ) 		
			this.ui.addEventListener( ItemPromptViewer.SAVE, this.onSave ) 		
			this.ui.addEventListener( ItemPromptViewer.SELECT_PROMPT, this.onSelectPrompt ) 		
			
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.LESSON_PROMPTS_CHANGED, 
				this.onLessonItemChanged);	
			this.onLessonItemChanged( null ) 
		}
		
		protected function onSelectPrompt(event:CustomEvent):void
		{
			var prompt : PromptVO = event.data as PromptVO;
			this.currentLessonItem.currentPrompt = prompt
			this.model.currentPrompt = prompt
			this.ui.prompt = this.model.currentPrompt
			
			this.ui.updateItemRenderer(); 
		}
		
		protected function onPlay(event:Event):void
		{
			this.model.playSound2( this.currentLessonItem.sourceSound ) ; 
		}
		public function onSave( e : CustomEvent ) : void
		{
			this.model.currentLessonItem = this.ui.item
		}	
		
		protected function onPlayAll(event:CustomEvent):void
		{
			
		}
		
		private function onLessonItemChanged(e: RSModelEvent): void
		{
			this.currentLessonItem = this.model.currentLessonItem;
			
			this.model.currentPrompt = null; 
			this.ui.prompt = this.model.currentPrompt; 
			
			this.ui.data = this.model.currentLessonItem; 
			if ( this.currentLessonItem == null ) 
				return;
			this.currentLessonItem.prompts = new ArrayCollection(this.model.currentLesson.clonePrompts( this.currentLessonItem.prompts.toArray() ) ) 
			
			this.ui.list.dataProvider = this.currentLessonItem.prompts
		}		
		
		
		
		
		
		
	}
}