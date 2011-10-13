package views.lite.flash.events
{
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class StageOrientationEvent extends Event
	{
		public static const ORIENTATION_CHANGE:String = 'loadConfig';
		public static const SAVE_CONFIG:String = 'saveCnofig';
		public var url : String;
		public var password : String;		
		
		public var fxResult : Function;
		public var fxFault : Function; 
		
		public function StageOrientationEvent(type:String   , fxR : Function=null, fxF : Function = null ) 
		{	
			this.fxResult = fxR
			this.fxFault = fxF; 
			super(type, true);
		}
		
	}
}