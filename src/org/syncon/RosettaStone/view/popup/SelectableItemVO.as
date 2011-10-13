package  org.syncon.RosettaStone.view.popup
{
	[RemoteClass]
	public class SelectableItemVO 
	{
		public var name : String = ''; 
		private var _selected :  Boolean = false; 
		 
		
		public function get selected():Boolean
		{
			return _selected;
		}
		//[Bindable]
		public function set selected(value:Boolean):void
		{
			_selected = value;
		}

	}
}