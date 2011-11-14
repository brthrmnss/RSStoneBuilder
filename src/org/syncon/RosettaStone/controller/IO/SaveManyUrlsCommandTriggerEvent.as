package   org.syncon.RosettaStone.controller.IO
{
	
	import flash.events.Event;
	
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	
	public class SaveManyUrlsCommandTriggerEvent extends Event
	{
		public static const SAVE_MANY_URLS:String = 'SAVE_MANY_URLS...';
		
		public var directory : String;
		public var urlArrayOverride:Array;
		public var url:String;
		public var itemNamesOverride : Array; 
		public var names : String; 
		public var appendFileExtension:Boolean;
		public  var fxResult:Function;
		
		public function SaveManyUrlsCommandTriggerEvent(type:String , directory : String, 
														url : String, names : String , fxResult : Function, appendFileExtension :  Boolean = true ) 
		{	
			this.directory = directory
			this.url = url
			this.names = names
			this.appendFileExtension = appendFileExtension
			this.fxResult = fxResult; 
			super(type, true);
		}
		
		
		static public function SaveFiles(  directory : String, 
										 url : String, names : String, fxResult : Function, appendFileExtension :  Boolean = true ) : 
			SaveManyUrlsCommandTriggerEvent
		{	
			var e : SaveManyUrlsCommandTriggerEvent = new SaveManyUrlsCommandTriggerEvent(
				SAVE_MANY_URLS, directory, url, names,fxResult, appendFileExtension )
			return e; 
		}
		
		static public function SaveFilesFromArrays(  directory : String, 
												   urlArrayOverride :  Array, itemNamesOverride : Array,
												   fxResult : Function, appendFileExtension :  Boolean = true ) : 
			SaveManyUrlsCommandTriggerEvent
		{	
			var e : SaveManyUrlsCommandTriggerEvent = new SaveManyUrlsCommandTriggerEvent(
				SAVE_MANY_URLS, directory,null, null,fxResult, appendFileExtension )

			e.urlArrayOverride =urlArrayOverride; 
			e.itemNamesOverride = itemNamesOverride
			return e; 
		}		
		
	}
}