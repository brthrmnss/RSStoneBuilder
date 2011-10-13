package  org.syncon.RosettaStone.view.edit
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	
	public class PlayerItemViewerMediator extends Mediator 
	{
		[Inject] public var ui : PlayerItemViewer;
		[Inject] public var model : RSModel;
		private var currentLessonItem: LessonItemVO;
		
		override public function onRegister():void
		{
			/*	eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_LESSON_ITEM_CHANGED, 
			this.onLessonItemChanged);	
			this.onLessonItemChanged( null ) 
			*/
			this.ui.addEventListener( PlayerItemViewer.PLAY_PROMPT, this.onPlayPrompt ) 	 
			this.ui.addEventListener( PlayerItemViewer.DATA_CHANGED, this.onDataChanged ) 	 
		}
		
		protected function onDataChanged(event:Event):void
		{
			this.currentLessonItem = this.ui.filter
		}
		
		public function onPlayPrompt(   e : CustomEvent )  : void
		{
			this.model.playSound2( this.currentLessonItem.sourceSound )
			//	this.model.currentLessonItem = this.ui.filter
		}	
		
		
		
		
	}
}