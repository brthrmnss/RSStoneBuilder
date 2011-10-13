package org.syncon.RosettaStone.view.ellips
{
	import flash.events.Event;
	
	import mvc.controller.SwitchScreensTriggerEvent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.AutomateEvent;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.model.RSMobileModel;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.*;
	import org.syncon.TalkingClock.model.NightStandConstants;
	import org.syncon2.utils.mobile.AndroidExtensions_OpenPlug2;
	
	
	public class SettingsViewMediator extends Mediator
	{
		[Inject] public var ui: SettingsView;
		[Inject] public var model : RSModel;
		[Inject] public var modelMobile : RSMobileModel;		
		
		public var injections  : Array = ['model', RSModel,'modelMobile', RSMobileModel]  
		
		private var currentUnit:UnitVO;
		
		private var styler:StyleConfigurator;
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		override public function onRemove():void
		{
			ev.unmapAll(); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			
			ev.init( this.ui ) ; 
			
			this.styler = new StyleConfigurator(); 
			
			this.ev.addEv( GettingStartedView.RESUME, this.onResume ) 
			this.ev.addEv( SettingsView.GO_BACK, this.onBack ) 
			eventMap.mapListener(eventDispatcher, RSModelEvent.DEBUG_MODE_CHANGED, 
				this.onDebugModeChanged);	
			this.onDebugModeChanged( null ) 		
				
				
			this.ev.addEv( SettingsView.SOUND_DOWN, this.onSoundDown ) 
			this.ev.addEv( SettingsView.SOUND_UP, this.onSoundUp ) 
			
			this.ev.addEv( SettingsView.CHANGE_OS, this.onChangeOS ) 
				
			
			this.ui.volumeTextSound.text="50%";
			volumeSound = 50;
		}
		private var volumeSound:int; 
		private function onSoundDown(e:Event):void
		{
			if(volumeSound>0)
			{
				volumeSound -= 10;
				//SystemAPI.setVolumeSoundFile(soundID, volumeSound);
				NightStandConstants.PlaySound.setVolume( volumeSound ) ; 
				this.ui.volumeTextSound.text = ""+volumeSound+"%";
				this.model.config.volume = this.volumeSound; 
			}
		}
		
		private function onSoundUp(e:Event):void
		{
			if(volumeSound<100)
			{
				volumeSound += 10;
				NightStandConstants.PlaySound.setVolume( volumeSound ) ; 
				this.ui.volumeTextSound.text = ""+volumeSound+"%";
				this.model.config.volume = this.volumeSound; 
			}
		}
		private function onChangeOS(e:Event):void
		{
			var ee : AndroidExtensions_OpenPlug2 = new AndroidExtensions_OpenPlug2()
			ee.changeVolumeIntent(); 
		}
		
		private function onDebug(e:Event):void
		{
			this.model.debugMode = ! this.model.debugMode; 
		}
		
		public function  onDebugModeChanged (e:Event) : void
		{
			this.ui.debug.visible = this.model.debugMode; 
		}
		
		protected function onResume(event:Event):void
		{
			/*
			this.dispatch( SwitchScreensTriggerEvent.GoBack() )
			var e :  SwitchScreensTriggerEvent =SwitchScreensTriggerEvent.GoTo(
				SwitchScreensTriggerEvent.PLAYER_VIEW ) 
			this.dispatch( e ) */
			//this.model.currentLesson = this.model.
			this.modelMobile.goToPlayer( 1 ) ; 
			this.dispatch( new AutomateEvent(AutomateEvent.RESUME_LESSON, null ) ) ; 
			//who loads this ?  
		} 
		
		
		
		private function onBack(param0:Object):void
		{
			this.dispatch( SwitchScreensTriggerEvent.GoBack() )
 
		}
		
 
		
		
	}
}