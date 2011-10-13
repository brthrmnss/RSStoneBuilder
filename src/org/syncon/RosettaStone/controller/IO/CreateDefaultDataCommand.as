package org.syncon.RosettaStone.controller.IO
{
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon.RosettaStone.vo.LessonVO;
	import org.syncon2.utils.MakeVOs;
	
	
	public class CreateDefaultDataCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:CreateDefaultDataTriggerEvent;
		
		override public function execute():void
		{
			if ( event.type == CreateDefaultDataTriggerEvent.CREATE ) 
			{
				this.createDeafultLessonPlan()
			}				
		}
		
		private function createDeafultLessonPlan():void
		{
			
			
			if ( event.config is LessonGroupVO )
			{
				var lp : LessonGroupVO = event.config as LessonGroupVO
					
				var l :  Array = [] ; 
				l = MakeVOs.makeObjs(['L1', 'L2'], LessonVO, 'name' )
				
				
				lp.name = 'Default Lesson Plan'; 
				lp.desc = 'desc'; 
				lp.lessons = new ArrayCollection( l ) ; 
				//this.model.loadLessons( l ); 
				var firstLesson : LessonVO = lp.lessons.getItemAt( 0 ) as LessonVO
			}
			//this code is wrong ... fix i blieve
			if ( event.config is LessonVO ) 
			{
				firstLesson = event.config as LessonVO
			}
			if ( firstLesson != null ) 
			{
				l =  MakeVOs.makeObjs(['Ls1', 'Ls2', 'Ls3'], LessonSetVO, 'name' )
				firstLesson.sets = new ArrayCollection( l ) ; 
				var set : LessonSetVO = firstLesson.sets.getItemAt( 0 ) as LessonSetVO
			}

			if ( event.config is LessonSetVO ) 
			{
				set =  event.config as LessonSetVO
			}
			
			l =  MakeVOs.makeObjs(['dog', '2', '3','4'], LessonItemVO, 'name' )
			set.items = new ArrayCollection( l ) ; 					
			
			//this.model.currentLessonPlan =  lp ; 
		}		
		
		
	}
}