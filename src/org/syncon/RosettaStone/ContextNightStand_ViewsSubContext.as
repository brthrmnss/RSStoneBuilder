package org.syncon.RosettaStone
{
	import org.syncon.RosettaStone.controller.Search.PlayLessonItemCommand;
	import org.syncon.RosettaStone.controller.Search.PlayLessonItemCommandTriggerEvent;
	import org.syncon.RosettaStone.view.edit.*;
	import org.syncon.RosettaStone.view.edit.lesson.*;
	import org.syncon.RosettaStone.view.edit.search.*;
	import org.syncon.RosettaStone.view.edit.utils.*;
	import org.syncon.RosettaStone.view.ellips.IAutomateMediator;
	import org.syncon.RosettaStone.view.ellips.PlayerAutomateMediator;
	import org.syncon.RosettaStone.view.mobile.*;
	import org.syncon.RosettaStone.view.subview.*;
	import org.syncon2.utils.SubContext;
	
	public class ContextNightStand_ViewsSubContext extends SubContext 
	{
		override public function startup():void
		{
			// View
			//no auto removal, air dispatches remove child events, even when the view is nto to be destroyed
			var autoRemove : Boolean = false; 
			
			
			mediatorMap.mapView( Packages, PackagesMediator ) 		
			mediatorMap.mapView( Units, UnitsMediator ) 						
			mediatorMap.mapView( Lessons, LessonsMediator ) 			
			mediatorMap.mapView( LessonItemSets, LessonItemSetsMediator ) 		
			mediatorMap.mapView( LessonPrompts, LessonPromptsMediator ) 	
			mediatorMap.mapView( Player, PlayerMediator ) 		
			mediatorMap.mapView( PreviewJSON, PreviewJSONMediator ) 	
			mediatorMap.mapView( SearchPics, SearchPicsMediator ) 		
			mediatorMap.mapView( SearchSounds, SearchSoundsMediator ) 	
			mediatorMap.mapView( SearchDictionary, SearchDictionaryMediator ) 					
			mediatorMap.mapView( SearchYoutube, SearchYoutubeMediator ) 			
				
			mediatorMap.mapView( PronunciationViewer, PronunciationViewerMediator ) 		
			mediatorMap.mapView( ItemSets, ItemSetsMediator ) 	
			mediatorMap.mapView( ItemViewer, ItemViewerMediator ) 		
			mediatorMap.mapView( ItemPromptViewer, ItemPromptViewerMediator ) 					
			
				
			mediatorMap.mapView( ItemSetViewer, ItemSetViewerMediator ) 					
				
			mediatorMap.mapView( LessonViewer, LessonViewerMediator ) 	
			mediatorMap.mapView( QuickInput, QuickInputMediator ) 	
			mediatorMap.mapView( QuickInputLesson, QuickInputLessonMediator ) 	
				
			mediatorMap.mapView( PlayerItemViewer, PlayerItemViewerMediator)
				//use the more limited one
			//mediatorMap.mapView( PlayerAutomate, PlayerAutomateMediator )
			mediatorMap.mapView( PlayerAutomate, org.syncon.RosettaStone.view.ellips.PlayerAutomateMediator, IAutomateMediator )

				
			mediatorMap.mapView( GroupViewer, GroupViewerMediator )
			mediatorMap.mapView( UnitViewer, UnitViewerMediator )
				
				
			mediatorMap.mapView( LessonViewerBulk, LessonViewerBulkMediator ) 	
			mediatorMap.mapView( LessonItemSetsBulk, LessonItemSetsBulkMediator ) 	
			mediatorMap.mapView( ItemSetsBulk, ItemSetsBulkMediator ) 	
			
			mediatorMap.mapView( ExcelUtils, ExcelUtilsMediator ) 	
			mediatorMap.mapView( LessonUtils, LessonUtilsMediator ) 	
			/*
			mediatorMap.mapView( Clock, ClockMediator )//, null, true, false );	
			mediatorMap.mapView( FilterStack, FilterStackMediator )//, null, true, false );		
			mediatorMap.mapView(FilterEditor, FilterEditorMediator )//, null, true, false );				
			mediatorMap.mapView(FilterNewSelection, FilterNewMediator )//, null, true, false );						
			mediatorMap.mapView( ClockView, ClockViewMediator ) 
			mediatorMap.mapView( SettingsView, SettingsViewMediator ) 
			mediatorMap.mapView( EditFilters, EditFiltersMediator ) 		
			
			mediatorMap.mapView( SettingsViewMini, SettingsViewMiniMediator ) 					
			
			mediatorMap.mapView( SelectThemeView, SelectThemeViewMediator ) 			
			mediatorMap.mapView( InfoView, InfoViewMediator ) 			
			mediatorMap.mapView( BottomNavMenu, BottomNavMenuMediator ) 			
			
			mediatorMap.mapView( HomeView, HomeViewMediator ) 		
			mediatorMap.mapView( HelpView, HelpViewMediator ) 		
			
			mediatorMap.mapView( AnalogLCDView, AnalogLCDViewMediator ) 
			mediatorMap.mapView( AnalogLCDSettings, AnalogLCDSettingsMediator ) 		
			
			mediatorMap.mapView( FlipClockView, FlipClockViewMediator ) 
			mediatorMap.mapView( FlipClockSettings, FlipClockSettingsMediator ) 			
			
			mediatorMap.mapView( WallClockView, WallClockViewMediator ) 
			mediatorMap.mapView( WallClockSettings, WallClockSettingsMediator ) 						
			*/
			
			this.loadSubContexts()			
			super.startup();
			
			if ( doInit == false ) {trace('ContextNightStand_ViewsSubContext', 'skipped init'); return;} 
			var wait : Boolean = false;
			if ( wait ) { import flash.utils.setTimeout; setTimeout( this.onInit, 1500 ); }
			else{ this.onInit();}	
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
		private function onInit() : void
		{
			return; 
		}
		
		private function loadSubContexts() : void
		{
			for each ( var _subContext : SubContext in this.subContexts ) 
			{
				_subContext.subLoad( this, this.injector, this.commandMap, this.mediatorMap, this.contextView ) 		
			}
		}
		
		public var subContexts : Array = []; 
		
		/*
		public function mapMediator(view:Object=null) : void
		{
		mediatorMap.createMediator(view)
		}
		
		*/
	}
}