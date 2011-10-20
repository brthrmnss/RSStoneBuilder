package   org.syncon.RosettaStone.view.ellips.rs
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.AutomateEvent;
	import org.syncon.RosettaStone.model.RSMobileModel;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.RotateVO;
	import org.syncon.TalkingClock.model.NightStandModel;
	import org.syncon2.utils.mobile.AndroidExtensions_OpenPlug;
	
	public class  PopupLessonCompleteMediator extends Mediator
	{
		[Inject] public var ui:PopupLessonComplete;
		[Inject] public var model : RSModel;
		[Inject] public var modelMobile : RSMobileModel;		
		[Inject] public var model2 : NightStandModel;	
		
		public var injections  : Array = ['model', RSModel,'modelMobile', RSMobileModel,
			'model2', NightStandModel]  
		
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		private var rotate : RotateVO = new RotateVO()
		
		
		public function PopupLessonCompleteMediator()
		{
		} 
		override public function onRemove():void
		{
			ev.unmapAll(); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			trace('mediatoe', 'PopupLessonCompleteMediator')
			ev.init( this.ui ) ; 
			this.ev.addEv(PopupLessonComplete.CANCEL, this.onCancel )
			this.ev.addEv( PopupLessonComplete.SETUP, this.onSetup ) ; 
			
			this.ev.addEv(PopupLessonComplete.REPEAT, this.onRepeat )
			this.ev.addEv( PopupLessonComplete.NEXT_LESSON, this.onNext ) ; 
			this.ev.addEv(PopupLessonComplete.GO_HOME, this.noHome )
			
			this.ev.addEv(PopupLessonComplete.SEE_APP, this.onSeeApp )
			
			
			this.modelMobile.registerPopup( this.ui, 'PopupLessonComplete' , this.ui.id ) 
			trace('mediatoe','done',  'PopupLessonCompleteMediator')
		}
		
		
		protected function onRepeat(event:Event=null):void
		{
			//this.ui.hide(); 
			this.dispatch( new AutomateEvent(AutomateEvent.START_LESSON, this.ui.lesson )) 
		}
		
		protected function onNext(event:Event=null):void
		{
			//this.ui.hide(); 
			this.dispatch( new AutomateEvent(AutomateEvent.NEXT_LESSON, this.ui.lesson )) 
			//this.dispatchEvent( new Event( NEXT_LESSON ) )  
			
		}
		
		protected function noHome(event:Event=null):void
		{
			// this.ui.hide(); 
			/*	this.dispatch( new NavigateCommandTriggerEvent(NavigateCommandTriggerEvent.PUSH, 
			Places.HOME	) ) ; 
			*/
			//this.modelMobile.goHome(2); 
			
			/*this.dispatch( SwitchScreensTriggerEvent.GoBack() )
			this.dispatch( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.home )  ) */
			/*this.dispatch( SwitchScreensTriggerEvent.GoBack() )
			this.dispatch( SwitchScreensTriggerEvent.GoBack() )*/
			//this.dispatch( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.home )  ) 
			/*
			this.dispatch( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.home )  ) */
			/*
			this.dispatch( SwitchScreensTriggerEvent.GoBack() )
			this.dispatch( SwitchScreensTriggerEvent.GoBack() )
			this.dispatch( SwitchScreensTriggerEvent.GoTo(SwitchScreensTriggerEvent.home)  ) 
			*/
			
			this.modelMobile.goHome(2); 
		}		
		
		
		protected function onSetup(event:Event):void
		{
			this.ui.txtLessonName.text = this.model.currentLesson.name; 
			if ( this.model.dontShowNextLesson ) 
			{
				this.ui.btnNext.visible = false; 
			}
			
			if ( this.model2.config != null ) 
			{
				if ( this.model2.config.demo_mode ) 
				{
					this.ui.txtMessage.text = this.model2.config.demo_message
					this.ui.btnSeeApp.visible = true
				}
				else
				{
					this.ui.txtMessage.text = ''
					this.ui.btnSeeApp.visible = false
				}
			}
		}
		
		private function onCancel(e:Event) : void
		{
			this.ui.hide();
		}				
		
		private function onSeeApp(e:Event) : void
		{
			if ( this.model2.config == null ) 
			{
				trace('on see app', 'why you here' ) 
				return; 
			}
			var a : AndroidExtensions_OpenPlug = new AndroidExtensions_OpenPlug()
			a.goToStore( this.model2.config.demo_app ) 
		}			
		
		
	}
}