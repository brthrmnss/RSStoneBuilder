package   org.syncon.RosettaStone
{
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.mvcs.Context;
	import org.syncon.RosettaStone.view.popup.*;
	import org.syncon.RosettaStone.view.popup.default_popups.PopupMessage;
	import org.syncon.popups.controller.*;
	import org.syncon.popups.controller.default_commands.*;
	import org.syncon.popups.model.PopupModel;
	import org.syncon.popups.view.popups.default_popups.*;
	import org.syncon2.utils.SubContext;

	/*
	import sss2.Onenote.views.OnenotePage.view.popups.PopupDragListerMediator;
	import sss2.Onenote.views.OnenotePage.view.popups.PopupFloatingCellAdjusterMediator;
	import sss2.Onenote.views.OnenotePage.view.popups.popup_drag_listerV2;
	import sss2.Onenote.views.OnenotePage.view.popups.popup_floating_cell_adjusterV2;
	*/
	public class ContextNightStand_PopupContext  extends  SubContext
	{
		
		public function ContextNightStand_PopupContext()
		{
			super();
		}
 
		
		override public function startup():void
		{
			// Model
			// Controller
			// Services
			// View
			
			this.startupPopupSubContext()
				
				this.customContext(); 
		}
		
		public function startupPopupSubContext()  : void
		{
			// Model
			injector.mapSingleton( PopupModel  )		
			// Controller
			//commandMap.mapEvent(StockPricePopupEvent.CREATE_POPUP, CreateStockPricePopupCommand, StockPricePopupEvent);	
			commandMap.mapEvent(CreatePopupEvent.REGISTER_AND_CREATE_POPUP, CreatePopupCommand, CreatePopupEvent);		
			commandMap.mapEvent(CreatePopupEvent.REGISTER_POPUP, CreatePopupCommand, CreatePopupEvent);			
			commandMap.mapEvent(RemovePopupEvent.REMOVE_POPUP, RemovePopupCommand, RemovePopupEvent);			
			commandMap.mapEvent(ShowPopupEvent.SHOW_POPUP, ShowPopupCommand, ShowPopupEvent);			
			commandMap.mapEvent(HidePopupEvent.HIDE_POPUP, HidePopupCommand, HidePopupEvent);			
			
			//default popups
			commandMap.mapEvent(ShowConfirmDialogTriggerEvent.SHOW_CONFIRM_DIALOG_POPUP, ShowConfirmDialogCommand, ShowConfirmDialogTriggerEvent);			
			commandMap.mapEvent(ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, ShowAlertMessageCommand, ShowAlertMessageTriggerEvent);				
			
			commandMap.mapEvent(AddKeyboardShortcutToOpenPopupEvent.ADD_KEYBOARD_SHORTCUTS, AddPopupsKeyboardShortcutsCommand, AddKeyboardShortcutToOpenPopupEvent);	
			commandMap.mapEvent(AddKeyboardShortcutToOpenPopupEvent.ENABLE_KEYBOARD_SHORTCUTS, AddPopupsKeyboardShortcutsCommand);				
			
			 
			// View
			mediatorMap.mapView( popup_modal_bg , PopupModalMediator , null, true, true );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP,  popup_modal_bg, 'popup_modal_bg', true ) );
			this._this.dispatchEvent( new CreatePopupEvent( 
			CreatePopupEvent.REGISTER_POPUP, 
			PopupMessage, 'popup_alert' ) );
			//org.syncon.evernote.basic.view.popup.default_popups.popup_message
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, 
			popup_confirm, 'popup_confirm' ) );			
			//org.syncon.evernote.basic.view.popup.default_popups.popup_confirm
			this._this.dispatchEvent( new AddKeyboardShortcutToOpenPopupEvent( AddKeyboardShortcutToOpenPopupEvent.ENABLE_KEYBOARD_SHORTCUTS  ) );
			this._this.dispatchEvent( new AddKeyboardShortcutToOpenPopupEvent( AddKeyboardShortcutToOpenPopupEvent.ADD_KEYBOARD_SHORTCUTS, 
			'popup3', 89 ) ); //ctrl+Y	
		}
		
		/**
		 * Add your custom popups here
		 * */
		public function customContext() : void
		{
		/*	mediatorMap.mapView( popup_floating_cell_adjusterV2 , PopupFloatingCellAdjusterMediator, null, false, false );	
			var contextView : Object = this._this_.contextView as Object
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				popup_floating_cell_adjusterV2, 'popup_floating_cell_adjuster', false, false,false, 
				contextView.workspace, false
				   ) );*/
			/*this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				popup_floating_cell_adjusterV2, 'popup_floating_cell_adjuster', false, false 
			) );
				*/		
			mediatorMap.mapView( PopupTextArea , PopupTextAreaMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupTextArea, 'PopupTextArea', true  ) );
						
			mediatorMap.mapView( PopupSelectableList, PopupSelectableListMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupSelectableList, 'PopupSelectableList', true  ) );		
			
			mediatorMap.mapView( PopupRadioList, PopupRadioListMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupRadioList, 'PopupRadioList', true  ) );				
			import org.syncon.RosettaStone.view.popup.rs.*
			mediatorMap.mapView(  PopupSelectionResult,  PopupSelectionResultMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupSelectionResult, 'PopupSelectionResult',false  ) );						
			
				mediatorMap.mapView(  PopupLessonComplete,  PopupLessonCompleteMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupLessonComplete, 'PopupLessonComplete', true  ) );		
			
			mediatorMap.mapView(  PopupUnitComplete,  PopupUnitCompleteMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupUnitComplete, 'PopupUnitComplete', true  ) );	
			
			mediatorMap.mapView(  PopupGroupComplete,  PopupGroupCompleteMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupGroupComplete, 'PopupGroupComplete', true  ) );				
			
			
			mediatorMap.mapView(  PopupSearchWord,  PopupSearchWordMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupSearchWord, 'PopupSearchWord', false  ) );		
			
			mediatorMap.mapView(  PopupUpdateItemsBulk,  PopupUpdateItemsBulkMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupUpdateItemsBulk, 'PopupUpdateItemsBulk', false  ) );	
