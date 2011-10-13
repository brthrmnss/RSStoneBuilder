package  	org.syncon.RosettaStone.view.popup.rs 
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.OrientationVO;
	import org.syncon.RosettaStone.vo.RotateVO;
	
	public class  PopupSelectionResultMediator extends Mediator
	{
		[Inject] public var ui:PopupSelectionResult;
		//[Inject] public var model : EvernoteAPIModel;
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		private var rotate : RotateVO = new RotateVO()
		public function PopupSelectionResultMediator()
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
			this.ev.addEv(PopupSelectionResult.CANCEL, this.onCancel )
			this.ev.addEv( PopupSelectionResult.SETUP, this.onSetup ) ; 
		}
		
		protected function onSetup(event:Event):void
		{
			
		}
		
	 
		
		
		private function onCancel(e:Event) : void
		{
			this.ui.hide();
		}				
		
		
	}
}