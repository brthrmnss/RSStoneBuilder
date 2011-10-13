package  org.syncon.RosettaStone.view.ellips
{
	import mvc.controller.SwitchScreensTriggerEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.core.IFactory;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.IO.LoadLessonPlanCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.*;
	import org.syncon.TalkingClock.model.NightStandConstants;
	import flash.events.Event;
	
	
	public class GroupSelectViewMediator extends Mediator
	{
		[Inject] public var ui: GroupSelectView;
		[Inject] public var model : RSModel;
		public var injections  : Array = ['model', RSModel] 
		private var currentUnit:UnitVO;
		
		private var styler:StyleConfigurator;
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		
		override public function onRemove():void
		{
			ev.unmapAll(); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			if ( this.model.showAds == false ) 
			{
				this.ui.list.setStyle('bottom', 0 ); 
			}			
			ev.init( this.ui ) ; 
			
			this.styler = new StyleConfigurator(); 
			//this.styler.init( this.ui, this.model.config, this.updateStyles ); 
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_UNIT_CHANGED, 
				this.onUnitChanged);	
			this.onUnitChanged( null ) 
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_PLAN_CHANGED, 
				this.onLessonPlanChanged);	
			this.onLessonPlanChanged( null ) 
			
			this.ev.addEv( GroupSelectView.LIST_CHANGED, this.onListChanged ) 
			this.ev.addEv( GroupSelectView.GO_BACK, this.onGoBack ) 
			
			this.CreateStuff()
			/*
			if ( this.model.flex ) 
			{
			var clas : ClassFactory = new ClassFactory(ThemeItemRenderer_Flex ) 
			this.ui.list.itemRenderer = clas
			}*/
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.LOADED_LAST_LESSON, 
				this.onLoadedLastLesson);	
			this.onLoadedLastLesson( null ) 				
		}
		
		protected function onResume(event:Event):void
		{
			/*this.dispatch( new NavigateCommandTriggerEvent( 
			NavigateCommandTriggerEvent.PUSH, PlayerView ) ) */
		}
		
		private function CreateStuff():void
		{
			/*var themes : Array = [
			['LED Clock', 'assets/ledclock.jpg', LEDConfigVO.Type ],
			['LCD Clock', 'assets/lcdclock.jpg',  LCDConfigVO.Type ],
			['Flip Clock', 'assets/flipclock.jpg',  FlipClockConfigVO.Type ],
			['Wall Clock', 'assets/wallclock.jpg',  WallClockConfigVO.Type ],
			]
			var themes2 : Array = [] ;
			for ( var i : int = 0 ; i < themes.length; i++ )
			{
			var set : Array = themes[i]; 
			var t : ThemeVO = new ThemeVO(); 
			t.name = set[0]; 
			t.pic = set[1] ; 
			t.type = set[2] 
			themes2.push( t )
			}
			this.ui.list.dataProvider = new ArrayList( themes2 ) */
		}
		
		public function updateStyles(init:Boolean=false) : void
		{
			var updateAnyway : Boolean = false
			if ( this.styler.bgChanged || init ) 
			{
				/*
				var css : CSSStyleDeclaration = this.ui.styleManager.getStyleDeclaration('org.syncon.odb.view.mobile.ODBRenderer')
				css.setStyle( 'backgroundColor', this.model.config.reverseText ? 0: 0xFFFFFF ) 
				var css2 : CSSStyleDeclaration = this.ui.styleManager.getStyleDeclaration('.txtTitleStyle')
				css2.setStyle( 'color', this.model.config.reverseText == false ? 0: 0xFFFFFF ) 
				updateAnyway = true; 
				*/
			}
			if ( this.styler.fontChanged || updateAnyway ) // != this.model.config.fontSize ) 
			{
				//refresh list itemRenderers
				var oldItemRenderer : Object = this.ui.list.itemRenderer
				this.ui.list.itemRenderer = null ; 
				this.ui.list.itemRenderer = oldItemRenderer as IFactory ;
				
				NightStandConstants.PlatformGlobals.setListSelectedIndex( this.ui.list, 0 ); 
				//this.ui.list.scroller.verticalScrollBar.value = 0; 
			}
		}
		
		private function onTryAgain(e:Event):void
		{
		}		
		
		private function onGoBack(e:Event):void
		{
			//this.dispatch( NavigateCommandTriggerEvent.popView() ) 	
			this.dispatch( SwitchScreensTriggerEvent.GoBack() )
		}		
		
		private function onUnitChanged(e: RSModelEvent): void
		{
			var unit : UnitVO = this.model.currentUnit
			this.currentUnit = unit; 
			if ( unit != null ) 
			{
				var dp : ArrayCollection =unit.groups 
			}
			else
				dp = new ArrayCollection(); 			
			this.ui.list.dataProvider = dp
			this.ui.list.selectedItem = null; 
		}	
		/**
		 * Export when lesson changed, as we have just saved it
		 * */
		private function onLessonPlanChanged(param0:Object):void
		{
			//this.ui.list.selectedItem = this.model.currentLessonPlan
		}
		protected function onListChanged(e:CustomEvent):void
		{
			this.model.currentLessonPlan = e.data as LessonGroupVO;
			var group : LessonGroupVO =this.model.currentLessonPlan
			this.dispatch( new  LoadLessonPlanCommandTriggerEvent(
				LoadLessonPlanCommandTriggerEvent.LOAD_LESSON_PLAN, group,'', this.onLoadedGroup  ) ) ; 
			
			
			this.ui.list.selectedItem = null; 
		}
		
		private function onLoadedGroup(e:Object):void
		{SwitchScreensTriggerEvent
			//this.dispatch( NavigateCommandTriggerEvent.pushView( LessonSelectView )  ) 				
			this.dispatch( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.SELECT_LESSON ) ) ; 
		}
		
		private function onLoadedLastLesson(param0:Object):void
		{
			//this.ui.btnResume.visible =  this.model.loadedLastLesson
		}
		
		
	}
}