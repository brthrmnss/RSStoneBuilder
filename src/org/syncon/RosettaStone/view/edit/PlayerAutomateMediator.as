package org.syncon.RosettaStone.view.edit
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.AutomateEvent;
	import org.syncon.RosettaStone.controller.ConfigCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.IO.LoadLessonPlanCommandTriggerEvent;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.LessonResultVO;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon.RosettaStone.vo.LessonVO;
	import org.syncon.popups.controller.HidePopupEvent;
	import org.syncon.popups.controller.ShowPopupEvent;
	import org.syncon2.utils.ArrayListMoveableHelper;
	import org.syncon2.utils.data.GoThroughEach;
	
	public class PlayerAutomateMediator extends Mediator 
	{
		[Inject] public var ui : PlayerAutomate;
		[Inject] public var model : RSModel;
		private var currentLesson: LessonVO;
		private var currentLessonSet: LessonSetVO=new LessonSetVO;
		private var seenItems:Array;
		private var indexSet:int;
		public var injections : Array =  ['model', RSModel] 
		public var timerDelayIntroduction : Timer = new Timer(1000, 1); 
		
		
		public var modes : Array =  [] ; 
		
		/**
		 * falg will hide namesof stuff 
		 * */
		public var option_showPromptOnItemRender : Boolean = false; 
		public var option_introduceItems : Boolean = true 
		public var option_oneShotAnswerAttemps : Boolean = false //why would you want this ? or maybe counting how many times
		public var option_PlaySoundWhenWrongOneClicked : Boolean = false; 
		public var option_MasteryMode : Boolean = false;
		public var option_ShowAnswerFeedback : Boolean = true; 
		public var option_showPromptText : Boolean = true; 
		
		override public function onRegister():void
		{
			/*
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CHANGED_DATE_XML_FILE_DATE, 
			this.onChangedFileDate);		
			*/
			/*eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_LESSON_SET_CHANGED, 
			this.onLessonSetChanged);	
			this.onLessonSetChanged( null ) 
			*/
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_CHANGED, 
				this.onLessonChanged);	
			this.onLessonChanged( null ) 
			
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.SELECTED_LESSON_ITEM_CHANGED, 
				this.onSelectedItemChanged);	
			this.onSelectedItemChanged( null ) 
			
			eventMap.mapListener(eventDispatcher, AutomateEvent.START_LESSON, 
				this.onStartLesson);	
			//this.onStartLesson( null ) 
			
			eventMap.mapListener(eventDispatcher, AutomateEvent.NEXT_LESSON, 
				this.onNextLesson);				
			
			eventMap.mapListener(eventDispatcher, AutomateEvent.PAUSE_LESSON, 
				this.onPauseLesson);				
			
			eventMap.mapListener(eventDispatcher, AutomateEvent.RESUME_LESSON, 
				this.onResumeLesson );				
			
			
			this.ui.addEventListener( PlayerAutomate.RESTART, this.onRestart ) 
			this.ui.addEventListener( PlayerAutomate.NEXT, this.onNextItem ) 				
			
			this.ui.addEventListener( PlayerAutomate.NEXT_SET, this.onSkipToNextSet ) 		
			this.ui.addEventListener( PlayerAutomate.DONE, this.onTestDone ) 		
			this.timerDelayIntroduction.addEventListener(TimerEvent.TIMER, this.onDelayIntroductionComplete , false, 0, true)
			
			
			//this.timer2.addEventListener(TimerEvent.TIMER, this.onTimerComplete ) ; 
			this.timer_DelayIntroducingSetItems.addEventListener(TimerEvent.TIMER, onTimer_DelayIntroducingSetItems_Complete ) 
		}
		
		//probably want overrides for the adove .
		/**
		 * if not automating, do not call 
		 * if introducing, do not allow ocntinue
		 * */
		private function onSelectedItemChanged(e: RSModelEvent): void
		{
			if ( this.model.selectedItem == null ) 
				return; 
			if ( this.model.automating == false ) return; 
			if ( this.modeIntroducing )
			{
				this.gIntroduce.end(); 
				if ( this.timerDelayIntroduction != null ) 
					this.timerDelayIntroduction.stop(); 
				return; 
			}
			var userChoice : LessonItemVO = this.model.selectedItem; 
			this.lastUserChoice = userChoice; 
			this.model.selectedItem = null; //we do this so the Player unselects this item
			if ( userChoice == this.model.currentLessonItem ) 
			{
				
				
				this.model.correctItem()
				this.receipt.currentCorrect(); 
				
				if ( this.option_ShowAnswerFeedback == false ) 
				{
					this.onNextItem(); 
					return; 
				}
				this.model.playCorrect(this.onNextItem); 
				this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
					'PopupSelectionResult', [userChoice.itemRenderer, true],'selectFromList') ) ; 
				
				//this.onNext()
				return; 
			}
			
			this.model.wrongItem()
			this.receipt.currentWrong();
			
			if ( this.option_ShowAnswerFeedback == false ) 
			{
				this.onNextItem(); 
				return; 
			}
			if ( this.option_PlaySoundWhenWrongOneClicked == false ) 
				this.model.playIncorrect(this.onRepeatPrompt); 
			else
				this.model.playIncorrect(this.onRepeatPrompt_RepeatSelection); 
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupSelectionResult', [userChoice.itemRenderer, false],'selectFromList') ) ; 	
			/*
			this.currentLesson = this.model.currentLesson ;
			this.clear()
			*/	
		}		
		
		private function onLessonChanged(e: RSModelEvent): void
		{
			this.closeEndingPopups()
			this.currentLesson = this.model.currentLesson ;
			this.clear()
			
			
			if ( this.ui.autoStart == true &&  this.model.automating == false ) 
			{
				this.onRestart()
			}
		}		
		
		private function closeEndingPopups():void
		{
			this.dispatch( new HidePopupEvent(HidePopupEvent.HIDE_POPUP, 'PopupLessonComplete' ) )
			this.dispatch( new HidePopupEvent(HidePopupEvent.HIDE_POPUP, 'PopupGroupComplete' ))
			this.dispatch( new HidePopupEvent(HidePopupEvent.HIDE_POPUP, 'PopupUnitComplete' ))
		}
		/**
		 * load lesson from event and restart auotating
		 * */
		private function onStartLesson(e: AutomateEvent): void
		{
			this.model.currentLesson = e.lesson; 
			this.currentLesson = this.model.currentLesson ;
			this.onRestart(null) 
		}	
		
		public function onPauseLesson(e:Object):void{
			this.gIntroduce.end()
		}
		/**
		 * on resume, if not started, start it up, if active, then reintroduce the current set 
		 * ... perhabs we should have a 'paused' flag ? 
		 * */
		public function onResumeLesson(e:Object):void{
			if ( this.model.automating ) 
			{
				onNextSet( this.currentLessonSet ) ; 
			}
			else
			{
				this.onRestart()
			}
		}
		
		
		/**
		 * load lesson from event and restart auotating
		 * */
		private function onNextLesson(e: AutomateEvent): void
		{
			this.endAll()
			var nextLesson : LessonVO = ArrayListMoveableHelper.nextAfter( 
				e.lesson, this.model.currentLessonPlan.lessons )  as LessonVO
			
			var nextGroup : LessonGroupVO = ArrayListMoveableHelper.nextAfter( 
				this.model.currentLessonPlan, this.model.currentUnit.groups )  as LessonGroupVO			
			if ( nextLesson == null && nextGroup != null ) 
			{
				//if confirmed, this is fisrt time, tell user lesson-group is complete
				if ( e.confirmed == false  ) 
				{
					this.closeEndingPopups(); 
					this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 'PopupGroupComplete', [], 'done') )
					return ;
				}
				else
				{
					//this.model.currentLessonPlan = nextGroup
					
					this.dispatch( new  LoadLessonPlanCommandTriggerEvent(
						LoadLessonPlanCommandTriggerEvent.LOAD_LESSON_PLAN, nextGroup ,'', loadFirstLessonPlan ) ) ; 
					//load next group and lesson ...
					return
					//set current lesson 
					nextLesson =  ArrayListMoveableHelper.nextAfter( 
						e.lesson, this.model.currentLessonPlan.lessons )  as LessonVO
					//this.onRestart(null) 
					//return;
				}
			}
			
			if ( nextLesson == null && nextGroup == null ) 
			{
				//if confirmed, this is fisrt time, tell user lesson-group is complete
				if ( e.confirmed == false  ) 
				{
					this.closeEndingPopups(); 
					this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 'PopupUnitComplete' , [], 'done'))
					return ;
				}
				else
				{
					//oppu does not send user back here
					return; ///
				}
			}
			
			
			/*		
			
			if ( nextGroup == null ) 
			{
			//unit complete
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 'PopupUnitComplete' , [], 'done')
			
			}
			else
			{
			this.dispatch( new  LoadLessonPlanCommandTriggerEvent(
			LoadLessonPlanCommandTriggerEvent.LOAD_LESSON_PLAN, nextGroup , loadFirstLessonPlan ) ) ; 
			//load next group and lesson ...
			}
			*/
			
			
			
			this.model.currentLesson = nextLesson
			this.currentLesson = this.model.currentLesson ;
			if ( this.ui.autoStart == false ) 
				this.onRestart(null) 
			
		}	
		
		
		public function loadFirstLessonPlan(e:Object=null):void
		{
			this.onRestart();
		}
		
		public var g : GoThroughEach = new GoThroughEach()
		public var gIntroduce : GoThroughEach = new GoThroughEach()
		private var fxDoneIntroducingItems:Function;
		private var modeIntroducing:Boolean;
		private var _receipt:LessonResultVO;
		
		public function get receipt():LessonResultVO
		{
			return _receipt;
		}
		
		public function set receipt(value:LessonResultVO):void
		{
			_receipt = value;
		}
		
		
		protected function onRestart(event:Event=null):void
		{
			if ( this.currentLesson == null ) 
				return; 
			/*if ( this.currentLesson.sets.length == 0 ) 
			return; */
			
			//new function copy settings ( it is here so we can upadte them quickly from lessonvo ) 
			if ( this.currentLesson != null ) 
			{
				option_introduceItems = this.currentLesson.option_introduceItems
				option_PlaySoundWhenWrongOneClicked = this.currentLesson.option_PlaySoundWhenWrongOneClicked
				option_oneShotAnswerAttemps = this.currentLesson.option_oneShotAnswerAttemps
				option_MasteryMode = this.currentLesson.option_MasteryMode	
				option_showPromptOnItemRender = this.currentLesson.option_showPromptOnItemRender; 
				option_showPromptText = this.currentLesson.option_showPromptText; 
				//some override support here ..
			}
			
			this.model.automating = true; 
			this.dispatch( new ConfigCommandTriggerEvent(ConfigCommandTriggerEvent.SAVE_CONFIG) ) 
			this.clear()
			this.receipt = new LessonResultVO; 
			g.go( this.currentLesson.sets.toArray(), onNextSet, this.onDoneAutomatingSets ) 
			this.updateDisplay();
		}
		
		public function onNextSet(o : LessonSetVO ) : void
		{
			this.endIntroductions()
			
			this.currentLessonSet = o ;
			this.model.currentLessonSet = this.currentLessonSet
			this.dispatch( new RSModelEvent (
				RSModelEvent.AUTOMATE_CLEAR 	) ) ; 
			if ( o.items.length == 0 ) 
			{
				this.g.next(); 
				return;
			}
			this.seenItems = []
			this.introduceItems( this.onNextItem ) ; 
			this.updateDisplay(); 
			//this.onNext()
		}
		
		
		public function onDoneAutomatingSets() : void
		{
			this.model.automating = false; 
			//trace('done'); 
			this.dispatch( new HidePopupEvent(HidePopupEvent.HIDE_POPUP, 'PopupSelectionResult' ))
			this.dispatch( new RSModelEvent ( RSModelEvent.AUTOMATING_COMPLETE )) ; 
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 'PopupLessonComplete' ,
				[this.ui, this.receipt, this.currentLesson, this.goToNextLesson], 'done' ))
			this.clear()
		}
		
		
		public var timer_DelayIntroducingSetItems : Timer = new Timer(250,   1 ) ; 
		public var nextFxDone : Function
		private var lastItemIntroduced:LessonItemVO;
		private var lastUserChoice:LessonItemVO;
		public function onTimer_DelayIntroducingSetItems_Complete(e:TimerEvent):void
		{
			this.introduceItems( this.nextFxDone, false ) ; 
		}
		
		private function introduceItems(fxDone:Function, wait  : Boolean = true ):void
		{
			if ( wait ) 
			{
				this.nextFxDone = fxDone
				this.timer_DelayIntroducingSetItems.start()
				return; 
			} 
			timer_DelayIntroducingSetItems.stop(); 
			hideCurrentSetPrompts()
			if ( this.option_introduceItems ) 
			{
				this.modeIntroducing = true; 
				this.fxDoneIntroducingItems = fxDone; 
				gIntroduce.go( this.currentLessonSet.items.toArray(), introduceItem, this.onDoneIntroducingItems )
			}
			else
			{
				this.onDoneIntroducingItems()
				this.onNextItem()
			}
			//	this.updateDisplay();
			
		}
		/*
		public var timer2 : Timer = new Timer(500,   1 ) ; 
		private var nextItem_Delay:LessonItemVO;
		public function onTimerComplete(e:TimerEvent):void
		{
		this.introduceItem( this.nextItem_Delay, false ) ; 
		}
		*/
		public function introduceItem( item : LessonItemVO/*, wait : Boolean = true */) : void
		{
			/*	if ( wait ) 
			{
			PlatformGlobals.show( 'wait', item.name ) ; 
			this.timer2.start()
			this.nextItem_Delay = item
			return; 
			} 
			PlatformGlobals.show( 'here', item.name ) ; 
			this.timer2.stop()
			*/
			//play sound, higlight, 
			//does this work or break ellips?
			/*
			import org.syncon.TalkingClock.model.NightStandConstants;
			NightStandConstants.PlaySound.fxCallAfterSoundCompletePlaying = null; 
			this.model.playSound2( item.sourceSound , 1, null , null) ; 
			NightStandConstants.PlaySound.fxCallAfterSoundCompletePlaying = onIntroduceNextItem; */
			//this.model.playSound2( item.sourceSound , 1, null , onIntroduceNextItem) ; 
			this.model.playLessonItem( item, onIntroduceNextItem) ; 
			this.model.currentHighlightedItem = item; 
			item.promptShow(); 
			if ( this.lastItemIntroduced != null ) 
				this.lastItemIntroduced.promptHide()
			this.lastItemIntroduced = item; 
		}
		protected function onIntroduceNextItem(event:Event=null):void
		{
			//assume it has been cancled, if false ...
			if ( this.modeIntroducing == false ) 
				return; 
			this.timerDelayIntroduction.start(); 
			//this.gIntroduce.next(); 
		}
		private function onDelayIntroductionComplete(e:Event):void
		{
			this.timerDelayIntroduction.stop(); 
			this.gIntroduce.next(); 
		}
		public function onDoneIntroducingItems() : void
		{
			this.modeIntroducing = false; 
			if ( this.option_showPromptOnItemRender  == false ) 
			{
				this.hideCurrentSetPrompts()
				
			}
			//trace('done introducing'); 
			if ( this.fxDoneIntroducingItems != null ) 
				this.fxDoneIntroducingItems(); 
		}
		
		protected function onNextItem(event:Event=null):void
		{
			if ( this.model.automating == false ) 
				return;
			this.receipt.newItem(); 
			this.dispatch( new HidePopupEvent(HidePopupEvent.HIDE_POPUP, 'PopupSelectionResult' ))
			this.dispatch( new RSModelEvent ( 	RSModelEvent.AUTOMATE_CLEAR 	) ) ; 
			if ( this.seenItems.length == this.currentLessonSet.items.length ) 
			{
				this.g.next(); 
				return; 
			}
			
			//this.dispatch( new HidePopupEvent(HidePopupEvent.HIDE_POPUP, 'PopupSelectionResult' ))
			
			var item : LessonItemVO = this.currentLessonSet.getRandom( this.seenItems ) ; 
			this.seenItems.push( item ) ; 
			this.model.currentLessonItem = item;
			//this.model.playSound2( item.sourceSound ) ; 
			this.model.playLessonItem( item ) ; 
			this.updateDisplay()
		}
		
		public function onSkipToNextSet(event:Event=null):void
		{
			this.endIntroductions()
			this.g.next(); 
		}
		public function onTestDone(event:Event=null):void
		{
			if ( this.receipt == null ) 
				return; 
			for ( var i : int = 0 ; i < 15; i++ )
			{
				this.receipt.newItem()
				if ( Math.random() < .5 ) 
					this.receipt.currentCorrect();
				else
					this.receipt.currentWrong()
			}
			
			this.g.end(); 
		}
		
		protected function onRepeatPrompt(event:Event=null):void
		{
			if ( this.model.automating == false ) 
				return;
			
			
			this.dispatch( new HidePopupEvent(HidePopupEvent.HIDE_POPUP, 'PopupSelectionResult' ))
			if ( this.option_oneShotAnswerAttemps ) 
			{
				this.onNextItem();
				return; 
			}
			this.model.( this.model.currentLessonItem ) ; 
			//this.model.playSound2( this.model.currentLessonItem.sourceSound ) ; 
		}
		
		protected function onRepeatPrompt_RepeatSelection(event:Event=null):void
		{
			if ( this.model.automating == false ) 
				return;
			this.model.playLessonItem( this.lastUserChoice, onRepeatPrompt ) ; 
			//this.model.playSound2(  this.lastUserChoice.sourceSound, 1, null, onRepeatPrompt ) ; 
		}
		
		
		private function updateDisplay():void
		{
			this.ui.txtCurrentSet.text =(this.g.index+1).toString()
			this.indexSet =this.g.index
			this.ui.txtSetCount.text = this.currentLesson.sets.length.toString(); 
			
			this.ui.txtCurrentItem.text =( this.seenItems.length ).toString()
			
			this.ui.txtItemCount.text = this.currentLessonSet.items.length.toString()
			
			/*
			this.ui.txtCurrentSetIndex.text = this.
			this.ui.txtCurrentSetCount.text = '0'; */
		}
		
		protected function clear( ):void
		{
			this.ui.txtLesson.text = '';//this.currentLesson.name;
			this.ui.txtCurrentSet.text = "0"
			this.indexSet = 0 ; 
			this.ui.txtSetCount.text ='0'; // this.currentLesson.sets.length.toString()
			this.ui.txtCurrentItem.text ="0"
			this.seenItems = []
			this.ui.txtItemCount.text = '0';//this.currentLessonSet.items.length.toString()
			
			/*
			this.ui.txtCurrentSetIndex.text ="0"
			this.ui.txtCurrentSetCount.text = '0'; 
			*/
		}
		
		
		public function endAll() : void
		{
			this.g.end(); 
			this.endIntroductions()
		}
		
		private function endIntroductions():void
		{
			this.gIntroduce.end(); 
			if ( this.timerDelayIntroduction != null ) 
				this.timerDelayIntroduction.stop(); 
			return; 
		}
		public function goToNextLesson() : void
		{
			
		}
		
		
		
		private function hideCurrentSetPrompts():void
		{
			for ( var i : int = 0 ; i < this.currentLessonSet.items.length; i++ )
			{
				var item : LessonItemVO = this.currentLessonSet.items.getItemAt( i ) as LessonItemVO
				item.promptHide(); 	
			}
		}		
		
		
	}
}