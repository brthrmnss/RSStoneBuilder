package org.syncon.RosettaStone.view.mobile
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.ConfigCommandTriggerEvent;
	import org.syncon.TalkingClock.controller.LoadWidgetCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.view.mobile.itemrenderers.ThemeItemRenderer_Flex;
	import org.syncon.RosettaStone.vo.*;
	
	import spark.events.ViewNavigatorEvent;
	
	
	public class SelectThemeViewMediator extends Mediator
	{
		[Inject] public var ui: SelectThemeView;
		[Inject] public var model : RSModel;
		private var firstLoad:Boolean=true;
		
		private var styler:StyleConfigurator;
		
		public function SelectThemeViewMediator()
		{
		} 
		override public function onRemove():void
		{
			trace('mediator removed'); 
			this.ui.removeEventListener(SelectThemeView.GO_BACK, this.onGoBack ) ;
			this.ui.removeEventListener(SelectThemeView.TRY_AGAIN , this.onTryAgain ) ; 
			this.ui.removeEventListener(SelectThemeView.LIST_CHANGED, this.onListChanged ) ;
			this.ui.removeEventListener(SelectThemeView.SETTINGS, this.onSettings ) ;
			super.onRemove()
		}
		override public function onRegister():void
		{
			if ( this.model.showAds == false ) 
			{
				this.ui.list.setStyle('bottom', 0 ); 
			}			
			trace('mediator created'); 
			/*if ( this.ui.destructionPolicy == 'never' ) {
			this.mediatorMap.unmapView( SelectThemeView )
			}*/
			/*eventMap.mapListener(eventDispatcher, NightStandModelEvent.LOADED_ODBS,
			this.onLoadOdbs);	
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.LOAD_ODBS_FAULT,
			this.onLoadOdbsFault);		*/		
			//this.ui.addEventListener(FlexEvent.DATA_CHANGE, this.onDataChange, false, 0, true ) ; 
			this.ui.addEventListener(SelectThemeView.GO_BACK, this.onGoBack, false, 0, true ) ;
			this.ui.addEventListener(SelectThemeView.TRY_AGAIN , this.onTryAgain, false, 0, true ) ; 
			this.ui.addEventListener(SelectThemeView.LIST_CHANGED, this.onListChanged, false, 0, true ) ;
			
			this.ui.addEventListener(SelectThemeView.SETTINGS, this.onSettings, false, 0, true ) ;
			
			
			//this.ui.addEventListener(Event.ACTIVATE, this.onActivate, false, 0, true ) ; 
			this.ui.addEventListener(ViewNavigatorEvent.VIEW_ACTIVATE, this.onActivate2, false, 0, true ) ; 
			
			this.styler = new StyleConfigurator(); 
			this.styler.init( this.ui, this.model.config, this.updateStyles ); 
			
			this.CreateStuff()
			
			if ( this.model.flex ) 
			{
				var clas : ClassFactory = new ClassFactory(ThemeItemRenderer_Flex ) 
				this.ui.list.itemRenderer = clas
			}
		}
		
		private function CreateStuff():void
		{
			var themes : Array = [
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
			this.ui.list.dataProvider = new ArrayList( themes2 ) 
		}
		
		protected function onSettings(event:Event):void
		{
			this.ui.navigator.pushView( SettingsView );
		}
		
		protected function onActivate2(event:ViewNavigatorEvent):void
		{
			//trace('activate', this.ui ); 
			/*this.ui.list.alpha = 1; 
			this.ui.txtLoading.visible = false; */
			this.styler.changedCheck( this.model.config ) ; 
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
		
		protected function onListChanged(event:CustomEvent):void
		{
			//this.ui.list.selectedItem = null 
			this.ui.list.selectedIndex = -1; 
			trace('change heard'); 
			
			var theme : ThemeVO = event.data as ThemeVO;
			if (  theme.type == this.model.currentConfig.type ) 
			{
				trace('same theme ' ) 
				return;
			}
			var iWidget : IWidgetConfigVO 
			//look for it 
			iWidget = this.model.config.findTypeOrMakeNew( theme.type ) ; 
			//this.model.config.newCurrent( iWidget ) 
			
			this.model.currentConfig =this.model.config.currentConfig; 
			
			this.dispatch( NavigateCommandTriggerEvent.popView() ) 	
			this.dispatch( NavigateCommandTriggerEvent.popView() ) 	
			this.dispatch( NavigateCommandTriggerEvent.popView() ) 	
			/*this.dispatch( NavigateCommandTriggerEvent.pushView( HomeView ) ) ; */
			//this.ui.navigator.pushView( DevotionView, this.loadOdb );
			this.dispatch( new ConfigCommandTriggerEvent(ConfigCommandTriggerEvent.SAVE_AND_LOAD_CONFIG ));  
			
			this.dispatch( new LoadWidgetCommandTriggerEvent(LoadWidgetCommandTriggerEvent.LOAD_WIDGET, 
			     iWidget ) )  ;
		}
		
		
	}
}