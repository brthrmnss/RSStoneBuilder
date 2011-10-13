package  	org.syncon.RosettaStone.view.popup.rs 
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.AutomateEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.Places;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	
	public class  PopupGroupCompleteMediator extends Mediator
	{
		[Inject] public var ui:PopupGroupComplete;
		[Inject] public var model : RSModel;
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		public function PopupGroupCompleteMediator()
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
			this.ev.addEv(PopupGroupComplete.CANCEL, this.onCancel )
			this.ev.addEv( PopupGroupComplete.SETUP, this.onSetup ) ; 
			
			this.ev.addEv(PopupGroupComplete.REPEAT, this.onRepeat )
			this.ev.addEv( PopupGroupComplete.NEXT_LESSON, this.onNext ) ; 
			this.ev.addEv(PopupGroupComplete.GO_HOME, this.noHome )
		}
		
		
		protected function onRepeat(event:Event=null):void
		{
			this.dispatch( new AutomateEvent(AutomateEvent.START_LESSON, this.ui.lesson )) 
			this.ui.hide(); 
		}
		
		protected function onNext(event:Event=null):void
		{
			this.dispatch( new AutomateEvent(AutomateEvent.NEXT_LESSON, this.ui.lesson, true )) 
			//this.dispatchEvent( new Event( NEXT_LESSON ) )  
			this.ui.hide(); 
		}
		
		protected function noHome(event:Event=null):void
		{
			this.dispatch( new NavigateCommandTriggerEvent(NavigateCommandTriggerEvent.PUSH, 
				Places.HOME	) ) ; 
			this.ui.hide(); 
		}		
		
		
		protected function onSetup(event:Event):void
		{
			this.ui.txtLessonName.text = this.model.currentLessonPlan.name; 
		}
		
		
		
		
		private function onCancel(e:Event) : void
		{
			this.ui.hide();
		}				
		
		
	}
}