package org.syncon.RosettaStone.view.popup
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.RotateVO;
	
	public class PopupRadioListMediator extends Mediator
	{
		[Inject] public var ui: PopupRadioList;
		//	[Inject] public var model : EvernoteAPIModel;
		private var ev : LazyEventHandler = new LazyEventHandler(); 
		private var rotate : RotateVO = new RotateVO()
		public function PopupRadioListMediator()
		{
		} 
		override public function onRemove():void
		{
			ev.unmapAll(); 
			
			super.onRemove()
		}
		override public function onRegister():void
		{
			ev.init( this.ui ) ; 
			this.rotate.setupStageListeners( this.ui, this.ui.resize ) ; 
			this.ev.addEv(PopupRadioList.OK, this.onSave )
			this.ev.addEv(PopupRadioList.CANCEL, this.onCancel )
			this.ev.addEv( PopupRadioList.SETUP, this.onSetup ) ; 
			this.ev.addEv( PopupRadioList.LIST_CHANGED, this.onListChanged )	
		}
		
		protected function onSetup(event:Event):void
		{
			var items : Array = 	this.ui.args[0] 
			var arr : ArrayList = new ArrayList()
			var prevSelected : Array = [ this.ui.args[1] ]
				var itemSelected : Boolean = false
			for each ( var item : Object in items ) 
			{
				var s : SelectableItemVO = new SelectableItemVO()
				s.name = item.toString(); 
				if ( prevSelected.indexOf( s.name ) != -1 ) 
				{
					s.selected = true ; 
					itemSelected = true; 
				}
				arr.addItem ( s ) 
			}
			//select the first one if none selected
			if ( itemSelected == false ) 
				arr.getItemAt(0).selected = true; 
			this.ui.list.dataProvider = arr
			
		}
		
		/**
		 * deselect all others
		 * */
		protected function onListChanged(event:CustomEvent):void
		{
			var items : Array = this.ui.list.dataProvider.toArray(); 
			//this.ui.list.selectedItem = null 
			this.ui.list.selectedIndex = -1; 
			//trace('change heard'); 
			//var alarm : SelectableItemVO = event.data as SelectableItemVO;
			for each ( var item : SelectableItemVO in items ) 
			{
				if ( item == event.data ) 
				{
					continue
					 
				}
				item.selected = false; 
				this.ui.list.dataProvider.itemUpdated( item ) ; 
			}
			if ( this.ui.args[3] != null ) 
				this.ui.args[3]( event.data.name ) 
			 
		}
		
		private function onSave(e:Event) : void
		{
			var selected : Array = []; 
			var items : Array = this.ui.list.dataProvider.toArray(); 
			for each ( var item : SelectableItemVO in items ) 
			{
				if ( item.selected ) 
				{
					selected.push( item.name ) ; 
				}
			}
			//make sure at least 1 is selected
			this.ui.args[2](selected[0])
			this.ui.hide();
		}		
		
		
		private function onCancel(e:Event) : void
		{
			if ( this.ui.args[4] != null ) this.ui.args[4]( ); 
			this.ui.hide();
			//this.ui.listSavedSearches.dataProvider = e.data as ArrayCollection
		}				
		
		
		
	}
}