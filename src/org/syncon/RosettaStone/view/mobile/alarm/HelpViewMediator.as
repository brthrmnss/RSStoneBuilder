package  org.syncon.RosettaStone.view.mobile.alarm
{
	//import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.ConfigCommandTriggerEvent;
	import org.syncon.TalkingClock.controller.LoadWidgetCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.view.parts.BackBtn;
	import org.syncon.TalkingClock.vo.IWidgetConfigVO;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.StyleConfigurator;
	
	import spark.events.ViewNavigatorEvent;
	
	public class  HelpViewMediator extends Mediator
	{
		[Inject] public var ui:  HelpView;
		[Inject] public var model :  RSModel;
		private var styler:StyleConfigurator=new  StyleConfigurator();
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		
		private var forcedOpening: Boolean = false 
		
		override public function onRemove():void
		{
			trace('mediator removed'); 
			ev.unmapAll(); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			if ( this.model.showAds == false ) 
			{
				this.ui.scroller.setStyle('bottom', 0 ); 
			}			
			
			ev.init( this.ui ) ; 
			
			ev.addEv(HelpView.GO_BACK, this.onGoBack)
			ev.addEv(HelpView.OK, this.onOk)
			
			ev.addEv(ViewNavigatorEvent.VIEW_ACTIVATE, this.onActivate) 
			this.styler.init( this.ui, this.model.config  );
			ev.addEv( BackBtn.GO_BACK_BTN, this.onGoBack ) ; 	
			this.adjustScreen(); 
		}
		
		private function adjustScreen():void
		{
			return;
			if ( this.model.config.helpShown  == false ) 
			{
				forcedOpening = true; 
				this.ui.btnGoBack.visible = false; 
				this.ui.title = 'Getting Started'
			}
			else
			{
				forcedOpening = false; 
				this.ui.btnGoBack.visible = true; 
				this.ui.title = 'Help'				
			}
		}
		
		protected function onSend(event:Event):void
		{
			
			
			
		}
		
		private function navigateToURL(param0:URLRequest):void
		{
			// TODO Auto Generated method stub
			
		}		
		
		protected function onActivate(event:ViewNavigatorEvent):void
		{
			this.styler.changedCheck( this.model.config ) ; 
			this.adjustScreen() 
		}
		
		private function onGoBack(e:Event):void
		{
			this.dispatch(   NavigateCommandTriggerEvent.popView()    ) 				
		}		
		
		private function onOk(e:Event):void
		{
			this.dispatch(   NavigateCommandTriggerEvent.popView()    ) 	
		}		
		
		
		
	}
}