package org.syncon.RosettaStone.views.clocks.WallClock
{
	[RemoteClass]
	public class ClockVO  
	{
		public var name :  String = '';  
		public var offset : Number = 0; 
		public function set  offsetHours ( o : Number ) : void
		{
			this.offset = 0*60*60*1000
		}
		
	}
}