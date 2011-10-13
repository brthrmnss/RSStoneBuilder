package  org.syncon.RosettaStone.view.mobile
{
	//import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.ConfigCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.NightStandConfigVO;
	import org.syncon.RosettaStone.vo.StyleConfigurator;
	
	import spark.events.ViewNavigatorEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class  InfoViewMediator extends Mediator
	{
		[Inject] public var ui:  InfoView;
		[Inject] public var model :  RSModel;
		private var styler:StyleConfigurator=new  StyleConfigurator();
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		public function InfoViewMediator()
		{
			
		}
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
			
			ev.addEv(InfoView.GO_BACK, this.onGoBack)
			ev.addEv(InfoView.SEND, this.onSend)
			
			ev.addEv(ViewNavigatorEvent.VIEW_ACTIVATE, this.onActivate) 
			this.styler.init( this.ui, this.model.config  );
		}
		
		protected function onSend(event:Event):void
		{
			var urlString:String = "mailto:";
			urlString += 'info.sync.con@gmail.com'
			urlString += "?subject="
			urlString += 'Comment on clock thing'
			//urlString += "&body=";
			//urlString += body.text;
			navigateToURL(new URLRequest(urlString));
		}
		
		protected function onActivate(event:ViewNavigatorEvent):void
		{
			this.styler.changedCheck( this.model.config ) ; 
		}
		
		private function onGoBack(e:Event):void
		{
			this.dispatch(   NavigateCommandTriggerEvent.popView()    ) 				
		}		
		
 
		
	}
}