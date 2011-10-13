package org.syncon.RosettaStone.controller
{
	
	import flash.events.Event;
	
	/**
	 * 
	 * This class encapsulates moving navigator views
	 * 
	 */
	public class  NavigateCommandTriggerEvent extends Event
	{
		public static const PUSH:String = 'pushS';
		public static const POP:String = 'popS';
		public static const CACHE:String = 'cache';
		
		public var ui : Object;		
		public var data : Object;		
		public var transition : Object;		
		
		public function NavigateCommandTriggerEvent(type:String , ui : Object =null ) 
		{	
			this.ui = ui
			super(type, true);
		}
		
		static public function popView(  ) : NavigateCommandTriggerEvent
		{	
			var e :  NavigateCommandTriggerEvent = new NavigateCommandTriggerEvent(NavigateCommandTriggerEvent.POP)
			return e;
		}
		static public function pushView( ui : Object, data : Object=null, transition : Object = null ) : NavigateCommandTriggerEvent
		{	
			var e :  NavigateCommandTriggerEvent = new NavigateCommandTriggerEvent(NavigateCommandTriggerEvent.PUSH)
			e.ui = ui; 
			e.data = data; 
			e.transition = transition; 
			return e;
		}
		
		/**
		 * Maps user store commands 
		 * */
		static public function mapCommands(commandMap :  Object, command : Object ) : void
		{
			var types : Array = [
				NavigateCommandTriggerEvent.PUSH, 
				NavigateCommandTriggerEvent.POP, 
				NavigateCommandTriggerEvent.CACHE, 
			]
			for each ( var commandTriggerEventString : String in types ) 
			{
				commandMap.mapEvent(commandTriggerEventString,  command, NavigateCommandTriggerEvent, false );			
			}
		}	
		
		
		
	}
}