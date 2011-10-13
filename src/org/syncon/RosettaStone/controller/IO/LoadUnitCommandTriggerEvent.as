package org.syncon.RosettaStone.controller.IO
{
	
	import flash.events.Event;
	
	import org.syncon.RosettaStone.vo.UnitVO;
 
	/**
	 * 
	 * Load all units in a folder
	 * */
	public class LoadUnitCommandTriggerEvent extends Event
	{
		public static const LOAD_UNIT:String = 'LoadUnitCommandTriggerEvent...';
		public var unit :UnitVO;
		
		public var exactLocation : String;
		public var autoLoad:Boolean=true;
		public var fxDone : Function; 
		public var autoCreate : Boolean; 
		public function LoadUnitCommandTriggerEvent(type:String , unit : UnitVO,  exactLocation : String='',
													fx : Function = null, autoload : Boolean = true , autoCreate : Boolean  =true )//,filename : String='') 
		{	
			this.unit = unit
			this.exactLocation = exactLocation; 
			this.fxDone = fx; 
			this.autoLoad = autoload; 
			this.autoCreate = autoCreate; 
			super(type, true);
		}
		
	 
	}
}