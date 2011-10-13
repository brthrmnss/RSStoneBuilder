package org.syncon.RosettaStone.controller
{
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.utils.IAirOnlyFeatures;
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon.RosettaStone.vo.LessonVO;
	import org.syncon2.utils.MakeVOs;
	
	/**
	 *
	 * */
	public class InitMainContextCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:InitMainContextCommandTriggerEvent;
		
		/**
		 * All uses constants
		 * */
		static public var AirFeaturesClass : Class ; 
		static public var airFeatures : IAirOnlyFeatures; 
		
		override public function execute():void
		{
			if ( event.type == InitMainContextCommandTriggerEvent.INIT ) 
			{
				this.model.showAds = event.showAds
				this.model.flex = event.flex; 
				
				if ( this.model.flex == false ) 
				{
				/*	airFeatures = new AirFeaturesClass()*/
				/*	airFeatures.disableKeyLock(); */
				}
			}
			if ( event.type == InitMainContextCommandTriggerEvent.INIT2 ) 
			{
				if ( this.model.flex == false ) 
				{
					/*AirFeaturesClass['stage'] = this.contextView.stage*/
					//airFeatures.goIntoFullscreenMode(); 
				}
			}	
		/*	if ( event.type == InitMainContextCommandTriggerEvent.SET_MULTIPLER ) 
			{
				if ( this.model.flex == false ) 
				{
					this.model.multipler = event.data as Number
				}
			}	*/
			
			if ( event.type == InitMainContextCommandTriggerEvent.INIT3_MAKEUP_FLEX_DATA ) 
			{
				if ( this.model.flex ) 
				{
					var l :  Array = [] ; 
					l = MakeVOs.makeObjs(['L1', 'L2'], LessonVO, 'name' )
					var lp : LessonGroupVO = new LessonGroupVO(); 
					lp.lessons = new ArrayCollection( l ) ; 
					//this.model.loadLessons( l ); 
					
					var firstLesson : LessonVO = lp.lessons.getItemAt( 0 ) as LessonVO
					l =  MakeVOs.makeObjs(['Ls1', 'Ls2', 'Ls3'], LessonSetVO, 'name' )
					firstLesson.sets = new ArrayCollection( l ) ; 
					
					var set : LessonSetVO = firstLesson.sets.getItemAt( 0 ) as LessonSetVO
					l =  MakeVOs.makeObjs(['dog', '2', '3','4'], LessonItemVO, 'name' )
					set.items = new ArrayCollection( l ) ; 					
					
					this.model.currentLessonPlan =  lp ; 
				}
			}	
			
			if ( event.type == InitMainContextCommandTriggerEvent.EXIT_APP ) 
			{
				if ( this.model.flex == false ) 
				{
					if ( airFeatures == null ) airFeatures = new AirFeaturesClass()
					airFeatures.exitApp()
				}
			}
			
			
		}
		
		
		
		
		
	}
}