package org.syncon.RosettaStone.view.popup
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.RotateVO;
	
	public class PopupSetTimeMediator extends Mediator
	{
		[Inject] public var ui: PopupSetTime;
		//	[Inject] public var model : EvernoteAPIModel;
		private var ev : LazyEventHandler = new LazyEventHandler(); 
		private var rotate : RotateVO = new RotateVO()
		public function PopupSetTimeMediator()
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
			this.ev.addEv(PopupSetTime.OK, this.onSave )
			this.ev.addEv(PopupSetTime.CANCEL, this.onCancel )
			this.ev.addEv( PopupSetTime.SETUP, this.onSetup ) ; 
			this.ev.addEv( PopupSetTime.LIST_CHANGED, this.onListChanged )	
		}
		
		protected function onSetup(event:Event):void
		{
 
			
		}
		
		/**
		 * deselect all others
		 * */
		protected function onListChanged(event:CustomEvent):void
		{
 
			 
		}
		
		private function onSave(e:Event) : void
		{
			var date : Date = this.ui.getDate(); 
		 	if ( this.ui.args[1] != null ) 
				this.ui.args[1]( date ) 
			this.ui.hide();
		}		
		
		
		private function onCancel(e:Event) : void
		{
			this.ui.hide();
			//this.ui.listSavedSearches.dataProvider = e.data as ArrayCollection
		}				
		
		
		
	}
}