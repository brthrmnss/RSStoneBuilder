package org.syncon.RosettaStone.controller.IO
{
	
	import com.adobe.serialization.json.JSON;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonVO;
	
	
	public class LoadLessonCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:LoadLessonTriggerEvent;
		public var injections  : Array = ['model', RSModel] 
		override public function execute():void
		{
			if ( event.type == LoadLessonTriggerEvent.LOAD_SOUNDS ) 
			{
		
				this.loadLesson()
			}				
			//this.findPortFile(); 
		}
		
		
		private function loadLesson():void
		{
			var fileLocation : String// = event.exactUrl; 
			//exact location specified
			if ( event.exactUrl != '' )
			{
				//fileLocation = event.lesson.folder_name; 
				NightStandConstants.FileLoader.readFile( null, event.exactUrl, this.onLessonLoaded ) 
				return; 
			}
			
			//if ( event.subdir != null && event.subdir != '' ) 
			fileLocation = event.lesson.baseFolder 
			
			if ( fileLocation != ''  && fileLocation != '' ) 	
				fileLocation = fileLocation+ '/' 
					
			if ( event.lesson.folder_name == '' ) 
				event.lesson.folder_name = event.lesson.name; 
			fileLocation	 += event.lesson.folder_name; 
			
			
			if ( fileLocation == '' ) 
				throw 'cant find file';
			
			NightStandConstants.FileLoader.readFile(fileLocation ,"lesson.json", this.onLessonLoaded ) 
		}		
		
		public function onLessonLoaded( input : String ) : void
		{
			if ( input == null )
			{
				this.onLessonLoadedPart3( null ) ; 
				return
			}
			var inputObj :  Object = JSON.decode( input.toString() )
			var lesson : LessonVO = event.lesson; 
			lesson.importObj( inputObj ) ; 
			this.onLessonLoadedPart3( lesson ) ; 
		}
		public function onLessonLoadedPart3( lesson  : LessonVO ) : void
		{
			if ( lesson == null ) 
			{
				if ( event.autoCreate == false ) 
				{
					if ( this.event.fxDone != null ) 
						this.event.fxDone(null); 
					return; 
				}
				lesson = event.lesson
				/*this.dispatch( new CreateDefaultDataTriggerEvent(
				CreateDefaultDataTriggerEvent.CREATE, config ) ) ;*/
				//save this 
				this.dispatch( new SaveLessonTriggerEvent(SaveLessonTriggerEvent.LOAD_SOUNDS, 
					lesson , this.model.currentLessonPlan.getSubDir() ) ) ; 
			}
			lesson.retrievedContentsOnce = true; 
			if ( event.updateModel ) 
			this.model.currentLesson = lesson; 
			
			this.model.copyAssetFolderToItems(); 
			
			if ( this.event.fxDone != null ) 
				this.event.fxDone(lesson); 
			/*
			//if auto load
			if ( config.lessons.length > 0 ) 
			{
			var firstLesson : LessonVO = config.lessons.getItemAt(  0 )  as LessonVO
			
			this.dispatch( new  LoadLessonTriggerEvent(LoadLessonTriggerEvent.LOAD_SOUNDS, firstLesson) ) ; 
			
			}
			*/
		}
		
	}
}