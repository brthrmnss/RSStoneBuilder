package org.syncon.RosettaStone.view.edit
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	
	public class ItemViewerMediator extends Mediator 
	{
		[Inject] public var ui :  ItemViewer;
		[Inject] public var model : RSModel;
		private var currentLessonItem: LessonItemVO;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_ITEM_CHANGED, 
				this.onLessonItemChanged);	
			this.onLessonItemChanged( null ) 
			this.ui.addEventListener( ItemViewer.PLAY, this.onPlay ) 		
			this.ui.addEventListener( ItemViewer.SAVE, this.onSave ) 		
			
		}
		
		protected function onPlay(event:Event):void
		{
			this.model.playSound2( this.currentLessonItem.sourceSound ) ; 
		}
		public function onSave(   e : CustomEvent )  : void
		{
			 this.model.currentLessonItem = this.ui.filter
		}	
		
		protected function onPlayAll(event:CustomEvent):void
		{
			
		}
		
		private function onLessonItemChanged(e: RSModelEvent): void
		{
			this.currentLessonItem = this.model.currentLessonItem;
			this.ui.data = this.model.currentLessonItem; 
		}		
		
		
		
		
		
		
	}
}