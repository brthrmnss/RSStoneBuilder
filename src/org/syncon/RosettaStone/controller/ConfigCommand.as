package org.syncon.RosettaStone.controller
{
	
	import com.adobe.serialization.json.JSON;
	
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	import mx.styles.CSSStyleDeclaration;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.controller.IO.LoadLessonPlanCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.IO.LoadLessonTriggerEvent;
	import org.syncon.RosettaStone.controller.IO.LoadUnitCommandTriggerEvent;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	import org.syncon.RosettaStone.vo.LessonVO;
	import org.syncon.RosettaStone.vo.MapHelper;
	import org.syncon.RosettaStone.vo.NightStandConfigVO;
	import org.syncon.RosettaStone.vo.RosettaStoneConfig;
	import org.syncon.RosettaStone.vo.UnitVO;
	import org.syncon.RosettaStone.vo.VoiceVO;
	
	public class ConfigCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:ConfigCommandTriggerEvent;
		public var injections  : Array = ['model', RSModel] 
		private var debug : Boolean = true
		private var alert : Boolean = false; 
		private var notAuthenticatedRetryTimer : Timer;
		private var retryWaitForAuthenticationCount : int = 0 ;
		/**
		 * Max retry count for events
		 * */
		private var retryCount : int = 2 ;		
		/**
		 * Remove all references to Alert for mobile test.
		 * */
		static public var FxAlert : Function = null; 
		static private var filename:String='config.txt';
		
		/**
		 * clumsy for now, but will update later
		 * */
		static public var CONFIG_LOCATION : String = ''; //usually b/c the app-storage not writable
		
		override public function execute():void
		{
			//return;
			//if config file is set use that for the rest of th eapplication 
			if ( this.event.filename != null && this.event.filename != '' ) 
			{
				filename = this.event.filename 
			}
			if ( event.type == ConfigCommandTriggerEvent.SAVE_AND_LOAD_CONFIG ) 
			{
				this.loadConfigWhenFinishedSaving = true; 
				this.saveConfig() 
			}
			if ( event.type == ConfigCommandTriggerEvent.LOAD_CONFIG ) 
			{
				this.loadConfig()
			}
			if ( event.type == ConfigCommandTriggerEvent.SAVE_CONFIG ) 
			{
				try {
				this.saveConfig()
				}
				catch ( e : Error ) 
				{
					trace( 'save config', 'error', e.name, e.message ) ; 
					
				}
			}				
			
		}
		
		private var ui : UIComponent; 
		private var loadConfigWhenFinishedSaving:Boolean;
		private var config:RosettaStoneConfig;
		private function loadConfig():void
		{
			NightStandConstants.FileLoader.readFile(CONFIG_LOCATION, "user_config.json", this.importConfig )
		}
		public function importConfig(  input :  String ) : void
		{
			if ( input == null )  
			{
				config = new RosettaStoneConfig(); 
				this.loadConfigPart3( null ) ; 
				return
			}
			

			var map : Object = {currentUnit:UnitVO, currentLessonGroup:LessonGroupVO,currentLesson:LessonVO}//currentVoice:VoiceVO, voices:[VoiceVO]}
			//specify function to help arrange alarms adn so forth ..
			var c : Object = JSON.decode( input ) ; 
			config = new RosettaStoneConfig(); 
			config.importObj( c ) ; 
			/*
			
			map.__baseClass = RosettaStoneConfig //FrontPageResultVO ;
			try 
			{
				var config : RosettaStoneConfig =MapHelper.map( map , c ) as RosettaStoneConfig
			}
			catch(e:Error ) 
			{
				config =MapHelper.map( map , c ) as RosettaStoneConfig
				config = new RosettaStoneConfig(); 
			}*/
			this.loadConfigPart3( config ) ; 
		}
		public function loadConfigPart3( config : RosettaStoneConfig ) : void
		{
			var noConfig :  Boolean; 
			if ( config == null ) 
			{
				noConfig = true; 
				config = new RosettaStoneConfig(); 
			}	

			/*if ( this.ui != null && this.cachingNavigator() ) 
			{
			this.ui['navigator'].cachingMode = config.hiSpeedMode; 
			}*/
			this.model.config = config; 
			
			if ( config.gettingStartedSeen == false ) 
			{
				this.dispatch( new RSModelEvent(RSModelEvent.GETTING_STARTED_NOT_SHOWN) ) ; 
				//dispatch Model  first time event
				
				/*
				this.model.callLater( this.dispatch, [SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.gettingStarted )] ) 
				*/
				//this.dispatch( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.gettingStarted ) ) 
				config.gettingStartedSeen = true;
				//this.model.saveConfig(); 
			}
			
			if ( noConfig ) 
			{
				/*config.fontSize = fontSize; 
				config.voices = makeFirstConfig(); 
				this.model.loadVoices( config.voices ) 
				config.currentVoice = config.voices[0];
				//t/his.model.config = config;
				this.model.currentVoice = config.currentVoice;*/
				return; 
			}
			
			this.config = config; 
			this.tryToResumeLesson()
			//if load 

			
			
		}
		
		private function tryToResumeLesson():void
		{
			if ( config.currentUnit != null ) 
			{
				this.config = config; 
				this.model.currentUnit = config.currentUnit //have to set this so we can list it out later
				this.dispatch( new LoadUnitCommandTriggerEvent(
					LoadUnitCommandTriggerEvent.LOAD_UNIT, config.currentUnit, '',  this.onUnitLoaded,false,false  ) )// ;  config.currentLessonGroup, config.cur
				//) ) 
			}
			
		}
		
		/**
		 * Try to find current unity 
		 * */
		private function onUnitLoaded(u:UnitVO):void
		{
			if ( u == null ) 
			{
				trace('ConfigCommand', 'could not load the unit'); 
				return;
			}
			var group : LessonGroupVO = this.config.currentLessonGroup; 
			this.model.currentLessonPlan = group; 
			if ( group == null ) {
				trace('failed at group') 	
				return;
			}
			var matched : LessonGroupVO; 
			for each ( var l : LessonGroupVO in u.groups.toArray() ) 
			{
				//if ( group.name == l.name ) 
				if ( group.url == l.url ) 
					matched = l ;
			}
			if ( matched == null ) {
				trace('failed at group1') 	
				return;
			}
			this.dispatch( new LoadLessonPlanCommandTriggerEvent(
				LoadLessonPlanCommandTriggerEvent.LOAD_LESSON_PLAN, matched, '',  this.onLoadLessonGroup, false, false  ) )// ;  config.currentLessonGroup, config.cur
			//) ) 
			
		}
		
		private function onLoadLessonGroup(l: LessonGroupVO):void
		{
			var lesson : LessonVO = this.config.currentLesson; 
			if ( lesson == null ) {
				trace('failed at lesson') 	
				return;
			}
			var matched : LessonVO; 
			for each ( var search : LessonVO in l.lessons.toArray() ) 
			{
				trace('compare', lesson.url, search.url ) ; 
				trace('compare', lesson.name, search.name ) ; 
				if (  lesson.name ==  search.name ) 
				{
					//if ( lesson.name == search.name ) 
					matched = search ;
				}
			}
			if ( matched == null ) {
				trace('failed at lesson') 	
				return;
			}
			this.dispatch( new LoadLessonTriggerEvent(
				LoadLessonTriggerEvent.LOAD_SOUNDS, matched, '',  this.onLoadLesson, '', false, false  ) )// ;  config.currentLessonGroup, config.cur
			//) ) 
		}		
		
		private function onLoadLesson(lu: LessonVO):void
		{
			if ( lu.sets.length > 0  ) 
				this.model.loadedLastLesson = true; 
			return;
		}				
		
		private function cachingNavigator(): Boolean
		{
			if ( this.ui != null && this.ui.hasOwnProperty('navigator' ) && this.ui['navigator'].hasOwnProperty('cachingMode' ) )
				return true;
			return false; 
		}
		
		
		
		private function saveConfig(): void
		{
			trace('save config', '1'); 
			if ( this.model.config == null ) 
			{
				//why return, user wants to save it 
				//return;
				this.model.config = new RosettaStoneConfig(); 
			}
			this.model.config.currentUnit = this.model.currentUnit; 
			this.model.config.currentLessonGroup = this.model.currentLessonPlan; 
			this.model.config.currentLesson = this.model.currentLesson; 
			trace('save config', '2'); 
		 
			var contents : String =  this.model.config.export(); //JSON.ecndoe( this.model.config ) //not licked
				trace('save config'); 
			NightStandConstants.FileLoader.writeFile(contents, CONFIG_LOCATION, 'user_config.json',    configSaved ) ; 
			trace('save config complete'); 
			//this.model.config.alarms = this.model.alarmList.toArray();
			//this.model.config.currentVoice = this.model.currentVoice;
			//it is important that this always calls the post save fx ....
			//return NightStandConstants.FileLoader.writeObjectToFile( this.model.config, filename, configSaved ) ; 
		}
		
		private function configSaved(o:Object=null):void
		{
			if ( this.loadConfigWhenFinishedSaving  ) 
				this.loadConfig()
		}
		
	}
}