/*			
			mediatorMap.mapView( PopupSetTime, PopupSetTimeMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupSetTime, 'PopupSetTime', true  ) );			
			
			mediatorMap.mapView( PopupAlarm, PopupAlarmMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupAlarm, 'PopupAlarm', true  ) );				*/		
/*			
			mediatorMap.mapView( PopupPlaySample, PopupPlaySampleMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupPlaySample, 'PopupPlaySample', true  ) );				
			
			
			*/
			 mediatorMap.mapView( PopupSelectOptions, PopupSelectOptionsMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupSelectOptions, 'PopupSelectOptions', true  ) );	 
		/*	
			mediatorMap.mapView( PopupTestVoice, PopupTestVoiceMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupTestVoice, 'PopupTestVoice', true  ) );		*/
			/*
			mediatorMap.mapView( PopupTagForm , PopupTagMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, PopupTagForm, 'popup_tag_form'  ) );
			
			mediatorMap.mapView( PopupNotebookForm , PopupNotebookMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, PopupNotebookForm, 'popup_notebook_form'  ) );			
			
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, PopupExtraOptions, 'utilsExtraOptionsPopup', false ) );
			mediatorMap.mapView( PopupLogin , PopupLoginMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, PopupLogin, 'popup_login', 
			true, false, true) );						
			
			mediatorMap.mapView( PopupLoading , PopupLoadingMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, PopupLoading, 'popup_loading' ) );				
			
			*/
		}
		
		public function onInit()  : void
		{
			return; 
			import flash.utils.setTimeout; 
			// this.contextView.alpha = 0.3
			//setTimeout( this.onInit2 , 2000 ) 
			this._this.dispatchEvent( new ShowPopupEvent( 
				ShowPopupEvent.SHOW_POPUP,  'popup_login' ) );	
		}
		public function onInit2()  : void
		{
			/*import flash.utils.setTimeout; 
			setTimeout( this.onInit2 , 10000 )*/
			this._this.dispatchEvent( new ShowPopupEvent( 
				ShowPopupEvent.SHOW_POPUP,  'popup_login' ) );	
			
		}		
		
		
	}
}