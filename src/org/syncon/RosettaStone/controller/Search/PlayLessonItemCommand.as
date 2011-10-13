package  org.syncon.RosettaStone.controller.Search
{
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon2.utils.data.GoThroughEach;
	
	public class PlayLessonItemCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:PlayLessonItemCommandTriggerEvent;
		public var injections  : Array = ['model', RSModel] 
		public var goThroughEachWordOnServer : GoThroughEach = new GoThroughEach()	
		
		override public function execute():void
		{
			if ( event.type == PlayLessonItemCommandTriggerEvent.PLAY_LESSON_ITEM ) 
			{
				this.playSound()
			}				
		}
		/**
		 * load teh local sound ... for prompts we might load something else 
		 * by setting the event url ...
		 * */
		private function playSound():void
		{
			var sound : String = event.item.sound; 
			if ( event.url != '' && event.url != null ) 
				sound = event.url ; 
			//things like lab retrive.mp3" will cause problems ....
			if  ( sound.indexOf(' ') == -1 ||  sound.split('.').length < 3 )
			{
				var finalUrl : String = event.item.convertSoundToSourceSound(sound)
				if ( finalUrl == '' )
				{
					trace('warning:', 'PlayLessonItemCommand', 'final sond empty'); 
					if ( event.fxResult != null ) 
						this.event.fxResult(); 
					//this.model.set
					return; 
				}
				// TODO Auto Generated method stub
				//this.model.playSound2( event.item.sourceSound , 1, null , this.event.fxResult ) ;
				this.model.playSound2( finalUrl , 1, null , this.event.fxResult ) ;
			}
			else
			{
				//var split : Array = event.item.sound.split( ' ' ) 
				var sounds  : Array  = event.item.getSoundSources(sound); 
				goThroughEachWordOnServer.go( sounds, this.playNextSound, this.onDonePlayingSounds, 20 ) ; 
			}
		}		
		
		private function playNextSound(url : String):void
		{
			if ( url == '' ) 
			{
				this.goThroughEachWordOnServer.next();  
				return; 
			}
			this.model.playSound2( url,1, null, this.goThroughEachWordOnServer.next ) ; 
		}
		
		private function onDonePlayingSounds():void
		{
			if ( this.event.fxResult != null ) 
				this.event.fxResult(); 
		}		
		
		
	}
}