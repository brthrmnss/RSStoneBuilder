package org.syncon.RosettaStone.model
{
	import org.syncon2.utils.file.ILoadConfig;
	import org.syncon2.utils.file.ServerMultimedia;

	public class NightStandConstants  
	{
		/**
		 * Let init take palce without waitin for the thing .... 
		 * */
		static  public var flex : Boolean = false; 
		public static var showSettingsOnStart:Boolean=false;
		public static var showAds:Boolean=true;
		public static var editFilters:Boolean = false; 
		public static var testAds:Boolean= false;
		public static var ad: Object;
		public static var MenuItemHelper:Class;
		public static var holdWidgetLoading:Boolean;
		public static var EXIT_SETTINGS_MODE:String='gogo';
		public static var FileLoader:ILoadConfig;
		public static var Server2:ServerMultimedia=new ServerMultimedia;
		
		//public static var urlReq:Object;
		public static var fxGenerateUrlReq: Function;
		public static var debug:Boolean;
		public static var loadFolder:String='';
		/**
		 *  Used to load image and sounds from folders, in flex this was the assets folder, 
		 * in air ... ???
		 */
		public static var ResourcesDir:String='';
	}
}