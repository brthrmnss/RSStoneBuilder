package org.syncon.RosettaStone
{
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.Context;
	import org.syncon.RosettaStone.controller.*;
	import org.syncon.RosettaStone.controller.IO.*;
	import org.syncon.RosettaStone.controller.Import.*;
	import org.syncon.RosettaStone.controller.Search.*;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.popups.controller.default_commands.ShowAlertMessageTriggerEvent;
	import org.syncon2.utils.SubContext;
	import org.syncon2.utils.mobile.AndroidExtensions;
	
	public class ContextNightStand extends Context
	{
		public function ContextNightStand()
		{
			super();
		}
		override public function startup():void
		{
			// Model
			injector.mapSingleton( RSModel )		
			
			//	GetInitDataCommandTriggerEvent.mapCommands( this.commandMap, GetInitDataCommand )
			InitMainContextCommandTriggerEvent.mapCommands( this.commandMap, InitMainContextCommand ); 
			
			ManageAdCommandTriggerEvent.mapCommands( this.commandMap, ManageAdCommand ); 
			this.commandMap.mapEvent( SearchImagesTriggerEvent.SEARCH_IMAGES, SearchImagesCommand );
			this.commandMap.mapEvent( SearchImagesTriggerEvent.GET_COPYRIGHT, SearchImagesCommand );
			this.commandMap.mapEvent( SearchPronunciationsTriggerEvent.SEARCH_IMAGES, SearchPronunciationsCommand );
			
			this.commandMap.mapEvent( SearchDictionaryTriggerEvent.SEARCH_DICTIONARY, SearchDictionaryCommand );
			this.commandMap.mapEvent( SearchDictionaryMultipleTriggerEvent.SEARCH_DICTIONARY_MULTIPLE, SearchDictionaryMultipleCommand );
			
			this.commandMap.mapEvent( SearchYoutubeCommandTriggerEvent.SEARCH_YOUTUBE, SearchYoutubeCommand );
			
			this.commandMap.mapEvent( UpdateLessonItemCommandTriggerEvent.UPDATE_ITEM, UpdateLessonItemCommand );
			this.commandMap.mapEvent( UpdateLessonItemBulkCommandTriggerEvent.UPDATE_ITEMS, UpdateLessonItemBulkCommand );
			
			this.commandMap.mapEvent( SaveManyUrlsCommandTriggerEvent.SAVE_MANY_URLS, SaveManyUrlsCommand );
			
			this.commandMap.mapEvent( LoadUnitsCommandTriggerEvent.LOAD_UNITS, LoadUnitsCommand );
			this.commandMap.mapEvent( LoadUnitCommandTriggerEvent.LOAD_UNIT, LoadUnitCommand );
			this.commandMap.mapEvent( SaveUnitCommandTriggerEvent.SAVE_UNIT, SaveUnitCommand   );
			
			this.commandMap.mapEvent( LoadLessonPlanCommandTriggerEvent.LOAD_LESSON_PLAN, LoadLessonPlanCommand );
			this.commandMap.mapEvent( LoadLessonTriggerEvent.LOAD_SOUNDS, LoadLessonCommand );
			this.commandMap.mapEvent( SaveLessonPlanTriggerEvent.LOAD_SOUNDS, SaveLessonPlanCommand );
			this.commandMap.mapEvent( SaveLessonTriggerEvent.SAVE_LESSON, SaveLessonCommand );
			
			this.commandMap.mapEvent( CreateDefaultDataTriggerEvent.CREATE, CreateDefaultDataCommand );
			this.commandMap.mapEvent( ConvertStringToItemSetCommandTriggerEvent.CONVER_STRING, ConvertStringToItemSetCommand );
			this.commandMap.mapEvent( ConvertStringToLessonCommandTriggerEvent.CONVER_STRING, ConvertStringToLessonCommand );
			
			ConfigCommandTriggerEvent.mapCommands( this.commandMap, ConfigCommand); 
			NavigateCommandTriggerEvent.mapCommands( this.commandMap, NavigateCommand); 
			
			
			this.commandMap.mapEvent(   PlayLessonItemCommandTriggerEvent.PLAY_LESSON_ITEM, PlayLessonItemCommand );
			
			
			//this.commandMap.mapEvent( LoadWidgetCommandTriggerEvent.LOAD_WIDGET, LoadWidgetCommand );
			/*
			this.commandMap.mapEvent( CheckAlarmsCommandTriggerEvent.CHECK_ALARMS, CheckAlarmsCommand );
			
			this.commandMap.mapEvent( GetSoundTriggerEvent.GET_SOUND, GetSoundCommand );			
			*/
			/*
			ConfigCommandTriggerEvent.mapCommands( this.commandMap, ConfigCommand); 
			
			
			
			this.commandMap.mapEvent( LoadSoundsTriggerEvent.LOAD_SOUNDS,  LoadSoundsCommand ); 
			this.commandMap.mapEvent( LoadPortCommandTriggerEvent.LOAD_PORT,  LoadPortCommand ); 
			
			*/
			
			this.loadSubContexts()			
			super.startup();
			this.initStage()
			
			if ( doInit == false ) {trace('this.context.loadConfig( ) ; ', 'skipped init'); return;} 
			var wait : Boolean = false;
			if ( wait ) 
			{
				import flash.utils.setTimeout;
				setTimeout( this.onInit, 1500 )
			}
			else
				this.onInit()	
			//this.dispatchEvent( new Event( CreateDefaultDataCommand.START ))
			//this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, popup_modal_bg, 'popup_modal_bg', true ) );
			
			
		}
		override public function set contextView(value:DisplayObjectContainer):void
		{
			super.contextView = value;
			listenForMediation()
		}
		public function listenForMediation(): void
		{
			this.contextView.addEventListener( 'mediate', this.onMediate ) ; 
		}
		protected function onMediate(event:CustomEvent):void
		{
			this.mediatorMap.createMediator( event.data) 
		}
		
		public function addSubContext( _subContext : SubContext ) : void
		{
			this.subContexts.push(_subContext)
		}
		/**
		 * Prevents onInit from being called, 
		 * fill in models with fake information 
		 * */
		public var doInit : Boolean = true; 
		//private var subContext : EvernoteBasicPopupContext = new EvernoteBasicPopupContext()
		private function onInit() : void
		{
			//this.dispatchEvent( new Event( CreateDefaultDataCommand.START ))
			//this.dispatchEvent( new Event( CreateDefaultDataCommand.LIVE_DATA ))
			//this.subContext.onInit(); 
		}
		
		
		public function initStage() : void
		{
			this.dispatchEvent( new InitMainContextCommandTriggerEvent(
				InitMainContextCommandTriggerEvent.INIT, NightStandConstants.showAds, NightStandConstants.flex ) ) ; 
			
			this.dispatchEvent( new InitMainContextCommandTriggerEvent(
				InitMainContextCommandTriggerEvent.INIT2 ) ) ; 
			
			this.dispatchEvent( new InitMainContextCommandTriggerEvent(
				InitMainContextCommandTriggerEvent.INIT3_MAKEUP_FLEX_DATA ) ) ; 
			
			this.dispatchEvent( new LoadSoundsTriggerEvent(
				LoadSoundsTriggerEvent.LOAD_SOUNDS ) ) ; 
			this.dispatchEvent( new LoadPortCommandTriggerEvent(
				LoadPortCommandTriggerEvent.LOAD_PORT ) ) ; 			
			
			
			/*this.dispatchEvent( new LoadLessonPlanTriggerEvent(
			LoadLessonPlanTriggerEvent.LOAD_LESSON_PLAN ) ) ;
			*/
			this.dispatchEvent( new LoadUnitsCommandTriggerEvent(
				LoadUnitsCommandTriggerEvent.LOAD_UNITS, '', false  ) ) ;
			
			
			this.dispatchEvent( new ConfigCommandTriggerEvent(
				ConfigCommandTriggerEvent.LOAD_CONFIG, configName ) );
			
			AndroidExtensions.FxError = this.onAlert; 
		}
		
		public var configName : String = ''; 
		
		public function onAlert(msg : String ) : void
		{
			this.dispatchEvent( new ShowAlertMessageTriggerEvent( ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, msg  )  ) 
		}
		
		private function loadSubContexts() : void
		{
			for each ( var _subContext : SubContext in this.subContexts ) 
			{
				_subContext.subLoad( this, this.injector, this.commandMap, this.mediatorMap, this.contextView ) 		
			}
		}
		
		public var subContexts : Array = []; 
		public function newMultipler( n : Number ) : void
		{
			this.dispatchEvent( new InitMainContextCommandTriggerEvent(
				InitMainContextCommandTriggerEvent.SET_MULTIPLER,false, false, n ) ) ; 
		}
		
		public function importAd( n : Object ) : void
		{
			this.dispatchEvent( new ManageAdCommandTriggerEvent(
				ManageAdCommandTriggerEvent.IMPORT_AD, n ) ) ; 
		}		
		
		
		public function mapMediator(view:Object=null) : void
		{
			mediatorMap.createMediator(view)
		}
		
		
		
		
		
		
	}
}