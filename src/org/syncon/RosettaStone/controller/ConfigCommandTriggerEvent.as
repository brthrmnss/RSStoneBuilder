package   org.syncon.RosettaStone.controller
{
	
	import flash.events.Event;
	import flash.utils.ByteArray;
 
	public class ConfigCommandTriggerEvent extends Event
	{
		public static const LOAD_CONFIG:String = 'loadRSConfig';
		public static const SAVE_CONFIG:String = 'saveRsCnofig';
		public static var SAVE_AND_LOAD_CONFIG:String= 'saveAndLoadRsConfig';
		public var filename : String;
		public var password : String;		
		
		public var fxResult : Function;
		public var fxFault : Function; 

		
		public function ConfigCommandTriggerEvent(type:String   ,  filename : String = '' , fxR : Function=null, fxF : Function = null ) 
		{	
			this.fxResult = fxR
			this.fxFault = fxF; 
			this.filename = filename; 
			super(type, true);
		}
		
		
		static public function mapCommands(commandMap :  Object, command : Object ) : void
		{
			var types : Array = [
				ConfigCommandTriggerEvent.LOAD_CONFIG, 
				ConfigCommandTriggerEvent.SAVE_CONFIG,
				SAVE_AND_LOAD_CONFIG
			]
			for each ( var commandTriggerEventString : String in types ) 
			{
				commandMap.mapEvent(commandTriggerEventString,  command, ConfigCommandTriggerEvent, false );			
			}
		}		
		
	}
}