package  org.syncon.RosettaStone.view.popup
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.OrientationVO;
	import org.syncon.RosettaStone.vo.RotateVO;
	
	public class PopupSelectableListMediator extends Mediator
	{
		[Inject] public var ui:PopupSelectableList;
		//	[Inject] public var model : EvernoteAPIModel;
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		private var rotate :  RotateVO = new RotateVO()
		public function PopupSelectableListMediator()
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
			this.ev.addEv(PopupSelectableList.OK, this.onSave )
			this.ev.addEv(PopupSelectableList.CANCEL, this.onCancel )
			this.ev.addEv( PopupSelectableList.SETUP, this.onSetup ) ; 
			this.ev.addEv( PopupSelectableList.LIST_CHANGED,  this.onListChanged )	
		}
		
		protected function onSetup(event:Event):void
		{
			var items : Array = 	this.ui.args[0] 
			var arr : ArrayList = new ArrayList()
				var prevSelected : Array = this.ui.args[1]; 
			for each ( var item : Object in items ) 
			{
				var s : SelectableItemVO = new SelectableItemVO()
				s.name = item.toString(); 
				if ( prevSelected.indexOf( s.name  ) != -1 ) 
				{
					s.selected  = true ; 
				}
				arr.addItem ( s ) 
			}
			this.ui.list.dataProvider = arr
			
		}
		
		protected function onListChanged(event:CustomEvent):void
		{ 
			//this.ui.list.selectedItem = null 
			this.ui.list.selectedIndex = -1; 
			//trace('change heard'); 
			var selected :    SelectableItemVO = event.data as  SelectableItemVO;
			
			this.ui.args[2](selected)
			this.ui.hide();
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
			
			this.ui.args[2](selected)
				this.ui.hide();
		}		
		
		
		private function onCancel(e:Event) : void
		{
			this.ui.hide();
			//this.ui.listSavedSearches.dataProvider = e.data as ArrayCollection
		}				
		
		
	}
}