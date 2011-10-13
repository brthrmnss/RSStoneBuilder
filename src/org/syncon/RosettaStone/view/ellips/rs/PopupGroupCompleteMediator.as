package  	 org.syncon.RosettaStone.view.ellips.rs
{
	import flash.events.Event;
	
	import mvc.controller.SwitchScreensTriggerEvent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.AutomateEvent;
	import org.syncon.RosettaStone.model.RSMobileModel;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	
	public class  PopupGroupCompleteMediator extends Mediator
	{
		[Inject] public var ui:PopupGroupComplete;
		[Inject] public var model : RSModel;
		[Inject] public var modelMobile : RSMobileModel;		
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		public var injections  : Array = ['model', RSModel,'modelMobile', RSMobileModel]  
		
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
			
			trace('mediatoe', 'PopupSelectionResultMediator')
			ev.init( this.ui ) ; 
			this.ev.addEv(PopupGroupComplete.CANCEL, this.onCancel )
			this.ev.addEv( PopupGroupComplete.SETUP, this.onSetup ) ; 
			
			this.ev.addEv(PopupGroupComplete.REPEAT, this.onRepeat )
			this.ev.addEv( PopupGroupComplete.NEXT_LESSON, this.onNext ) ; 
			this.ev.addEv(PopupGroupComplete.GO_HOME, this.noHome )
			
			this.modelMobile.registerPopup( this.ui, 'PopupGroupComplete' , this.ui.id ) 
			trace('mediatoe done', 'PopupSelectionResultMediator')
		}
		
		
		protected function onRepeat(event:Event=null):void
		{
			this.ui.hide(); 
			this.dispatch( new AutomateEvent(AutomateEvent.START_LESSON, this.ui.lesson )) 
		}
		
		protected function onNext(event:Event=null):void
		{
			this.ui.hide(); 
			this.dispatch( new AutomateEvent(AutomateEvent.NEXT_LESSON, this.ui.lesson, true )) 
		}
		
		protected function noHome(event:Event=null):void
		{
			this.ui.hide(); 
			this.modelMobile.goHome(1); 
			/*this.dispatch( SwitchScreensTriggerEvent.GoBack() )
			this.dispatch( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.home )  ) */
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