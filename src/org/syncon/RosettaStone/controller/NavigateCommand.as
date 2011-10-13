package   org.syncon.RosettaStone.controller
{
	
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.RSModel;
	
	import spark.filters.BlurFilter;
	import spark.filters.DropShadowFilter;
	import spark.filters.GlowFilter;
	
	public class NavigateCommand extends Command
	{
		[Inject] public var model:RSModel
		[Inject] public var event:NavigateCommandTriggerEvent;
		
		static public var airMode : Boolean = false;  
		static public var nav : Object; 
		
		override public function execute():void
		{
			/*			if ( airMode ) 
			{
			this.execute_Air(); 
			}*/
			if ( event.ui is String ) 
			{
				event.ui = placesDict[event.ui]
			}
			if ( event.type == NavigateCommandTriggerEvent.PUSH ) 
			{
				if ( airMode ) 
				{
					nav.pushView( event.ui ,event.data) ; 
				}
				else
				{
					nav.pushView( event.ui ,event.data) ; 
				}
			}
			if ( event.type == NavigateCommandTriggerEvent.POP ) 
			{
				if ( airMode ) 
				{
					nav.popView();// ( event.ui ) ; 
				}
				else
				{
					nav.popView(  ) ; 
				}
			}		
			if ( event.type == NavigateCommandTriggerEvent.CACHE ) 
			{
				if ( airMode ) 
				{
					nav.inject(  event.ui ) ; 
				}
				else
				{
					nav.inject(  event.ui ) ; 
				}
			}					
			
			
		}
		
		private function execute_Air():void
		{
			// TODO Auto Generated method stub
			
		}
		
		static public var placesDict :  Dictionary = new Dictionary(true); 
	}
}