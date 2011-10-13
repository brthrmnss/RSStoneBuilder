package  org.syncon.RosettaStone.vo
{
	[RemoteClass]
	public class FlipClockConfigVO   implements IWidgetConfigVO
	{
		public function get type():String
		{
			return Type;
		}
		public static var Type:String= 'FlipClock';
	 
		
		public var brightness : Number = 1;  
		public var scale : Number = 1; 
		public var color :  uint = 0x1A242E; //0xA3FF20;
		
		
		private var _fontSize : Number = NaN; 
		
		
		public function get fontSize():Number
		{
			return _fontSize;
		}
		
		public function set fontSize(value:Number):void
		{
			_fontSize = value;
		}
		
		
		public function get colorString() : String
		{
			return ''; 
		}
		/*	public var format24Hours : Boolean = false ; 
		public var showDate : Boolean = false; 
		*/
		public function importObj( obj : Object ) : void 
		{
			var b : ConfigBaseVO = new ConfigBaseVO()
				b.importObj( this, obj ) ; 
		}
	}
}