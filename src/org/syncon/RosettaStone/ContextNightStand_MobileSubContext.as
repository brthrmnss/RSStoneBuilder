package org.syncon.RosettaStone
{
	import org.syncon.RosettaStone.controller.*;
	import org.syncon.RosettaStone.view.mobile.*;
	import org.syncon2.utils.SubContext;
	
	/**
	 * Contains not flex compatible classes ... i guess services?
	 * */
	public class ContextNightStand_MobileSubContext extends SubContext 
	{
		override public function startup():void
		{
			//move this to another subscontext
			//ConfigCommandTriggerEvent.mapCommands( this.commandMap,  ConfigCommand);  
			this.mediatorMap.mapView( PackageSelectView , PackageSelectViewMediator   ) 
			this.mediatorMap.mapView( GroupSelectView , GroupSelectViewMediator   ) 
			this.mediatorMap.mapView( LessonSelectView , LessonSelectViewMediator   ) 
			this.mediatorMap.mapView( PlayerView , PlayerViewMediator   ) 
				
			this.loadSubContexts()		
			loadConfig()
			super.startup();
			
			if ( doInit == false ) {trace('ContextNightStand_MobileSubContext', 'skipped init'); return;} 
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
			//this.dispatchEvent( new ConfigCommandTriggerEvent(ConfigCommandTriggerEvent.LOAD_CONFIG)  ); 
			return; 
		}
		
		public  function loadConfig( ) : void  
		{
			//this.dispatchEvent( new ConfigCommandTriggerEvent(ConfigCommandTriggerEvent.LOAD_CONFIG)  ); 
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