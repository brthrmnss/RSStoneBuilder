package org.syncon.RosettaStone.view.mobile
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.IO.LoadUnitCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.view.mobile.itemrenderers.ThemeItemRenderer_Flex;
	import org.syncon.RosettaStone.vo.*;
	
	import spark.events.ViewNavigatorEvent;
	
	
	public class PackageSelectViewMediator extends Mediator
	{
		[Inject] public var ui: PackageSelectView;
		[Inject] public var model : RSModel;
		
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
			eventMap.mapListener(eventDispatcher, RSModelEvent.UNITS_CHANGED, 
				this.onUnitsChanged);	
			this.onUnitsChanged( null ) 
			
			this.ev.addEv( PackageSelectView.LIST_CHANGED, this.onListChanged ) 
			this.ev.addEv( PackageSelectView.RESUME, this.onResume ) 
			
			
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
			this.dispatch( new NavigateCommandTriggerEvent( 
				NavigateCommandTriggerEvent.PUSH, PlayerView ) ) 
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
		
		
		
		protected function onActivate2(event:ViewNavigatorEvent):void
		{
			//trace('activate', this.ui ); 
			/*this.ui.list.alpha = 1; 
			this.ui.txtLoading.visible = false; */
			//this.styler.changedCheck( this.model.config ) ; 
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
				 
				this.ui.list.scroller.verticalScrollBar.value = 0; 
			}
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
			var dp : ArrayList = new ArrayList( this.model.listUnits.toArray() ) ; 
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
			this.ui.list.selectedIndex = -1 ; // = null; 
		}
		
		private function onLoadedUnit(e:Object):void
		{
			this.dispatch( NavigateCommandTriggerEvent.pushView( GroupSelectView)  ) 				
		}
		private function onLoadedLastLesson(param0:Object):void
		{
			this.ui.btnResume.visible =  this.model.loadedLastLesson
		}
		
		
	}
}