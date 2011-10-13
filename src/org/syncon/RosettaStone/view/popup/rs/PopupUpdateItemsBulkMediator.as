package  	org.syncon.RosettaStone.view.popup.rs 
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.AutomateEvent;
	import org.syncon.RosettaStone.controller.Import.UpdateLessonItemCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.Places;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon2.utils.data.GoThroughEach;
	
	import spark.components.CheckBox;
	
	public class  PopupUpdateItemsBulkMediator extends Mediator
	{
		[Inject] public var ui:PopupUpdateItemsBulk;
		[Inject] public var model : RSModel;
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		
		override public function onRemove():void
		{
			ev.unmapAll(); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			ev.init( this.ui ) ; 
			this.ev.addEv(PopupUpdateItemsBulk.CANCEL, this.onCancel )
			this.ev.addEv(PopupUpdateItemsBulk.SETUP, this.onSetup ) ; 
			
			this.ev.addEv(PopupUpdateItemsBulk.REPEAT, this.onRepeat )
			this.ev.addEv(PopupUpdateItemsBulk.NEXT_LESSON, this.onNext ) ; 
			this.ev.addEv(PopupUpdateItemsBulk.GO_HOME, this.noHome )
			
			this.ev.addEv(PopupUpdateItemsBulk.START_OP, this.onStart ) ; 
			this.ev.addEv(PopupUpdateItemsBulk.STOP_OP, this.onStop )
			/*
			this.mediatorMap.createMediator( this.ui.searchDictionary ) ; 
			this.mediatorMap.createMediator( this.ui.searchPic ) ; 
			this.mediatorMap.createMediator( this.ui.searchSounds ) ;*/ 				
		}
		
		private function onStop(e:Event):void
		{
			// TODO Auto Generated method stub
			this.active = false ; 
		}
		
		public var goThroughAllSelectedItems : GoThroughEach = new GoThroughEach(); 
		public var goDownloadAllOptions : GoThroughEach = new GoThroughEach(); 
		private var _active:Boolean;
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function set active(value:Boolean):void
		{
			_active = value;
			this.ui.txtActive.text = 'Active: ' + value.toString()
			/*if ( value == false ) 	
			this.checkForFile.stop()*/
		}
		
		private function onStart(e:Event):void
		{
			this.active = true; 
			// TODO Auto Generated method stub
			this.goThroughAllSelectedItems.go( this.ui.list.dataProvider.toArray(), this.onNextLessonItem, this.lessonItemsDone ) 	
		}		
		
		public function collectOptions () : Array
		{
			var fields : Array = [this.ui.chkAudio, this.ui.chkDefinition, this.ui.chkPic, this.ui.chkPronounce, this.ui.chkMovie] 
			var fields2 : Array = [UpdateLessonItemCommandTriggerEvent.AUDIO, 
				UpdateLessonItemCommandTriggerEvent.DICTIONARY, 
				UpdateLessonItemCommandTriggerEvent.PIC, 
				UpdateLessonItemCommandTriggerEvent.PRONUNCIATION,
				UpdateLessonItemCommandTriggerEvent.VIDEO]
			var arr : Array = [] 
			for  ( var i : int = 0 ; i < fields.length; i++ ) 
			{
				var chk : CheckBox  = fields[i] as CheckBox; 
				if ( chk.selected ) 
				{
					arr.push( fields2[i] ) 
				}
			}
			
			
			return arr; 
		}
		
		private function lessonItemsDone( ):void
		{
			// TODO Auto Generated method stub
			this.active = false; 
		}
		
		private var goThroughAllTypes : GoThroughEach = new GoThroughEach(); 
		private var currentItem:LessonItemVO;
		 
		private function onNextLessonItem(i : LessonItemVO):void
		{
			this.currentItem = i; 
			this.goThroughAllTypes.go( this.collectOptions(), this.onProcessUpdate, this.onProcesingItemUpdateDone,1000 ) 	
			return;//
		}		
		
		
		private function onProcessUpdate( action : String ):void
		{
			this.dispatch( new UpdateLessonItemCommandTriggerEvent
				(UpdateLessonItemCommandTriggerEvent.UPDATE_ITEM, '',
					this.currentItem, this.goThroughAllSelectedItems.next, action, 
				true, '', this.ui.txtQueryPre.text ) ) ; 
			return;//
		}		
		
		private function onProcesingItemUpdateDone( ):void
		{
			this.goThroughAllSelectedItems.next(); 
		}		
		
		private function downloadAudio():void
		{
			// this.server.downloadVideo( video_id , this.onFileToLookFor ) 
			//this.server2.downloadVideo( video_id, this.onDownloadedVideo, true ) 
		}		
		//server should hold on return 
		/*		private function onFileToLookFor(string : String):void
		{
		this.checkForFile.start( this.server.readFile, this.onReadMovieFile, 10*1000 )
		}		
		private function onReadMovieFile(e:Object) : void
		{
		this.server2.
		}*/
		
		protected function onRepeat(event:Event=null):void
		{
			this.dispatch( new AutomateEvent(AutomateEvent.START_LESSON, this.ui.lesson )) 
			this.ui.hide(); 
		}
		
		protected function onNext(event:Event=null):void
		{
			this.dispatch( new AutomateEvent(AutomateEvent.NEXT_LESSON, this.ui.lesson, true )) 
			//this.dispatchEvent( new Event( NEXT_LESSON ) )  
			this.ui.hide(); 
		}
		
		protected function noHome(event:Event=null):void
		{
			this.dispatch( new NavigateCommandTriggerEvent(NavigateCommandTriggerEvent.PUSH, 
				Places.HOME	) ) ; 
			this.ui.hide(); 
		}		
		
		protected function onSetup(event:Event):void
		{
			this.ui.list.dataProvider = new ArrayCollection( this.ui.args[1] ) ; 
			//this.ui.txtLessonName.text = this.model.currentLessonPlan.name; 
			if ( this.model.currentPromptDefinition == null ) 
			{
				this.ui.txtCurrentPrompt.text = '' 
			}
			else
				this.ui.txtCurrentPrompt.text = this.model.currentPromptDefinition.name; 
		}
		
		private function onCancel(e:Event) : void
		{
			this.ui.hide();
		}				
		
		
	}
}