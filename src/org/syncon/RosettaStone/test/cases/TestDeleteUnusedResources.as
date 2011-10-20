package org.syncon.RosettaStone.test.cases
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;
	import org.hamcrest.mxml.collection.Array;
	import org.syncon.RosettaStone.controller.IO.*;
	import org.syncon.RosettaStone.controller.Import.*;
	import org.syncon.RosettaStone.controller.Search.*;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon2.utils.data.GoThroughEach;
	import org.syncon2.utils.sound.PlaySound_Flex;
	
	public class TestDeleteUnusedResources
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
			
			this.makeStuff.setUp ( 'deleteUnused');
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
			this.makeStuff.serviceDispatcher.addEventListener( 'done', this.onDone ) ; 
			this.makeStuff.buildLesson()
			
			
			
			
			var asyncHandler:Function = Async.asyncHandler( this, handleTimerComplete, 50*1000, null, handleTimeout );
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, asyncHandler, false, 0, true );
			timer.delay = 50*1000
			timer.start();	
			
			
		}
		
		protected function onDone(event:Event):void
		{
			lessonBuildCount++
			if ( lessonBuildCount == 1   )
			{
				this.makeStuff.lesson.sets.removeAll(); 
				this.makeStuff.buildLesson()
			}
			if ( lessonBuildCount == 2   )
			{
				
				this.step2(); 
			}
		}		
		
		
		protected function handleTimerComplete( event:TimerEvent, passThroughData:Object ):void
		{
			trace('timer complete') 
		}
		
		protected function handleTimeout( passThroughData:Object ):void
		{
			//assertEquals( true, false ) ; 
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
		
	}
}