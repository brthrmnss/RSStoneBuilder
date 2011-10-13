package   org.syncon.RosettaStone.controller
{
	import flash.events.Event;
	import flash.utils.ByteArray;

	/**
	 * */
	public class ManageAdCommandTriggerEvent extends Event
	{
		public static const AD_SHOW:String = 'AD_SHOW.init..';
		public static const AD_HIDE:String = 'AD_HIDE.init.2.';
		public static const IMPORT_AD:String = 'IMPORT_AD.init.2.';
		
		public var data : Object = null; 
		public function ManageAdCommandTriggerEvent(type:String,   data : Object = null,  fxR : Function=null, fxF : Function = null ) 
		{	
			this.data = data; 
			super(type, true);
		}
		
		/**
		 * Maps user store commands 
		 * */
		static public function mapCommands(commandMap :  Object, command : Object ) : void
		{
			
			var types : Array = [
				ManageAdCommandTriggerEvent.AD_SHOW, 
				ManageAdCommandTriggerEvent.AD_HIDE,
				ManageAdCommandTriggerEvent.IMPORT_AD
			]
			for each ( var commandTriggerEventString : String in types ) 
			{
				commandMap.mapEvent(commandTriggerEventString,  command, ManageAdCommandTriggerEvent, false );			
			}
		}		
		
	}
}