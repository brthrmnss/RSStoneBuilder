package   org.syncon.RosettaStone.controller.Import
{
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.controller.Search.SearchDictionaryTriggerEvent;
	import org.syncon.RosettaStone.controller.Search.SearchImagesTriggerEvent;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon.RosettaStone.vo.LessonVO;
	import org.syncon.RosettaStone.vo.SearchVO;
	import org.syncon2.utils.MakeVOs;
	import org.syncon2.utils.data.GoThroughEach;
	
	
	
	public class ConvertStringToLessonCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:ConvertStringToLessonCommandTriggerEvent;
		private var currentLesson: LessonVO;
		override public function execute():void
		{
			if ( event.type == ConvertStringToLessonCommandTriggerEvent.CONVER_STRING ) 
			{
				if ( event.arr == null ) 
				{
				var input : String = event.input; 
				//clear any new lines or \r ....
				var pattern:RegExp = new RegExp("\r", 'gi' ) 
				input = input.replace( pattern, '' ) ; 
				pattern= new RegExp("\n", 'gi' ) 
				input = input.replace( pattern, '' ) ; 
				
				var arr : Array = event.input.split(event.demarc); 
				//var items : Array = MakeVOs.makeObjs( arr, LessonItemVO, 'name' ) ; 
				}
				else
				{
					arr = event.arr; 		
					}
				this.currentLesson = event.lesson; 
				this.automateItems(arr ) ; 
			}				
		}
		
		public var g :   GoThroughEach = new GoThroughEach()
		private function automateItems(items:Array):void
		{
			newItems= []; 
			g.go( items, importStringToLessonSet, this.onDoneAutomating ) 
		}		

		public var newItems : Array = []; 
		private var currentLessonSet:LessonSetVO;
		public function importStringToLessonSet( txt :  String ) : void
		{
			this.currentLessonSet = new LessonSetVO(); 
			this.currentLessonSet.name = 'L'+this.currentLesson.sets.length.toString(); 
			this.currentLesson.sets.addItem( this.currentLessonSet ) ; 
			this.dispatch( new ConvertStringToItemSetCommandTriggerEvent( 
				ConvertStringToItemSetCommandTriggerEvent.CONVER_STRING, txt, this.currentLessonSet, 
				this.onLessonSetCreated, true, ', ') ) 
		}
		
		public function onLessonSetCreated( ):void
		{
			this.nextItem()
		}
		
		private function nextItem( ):void
		{
			this.g.next(); 
		}
		
		public function onDoneAutomating() : void
		{
			if ( this.event.save ) 
				this.model.saveLesson(); 
			if ( event.fxResult != null ) 
				event.fxResult(); 
		}
		
		
	}
}