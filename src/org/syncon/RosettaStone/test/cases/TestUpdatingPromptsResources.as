package org.syncon.RosettaStone.test.cases
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;
	import org.hamcrest.mxml.collection.Array;
	import org.syncon.RosettaStone.controller.IO.*;
	import org.syncon.RosettaStone.controller.Import.*;
	import org.syncon.RosettaStone.controller.Search.*;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon2.utils.data.GoThroughEach;
	import org.syncon2.utils.sound.PlaySound_Flex;
	import org.syncon.RosettaStone.vo.PromptDefinitionVO;
	
	/**
	 * Create a lesson, create items, 
	 * bulk update many of hte items prompts , 
	 *  
	 * @author user3
	 * 
	 */
	public class TestUpdatingPromptsResources
	{
		
		private var makeStuff : TestUpdateManyLessonItems = new TestUpdateManyLessonItems(); 
		
		/*
		public var goThroughAllSelectedItems : GoThroughEach = new GoThroughEach(); 
		public var goDownloadAllOptions : GoThroughEach = new GoThroughEach(); 
		private var serviceDispatcher:EventDispatcher = new EventDispatcher();
		public var model : RSModel;
		*/
		private var timer:Timer= new Timer( 50*1000, 1 );	
		private var lessonBuildCount:int;
		private var fileNames:Array;
		
		
		
		[Before]
		public function setUp():void
		{
			
			this.makeStuff.setUp ( 'UpdateLessonFromPrompts');
			this.makeStuff.itemsToMake = [ 'dog', 'cat']//, 'bird'] 
			
			
			
		}
		
		import org.syncon.RosettaStone.model.NightStandConstants;
		import org.syncon2.utils.file.LoadConfig_Flex;
		
		
		[After]
		public function tearDown():void
		{
			/*this.serviceDispatcher = null;
			this.service = null;*/
		}
		
		[Test(async)]
		public function testRetreiveImages():void
		{
			this.makeStuff.serviceDispatcher.addEventListener( TestUpdateManyLessonItems.LOADED_LESSON, this.onDone ) ; 
			this.makeStuff.creationOptions = this.makeStuff.basics; 
			//this.makeStuff.buildLesson()
			this.makeStuff.loadLesson(); 
			var asyncHandler:Function = Async.asyncHandler( this, handleTimerComplete, 10*50*1000, null, handleTimeout );
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, asyncHandler, false, 0, true );
			timer.delay = 10*50*1000
			timer.start();	
			
			
		}
		
		protected function onDone(event:Event):void
		{
			this.beganProcessing = true; 
			lessonBuildCount++
			if ( lessonBuildCount == 1   )
			{
				this.step1_addPrompts()
				//this.makeStuff.lesson.sets.removeAll(); 
				//this.makeStuff.buildLesson()
			}
			if ( lessonBuildCount == 2   )
			{
				
				this.step2(); 
			}
		}		
		public static var ALT_PIC2  : String =   'Alt2 Pic' 
		private function step1_addPrompts():void
		{
			var def : PromptDefinitionVO = new PromptDefinitionVO()
			def.name =ALT_PIC2 
			def.makePic(); 
			
			this.makeStuff.lesson.addPrompt( def ) ; 
			
			//this.makeStuff.creationOptions = [this.makeStuff.lesson.findPromptByName( ALT_PIC2)  ] 
			this.makeStuff.serviceDispatcher.addEventListener( TestUpdateManyLessonItems.DONE_UPDATE, this.onDoneUpdate ) ;
			this.makeStuff.updateLesson(null, [this.makeStuff.lesson.findPromptByName( ALT_PIC2)  ] ,'dog',2); 
			
			
			
		}		
		
		protected function onDoneUpdate(event:Event):void
		{
			this.makeStuff.model.saveLesson()
			trace('done'); 
			this.terminateTest()
			trace('post terminate' )  
		}
		
		protected function handleTimerComplete( event:TimerEvent, passThroughData:Object ):void
		{
			trace('timer complete') 
			if ( this.beganProcessing == false ) 
				fail('Never Started processing, has webserver been started?');
		}
		
		protected function handleTimeout( passThroughData:Object ):void
		{
			assertEquals( true, false ) ; 
		}
		
		
		private function step2():void
		{
			// TODO Auto Generated method stub
			
			
			this.getAllFolders()
			
		}
		
		
		private function getAllFolders():void
		{
			NightStandConstants.FileLoader.getDirectoryListing( this.getFolder(), this.onFileNames ) ; 
		}
		
		private function onFileNames(names : Array ):void
		{
			// TODO Auto Generated method stub
			this.fileNames = names; 
			var datas : Array = this.makeStuff.lesson.getAllMedia()
			datas.push('lesson.json'); 
			var filesToRemove : Array = this.itemsInANotInB( fileNames, datas ) ; 
			var dbg : Array = [datas.length, filesToRemove.length, names.length] 
			assertEquals('Doesnt seem like enough files were downloaded, too fe wfiles found', names.length>5, true ) ; 
			this.deleteAllFiles(filesToRemove)
		} 
		
		private function itemsInANotInB(fileNames:Array, datas:Array):Array
		{
			var remove:Array = [];
			for each ( var  str : String in fileNames ) 
			{
				if ( datas.indexOf( str ) == -1 ) 
					remove.push(str)
			}
			return remove;
		}
		public var deleteFiles : GoThroughEach = new GoThroughEach(); 
		/**
		 * Set to true when processing begins
		 * */
		private var beganProcessing:Boolean;
		public function  deleteAllFiles(filesToRemove: Array) : void
		{
			this.deleteFiles.go( filesToRemove, this.onDeleteNext, this.onCompleteDeletion, 250 ) ; 
			/*
			var folder : String = this.getFolder()
			for each ( var  str : String in fileNames ) 
			{
			NightStandConstants.FileLoader.deleteFile(( this.getFolder(), str ) ; 
			}
			*/
		}
		
		
		public function onDeleteNext(str : String ) : void
		{
			NightStandConstants.FileLoader.deleteFile( this.getFolder(), str, this.deleteFiles.next  ) ; 
		}
		
		
		public function onCompleteDeletion() : void
		{
			trace('onCompleteDeletion','...');
			//Async.
			this.verifyCompletion(); 
		}
		
		private function verifyCompletion():void
		{
			NightStandConstants.FileLoader.getDirectoryListing( this.getFolder(), this.onFileNames_Verify ) ; 
		}
		
		private function onFileNames_Verify(names : Array ):void
		{
			assertEquals('all files werent deleted', names.length==4+1, true) ; 
		} 
		
		private function getFolder():String
		{
			//return  this.makeStuff.lesson.baseFolder
			return 'test' + '/' + this.makeStuff.lesson.folder_name
		}
		
		/*		
		private function dispatch( e : Event ) : void
		{
		if ( e is UpdateLessonItemCommandTriggerEvent ) 
		{
		var c : UpdateLessonItemCommand = new UpdateLessonItemCommand()
		c.event =  e as UpdateLessonItemCommandTriggerEvent ; 
		c.model = this.model; 
		c.eventDispatcher = serviceDispatcher; 
		c.execute(); 
		}
		var commandClass : Class = this.commands[e.type] as Class; 
		if ( commandClass != null ) 
		{
		var command :  Object = new commandClass()
		command.event =  e ;//as UpdateLessonItemCommandTriggerEvent ; 
		command.model = this.model; 
		command.eventDispatcher = serviceDispatcher; 
		command.execute(); 
		}
		}
		*/
		
		private function terminateTest():void
		{
			this.timer.stop()
			this.timer.dispatchEvent( new TimerEvent(TimerEvent.TIMER_COMPLETE, false, false ) ) ; 
		}
		
	}
}