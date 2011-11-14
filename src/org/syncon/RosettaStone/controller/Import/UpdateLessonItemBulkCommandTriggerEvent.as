package  org.syncon.RosettaStone.controller.Import
{
	import flash.events.Event;
	
	import mx.messaging.AbstractConsumer;
	
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.LessonVO;
	
	public class UpdateLessonItemBulkCommandTriggerEvent extends Event
	{
		public static const UPDATE_ITEMS:String = 'UpdateLessonItemCommandBulkTriggerEvent-UPDATE_ITEM.';
		
		public var fxResult : Function;
		public var save:Boolean;
		public var queryPost : String ; 
		public var searchResultNum:int = 0 ;
		public var actions:Array;
		public var items:Array;
		public var lesson:LessonVO;
		
		/**
		 * actions - promtp definitions or string of field to update
		 * */
		public function UpdateLessonItemBulkCommandTriggerEvent(type:String ,lesson : LessonVO,  items : Array,
																  fxR : Function, actions : Array, save : Boolean = true ,
																  queryPost : String = null, searchResultNum : int =0 ) 
		{	
			this.lesson = lesson; 
			this.items = items
			this.fxResult = fxR
			this.save = save; 
			this.actions = actions; 
			
			this.queryPost = queryPost; 
			this.searchResultNum = searchResultNum
			super(type, true);
		}
 
		
		
	}
}