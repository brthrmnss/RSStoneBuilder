package org.syncon.RosettaStone.controller.IO
{
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon2.utils.data.GoThroughEach;
	
	/**
	 * can save many urls and any fiels names, 
	 * but works on 1 as wlel ..
	 
	 
	 */
	public class SaveManyUrlsCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:SaveManyUrlsCommandTriggerEvent;
		public var injections  : Array = ['model', RSModel] 
		
		public var filenames : Array = [] ; 
		private var goTrhgoutEAchWrodInName:GoThroughEach = new GoThroughEach();
		private var currentUrl:String;
		private var currentFilename:String;
		private var savedFilesnames:Array = [];
		override public function execute():void
		{
			if ( event.type == SaveManyUrlsCommandTriggerEvent.SAVE_MANY_URLS ) 
			{
				this.saveLessonPlan()
			}				
			//this.findPortFile(); 
		}
		
		
		private function saveLessonPlan():void
		{
			var url : String =  event.url ; 
			var items : Array = [url] 
			filenames = [event.names]
			if ( url.indexOf(' ' ) != -1 ) 
			{
				items = url.split(' '); 
				filenames = event.names.split(' ')
			} 
			if ( event.urlArrayOverride != null ) 
				items =  event.urlArrayOverride ; 
			if ( event.itemNamesOverride != null ) 
				filenames =  event.itemNamesOverride ; 
			
			if ( items.length == 0 || filenames.length == 0 ) 
			{
				trace('SaveManyUrlsCommand', 'warning', 'nothign to save' )
			}
			if ( items.length   !=  filenames.length   ) 
			{
				throw 'SaveManyUrlsCommand '+ 'lengths not the same'
				trace('SaveManyUrlsCommand', 'warning', 'nothign to save' )
			}			
			this.goTrhgoutEAchWrodInName.go( items, this.onSaveNextFile, this.onDoneSearchingWords ) 
		}
		
		
		private function onSaveNextFile(url : String):void
		{
			this.currentUrl = url; 
			this.currentFilename = this.filenames[this.goTrhgoutEAchWrodInName.index] 
			if ( this.event.appendFileExtension )
				this.currentFilename+='.***'
			var url : String = unescape(url)
			NightStandConstants.FileLoader.downloadFileTo(this.currentUrl ,event.directory, 
				this.currentFilename , this.onSavedSound, true  )
			
		}
		
		
		public function onSavedSound(filename:String):void
		{
			/*if ( this.currentLessonItem.sound != '' ) this.currentLessonItem.sound += ' '
			this.currentLessonItem.sound +=  filename;
			this.currentLessonItem.update()*/
			this.savedFilesnames.push( filename ) ; 
			this.goTrhgoutEAchWrodInName.next() 
		}
		
		public function onDoneSearchingWords():void
		{
			var finalFiles : String = this.savedFilesnames.join(' '); 
			if  ( event.fxResult != null ) 
				event.fxResult(finalFiles); 
		}
		
		
	}
}