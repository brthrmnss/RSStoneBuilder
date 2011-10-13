package   org.syncon.RosettaStone.controller.IO
{
	
	import flash.events.Event;
	
	import org.syncon.RosettaStone.vo.UnitVO;
	
	public class SaveUnitCommandTriggerEvent extends Event
	{
		public static const SAVE_UNIT:String = 'SAVE_UNIT_triggerEvet...';
		
		public var unit : UnitVO;
		
		public function SaveUnitCommandTriggerEvent(type:String   , unit : UnitVO) 
		{	
			this.unit = unit
			super(type, true);
		}
		
		
	}
}