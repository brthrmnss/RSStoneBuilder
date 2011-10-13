package org.syncon.RosettaStone.controller.IO
{
	
	import flash.events.Event;
 
	/**
	 * 
	 * Load all units in a folder
	 * */
	public class LoadUnitsCommandTriggerEvent extends Event
	{
		public static const LOAD_UNITS:String = 'LoadUnitsCommandTriggerEvent...';
		//public var path :String;
		
		public var url : String;
		public var autoLoad:Boolean=true;
		public var loadFolder:Boolean=true;
		
		public function LoadUnitsCommandTriggerEvent(type:String , url : String='', autoload : Boolean = true, loadFolder : Boolean = true )//,filename : String='') 
		{	
			//this.path = path
			this.url = url; 
			this.loadFolder = loadFolder; 
			this.autoLoad = autoload; 
			super(type, true);
		}
		
	 
	}
}