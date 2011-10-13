package   org.syncon.RosettaStone.view.edit.lesson
{
	import flash.events.Event;
	import flash.net.FileReference;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon.RosettaStone.vo.LessonVO;
	import org.syncon.popups.controller.HidePopupEvent;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class LessonViewerBulkMediator extends Mediator  
	{
		[Inject] public var ui :   LessonViewerBulk;
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
			
			this.ui.addEventListener(  LessonViewerBulk.SEARCH_CHANGED, this.onSearchChanged ) ; 
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_ITEM_CHANGED, 
				this.onLessonItemChanged);	
			this.onLessonItemChanged( null )		
				
			this.ui.addEventListener(  LessonViewerBulk.SAVE, this.onSave ) ; 
		}
		
		public function onSave( e : CustomEvent ) : void
		{
			this.model.saveLesson(); 
		}	
		
		private function onLessonItemChanged(param0:Object):void
		{
			if ( null == this.model.currentLessonItem ) 
				return; 
			if ( this.ui.chkSearch.selected ) 
			{
				if ( this.model.currentLessonItem.itemRendererEdit == null ) 
					return; 
				//only open if already open ... 
				this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
					'PopupSearchWord', [this.model.currentLessonItem.itemRendererEdit],'goTo') ) ;
			}
		}
		
		
		protected function onSearchChanged(event:Event):void
		{
			if ( this.ui.chkSearch.selected ) 
			{
				this.dispatch( new HidePopupEvent(HidePopupEvent.HIDE_POPUP, 'PopupSearchWord' ) )
			}
			else
			{
				this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
					'PopupSearchWord', [this.model.currentLessonItem.itemRendererEdit],'goTo') ) ; 
			}
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