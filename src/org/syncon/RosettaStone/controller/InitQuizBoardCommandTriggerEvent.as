package   org.syncon.RosettaStone.controller
{
	import flash.events.Event;

	/**
	 * */
	public class InitQuizBoardCommandTriggerEvent extends Event
	{
		
		
		public static const INIT_QUIZBOARD:String = 'InitQuizBoardCommandTriggerEvent.init..';
		/*public var fxResult : Function;
		public var fxFault : Function; */
		public var showAds : Boolean = false;
		public var flex: Boolean = false ;
		public var data : Object = null; 
		public function InitQuizBoardCommandTriggerEvent(type:String, loadAds : Boolean = true,
														   flex : Boolean = false ,  data : Object = null,  fxR : Function=null, fxF : Function = null ) 
		{	
			/*this.fxResult = fxR
			this.fxFault = fxF; */
			this.showAds = loadAds; 
			this.flex = flex; 
			this.data = data; 
			super(type, true);
		}
		
		/**
		 * Maps user store commands 
		 * */
		/*
		static public function mapCommands(commandMap :  Object, command : Object ) : void
		{
			
			var types : Array = [
				InitMainContextCommandTriggerEvent.INIT, 
				InitMainContextCommandTriggerEvent.INIT2,
				InitMainContextCommandTriggerEvent.INIT3_MAKEUP_FLEX_DATA,
				InitMainContextCommandTriggerEvent.SET_MULTIPLER,			
				InitMainContextCommandTriggerEvent.EXIT_APP
			]
			for each ( var commandTriggerEventString : String in types ) 
			{
				commandMap.mapEvent(commandTriggerEventString,  command, InitMainContextCommandTriggerEvent, false );			
			}
		}		
		*/
	}
}