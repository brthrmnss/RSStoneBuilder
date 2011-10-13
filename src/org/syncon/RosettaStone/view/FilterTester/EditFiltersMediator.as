package  org.syncon.RosettaStone.view.FilterTester
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.events.ResizeEvent;
	import mx.managers.PopUpManager;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.TalkingClock.controller.ConvertFiltersCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.StyleConfigurator;
	
	import spark.components.Group;
	
	
	
	public class  EditFiltersMediator extends Mediator  implements IEditFilterMediator
	{
		[Inject] public var ui: EditFilters;
		[Inject] public var model :  RSModel;
		private var firstLoad:Boolean=true;
		private var timer:Timer;
		private var timer_Reset:Timer;
		public var ev : LazyEventHandler = new  LazyEventHandler()
		private var timer_ShowLoading : Timer; 
		private var styler:StyleConfigurator;
		/**
		 * VOs associated with this object
		 * */
		private var _filters:Array;
		public function get filters() : Array { return this._filters}
		public function set filters( a  : Array ) : void  { this._filters = a  } 
		
		public function EditFiltersMediator()
		{
		} 
		override public function onRemove():void
		{
			 PopUpManager.removePopUp(this.ui.btnEdit );
			this.ui.target.removeEventListener(ResizeEvent.RESIZE, this.onResizeTarget )
			this.ui.target.filters = []; 
			this.ui._filterJSON = []; 
			
			this.ev.unmapAll();
			this.ev = null; 
			this.styler = null;  
			super.onRemove()
		/*
			this.ui.target = null ;
			var dbg : Array = [this.ui.btnEdit.parent, this.ui.btnEdit.parentDocument] ; 
			this.ui.btnEdit = null
			this.ui = null ;*/
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
			
			
			this.ev.addEv(Clock.EDIT, this.onEdit, false, 0, true ) ; 
			
			this.styler = new StyleConfigurator(); 
			this.styler.init( this.ui, this.model.config ); //, this.updateStyles  ); 
			
			if ( this.ui._filterString != null ) 
			{
				this.onFilterString( null, this.ui._filterString )
			}
			if ( this.ui._filterJSON != null ) 
			{
				this.onFilterJSON( null, this.ui._filterJSON )
				this.ui._filterJSON = null; 
			}
			/*
			//this.ui
			// this.ui.parentDocument.addElement( this.ui ) ; 
			var g : Group = this.ui.parent as Group
			g.removeElement( this.ui ) ; 
			PopUpManager.addPopUp(this.ui, this.ui.parentApplication as DisplayObject, false);
			//PopUpManager.centerPopUp(ttlWndw);
			*/
			
			//this.ui.parentApplication.addElement( this.ui ) ; 
			
			//this.ui.parentApplication.addElement( this.ui.btnEdit ) ; 
			var g : Group = this.ui as Group
			g.removeElement( this.ui.btnEdit ) ; 
			PopUpManager.addPopUp(this.ui.btnEdit, this.ui.parentApplication as DisplayObject, false);
			this.moveToTarget();
			this.ui.target.addEventListener(ResizeEvent.RESIZE, this.onResizeTarget,false,0,true );  
		}
		
		protected function onResizeTarget(event:ResizeEvent):void
		{
			this.moveToTarget()
		}		
		
		private function moveToTarget():void
		{
			this.ui.parent 
			var point : Point = this.ui.target.localToGlobal( new Point() ) ;
			/*var pointOnLocalS : Point = this.ui.globalToLocal( point ) ; 
			this.ui.x = pointOnLocalS.x+this.ui.target.width; 
			this.ui.y = pointOnLocalS.y ; */
			var pointOnLocalS : Point = point; // this.ui.btnEdit.globalToLocal( point ) ; 
			this.ui.btnEdit.x = pointOnLocalS.x+this.ui.target.width; 
			this.ui.btnEdit.y = pointOnLocalS.y ; 
		}
		
		protected function onEdit(event:Event):void
		{
			/*if ( this.filters != this.ui.target.filters ) 
			this.filters = this.ui.target.filters; 
			*/
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
			this.addNewFiltersOnItem.filters = a; 
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
			this.ui.target.filters = this.model.getVisibleFilters(this.filters); 
			//var s : Array = this.ui.filters; 
			return; 
		}
		
	}
}