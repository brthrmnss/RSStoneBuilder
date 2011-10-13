package  org.syncon.RosettaStone.view.FilterTester
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.TalkingClock.controller.ConvertFiltersCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.TalkingClock.vo.FilterVO;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.StyleConfigurator;
	import org.syncon2.utils.ArrayListMoveableHelper;
	
	import spark.filters.BlurFilter;
	import spark.filters.DropShadowFilter;
	import spark.filters.GlowFilter;
	
	
	
	public class  FilterStackMediator extends Mediator
	{
		[Inject] public var ui:    FilterStack;
		[Inject] public var model :  RSModel;
		private var firstLoad:Boolean=true;
		private var styler:StyleConfigurator;
		public var ev : LazyEventHandler = new LazyEventHandler()
		private var moveables:  ArrayListMoveableHelper = new ArrayListMoveableHelper(); ;
		public function FilterStackMediator()
		{
		} 
		override public function onRemove():void
		{
			trace('mediator removed'); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			this.ev.init( this.ui ) ; 
			/*if ( this.model.showAds == false ) 
			{
			this.ui.list.setStyle('bottom', 0 ); 
			}	*/		
			eventMap.mapListener(eventDispatcher, RSModelEvent.CHANGED_FILTER_PROPERTIES,
				this.updateFilterProperies);	
			eventMap.mapListener(eventDispatcher, RSModelEvent.CLOSE_EDIT_FILTER,
				this.onCloseEditFilter);				
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.TARGET_CHANGED,
				this.onTargetChanged );						
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.ADD_FILTER,
				this.onAddFilter_M );		
			
			/*eventMap.mapListener(eventDispatcher, OdbModelEvent.LOADED_ODBS,
			this.onLoadOdbs);	
			
			this.ui.addEventListener(ListView.SETTINGS, this.onSettings, false, 0, true ) ;
			
			*/
			//this.ui.addEventListener(Event.ACTIVATE, this.onActivate, false, 0, true ) ; 
			
			this.ev.addEv( FilterNewSelection.ADD_BLUR, this.onAddBlur ) 
			this.ev.addEv( FilterNewSelection.ADD_DROP_SHADOW, this.onAddDropShadow ) 
			this.ev.addEv( FilterNewSelection.ADD_GLOW, this.onAddGlow ) 				
			this.ev.addEv( FilterStack.CHANGED_FILTER, this.onChangeFilter  ) 
			this.ev.addEv( FilterStack.IMPORT_FILTERS, this.onImportFilters  ) 
			this.ev.addEv( FilterStack.PASTE, this.onPasteFilters  ) 		
			this.ev.addEv( FilterStack.UPDATED_FILTER_ORDER, this.onUpdateFilterOrder  ) 						
			
			this.ev.addEv( FilterStack.ADD_FILTER , this.onAddFilter2 ) 
			
			this.ev.addEv( FilterStackItemRenderer.MOVE_UP, this.onMoveUp ) 
			this.ev.addEv( FilterStackItemRenderer.MOVE_DOWN, this.onMoveDown ) 				
			this.ev.addEv( FilterStackItemRenderer.DELETE, this.onDelete  ) 
			this.ev.addEv( FilterStackItemRenderer.CHANGED_FILTER_FROM_RENDERER, this.onChangedFilterFromRenderer  ) 
			this.ev.addEv( FilterStackItemRenderer.COPY_FILTER, this.onCopyFilter  ) 
			
			this.ev.addEv( FilterStack.EXPORT_FILTERS, this.onExport  ) 
			
			
			
			this.moveables.arr = this.model.filters; 	
			this.styler = new StyleConfigurator(); 
			this.styler.init( this.ui, this.model.config ); //, this.updateStyles  ); 
			/*
			if ( this.model.stories.length > 0 ) 
			this.onLoadOdbs(null); */
			var ee : Array = this.model.filters.toArray(); 
			this.ui.listx.dataProvider = this.model.filters; 
			
		}
		
		private function onTargetChanged(e:RSModelEvent):void
		{
			this.ui.listx.dataProvider = this.model.filters; 
		}
		
		public function onAddFilter2(e:Event):void
		{
			this.ui.currentState = 'new'; 
		}
		
		private function onAddGlow(e:Event):void
		{
			var f : FilterVO = new FilterVO()
			f.filter =  new   GlowFilter()
			this.onAddFilter(f); 
		}
		
		private function onAddDropShadow(e:Event):void
		{
			var f : FilterVO = new FilterVO()
			f.filter =  new DropShadowFilter(); 
			this.onAddFilter(f); 
		}
		
		private function onAddBlur(e:Event):void
		{
			var f : FilterVO = new FilterVO()
			f.filter = new BlurFilter()
			this.onAddFilter(f); 
		}
		private function onAddFilter_M(e: RSModelEvent):void
		{
			this.onAddFilter( e.data as FilterVO ) ; 
		}
		private function onImportFilters(e:Event):void
		{
			this.ui.txtPaste.visible = true; 
			this.ui.txtPaste.setFocus(); 
			this.ui.txtPaste.selectRange(0,0)
		}
		
		private function onPasteFilters(e:Event):void
		{
			this.ui.txtPaste.visible = false; 
			var junk :  String = this.ui.txtPaste.text; 
			this.dispatch( new ConvertFiltersCommandTriggerEvent(ConvertFiltersCommandTriggerEvent.IMPORT_CONFIG, junk))
		}
		private function onChangeFilter(ev: CustomEvent):void
		{
			// TODO Auto Generated method stub
			var e : FilterVO = ev.data as FilterVO
			this.model.currentFilter = e; 
			this.dispatch( new RSModelEvent( RSModelEvent.EDIT_FILTER) ) 
			this.ui.currentState = 'view'; 
		}
		
		private function onAddFilter(e: FilterVO):void
		{
			this.model.filters.addItem( e); 
			this.model.currentFilter = e; 
			if ( e.name == '' ) e.name = 'new'; 
			this.dispatch( new RSModelEvent( RSModelEvent.EDIT_FILTER) ) 
			this.ui.currentState = 'view'; 
			
			this.updateFilterProperies()
		}
		private function onCloseEditFilter(e:  Event):void
		{
			this.ui.currentState = ''; 
		}
		private function updateFilterProperies(e: Object=null):void
		{
			//this.model.target.ui.filters = this.model.filterObjs()
			this.model.target.loadFilters( this.model.filters.toArray() ) ; 
		}
		
		
		public function onMoveUp(e:CustomEvent ):void
		{
			if ( this.moveables.trypToMoveUp( e.data, this.model.filters )  ) 
				this.updateFilterProperies(); 
		}
		
		public function onMoveDown(e:CustomEvent ):void
		{
			if ( this.moveables.trypToMoveDown( e.data, this.model.filters )  ) 
				this.updateFilterProperies(); 
		}
		
		public function onDelete(e:CustomEvent ):void
		{
			this.onExport()
			if ( this.moveables.trypToRemove( e.data, this.model.filters )  ) 
				this.updateFilterProperies(); 
		}	
		
		public function onChangedFilterFromRenderer(e:CustomEvent ):void
		{
			this.updateFilterProperies(); 
		}				
		public function onCopyFilter(e:CustomEvent ):void
		{
			var f : FilterVO = e.data as FilterVO; 
			var clone : FilterVO = f.clone(); 
			var index : int = this.model.filters.getItemIndex( f ) ; 
			this.model.filters.addItemAt( clone, index+1 ) ; 
			this.updateFilterProperies(); 
		}				
		
		public function onUpdateFilterOrder(e:Event):void{
			this.updateFilterProperies(); 
		}
		public function onExport(e:Object=null):void
		{
			trace('b4 destructive delete'); 
			this.dispatch( new ConvertFiltersCommandTriggerEvent(
				ConvertFiltersCommandTriggerEvent.EXPORT_CONFIG, 
				this.model.filters.toArray()))
			trace(); 
		}
		
	}
}