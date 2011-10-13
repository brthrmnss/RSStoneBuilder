package org.syncon.RosettaStone.controller.IO
{
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	
	
	public class SaveLessonCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:SaveLessonTriggerEvent;
		
		public var injections  : Array = ['model', RSModel] 
		
		override public function execute():void
		{
			if ( event.type == SaveLessonTriggerEvent.LOAD_SOUNDS ) 
			{
				this.saveLesson()
			}				
		}
		private function saveLesson():void
		{
			var output : String = event.lesson.export()
			/*if ( event.url != '' )
			{
			fileLocation = event.lesson.folder_name; 
			NightStandConstants.FileLoader.readFile("" ,fileLocation, this.importConfig ) 
			return; 
			}
			*/
				//please specify a folder ... or we make it up 
			if ( event.lesson.folder_name == '' ) 
			{
				event.lesson.folder_name = event.lesson.name
			}
			var folderUrl : String = event.lesson.folder_name

			if ( event.subdir != '' ) 
			{
				folderUrl = event.subdir +'/'+ event.lesson.folder_name;
			}
			
			
			
			//notice that the name is fixed
			NightStandConstants.FileLoader.writeFile( output, folderUrl, "lesson.json", this.saved ) 
		}
		
		public function saved( c : Object ) : void
		{
			this.event.lesson.updated()
		}
		
		
	}
}