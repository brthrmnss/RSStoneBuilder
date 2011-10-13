package  org.syncon.RosettaStone.view.popup
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.RotateVO;
	import org.syncon.RosettaStone.vo.SampleVO;
	import org.syncon.RosettaStone.vo.VoiceVO;
	
	public class PopupSelectOptionsMediator extends Mediator
	{
		[Inject] public var ui: PopupSelectOptions  ;
		[Inject] public var model :  RSModel;
		private var ev : LazyEventHandler = new LazyEventHandler(); 
		private var rotate : RotateVO = new RotateVO()
		private var sample : SampleVO;
		private var modeVoice:Boolean;
		private var voice:VoiceVO;
		
		override public function onRemove():void
		{
			ev.unmapAll(); 
			super.onRemove()
		}
		public function PopupSelectOptionsMediator()
		{
		} 
 
		override public function onRegister():void
		{
			ev.init( this.ui ) ; 
			this.rotate.setupStageListeners( this.ui, this.ui.resize ) ; 
			this.ev.addEv(PopupSelectOptions.OK, this.onSave )
			this.ev.addEv(PopupSelectOptions.CANCEL, this.onCancel )
			this.ev.addEv( PopupSelectOptions.SETUP, this.onSetup ) ; 
			this.ev.addEv( PopupSelectOptions.LIST_CHANGED,  this.onListChanged )	
		}
		
		protected function onSetup(event:Event):void
		{
			var items : Array = 	this.ui.args[0] 
			var arr : ArrayList = new ArrayList()
			for each ( var item : Object in items ) 
			{
				var s : SelectableItemVO = new SelectableItemVO()
				s.name = item.toString(); 
				arr.addItem ( s ) 
			}
			this.ui.list.dataProvider = arr
			
		}
		
		protected function onListChanged(event:CustomEvent):void
		{
			 
			//this.ui.list.selectedItem = null 
			this.ui.list.selectedIndex = -1; 
			trace('change heard'); 
			var selected :    SelectableItemVO = event.data as  SelectableItemVO;
			this.ui.args[1](selected.name)
			this.ui.hide();
		}
		
		private function onSave(e:Event) : void
		{
		}		
		
		
		private function onCancel(e:Event) : void
		{
			this.ui.hide();
		}				
		
 
		
	}
}