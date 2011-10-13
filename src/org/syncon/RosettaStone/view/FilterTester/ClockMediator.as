package  org.syncon.RosettaStone.view.FilterTester
{
	import flash.events.Event;
	import flash.utils.Timer;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.TalkingClock.controller.ConvertFiltersCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.StyleConfigurator;
	
	
	
	public class  ClockMediator extends Mediator implements IEditFilterMediator
	{
		[Inject] public var ui:   Clock;
		[Inject] public var model :  RSModel;
		private var firstLoad:Boolean=true;
		public var ev : LazyEventHandler = new  LazyEventHandler()
		private var timer_ShowLoading : Timer; 
		private var styler:StyleConfigurator;
		/**
		 * VOs associated with this object
		 * */
		private var _filters:Array;
		public function get filters() : Array { return this._filters}
		public function set filters( a  : Array ) : void { this._filters = a  } 
		
		public function ClockMediator()
		{
		} 
		override public function onRemove():void
		{
			this.ev.unmapAll();
			super.onRemove()
		}
		override public function onRegister():void
		{
			this.model.target = this  
			/*if ( this.model.showAds == false ) 
			{
			this.ui.list.setStyle('bottom', 0 ); 
			}	*/		
			
			/*eventMap.mapListener(eventDispatcher, OdbModelEvent.LOADED_ODBS,
			this.onLoadOdbs);	
			
			this.ev.addEv(ListView.SETTINGS, this.onSettings, false, 0, true ) ;
			
			*/
			this.ev.init( this.ui ) ; 
			//this.ev.addEv(Event.ACTIVATE, this.onActivate, false, 0, true ) ; 
			this.ev.addEv(Clock.NEW_FILTER_STIRNG, this.onFilterString, false, 0, true ) ;
			this.ev.addEv(Clock.NEW_FILTER_JSON, this.onFilterJSON, false, 0, true ) ;
			
			this.ev.addEv(Clock.NEW_FILTER_JSON_ITEM, this.onFilterJSONAndAddOnItem )
			
			this.ev.addEv(Clock.EDIT, this.onEdit, false, 0, true ) ; 
			
			this.styler = new StyleConfigurator(); 
			this.styler.init( this.ui, this.model.config ); //, this.updateStyles  ); 
			/*
			if ( this.model.stories.length > 0 ) 
			this.onLoadOdbs(null); */
			if ( this.ui.initFilterString != null ) 
			{
				this.onFilterString( null, this.ui.initFilterString )
			}
			if ( this.ui._filterJSON != null ) 
			{
				this.onFilterJSON( null, this.ui._filterJSON )
				this.ui._filterJSON = null; 
			}
			this.ui.drawFilters()
		}
		
		
		protected function onEdit(event:Event):void
		{
			this.model.target = this; 
		}
		
		protected function onFilterString(event: CustomEvent, str : String = null ):void
		{
			if ( str == null ) 
				var junk :  String = event.data.toString();
			else
				junk = str; 
			this.dispatch( new ConvertFiltersCommandTriggerEvent(
				ConvertFiltersCommandTriggerEvent.IMPORT_CONFIG, junk, this.onNewFilters))
		}
		protected function onFilterJSON(event: CustomEvent,  arr :   Array = null ):void
		{
			if ( arr == null ) 
				var junk :  Array = event.data as Array 
			else
				junk = arr; 
			this.dispatch( new ConvertFiltersCommandTriggerEvent(
				ConvertFiltersCommandTriggerEvent.IMPORT_CONFIG, junk, this.onNewFilters))
		}
		
		public function onNewFilters(a:Array):void{
			
			this.loadFilters( a );
			//reset target so we can see the filters
			if ( this == this.model.target ) 
			{
				this.model.target = this; 
			}
		}
		
		private var addNewFiltersOnItem : Object; 
		private function onFilterJSONAndAddOnItem(event: CustomEvent,  arr :   Array = null ):void
		{
			var data : Array = event.data as Array 
			var filters :  Array = data[0]
			addNewFiltersOnItem = data[1]
			this.dispatch( new ConvertFiltersCommandTriggerEvent(
				ConvertFiltersCommandTriggerEvent.IMPORT_CONFIG, filters, this.onNewFilters_OnItem))
		}
		public function onNewFilters_OnItem(a:Array):void {
			this.addNewFiltersOnItem.filters = this.model.getVisibleFilters(a) ;  
		}
		
		public function loadFilters(e:Array ) : void
		{
			this.filters = e; 
			this.updateFilters(); 
			//this.dispatch( new OdbModelEvent( OdbModelEvent.LOADED_ODBS, e ) ) 
		}	
		
		private function updateFilters():void
		{
			// TODO Auto Generated method stub
			this.ui.filters = this.model.getVisibleFilters(this.filters); 
			//var s : Array = this.ui.filters; 
			return; 
		}
		
	}
}