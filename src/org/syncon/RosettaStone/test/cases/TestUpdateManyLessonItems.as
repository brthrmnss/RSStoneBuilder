package org.syncon.RosettaStone.test.cases
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;
	import org.syncon.RosettaStone.controller.IO.*;
	import org.syncon.RosettaStone.controller.Import.*;
	import org.syncon.RosettaStone.controller.Search.*;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon.RosettaStone.vo.LessonVO;
	import org.syncon.RosettaStone.vo.PromptDefinitionVO;
	import org.syncon2.utils.MakeVOs;
	import org.syncon2.utils.data.GoThroughEach;
	import org.syncon2.utils.sound.PlaySound_Flex;
	
	public class TestUpdateManyLessonItems
	{
		public var goThroughAllSelectedItems : GoThroughEach = new GoThroughEach(); 
		public var goDownloadAllOptions : GoThroughEach = new GoThroughEach(); 
		public var serviceDispatcher:EventDispatcher = new EventDispatcher();
		public var model : RSModel;
		//private var command :  
		public var lesson:LessonVO;
		private var lessonPlan :  LessonGroupVO; 
		private var currentItem:LessonItemVO;
		private var goThroughAllTypes : GoThroughEach = new GoThroughEach(); 
		private var timer:Timer= new Timer( 50*1000, 1 );	
		private var prompts:Array;
		
		static public var DONE_UPDATE : String = 'UPDATE_DONE'; 
		static public var LOADED_LESSON: String = 'LOADED_LESSON'; 
		[Before]
		public function setUp(  lessonBaseFolder : String = 'lesson' , planBaseFolder : String = 'test' ):void
		{
			this.baseFolderPlan = planBaseFolder; 
			this.baseFolderLesson = lessonBaseFolder; 
			this.model = new RSModel(); 
			this.model.eventDispatcher = this.serviceDispatcher
			/*	serviceDispatcher = new EventDispatcher();
			service = new EvernoteService();
			service.eventDispatcher = serviceDispatcher;*/
			this.setupDispatcher()
			this.createInitLesson()
			this.setupFolders(); 
			
			this.makePrompts()
			
		}
		import org.syncon.RosettaStone.controller.Search.SearchDictionaryTriggerEvent;
		import org.syncon.RosettaStone.controller.Search.SearchImagesTriggerEvent;
		import org.syncon.RosettaStone.controller.Search.SearchYoutubeCommandTriggerEvent;
		private function setupDispatcher():void
		{
			
			// TODO Auto Generated method stub
			this.registerCommand( SearchDictionaryTriggerEvent.SEARCH_DICTIONARY, SearchDictionaryCommand  )
			this.registerCommand( SearchImagesTriggerEvent.SEARCH_IMAGES, SearchImagesCommand )
			this.registerCommand( SearchYoutubeCommandTriggerEvent.SEARCH_YOUTUBE, SearchYoutubeCommand )
			this.registerCommand( SaveLessonTriggerEvent.SAVE_LESSON, SaveLessonCommand )
			this.registerCommand( UpdateLessonItemBulkCommandTriggerEvent.UPDATE_ITEMS, UpdateLessonItemBulkCommand  )
				
			this.registerCommand( UpdateLessonItemCommandTriggerEvent.UPDATE_ITEM, UpdateLessonItemCommand  )
			this.registerCommand( LoadLessonPlanCommandTriggerEvent.LOAD_LESSON_PLAN, LoadLessonPlanCommand );
			this.registerCommand( LoadLessonTriggerEvent.LOAD_SOUNDS, LoadLessonCommand );
			this.registerCommand( SaveManyUrlsCommandTriggerEvent.SAVE_MANY_URLS, SaveManyUrlsCommand );
		}
		
		/**
		 * Registers a command so it can be distpatched 
		 * */
		private function registerCommand(type:String, param1:Class):void
		{
			// TODO Auto Generated method stub
			this.serviceDispatcher.addEventListener( type, this.dispatch )
			this.commands[type] = param1; 
		}
		import org.syncon.RosettaStone.model.NightStandConstants;
		import org.syncon2.utils.file.LoadConfig_Flex;
		private function setupFolders():void
		{
			NightStandConstants.flex = true;
			NightStandConstants.FileLoader = new LoadConfig_Flex()
			NightStandConstants.ResourcesDir = 'assets' + '/'// why is this  aproblem
			
			var dbg : Array = [	LoadConfig_Flex.getDir('/d/g'),
				LoadConfig_Flex.getDir('/d/g/'),LoadConfig_Flex.getDir('/d/g.json')
			] 
			
			//other things are setup on rosettastonebuilder.mxml
			RSModel.BASE_FOLDER= 'assets/'
			RSModel.PlaySound = new PlaySound_Flex()
		}
		
		private function createInitLesson():void
		{
			var e : TestHelpers
			// TODO Auto Generated method stub
			this.lesson = TestHelpers.createLesson()
			this.lesson.folder_name = this.baseFolderLesson; 
			this.lesson.baseFolder =  this.baseFolderPlan //+ '/' + this.baseFolderLesson; 
			this.lessonPlan = new LessonGroupVO(); 
			this.lessonPlan.name = 'wtf'; 
			this.lessonPlan.baseFolder = this.baseFolderPlan; 
			this.model.currentLessonPlan = this.lessonPlan; 
		}
		
		[After]
		public function tearDown():void
		{
			/*this.serviceDispatcher = null;
			this.service = null;*/
		}
		
		[Test(async)]
		public function testRetreiveImages():void
		{
			
			var asyncHandler:Function = Async.asyncHandler( this, handleTimerComplete, 50*1000, null, handleTimeout );
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, asyncHandler, false, 0, true );
			
			timer.start();	
			 
			this.buildLesson()
		}
		
		public function updateLesson(selectedItemz : Array, updateOptions : Array, queryPost : String = '', 
			searchResultNum : int = 0 ):void
		{
			if ( updateOptions == null ) 
			 	 updateOptions = this.collectOptions() 
			if ( selectedItemz == null ) 
				selectedItemz = this.lesson.items;  
			this.dispatch( new UpdateLessonItemBulkCommandTriggerEvent(
				UpdateLessonItemBulkCommandTriggerEvent.UPDATE_ITEMS, this.lesson, selectedItemz, this.onDoneWithUpdate, 
				updateOptions, true, queryPost, searchResultNum ) ) 
		}		
		
		private function onDoneWithUpdate():void
		{
			this.serviceDispatcher.dispatchEvent( new Event(DONE_UPDATE) ) ; 
		}
		
		public function buildLesson():void
		{
			this.goThroughAllSelectedItems.go( this.selectedItems, this.onNextLessonItem, this.lessonItemsDone ) 	
		}		
		public function loadLesson():void
		{
			this.dispatch( new LoadLessonTriggerEvent(LoadLessonTriggerEvent.LOAD_SOUNDS, this.lesson, '', this.onLoadedLesson ) ) ; 
			//this.goThroughAllSelectedItems.go( this.selectedItems, this.onNextLessonItem, this.lessonItemsDone ) 	
		}		
		
		private function onLoadedLesson(e: LessonVO):void
		{
			var d : Array = [e.sets.length]
			this.dispatch( new Event(LOADED_LESSON ) ) 
		}		
		
		
		protected function handleTimerComplete( event:TimerEvent, passThroughData:Object ):void
		{
			trace('timer complete') 
		}
		
		protected function handleTimeout( passThroughData:Object ):void
		{
			assertEquals( true, false ) ; 
		}
		
		
		private function get selectedItems()  : Array
		{
			var v  : Array = MakeVOs.makeObjs( ['dog', 'cat', 'sheppard']  , LessonItemVO ) 
			v  = MakeVOs.makeObjs( ['dog' ]  , LessonItemVO ) 
			if ( itemsToMake != null ) 
			{
				v  = MakeVOs.makeObjs( itemsToMake  , LessonItemVO ) 
			}
			var set : LessonSetVO = new LessonSetVO()	
			this.lesson.sets.addItem( set ) 
			set.items.addAll( new  ArrayCollection(v) ) 
			this.model.currentLesson = this.lesson; 
			return v
		}
		private function onNextLessonItem(i : LessonItemVO):void
		{
			this.currentItem = i; 
			this.goThroughAllTypes.go( this.collectOptions(), this.onProcessUpdate, this.onProcesingItemUpdateDone,1000 )
			//this.onProcessUpdate()
			return;//
		}		 
		
		private function lessonItemsDone( ):void
		{
			// TODO Auto Generated method stub
			//this.active = false; 
			this.model.saveLesson(); 
			this.serviceDispatcher.dispatchEvent( new Event(DONE) ) ; 
		}
		
		
		static public var DONE : String = 'done' 
		
		private function onProcessUpdate( actionOrPrompt : Object ):void
		{
			if ( actionOrPrompt is String ) 
			{
				var action : String = actionOrPrompt.toString(); 
			}
			if ( actionOrPrompt is PromptDefinitionVO ) 
			{
				//	this.currentItem.currentPrompt = actionOrPrompt as PromptVO
				this.currentItem.setPromptDefinition( actionOrPrompt as PromptDefinitionVO,
					true, lesson.clonePrompts )
			}
			this.dispatch( new UpdateLessonItemCommandTriggerEvent
				(UpdateLessonItemCommandTriggerEvent.UPDATE_ITEM, '',
					this.currentItem, this.goThroughAllTypes.next, action, 
					true, '', this.preQueryText ) ) ; 
			return;//
		}		
		public function collectOptions () : Array
		{
			if ( creationOptions != null ) 
			{
				return creationOptions;
			}
			return [UpdateLessonItemCommandTriggerEvent.PIC, this.promptDefs(PIC) ];
		}
		
		static public var PIC : String = 'PIC'; 
		private var commands:Dictionary = new Dictionary(true);
		public var itemsToMake:Array;
		private var baseFolderPlan:String;
		private var baseFolderLesson:String;
		/**
		 * if set will overried the collect options default 
		 * */
		public var creationOptions:Array;
		public var basics:Array= [UpdateLessonItemCommandTriggerEvent.PIC, UpdateLessonItemCommandTriggerEvent.DICTIONARY];
		public function makePrompts() : void
		{
			this.prompts = []; 
			var def : PromptDefinitionVO = new PromptDefinitionVO()
			def.name = PIC; 
			def.makePic()
			//this.prompts.push( def ) 
			this.lesson.addPrompt( def ) ; 
		}
		
		public function promptDefs( name : String ) :  PromptDefinitionVO
		{
			return this.lesson.findPromptByName( name ) 
		}
		
		private function onProcesingItemUpdateDone( ):void
		{
			this.goThroughAllSelectedItems.next(); 
		}		
		
		
		private function dispatch( e : Event ) : void
		{
			/*if ( e is UpdateLessonItemCommandTriggerEvent ) 
			{
				var c : UpdateLessonItemCommand = new UpdateLessonItemCommand()
				c.event =  e as UpdateLessonItemCommandTriggerEvent ; 
				c.model = this.model; 
				c.eventDispatcher = serviceDispatcher; 
				c.execute(); 
			}*/
			var commandClass : Class = this.commands[e.type] as Class; 
			if ( commandClass != null ) 
			{
				var command :  Object = new commandClass()
				command.event =  e ;//as UpdateLessonItemCommandTriggerEvent ; 
				command.model = this.model; 
				command.eventDispatcher = serviceDispatcher; 
				command.execute(); 
			}
			else
			{
				serviceDispatcher.dispatchEvent( e )
			}
		}
		
		public function get preQueryText() : String
		{
			return '' 
		}
		
		/*
		[Test(async)]
		public function testRetreiveImages():void
		{
		this.serviceDispatcher.addEventListener( GalleryEvent.GALLERY_LOADED, 
		Async.asyncHandler(this, handleImagesReceived, 8000, null, 
		handleServiceTimeout), false, 0, true);
		this.service.loadGallery();
		}
		
		[Test(async)]
		public function testSearchImages():void
		{
		this.serviceDispatcher.addEventListener( GalleryEvent.GALLERY_LOADED, 
		Async.asyncHandler(this, handleImagesReceived, 8000, null, 
		handleServiceTimeout), false, 0, true);
		this.service.search("robotlegs");
		}
		
		protected function handleServiceTimeout( object:Object ):void
		{
		Assert.fail('Pending Event Never Occurred');
		}
		
		protected function handleImagesReceived(event:GalleryEvent, object:Object):void
		{
		Assert.assertEquals("The gallery should have some photos: ", 
		event.gallery.photos.length > 0, true)	
		}
		*/
		
	}
}