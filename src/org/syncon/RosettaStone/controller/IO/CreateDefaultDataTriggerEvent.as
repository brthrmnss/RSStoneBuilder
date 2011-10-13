package  org.syncon.RosettaStone.controller.IO
{
	import flash.events.Event;
	
	import org.syncon.RosettaStone.vo.LessonGroupVO;
 
	public class CreateDefaultDataTriggerEvent extends Event
	{
		public static const CREATE:String = 'CreateDefaultDataTriggerEvent...';
		
		public var config : Object;
		
		public function CreateDefaultDataTriggerEvent(type:String   , config :  Object  ) 
		{	
			this.config = config
			super(type, true);
		}
		
	 
	}
}