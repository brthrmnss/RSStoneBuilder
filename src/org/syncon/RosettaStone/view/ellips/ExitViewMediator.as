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
	
	
	public class ExitViewMediator extends Mediator
	{
		[Inject] public var ui: ExitView;
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
			ev.init( this.ui ) ; 
			
			this.styler = new StyleConfigurator(); 
			//this.styler.init( this.ui, this.model.config, this.updateStyles ); 
			
			this.ev.addEv( ExitView.EXIT, this.onExit ) 
			this.ev.addEv( ExitView.HOME, this.onHome ) 
		}
		
		
		private function onHome(e:Object):void
		{
			this.dispatch( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.home ) ) ; 
			//this.dispatch( NavigateCommandTriggerEvent.pushView( GroupSelectView)  ) 				
		}
		private function onExit(param0:Object):void
		{
			if ( this.contextView.hasOwnProperty('exit')  ) 
				this.contextView['exit'](); 
			//this.dispatch( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.SELECT_PACKAGE ) ) ; 
		}
		
		
	}
}