package   org.syncon.RosettaStone.view.mobile.itemrenderers
{
	import org.syncon.RosettaStone.view.mobile.itemrenderers.core.StyleClient;
	
	import spark.components.IItemRenderer;
	
	public class BaseRenderer extends StyleClient implements IItemRenderer
	{
		//--------------------------------------------------------------------------
		//  Public Setters and Getters
		//--------------------------------------------------------------------------
		
		protected var _data:Object;
		public function set data( value:Object ):void
		{
			if( _data == value )
				return;
			
			_data = value;
			// if the elements has been created we set the values
			if( creationComplete )
				setValues();
		}
		
		public function get data( ):Object
		{
			return _data;
		}
		
		// selected-------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  storage for the selected property 
		 */    
		protected var _selected:Boolean = false;
		
		/**
		 *  @inheritDoc 
		 *
		 *  @default false
		 */
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if (value != _selected)
			{
				_selected = value;
				updateSkin();
			}
		}
		
		// dragging-------------------------------------------------------------------------
		/**
		 * Property not used but it is required by the interface IItemRenderer
		 */
		protected var _dragging:Boolean;
		public function set dragging( value:Boolean ):void
		{
			_dragging = value;
		}
		
		public function get dragging():Boolean
		{
			return _dragging;
		}
		// showsCaret-------------------------------------------------------------------------
		/**
		 * Property not used but it is required by the interface IItemRenderer
		 */
		protected var _showsCaret:Boolean;
		public function set showsCaret( value:Boolean ):void
		{
			_showsCaret = value;
		}
		
		public function get showsCaret():Boolean
		{
			return _showsCaret;
		}
		
		// itemIndex-------------------------------------------------------------------------
		protected var _itemIndex:int;
		public function set itemIndex( value:int ):void
		{
			_itemIndex = value;
		}
		
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		
		// itemIndex-------------------------------------------------------------------------
		protected var _label:String;
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
		}
		
	
		protected function updateSkin():void
		{
			// To be implemented in children
		}
		
		protected function setValues():void
		{
			// To be implemented in children
		}
	}
}