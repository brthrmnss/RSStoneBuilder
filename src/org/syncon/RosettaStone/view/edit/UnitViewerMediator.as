package   org.syncon.RosettaStone.view.edit
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	import org.syncon.RosettaStone.vo.UnitVO;
	
	public class UnitViewerMediator extends Mediator  
	{
		[Inject] public var ui :  UnitViewer;
		[Inject] public var model : RSModel;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_UNIT_CHANGED, 
				this.onUnitChanged);	
			this.onUnitChanged( null ) 
		}
		
		private function onUnitChanged(e: RSModelEvent): void
		{
			var unit : UnitVO = this.model.currentUnit
			this.ui.data = unit
		}		
		
	}
}