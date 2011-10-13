package org.syncon.RosettaStone.model
{
	import flash.events.Event;
	
	import mvc.controller.SwitchScreensTriggerEvent;
	
	import org.robotlegs.mvcs.Actor;
	import org.syncon.RosettaStone.vo.*;
	import org.syncon.popups.controller.CreatePopupEvent;
	import org.syncon2.utils.data.GoThroughEach;
	
	public class RSMobileModel extends Actor 
	{
		 
		 
	  
		
		public function goHome(backTimes :int=0 ) : void
		{
			/*
			var events : Array = [] ; 
			for ( var i : int = 0 ; i < backTimes; i++ ) 
			{
				events.push( SwitchScreensTriggerEvent.GoBack() )
			}
			events.push( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.home )  ) 		
			this.switchMultipleScreens( events ) ; 
			*/
			this.dispatch(  SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.home )  ) 		
		}
		/**
		 * takes user back to homes tate
		 * */
		public function goToPlayer(backTimes :int=0 ) : void
		{
		/*	var events : Array = [] ; 
			for ( var i : int = 0 ; i < backTimes; i++ ) 
			{
				events.push( SwitchScreensTriggerEvent.GoBack() )
			}
			events.push( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.PLAYER_VIEW2 )  ) 		
			this.switchMultipleScreens( events ) ; */
			this.dispatch( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.PLAYER_VIEW2 )  )
		}
		
		private var automateSwitchScreens : GoThroughEach = new GoThroughEach()
		private function switchMultipleScreens(screens : Array ) : void
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
		}
		
		public function registerPopup( popup : Object, name : String, screen : String ) : void
		{
			var e : CreatePopupEvent = new CreatePopupEvent(CreatePopupEvent.REGISTER_EXISTING_POPUP, null) 
			e.popupExistingToRegister = popup
			e.name = name
			e.screen = screen
			this.dispatch( e ) 
		}
		
	}
}