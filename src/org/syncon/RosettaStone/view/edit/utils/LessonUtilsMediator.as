package org.syncon.RosettaStone.view.edit.utils
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.RSModel;
	
	public class LessonUtilsMediator extends Mediator 
	{
		[Inject] public var ui : LessonUtils;
		[Inject] public var model : RSModel;
		
		override public function onRegister():void
		{
			this.ui.addEventListener( LessonUtils.REMOVE_UNUSED, 
				this.onRemoveUnused);	
			this.ui.addEventListener( LessonUtils.GO4X4, 
				this.onGo4x4);				
		}
		
		private function onRemoveUnused(e: Event): void
		{
		}
		
		private function onGo4x4(e: Event): void
		{
		}
		
		
	}
}