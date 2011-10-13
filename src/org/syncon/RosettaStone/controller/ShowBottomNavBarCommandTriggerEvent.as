package   org.syncon.RosettaStone.controller
{
	import flash.events.Event;

	/**
	 * */
	public class ShowBottomNavBarCommandTriggerEvent extends Event
	{
		public static const SHOW:String = 'ShowBottomNavBarCommandTriggerEvent.show..';
		public static const CLOSE:String = 'ShowBottomNavBarCommandTriggerEvent.hide..';
		
		public var fxResult : Function;
		public var fxFault : Function; 
		
		public function ShowBottomNavBarCommandTriggerEvent(type:String, fxR : Function=null, fxF : Function = null ) 
		{	
			this.fxResult = fxR
			this.fxFault = fxF; 
			super(type, true);
		}
		
	}
}