package  org.syncon.RosettaStone.model
{
	import flash.events.Event;
	
	public class RSModelEvent extends Event
	{
		public static const EVERNOTE_API_MODEL_READY:String = 'ready';		
		public static const NOTES_RESULT:String = 'notesRecieved';
		public static const AUTOMATING_CHANGED:String = 'AUTOMATING_CHANGED';	
		/**
		 * Sent when config loads in lesson from config file 
		 * */
		public static const LOADED_LAST_LESSON:String = 'LOADED_LAST_LESSON';		
		
		public static const CHANGED_FILTER_PROPERTIES : String = 'CHANGED_FILTER_PROPERTIES';
		//public static const NOTEBOOK_RESULT : String = 'notebookResult';
		//public static const STORIES_CHANGED : String = 'STORIES_CHANGED';
		public static const LOADED_ODB : String = 'LOADED_ODB.Sinlge';	
		public static const LOADED_ODBS : String = 'LOADED_ODB';			
		public static const LOAD_ODBS_FAULT : String = 'LOAD_ODBS_FAULT';				
		
		public static const CONFIG_CHANGED : String = 'RS_CONFIG_CHANGED';		
		public static const WIDGET_CONFIG_UPDATED : String = 'WIDGET_CONFIG_UPDATED';				
		
		public static const WIDGET_CONFIG_CHANGED  : String = 'WIDGET_CONFIG_CHANGED'; 
		public static const SOUNDS_CHANGED : String = 'SOUNDS_CHANGED' ; 
		
		public static const MULTIPLER_CHANGED : String = 'MULTIPLER_CHANGED';		
		public static const ORIENTATION_CHANGED : String = 'ORIENTATION_CHANGED';		
		
		public static const MUTE_CHANGED : String = 'MUTE_CHANGED';
		
		public static const DEBUG_MODE_CHANGED : String = 'DEBUG_MODE_CHANGED';
		
		public static const CORRECT_ITEM : String = 'CORRECT_ITEM';
		public static const WRONG_ITEM : String = 'WRONG_ITEM';
		
		/**
		 * Intent to add a filter
		 * */
		public static const ADD_FILTER : String = 'pleaseADD_FILTER';		
		public static const EDIT_FILTER : String = 'editFilter';		
		/**
		 * loaded a new target 
		 * */
		public static const TARGET_CHANGED : String = 'TARGET_CHANGED';				
		
		public static const AD_CHANGED : String = 'AD_CHANGED';
		public static const PREFERENCES_CHANGED : String = ' preferencesChanged'
		public static const VOICE_CHANGED : String = ' userChanged'
			
		public static const SYNC_STATE_CHANGED : String = ' syncStateChanged'			
		
			
		public static const LOADING_CHANGED : String = 'loadingChanged'
		/**
		 * Where was this supposed to be hooked up? on the notebooks? for ALL NOTEBOOKS?
		 * */
		public static const NOTE_COUNT_CHANGED : String = 'noteCountChanged'			
			
		public static const AUTHENTICATED : String = 'authenticated' 
		public static const AUTHENTICATION_REFRESHED : String = 'AUTHENTICATION_REFRESHED' 			
		
		public static const LOGOUT : String = 'logout'			
		public var data: Object;
		public static const LIST_FAILED:String = 'loadListFailed'		;
		public static const CURRENT_LESSON_ITEM_CHANGED:String='CURRENT_LESSON_ITEM_CHANGED';
		public static const CURRENT_LESSON_SET_CHANGED:String='CURRENT_LESSON_SET_CHANGED';
		public static const CURRENT_LESSON_CHANGED:String='CURRENT_LESSON_CHANGED';
		public static const CURRENT_LESSON_PLAN_CHANGED:String='CURRENT_LESSON_PLAN_CHANGED';
		public static const CURRENT_UNIT_CHANGED:String='CURRENT_UNIT_CHANGED';
		public static const UNITS_CHANGED:String='UNITS_CHANGED';
		
		public static const LESSON_PROMPTS_CHANGED : String = 'LESSON_PROMPTS_CHANGED'; 
		
		public static const COLLECT:String='COLLECT';
		
		public static const SELECTED_LESSON_ITEM_CHANGED:String='SELECTED_LESSON_ITEM_CHANGED';
		public static const HIGHLIGHTED_ITEM_CHANGED:String='HIGHLIGHTED_ITEM_CHANGED';
		
		public static const CURRENT_PROMPT_DEFINITION_CHANGED:String='SELECTED_PROMPT_DEFINITION_CHANGED';
		public static const CURRENT_PROMPT_CHANGED:String='SELECTED_PROMPT_CHANGED';
		
		
		
		public static const AUTOMATING_COMPLETE : String = 'AUTOMATING_COMPLETE'; 
		public static const AUTOMATE_CLEAR : String = 'AUTOMATE_CLEAR'; 
		public static var GETTING_STARTED_NOT_SHOWN:String = 'GettingStartNotShown';
		
		public function RSModelEvent(type:String, _data:Object = null)
		{
			super(type);
			data = _data;
		}
	
	}
}