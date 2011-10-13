package   org.syncon.RosettaStone.controller
{
	import flash.events.Event;
 
	public class CheckAlarmsCommandTriggerEvent extends Event
	{
		public static const CHECK_ALARMS:String = 'CHECK_ALARMS';
		//public var config : IWidgetConfigVO;		
		
		public var fxResult : Function;
		public var fxFault : Function; 
		
		public function CheckAlarmsCommandTriggerEvent(type:String   ,   fxR : Function=null, fxF : Function = null ) 
		{	
			//this.config = config
			this.fxResult = fxR
			this.fxFault = fxF; 
			super(type, true);
		}
		 
		
	}
}