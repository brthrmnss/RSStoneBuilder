package org.syncon.RosettaStone
{
	import org.syncon.RosettaStone.view.FilterTester.*;
	import org.syncon.RosettaStone.view.mobile.alarm.*;
	import org.syncon.RosettaStone.view.subview.*;
	import org.syncon.RosettaStone.views.TalkTest;
	import org.syncon2.utils.SubContext;
	
	public class ContextNightStand_AlarmsViewsSubContext extends SubContext 
	{
		override public function startup():void
		{
			// View
			//no auto removal, air dispatches remove child events, even when the view is nto to be destroyed
			var autoRemove : Boolean = false; 
			/*
			mediatorMap.mapView( AlarmView, AlarmViewMediator )//, null, true, false );	
			mediatorMap.mapView( EditAlarmView, EditAlarmViewMediator )//, null, true, false );	
					
			mediatorMap.mapView( MainMenuView, MainMenuViewMediator ) 
			mediatorMap.mapView( SelectVoiceView, SelectVoiceViewMediator ) 
			mediatorMap.mapView( EditVoiceView,EditVoiceViewMediator ) 
				
			mediatorMap.mapView( EditSampleView,EditSampleViewMediator ) 
			mediatorMap.mapView( SettingsView, SettingsViewMediator ) 
				
			mediatorMap.mapView( TalkTest, TalkTestMediator ) 
				
			mediatorMap.mapView(  HelpView, HelpViewMediator ) 
				*/
			this.mediatorMap.mapView( SoundBoardHomeView , SoundBoardHomeViewMediator   ) 
				
			this.loadSubContexts()			
			super.startup();
			
			if ( doInit == false ) {trace('ContextNightStand_AlarmsViewsSubContext', 'skipped init'); return;} 
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