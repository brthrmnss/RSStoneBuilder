package   org.syncon.RosettaStone.controller
{
	
	import flash.events.Event;
	
	
	public class AutomateUIEvent extends Event
	{
		//UP
		static public var NEXT : String = 'CLICK_ITEM'  ; 
		static public var RESTART : String = 'RESTART---'  ; 
		static public var NEXT_SET : String = 'NEXT_SET---'  ; 			
		static public var DONE : String = 'DONE---'  ; 		
		static public var ACTIVE_CHANGED: String = 'ACTIVE_CHANGED'
		
			
		public var data : Object; 
		//Down
			
		public function AutomateUIEvent(type:String   , data :   Object  ) 
		{	
			this.data = data; 
			super(type, true);
		}
		
		
	}
}