package  org.syncon.RosettaStone.view.ellips
{
	import flash.events.Event;
	
	import mvc.controller.SwitchScreensTriggerEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.IO.LoadUnitCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.*;
	
	
	public class PackageSelectViewMediator extends Mediator
	{
		[Inject] public var ui: PackageSelectView;
		[Inject] public var model : RSModel;
		
		private var currentUnit:UnitVO;
		
		private var styler:StyleConfigurator;
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		public var injections  : Array = ['model', RSModel] 
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
			eventMap.mapListener(eventDispatcher, RSModelEvent.UNITS_CHANGED, 
				this.onUnitsChanged);	
			this.onUnitsChanged( null ) 
			
			this.ev.addEv( PackageSelectView.LIST_CHANGED, this.onListChanged ) 
			this.ev.addEv( PackageSelectView.RESUME, this.onResume ) 
			this.ev.addEv( PackageSelectView.HOME, this.onHome ) 				
			
			
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
			
			this.dispatch( SwitchScreensTriggerEvent.GoBack() )
			
			var e :  SwitchScreensTriggerEvent =SwitchScreensTriggerEvent.GoTo(
				SwitchScreensTriggerEvent.PLAYER_VIEW ) 
				
			//this.model.currentLesson = this.model.
				
			this.dispatch( e ) 
			
			//who loads this ? 
		}
		
		
		protected function onHome(event:Event):void
		{
			this.dispatch( SwitchScreensTriggerEvent.GoBack() )
			var e :  SwitchScreensTriggerEvent =SwitchScreensTriggerEvent.GoTo(
				SwitchScreensTriggerEvent.home ) 
			this.dispatch( e ) 
		}
		
		private function CreateStuff():void
		{
			 
		}
		
		
		public function updateStyles(init:Boolean=false) : void
		{
			/*var updateAnyway : Boolean = false
			if ( this.styler.bgChanged || init ) 
			{
			
			}
			if ( this.styler.fontChanged || updateAnyway ) // != this.model.config.fontSize ) 
			{
			//refresh list itemRenderers
			var oldItemRenderer : Object = this.ui.list.itemRenderer
			this.ui.list.itemRenderer = null ; 
			this.ui.list.itemRenderer = oldItemRenderer as IFactory ;
			
			this.ui.list.scroller.verticalScrollBar.value = 0; 
			}*/
		}
		
		private function onTryAgain(e:Event):void
		{
		}		
		
		private function onGoBack(e:Event):void
		{
			this.dispatch( NavigateCommandTriggerEvent.popView() ) 	
		}		
		
		private function onUnitsChanged(e: RSModelEvent): void
		{
			//var unit : UnitVO = this.model.currentUnit
			/*s.listenForObj( unit, UnitVO.UPDATED, this.onUpdatedLesson ) ; 	
			this.currentUnit = unit; 
			if ( unit != null ) 
			{*/
			var dp : ArrayCollection = new ArrayCollection( this.model.listUnits.toArray() ) ; 
			/*	}
			else
			dp = new ArrayList(); 			*/
			this.ui.list.dataProvider = dp
			this.ui.list.selectedItem = null; 
		}	
		/**
		 * Export when lesson changed, as we have just saved it
		 * */
		private function onUnitChanged(param0:Object):void
		{
			var unit : UnitVO = this.model.currentUnit
			//this.ui.list.selectedItem = unit
			this.currentUnit = unit; 
		}
		protected function onListChanged(e:CustomEvent):void
		{
			var unit : UnitVO =  e.data as UnitVO;
			/*this.model.currentDate = e.data as DateXMLVO;*/
			this.model.currentUnit =unit
			this.dispatch( new  LoadUnitCommandTriggerEvent(
				LoadUnitCommandTriggerEvent.LOAD_UNIT, unit,'' ,this.onLoadedUnit   ) ) ; 
			//this.ui.list.selectedIndex = -1 ; // = null; 
		}
		
		private function onLoadedUnit(e:Object):void
		{
			this.dispatch( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.SELECT_LESSON_GROUP ) ) ; 
			//this.dispatch( NavigateCommandTriggerEvent.pushView( GroupSelectView)  ) 				
		}
		private function onLoadedLastLesson(param0:Object):void
		{
              			this.ui.btnResume.visible =  this.model.loadedLastLesson
		}
		
		
	}
}