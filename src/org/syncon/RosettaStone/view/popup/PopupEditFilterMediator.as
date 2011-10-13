package  org.syncon.RosettaStone.view.popup
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.view.popup.PopupEditFilter;
	
	public class PopupEditFilterMediator  extends Mediator
	{
		[Inject] public var ui:PopupEditFilter;
		/*[Inject] public var model : EvernoteAPIModel;
		[Inject] public var service :  EvernoteService;
		*/
		public function PopupEditFilterMediator()
		{
			
		} 
		
		override public function onRegister():void
		{
			this.ui.editor.target
			this.ui.popupCode.stickTo( this.ui.editor.target , 'tr' ); 
			// this.ui.addEventListener( PopupEditFilter.OPENED, this.onLogin ) 
		}
		
		private function onLogin(e: Event):void
		{	
			//stick to target
		}
		
	}
}