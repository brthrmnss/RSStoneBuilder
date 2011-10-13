package org.syncon.RosettaStone.model
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;
	import org.syncon.RosettaStone.controller.ConfigCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.IO.SaveLessonTriggerEvent;
	import org.syncon.RosettaStone.controller.Search.PlayLessonItemCommandTriggerEvent;
	import org.syncon.RosettaStone.vo.*;
	import org.syncon.popups.controller.default_commands.ShowAlertMessageTriggerEvent;
	import org.syncon2.utils.sound.IPlaySound;
	
	public class RSModel extends Actor 
	{
		/**
		 * requires PlaySound
		 * ResourcesDir 
		 * */
		static public var PlaySound : IPlaySound; 
		public function playSound( s : SoundVO, fxCallAfterSoundCompletePlaying_ : Function = null ) : void
		{
			PlaySound.playSound( s, fxCallAfterSoundCompletePlaying_ ); 
		}
		public function playSound2(url : String , times : int = 1, x : Object=null, fxDone : Function = null  ) : void
		{
			PlaySound.playSound2( url, times, x, fxDone ); 
		}
		
		public function stopSound():void{
			PlaySound.stopSound();//( s, times ); 
		} 
		public function set fxCallAfterSoundCompletePlaying( fx : Function):void{
			PlaySound.fxCallAfterSoundCompletePlaying = fx //( s, times ); 
		} 
		
		
		public function chainUp(array : Array ) : void
		{
			PlaySound.chainUp( array );//, times, x, fxDone ); 
		}
		
		public var showAds:Object;
		private var _config: RosettaStoneConfig;
		
		public function get config(): RosettaStoneConfig
		{
			return _config;
		}
		
		public function set config(value:RosettaStoneConfig):void
		{
			currentConfigSet = true; 
			_config = value;
			this.dispatch( new RSModelEvent( RSModelEvent.CONFIG_CHANGED ) ) 
		}
		
		
		private var _automating : Boolean = false; 
		public function get automating(): Boolean
		{
			return _automating;
		}
		
		public function set automating(value:Boolean):void
		{
			_automating = value;
			this.dispatch( new RSModelEvent( RSModelEvent.AUTOMATING_CHANGED ) ) 
		}
		
		
		private var _debugMode : Boolean = false; 
		public function get debugMode(): Boolean
		{
			return _debugMode;
		}
		
		public function set debugMode(value:Boolean):void
		{
			_debugMode = value;
			this.dispatch( new RSModelEvent( RSModelEvent.DEBUG_MODE_CHANGED ) ) 
		}
		
		private var _loadedLastLesson : Boolean = false; 
		public function get loadedLastLesson(): Boolean
		{
			return _loadedLastLesson;
		}
		
		public function set loadedLastLesson(value:Boolean):void
		{
			_loadedLastLesson = value;
			if ( value == true ) 
				this.dispatch( new RSModelEvent( RSModelEvent.LOADED_LAST_LESSON ) ) 
		}
		
		public function playLessonItem(i : LessonItemVO, fxDone : Function = null, soundUrl : String = null  ) : void
		{
			this.dispatch( new PlayLessonItemCommandTriggerEvent( 
				PlayLessonItemCommandTriggerEvent.PLAY_LESSON_ITEM, i, fxDone, null, soundUrl   ) ) 
		}
		
		public var sounds: ArrayCollection = new ArrayCollection();
		public var flex:Boolean;
		public var currentConfigSet:Boolean=false;
		
		/**
		 * Player needs all images to be set first 
		 * */
		public function applyFolderToItems( arr : Array ) : void
		{
			for each ( var value : LessonItemVO in arr ) 
			{
				var dbg : Array = [org.syncon.RosettaStone.model.NightStandConstants.ResourcesDir,this.lessonDir(),
					this.currentLessonPlan.getSubDir() , '/', 
					this.currentLesson.getFolderName  ]
				value.folder = org.syncon.RosettaStone.model.NightStandConstants.ResourcesDir+this.lessonDir()
			}
		}
		private var _currentPromptDefinition : PromptDefinitionVO;
		public function get currentPromptDefinition(): PromptDefinitionVO 	{ return _currentPromptDefinition; }
		public function set currentPromptDefinition(value:PromptDefinitionVO):void { 
			_currentPromptDefinition = value;
			//	if ( value != null ) 
			//			value.folder = NightStandConstants.ResourcesDir+this.lessonDir()
			this.dispatch( new RSModelEvent( RSModelEvent.CURRENT_PROMPT_DEFINITION_CHANGED, value ) ) 
		}
		private var _currentPrompt  : PromptVO;
		public function get currentPrompt(): PromptVO 	{ return _currentPrompt; }
		public function set currentPrompt(value:PromptVO):void { 
			_currentPrompt = value;
			this.dispatch( new RSModelEvent( RSModelEvent.CURRENT_PROMPT_CHANGED, value ) ) 
		}
		
		
		private var _currentSelectedItem : LessonItemVO;
		public function get selectedItem(): LessonItemVO 	{ return _currentSelectedItem; }
		public function set selectedItem(value:LessonItemVO):void { 
			_currentSelectedItem = value;
			//	if ( value != null ) 
			//			value.folder = NightStandConstants.ResourcesDir+this.lessonDir()
			this.dispatch( new RSModelEvent( RSModelEvent.SELECTED_LESSON_ITEM_CHANGED, value ) ) }
		
		
		private var _currentHighlightedItem : LessonItemVO;
		public function get currentHighlightedItem(): LessonItemVO 	{ return _currentHighlightedItem; }
		public function set currentHighlightedItem(value:LessonItemVO):void { 
			_currentHighlightedItem = value;
			//	if ( value != null ) 
			//			value.folder = NightStandConstants.ResourcesDir+this.lessonDir()
			this.dispatch( new RSModelEvent( RSModelEvent.HIGHLIGHTED_ITEM_CHANGED, value ) ) }
		
		
		private var _currentLessonItem : LessonItemVO;
		public function get currentLessonItem(): LessonItemVO 	{ return _currentLessonItem; }
		public function set currentLessonItem(value:LessonItemVO):void { 
			_currentLessonItem = value;
			/*if ( value != null ) 
			value.folder = org.syncon.RosettaStone.model.NightStandConstants.ResourcesDir+this.lessonDir()*/
			this.dispatch( new RSModelEvent( RSModelEvent.CURRENT_LESSON_ITEM_CHANGED, value ) ) }
		
		private var _currentLessonSet : LessonSetVO;
		public function get currentLessonSet(): LessonSetVO 	{ return _currentLessonSet; }
		public function set currentLessonSet(value:LessonSetVO):void { 
			_currentLessonSet = value;
			this.dispatch( new RSModelEvent( RSModelEvent.CURRENT_LESSON_SET_CHANGED, value ) )  
			if (  value != null &&   this._currentLessonSet.items.length > 0 ) 
				var lessonSetItem : LessonItemVO =  this._currentLessonSet.items.getItemAt( 0 ) as LessonItemVO
			
			this.currentLessonItem =  lessonSetItem
		}
		private var _currentLesson:  LessonVO;
		public function get currentLesson(): LessonVO 	{ return _currentLesson; }
		public function set currentLesson(value:LessonVO):void { 
			_currentLesson = value;
			this.dispatch( new RSModelEvent( RSModelEvent.CURRENT_LESSON_CHANGED, value ) )  
			if ( value != null && this._currentLesson.sets.length > 0 ) 
				var lessonSet : LessonSetVO =  this._currentLesson.sets.getItemAt( 0 ) as LessonSetVO			
			if ( value == null ) 
			{
				trace('null lesson'); 
			}
			else
			{
				if ( value.loadedOnce == false ) 
				{
					value.loadedOnce = true; 
					this.copyAssetFolderToItems() 
				}
			}
			this.currentLessonSet =  lessonSet
		}
		
		/**
		 * LessonItemsVO only know the local path to their resources, 
		 * we must append the assets or debug part 
		 * */
		public function copyAssetFolderToItems():void
		{
			for each ( var item : LessonItemVO in this.currentLesson.items ) 
			{
				item.folder = org.syncon.RosettaStone.model.NightStandConstants.ResourcesDir+this.lessonDir()
			}
		}
		/**
		 * Same as above, but only affects current lessons set, used after importing items 
		 * */
		public function copyAssetFolderToCurrentSetItems():void
		{
			for each ( var item : LessonItemVO in this.currentLessonSet.items ) 
			{
				item.folder = org.syncon.RosettaStone.model.NightStandConstants.ResourcesDir+this.lessonDir()
			}
		}
		
		private var _currentLessonPlan:  LessonGroupVO;
		public function get currentLessonPlan(): LessonGroupVO 	{ return _currentLessonPlan; }
		public function set currentLessonPlan(value:LessonGroupVO):void { 
			_currentLessonPlan = value;
			
			this.dispatch( new RSModelEvent( RSModelEvent.CURRENT_LESSON_PLAN_CHANGED, value ) ) 
			if ( value != null && this._currentLessonPlan.lessons.length > 0 ) 
				var lesson : LessonVO =  this._currentLessonPlan.lessons.getItemAt( 0 ) as LessonVO
			
			this.currentLesson = lesson 
		}
		
		private var _currentUnit:  UnitVO;
		public function get currentUnit(): UnitVO 	{ return _currentUnit; }
		public function set currentUnit(value:UnitVO):void { 
			_currentUnit = value;
			
			this.dispatch( new RSModelEvent( RSModelEvent.CURRENT_UNIT_CHANGED, value ) ) 
			if ( value != null && this._currentUnit.groups.length > 0 ) 
				var group : LessonGroupVO =  this._currentUnit.groups.getItemAt( 0 ) as LessonGroupVO
			
			this.currentLessonPlan = group 
		}
		
		
		private var _listUnits : ArrayCollection = new ArrayCollection( ); 
		public function get listUnits():ArrayCollection
		{
			return _listUnits;
		}
		public function set listUnits(value:ArrayCollection):void
		{
			_listUnits = value;
		}
		public function loadUnits(value: Array):void
		{
			this.addAllTo( this.listUnits, value )
			this.dispatch( new RSModelEvent( RSModelEvent.UNITS_CHANGED, value ) ) 
		}
		public var port:Number;
		
		public function saveConfig() : void
		{
			this.dispatch( new ConfigCommandTriggerEvent(ConfigCommandTriggerEvent.SAVE_CONFIG)  );
		}
		public function saveLesson() : void
		{
			this.dispatch( new SaveLessonTriggerEvent(SaveLessonTriggerEvent.LOAD_SOUNDS, 
				this.currentLesson , this.currentLessonPlan.getSubDir() ) ) ; 
		}
		public function collect() : void
		{
			this.dispatch( new RSModelEvent(RSModelEvent.COLLECT
			) ) ; 
		}
		public function lessonDir() : String
		{
			var firstPart : String = this.currentLessonPlan.getSubDir(); 
			if ( firstPart.charAt( firstPart.length -1 ) != '/' )
				firstPart+='/'
			return firstPart +  this.currentLesson.getFolderName ;
		}
		
		/**
		 * adhoc like hell...remove asap 
		 * */
		static public var BASE_FOLDER : String = ''; 
		public function playCorrect(fxDone:Function=null) : void
		{
			//this.fxCallAfterSoundCompletePlaying = fxDone
			this.playSound2(BASE_FOLDER+'sounds/correct.mp3',1,null, fxDone ); 
		}
		
		public function playIncorrect(fxDone:Function=null) : void
		{
			this.playSound2(BASE_FOLDER+'sounds/incorrect.mp3',1,null, fxDone ); 
		}		
		
		public function correctItem() : void
		{
			this.dispatch( new RSModelEvent(RSModelEvent.CORRECT_ITEM
			) ) ; 
		}
		public function wrongItem() : void
		{
			this.dispatch( new RSModelEvent(RSModelEvent.WRONG_ITEM
			) ) ; 
		}
		
		/**
		 * Spanish 4.5
		 * */
		public function lessonString() : String
		{
			if ( this.currentUnit == null ) return ''; 
			if ( this.currentLessonPlan == null ) return ''; 
			var i : int = this.currentUnit.groups.getItemIndex( this.currentLessonPlan )+1
			if ( this.currentLesson == null ) return ''; 
			var i2 : int = this.currentLessonPlan.lessons.getItemIndex( this.currentLesson )		+1		
			
			var str : String =  this.currentUnit.name + ' ' + i.toString() + '.'  +  i2.toString()
			return str
		}
		
		/**
		 * how many sets completed
		 * */
		public function setProgress() : String
		{
			var i : int = this.currentLesson.sets.getItemIndex( this.currentLessonSet )+1
			var str : String =  ( i/this.currentLesson.sets.length).toFixed(1) + '%'
			return str
		}
		
		
		/**
		 * 56%, how much of usnit complete
		 * */
		public function unitCompletionPercentage() : String
		{
			var i : int = this.currentUnit.groups.getItemIndex( this.currentLessonPlan )
			var i2 : int = this.currentLessonPlan.lessons.getItemIndex( this.currentLesson )				
			var str : String =  this.currentUnit.name + ' ' + i.toString() + '.'  +  i2.toString()
			return str + '%'
		}
		/*
		public function goHome(backTimes :int=0 ) : void
		{
		var events : Array = [] ; 
		for ( var i : int = 0 ; i < backTimes; i++ ) 
		{
		events.push( SwitchScreensTriggerEvent.GoBack() )
		}
		events.push( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.home )  ) 		
		this.switchMultipleScreens( events ) ; 
		}
		//takes user back to homes tate
		public function goToPlayer(backTimes :int=0 ) : void
		{
		var events : Array = [] ; 
		for ( var i : int = 0 ; i < backTimes; i++ ) 
		{
		events.push( SwitchScreensTriggerEvent.GoBack() )
		}
		events.push( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.PLAYER_VIEW2 )  ) 		
		this.switchMultipleScreens( events ) ; 
		}
		
		public var automateSwitchScreens : GoThroughEach = new GoThroughEach()
		public function switchMultipleScreens(screens : Array ) : void
		{
		this.automateSwitchScreens.end(); 
		this.automateSwitchScreens.go( screens, switchScreenFromEvent, switchScreensComplete, 10 ) 
		}		
		private function switchScreenFromEvent(e:Event):void
		{
		this.dispatch(e); 
		automateSwitchScreens.next(); 
		}
		private function switchScreensComplete():void
		{
		//trace('pushed all screens'); 
		}*/
		private function addAllTo( e:ArrayCollection, arr : Array, append : Boolean = false ) : void
		{
			if ( append == false ) 
			{
				e.source = arr; 
				e.refresh()
			}
			else
			{
				e.disableAutoUpdate()
				for ( var i: int = 0 ; i < arr.length; i++ ) 
				{
					var item : Object = arr[i]
					e.addItem( item ) ; 
				}
				e.enableAutoUpdate()
			}
		}
		
		
		
		
		public function isDescendent( e : Object , againsts : Object ) : Boolean 
		{
			var par : Object = e; 
			do 
			{
				par = par.parent //as UIComponent
				if ( par == againsts ) 
					return true
				
			}	while ( par.parent != null )
			
			return false 
		}
		
		public function alert( str : String, title : String = '' ) : void
		{
			//PlatformGlobals.show( str, title ); 
			this.dispatch( new ShowAlertMessageTriggerEvent(
				ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, 
				str, title  )  )  
		}
		public var setTimeoutTimer_Fx  : Function; 
		public var setTimeoutTimer : Timer = new Timer(500, 1)
		public var setTimeoutTimer_Args : Array = []; 
		//can this compile in ellipse? 
		public function setTimeout( delay : Number, fx : Function,  params : Array ) : void
		{
			setTimeoutTimer.addEventListener(TimerEvent.TIMER, this.onCount, false, 0, true ) ; 
			setTimeoutTimer.stop(); 
			setTimeoutTimer.delay = delay;
			this.setTimeoutTimer_Args = params; 
			this.setTimeoutTimer_Fx = fx ;
		}
		
		protected function onCount(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			this.setTimeoutTimer.stop(); 
			setTimeoutTimer_Fx.apply( this, this.setTimeoutTimer_Args ) ; 
		}
		/*		
		public function registerPopup( popup : Object, name : String, screen : String ) : void
		{
		var e : CreatePopupEvent = new CreatePopupEvent(CreatePopupEvent.REGISTER_EXISTING_POPUP, null) 
		e.popupExistingToRegister = popup
		e.name = name
		e.screen = screen
		this.dispatch( e ) 
		}
		*/
	}
}