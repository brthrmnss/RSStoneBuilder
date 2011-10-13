package  org.syncon.RosettaStone.view.FilterTester
{
	import flash.events.Event;
	import flash.utils.Timer;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.TalkingClock.vo.FilterVO;
	import org.syncon.RosettaStone.vo.StyleConfigurator;
	
	
	
	public class  FilterEditorMediator extends Mediator
	{
		[Inject] public var ui:     FilterEditor ;
		[Inject] public var model :  RSModel;
		private var firstLoad:Boolean=true;
		private var timer:Timer;
		private var timer_Reset:Timer;
		
		private var timer_ShowLoading : Timer; 
		private var styler:StyleConfigurator;
		private var filter:FilterVO;
		
		public function FilterEditorMediator()
		{
		} 
		override public function onRemove():void
		{
			trace('mediator removed'); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			/*if ( this.model.showAds == false ) 
			{
			this.ui.list.setStyle('bottom', 0 ); 
			}	*/		
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.EDIT_FILTER,
				this.onEditFilter);	
			
			this.ui.addEventListener(FilterEditor.UPDATED_FILTER, this.onUpdateFilter, false, 0, true ) ;
			this.ui.addEventListener(FilterEditor.UPDATE_NAME, this.onUpdateFilterName, false, 0, true ) ;
			this.ui.addEventListener(FilterEditor.CLOSE, this.onClose, false, 0, true ) ;
			
			//this.ui.addEventListener(Event.ACTIVATE, this.onActivate, false, 0, true ) ; 
			
			this.styler = new StyleConfigurator(); 
			this.styler.init( this.ui, this.model.config ); //, this.updateStyles  ); 
			/*
			if ( this.model.stories.length > 0 ) 
			this.onLoadOdbs(null); */
			if ( this.model.currentFilter.filter != null ) 
				this.onEditFilter(null);
		}
		
		protected function onUpdateFilterName(event:Event):void
		{
			this.filter.name = this.ui.txtFilterName.text; 
			this.filter.desc = this.ui.txtFilterDesc.text;
			this.filter.notebookUpdated()
		}
		
		protected function onUpdateFilter(event:Event):void
		{
			this.dispatch( new RSModelEvent(RSModelEvent.CHANGED_FILTER_PROPERTIES) ) 
		}
		
		public function onClose(e:Event):void{
			
			this.dispatch( new RSModelEvent(RSModelEvent.CLOSE_EDIT_FILTER) ) 
			
		}
		
		private function onEditFilter(e:Event):void
		{
			this.filter = this.model.currentFilter; 
			this.ui.txtFilterName.text = this.filter.name; 
			this.ui.txtFilterDesc.text = this.filter.desc; 
			if ( this.filter.glow ) 
			{
				
				this.ui.currentState = 'glow'; 
				this.ui.filterGlow.filter = this.filter; 
			}
			if ( this.filter.blur ) 
			{
				
				this.ui.currentState = 'blur'; 
				this.ui.filterBlur.filter = this.filter; 
			}
			if ( this.filter.shadow ) 
			{
				
				this.ui.currentState = 'shadow'; 
				this.ui.filterShadow.filter = this.filter; 
			}			
			
		}
		
	}
}