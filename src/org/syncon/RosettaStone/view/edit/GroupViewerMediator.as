package   org.syncon.RosettaStone.view.edit
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	
	public class GroupViewerMediator extends Mediator  
	{
		[Inject] public var ui :  GroupViewer;
		[Inject] public var model : RSModel;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_PLAN_CHANGED, 
				this.onGroupChanged);	
			this.onGroupChanged( null ) 
		}
		
		private function onGroupChanged(e: RSModelEvent): void
		{
			var group : LessonGroupVO = this.model.currentLessonPlan
			this.ui.data = group
		}		
		
		
	}
}