package  org.syncon.RosettaStone.view.popup
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.RotateVO;
	
	public class PopupTextAreaMediator extends Mediator
	{
		[Inject] public var ui:PopupTextArea;
		//	[Inject] public var model : EvernoteAPIModel;
		private var ev : LazyEventHandler = new LazyEventHandler(); 
		private var rotate : RotateVO = new RotateVO()
			
		public function PopupTextAreaMediator()
		{
		} 
		override public function onRemove():void
		{
			ev.unmapAll(); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			ev.init( this.ui ) ; //unmap is unnecesary ... 
			
			
			this.ev.addEv(PopupSetTime.OK, this.onSave )
			this.ev.addEv(PopupSetTime.CANCEL, this.onCancel )
			this.ev.addEv( PopupSetTime.SETUP, this.onSetup ) ; 
		}
		
		
		protected function onSetup(event:Event):void
		{
			
			
		}
		
		private function onSave(e:Event) : void
		{
			
			var str : String = this.ui.txtTagName.text; 
			if ( this.ui.args[0] != null ) 
				this.ui.args[0]( str ) 
			this.ui.hide();
		}		
		
		
		private function onCancel(e:Event) : void
		{
			this.ui.hide();
			//this.ui.listSavedSearches.dataProvider = e.data as ArrayCollection
		}				
		
		
	}
}