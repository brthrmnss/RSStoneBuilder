package  org.syncon.RosettaStone.view.FilterTester
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.utils.FilterHelpers;
	import org.syncon.TalkingClock.vo.FilterVO;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.StyleConfigurator;
	import org.syncon2.utils.ButtonBarHelper;
	
	
	
	public class  FilterNewMediator extends Mediator
	{
		[Inject] public var ui:     FilterNewSelection;
		[Inject] public var model :  RSModel;
		
		public static const Outline : String = 'outline' ; 
		
		private var styler:StyleConfigurator;
		public var ev : LazyEventHandler = new LazyEventHandler()

		override public function onRemove():void
		{
			trace('mediator removed'); 
			super.onRemove()
		}
		
		public var buttons :  ButtonBarHelper = new ButtonBarHelper(); 
		
		override public function onRegister():void
		{
			this.ev.init( this.ui ) ; 
			
			this.buttons.load_Strings( [
				['Outline', Outline]
				
			],this.ui.holder, this.onAdd ) 
		}
		
		private function onAdd(type : String ):void
		{
			if ( type == Outline ) 
			{
				var ee : FilterHelpers
				var f : FilterVO = new FilterVO()
				f.filter = FilterHelpers.addOutline( null, 0xFFFFFF ) ;
				f.name = 'new outline'
			}
			if ( f != null ) 
				this.dispatch( new  RSModelEvent(RSModelEvent.ADD_FILTER, f) )
			else
			{
				trace('onAdd', 'could not create', type )
			}
		}
		
		
	}
}