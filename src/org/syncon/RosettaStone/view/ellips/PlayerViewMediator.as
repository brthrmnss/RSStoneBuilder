package org.syncon.RosettaStone.view.ellips
{
	import flash.events.Event;
	
	import mvc.controller.SwitchScreensTriggerEvent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.AutomateEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.*;
	import org.syncon.TalkingClock.vo.MobileMenuConfigVO;
	
	public class PlayerViewMediator extends Mediator
	{
		[Inject] public var ui: PlayerView;
		[Inject] public var model : RSModel;
		public var injections : Array =  ['model', RSModel] 
		private var styler:StyleConfigurator;
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		
		override public function onRemove():void
		{
			ev.unmapAll(); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			ev.init( this.ui ) ; 
			
			this.styler = new StyleConfigurator(); 
			//this.styler.init( this.ui, this.model.config, this.updateStyles ); 
			this.ev.addEv( PlayerView.GO_BACK, this.onGoBack ) 
			this.ev.addEv( PlayerView.HOME, this.onHome ) 
			this.ev.addEv( PlayerView.INFO, this.onInfo ) 
			this.ev.addEv( PlayerView.CURRICLUM, this.onCurriculumn )
			this.ev.addEv( PlayerView.SETTINGS, this.onSettings ) 
			this.ev.addEv( PlayerView.MENU, this.onMenu ) 
			this.ev.addEv( PlayerView.NEXT_SET, this.onNextSet ) 
			
			eventMap.mapListener(eventDispatcher,RSModelEvent.AUTOMATING_CHANGED , 
				this.onAutomationChanged);				
			eventMap.mapListener(eventDispatcher,RSModelEvent.CURRENT_LESSON_CHANGED , 
				this.onAutomationChanged);		
			this.onAutomationChanged(null);		
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.DEBUG_MODE_CHANGED, 
				this.onDebugModeChanged);	
			this.onDebugModeChanged( null ) 		
				
				
			this.ui.menuProvider2 =MobileMenuConfigVO.create( ['Settings', 'Home', 'Credits', 'Curriculum' ], this.onMenuOptions ) 
	 
		}
		
		private function onNextSet(e:Event):void
		{
			this.dispatch( new AutomateEvent(AutomateEvent.NEXT_SET, null ) )
		}
		static public const Settings : String = 'Settings';
		static public const Home : String = 'Home';  
		static public const Credits : String = 'Credits';  
		static public const Curriculum : String = 'Curriculum';  
		
		private function onMenuOptions(opt : String):void
		{
			if ( opt == Settings  ) 
			{
				this.onSettings(null)
			}
			if ( opt == Home  ) 
			{
				//this.dispatch( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.home ) ) ; 
				this.onHome(null)
			}
			if ( opt == Credits  ) 
			{
				this.onInfo(null)
			}
			if ( opt == Curriculum  ) 
			{
				this.onCurriculumn(null)
			}			
			
		}		
	 
		
		public function  onDebugModeChanged (e:Event) : void
		{
			this.ui.automate.visible = this.model.debugMode; 
		}
		private function onInfo(e:Event):void
		{
			this.model.alert( 'Lesson: ' + this.model.currentLesson.name + '\n' + 
				'Unit: ' + this.model.currentLessonPlan.name  + '\n'+
				'Package: ' + this.model.currentUnit.name  + '\n', 'Current Lesson' )
		}
		private function onCurriculumn(e:Event):void
		{
			this.dispatch( new AutomateEvent(AutomateEvent.PAUSE_LESSON , null) ) ; 
			//this.dispatch( SwitchScreensTriggerEvent.GoBack() )
			//this.dispatch( NavigateCommandTriggerEvent.pushView( PackageSelectView )  ) 	
			this.dispatch( SwitchScreensTriggerEvent.GoTo(SwitchScreensTriggerEvent.curriculum)  ) 
		}
		private function onSettings(e:Event):void
		{
			this.dispatch( new AutomateEvent(AutomateEvent.PAUSE_LESSON , null) ) ; 
			//this.dispatch( SwitchScreensTriggerEvent.GoBack() )
			//this.dispatch( NavigateCommandTriggerEvent.pushView( PackageSelectView )  ) 	
			this.dispatch( SwitchScreensTriggerEvent.GoTo(SwitchScreensTriggerEvent.settings)  ) 
		}
		
		private function onMenu(e:Event ) : void
		{
			this.dispatch(  SwitchScreensTriggerEvent.GoTo(SwitchScreensTriggerEvent.menu, this.ui.menuProvider2 )  )  
		}
		
		
		public function updateStyles(init:Boolean=false) : void
		{
		}
		
		private function onTryAgain(e:Event):void
		{
		}		
		
		private function onGoBack(e:Event):void
		{
			this.dispatch( new AutomateEvent(AutomateEvent.PAUSE_LESSON, null ) ) ; 
			//this.dispatch( NavigateCommandTriggerEvent.popView() ) 	
			this.dispatch( SwitchScreensTriggerEvent.GoBack()  ) 
		}		
		private function onHome(e:Event):void
		{
			this.dispatch( new AutomateEvent(AutomateEvent.PAUSE_LESSON , null ) ) ; 
			
			//this.dispatch( SwitchScreensTriggerEvent.GoBack() )
			//this.dispatch( NavigateCommandTriggerEvent.pushView( PackageSelectView )  ) 	
			this.dispatch( SwitchScreensTriggerEvent.GoTo(SwitchScreensTriggerEvent.home)  ) 
		}		
		private function onAutomationChanged(e:Event):void
		{
			if ( this.model.automating == false ) 
				this.ui.txtLessonInfo.text = ''; 
			else
				this.ui.txtLessonInfo.text =  this.model.lessonString(); 
			
		}		
		
		
		
		
	}
}