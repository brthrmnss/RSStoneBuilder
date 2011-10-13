package org.syncon.RosettaStone
{
	import flash.events.Event;
	
	import org.syncon.RosettaStone.controller.*;
	import org.syncon.RosettaStone.controller.IO.*;
	import org.syncon.RosettaStone.controller.Search.PlayLessonItemCommand;
	import org.syncon.RosettaStone.controller.Search.PlayLessonItemCommandTriggerEvent;
	import org.syncon.RosettaStone.model.RSMobileModel;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.view.ellips.*;
	import org.syncon.RosettaStone.view.ellips.rs.*;
	import org.syncon.TalkingClock.controller.ImportSoundsInRSCommand;
	import org.syncon.TalkingClock.controller.ImportSoundsInRSCommandTriggerEvent;
	import org.syncon.TalkingClock.controller.LoadRSUnitIntoRSCommand;
	import org.syncon.TalkingClock.controller.LoadRSUnitIntoRSCommandTriggerEvent;
	import org.syncon.TalkingClock.model.NightStandConstants;
	import org.syncon.popups.controller.*;
	import org.syncon.popups.controller.default_commands.ShowAlertMessageCommand;
	import org.syncon.popups.controller.default_commands.ShowAlertMessageCommand2;
	import org.syncon.popups.controller.default_commands.ShowAlertMessageTriggerEvent;
	import org.syncon2.utils.SubContext;
	
	public class Context_RSPlayer extends SubContext 
	{
		override public function startup():void
		{
			//mediatorMap.mapView( Lesson, LessonMediator ) 	
			injector.mapSingleton( RSModel )		
			RSModel.PlaySound = NightStandConstants.PlaySound;
			injector.mapSingleton( RSMobileModel )		
			RSModel.BASE_FOLDER = NightStandConstants.FileLoader.getBaseFolder //+'/' 
			if ( NightStandConstants.flex == false ) 
			{
				RSModel.BASE_FOLDER = NightStandConstants.FileLoader.getBaseFolder +'/' 
			}
			/**
			 * we are skipping the original, and will delete them later
			 * */
			mediatorMap.mapView( Player, PlayerMediator ) 	
			mediatorMap.mapView( PlayerItemViewer, PlayerItemViewerMediator)
			//mediatorMap.mapView( PlayerAutomate, PlayerAutomateMediator )
			
			mediatorMap.mapView( PlayerAutomate, PlayerAutomateMediator )
				
				
			this.mediatorMap.mapView( PackageSelectView, PackageSelectViewMediator )
			this.mediatorMap.mapView( GroupSelectView, GroupSelectViewMediator )
			this.mediatorMap.mapView( LessonSelectView, LessonSelectViewMediator )
			
			this.commandMap.mapEvent( ImportSoundsInRSCommandTriggerEvent.IMPORT,
				ImportSoundsInRSCommand );
			this.commandMap.mapEvent( LoadRSUnitIntoRSCommandTriggerEvent.IMPORT,
				LoadRSUnitIntoRSCommand );			
			ConfigCommandTriggerEvent.mapCommands( this.commandMap, ConfigCommand); 
			
			//mediatorMap.mapView( Player, PlayerMediator ) 	
			mediatorMap.mapView( PlayerView, PlayerViewMediator ) 	
			
			mediatorMap.mapView( RSHomeView , RSHomeViewMediator ) 	
			
			mediatorMap.mapView( ExitView , ExitViewMediator ) 	
			mediatorMap.mapView( PackageCurriculumView , PackageCurriculumViewMediator ) 
			
			mediatorMap.mapView( GettingStartedView , GettingStartedViewMediator ) 	
			mediatorMap.mapView( SettingsView , SettingsViewMediator ) 	
			mediatorMap.mapView( PopupMenuActionView , PopupMenuActionViewMediator ) 
			this.commandMap.mapEvent( CallNativeCommandTriggerEvent.PROCESS,  CallNativeCommand ); 
			
			this.commandMap.mapEvent(   PlayLessonItemCommandTriggerEvent.PLAY_LESSON_ITEM, PlayLessonItemCommand );
			 
			
			//commandMap.mapEvent(CreatePopupEvent.REGISTER_AND_CREATE_POPUP, CreatePopupCommand2, CreatePopupEvent);		
			commandMap.mapEvent(CreatePopupEvent.REGISTER_EXISTING_POPUP, CreatePopupCommand2, CreatePopupEvent);
			commandMap.mapEvent(CreatePopupEvent.REGISTER_POPUP2, CreatePopupCommand2, CreatePopupEvent);	
			//commandMap.mapEvent(RemovePopupEvent.REMOVE_POPUP, RemovePopupCommand2, RemovePopupEvent);			
			commandMap.mapEvent(ShowPopupEvent.SHOW_POPUP, ShowPopupCommand2, ShowPopupEvent);
			commandMap.mapEvent( ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, ShowAlertMessageCommand2, ShowAlertMessageTriggerEvent);
			commandMap.mapEvent(HidePopupEvent.HIDE_POPUP, HidePopupCommand2, HidePopupEvent);	
			import org.syncon.RosettaStone.view.ellips.rs.*
				//import org.syncon.RosettaStone.view.popup.rs.*
				mediatorMap.mapView( PopupSelectionResult, PopupSelectionResultMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupSelectionResult, 'PopupSelectionResult',false ) );		
			mediatorMap.mapView( PopupGroupComplete, PopupGroupCompleteMediator, null, false, false );	
			mediatorMap.mapView( PopupLessonComplete, PopupLessonCompleteMediator, null, false, false );	
			mediatorMap.mapView( PopupUnitComplete, PopupUnitCompleteMediator, null, false, false );	
			this._this.dispatchEvent( CreatePopupEvent.Register( 'PopupLessonComplete', 'popupLessonComplete' ) )	
			this._this.dispatchEvent( CreatePopupEvent.Register( 'PopupGroupComplete', 'popupGroupComplete' ) )	
			this._this.dispatchEvent( CreatePopupEvent.Register( 'PopupUnitComplete', 'popupUnitComplete' ) )	
			
			this.commandMap.mapEvent( LoadUnitsCommandTriggerEvent.LOAD_UNITS, LoadUnitsCommand );
			this.commandMap.mapEvent( LoadUnitCommandTriggerEvent.LOAD_UNIT, LoadUnitCommand );
			this.commandMap.mapEvent( SaveUnitCommandTriggerEvent.SAVE_UNIT, SaveUnitCommand );
			
			this.commandMap.mapEvent( LoadLessonPlanCommandTriggerEvent.LOAD_LESSON_PLAN, LoadLessonPlanCommand );
			this.commandMap.mapEvent( LoadLessonTriggerEvent.LOAD_SOUNDS, LoadLessonCommand );
			this.commandMap.mapEvent( SaveLessonPlanTriggerEvent.LOAD_SOUNDS, SaveLessonPlanCommand );
			this.commandMap.mapEvent( SaveLessonTriggerEvent.LOAD_SOUNDS, SaveLessonCommand );
			
			//this._this.eventMap.addEventListener( NightStandModelEvent.GETTING_STARTED_NOT_SHOWN, this.onGettingStarted ) ; 
			this._this.contextView.addEventListener( RSModelEvent.GETTING_STARTED_NOT_SHOWN, this.onGettingStarted ) ; 
			
			this.loadSubContexts()			
			super.startup();
			
			if ( doInit == false ) {trace('ContextNightStand_AlarmsViewsSubContext', 'skipped init'); return;} 
			var wait : Boolean = false;
			if ( wait ) {/* import flash.utils.setTimeout; setTimeout( this.onInit, 1500 );*/ }
			else{ this.onInit();}	
		}
		
		protected function onGettingStarted(event:Event):void
		{
			if ( fxGettingStarted != null ) 
				fxGettingStarted()
		}
		
		public var fxGettingStarted : Function 
		
		public function addSubContext( _subContext : SubContext ) : void
		{
			this.subContexts.push(_subContext)
		}
		/**
		 * Prevents onInit from being called, 
		 * fill in models with fake information 
		 * */
		public var doInit : Boolean = true; 
		private function onInit() : void
		{
			//model flex needs to be set ....
			this.dispatchEvent( new ConfigCommandTriggerEvent(
				ConfigCommandTriggerEvent.LOAD_CONFIG) );
			
			if ( loadUnitsFolder ) 
			this.dispatchEvent( new LoadUnitsCommandTriggerEvent(
				LoadUnitsCommandTriggerEvent.LOAD_UNITS, '', false ) ) ;
			
			this.dispatchEvent( new LoadRSUnitIntoRSCommandTriggerEvent(
				LoadRSUnitIntoRSCommandTriggerEvent.IMPORT,'Dogs' ) ) ;
			return; 
		}
		
		private function loadSubContexts() : void
		{
			for each ( var _subContext : SubContext in this.subContexts ) 
			{
				_subContext.subLoad2( this, this.injector, this.commandMap, this.mediatorMap, this.contextView ) 		
			}
		}
		
		public var subContexts : Array = []; 
		
		/*
		public function mapMediator(view:Object=null) : void
		{
		mediatorMap.createMediator(view)
		}
		
		*/
		/***
		 * Flag, if true, load all the units 
		 * */
		public var loadUnitsFolder:Boolean=true;
	}
}