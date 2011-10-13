package org.syncon.RosettaStone.view.edit
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	
	public class ItemSetViewerMediator extends Mediator 
	{
		[Inject] public var ui :  ItemSetViewer;
		[Inject] public var model : RSModel;
		private var currentLessonSet: LessonSetVO;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_SET_CHANGED, 
				this.onLessonItemSetChanged);	
			this.onLessonItemSetChanged( null ) 
			
			this.ui.addEventListener( ItemSetViewer.SAVE, this.onSave ) 		
			this.ui.addEventListener( ItemSetViewer.COLLECT, this.onCollectItemResources ) 	
		}
		public function onSave(   e : CustomEvent )  : void
		{
			// this.model.currentLessonItem = this.ui.filter
			this.model.saveLesson(); 
		}	
		
		public function onCollectItemResources(   e : CustomEvent )  : void
		{
			this.model.collect(); 
		}	
		
		private function onLessonItemSetChanged(e: RSModelEvent): void
		{
			this.ui.data = this.model.currentLessonSet; 
		}		
		
	}
}