package   org.syncon.RosettaStone.view.edit
{
	import flash.net.FileReference;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon.RosettaStone.vo.LessonVO;
	
	public class LessonViewerMediator extends Mediator  
	{
		[Inject] public var ui :  LessonViewer;
		[Inject] public var model : RSModel;
		
		override public function onRegister():void
		{
		 /*
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CHANGED_DATE_XML_FILE_DATE, 
			this.onChangedFileDate);		
			*/
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_CHANGED, 
			this.onLessonChanged);	
			this.onLessonChanged( null ) 
	 
		}
		 
		private function onLessonChanged(e: RSModelEvent): void
		{
			var lesson : LessonVO = this.model.currentLesson
			if ( lesson != null ) 
			{
				var dp : ArrayCollection =lesson.sets 
			}
			else
				dp = new ArrayCollection(); 			
			this.ui.data = this.model.currentLesson 
		}		
		
 
		
	 
		
	}
}