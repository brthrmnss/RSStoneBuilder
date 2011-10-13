package org.syncon.RosettaStone.controller
{
	
	import com.adobe.serialization.json.JSON;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
	
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.SoundBoardConfigVO;
	import org.syncon.RosettaStone.vo.SoundVO;
	
	
	public class LoadSoundsCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:LoadSoundsTriggerEvent;
		
		override public function execute():void
		{
			if ( event.type == LoadSoundsTriggerEvent.LOAD_SOUNDS ) 
			{
				this.loadSounds()
			}				
			//this.findPortFile(); 
		}
		
		private function findPortFile():void
		{
			var alert :  String = ''; 
			//File.applicationDirectory,  is assets and has no native path ...
			var listing : Array = [  File.applicationStorageDirectory] ; //,  File.applicationStorageDirectory] 
			for each ( var f : File in listing ) 
			{
				//var f : File = File.applicationStorageDirectory;//.resolvePath('assets/sub/')
				//File.
				output = ''; 
				if ( f.isDirectory ) 
				{
					var files : Array = f.getDirectoryListing();
					var fileNames : Array = []; 
					for each ( var ff : File in files )
					{
						fileNames.push( ff.name + ' ' + ff.isDirectory ) ; 
					}
					
					var output : String = f.name + ' ' + f.nativePath+ ' ' + fileNames.join(', ' ) ; 
					
				}
				alert += output + '\n';
			}
			this.model.alert( alert ); 
			return; 
			f.isDirectory
			if ( f.exists == false || Capabilities.isDebugger )
				f =  File.applicationDirectory.resolvePath('assets/sub/')
			var files : Array  = f.getDirectoryListing(); 
			for each ( var ff : File in f.getDirectoryListing() )
			{
				if ( NightStandConstants.loadFolder != '' ) 
				{
					if ( ff.name != NightStandConstants.loadFolder ) 
						continue; 
				}
				trace( ff.name ) ;
				var prepend : String// = ff.nativePath.replace( File.applicationStorageDirectory.nativePath , '' ) ; 
				prepend = ff.url.replace( File.applicationStorageDirectory.url , '' ) ; 
				prepend = prepend.replace( File.applicationDirectory.url , '' ) ; 
				var ee : Array = [ File.applicationStorageDirectory ] 
				//prepend  = prepend.replace( File.applicationStorageDirectory , '' ) ; 
				//prepend = prepend.slice(1, prepend.length ) ; 
				ff = ff.resolvePath( 'config.json' )
				var obj:Object;
				var fileStream:FileStream = new FileStream();
				fileStream.open(ff, FileMode.READ);
				obj = fileStream.readUTFBytes(fileStream.bytesAvailable ); 
				fileStream.close();
				
				return [obj,  prepend+"/"];
			}
		}
		
		private var ui : UIComponent;
		private function loadSounds():void
		{
			var arr :Array = new Array()
			var s :SoundVO = new SoundVO()
			s.name = 'doo'; 
			arr.push( s ); 
			s= new SoundVO()
			s.name = 'doddo'; 
			arr.push( s ); 
			this.model.loadSounds( arr ) ; 
			this.loadConfig(); 
		}
		
		private function loadConfig():void
		{
			
			var config :Object = NightStandConstants.FileLoader.readObjectFromFile("config.json", this.loadConfigPart2 ) //as NightStandConfigVO;
			if ( config != false ) 
				this.loadConfigPart3( config ) ; 
		}
		public function loadConfigPart2( c : Object ) : void
		{
			this.loadConfigPart3( c ) ; 
		}
		public function loadConfigPart3( config :Object ) : void
		{
			
			if ( config == null ) 
			{
				var output : Array  = this.getLocalConfig()
				config = output[0]
				var prepend : String = output[1] 
			}
			var arr :Array = [] ; 
			var pattern:RegExp = new RegExp("\r", 'gi' ) 
			config = config.replace( pattern, '' ) ; 
			pattern= new RegExp("\n", 'gi' ) 
			config = config.replace( pattern, '' ) ; 
			var d : Object = JSON.decode( config.toString() ) 
			var r :  SoundBoardConfigVO = new SoundBoardConfigVO()
			r.importObj( d, prepend ) ; 
			this.model.config = r; 
			
			//r.sounds = r.sounds
			this.model.loadSounds( r.sounds ) ; 
			return;
		}
		
		private function getLocalConfig(): Array
		{
			//write for flex later, move away
			var f : File = File.applicationStorageDirectory.resolvePath('assets/sub/')
			f.isDirectory
			if ( f.exists == false || Capabilities.isDebugger )
				f =  File.applicationDirectory.resolvePath('assets/sub/')
			var files : Array  = f.getDirectoryListing(); 
			for each ( var ff : File in f.getDirectoryListing() )
			{
				if ( NightStandConstants.loadFolder != '' ) 
				{
					if ( ff.name != NightStandConstants.loadFolder ) 
						continue; 
				}
				trace( ff.name ) ;
				var prepend : String// = ff.nativePath.replace( File.applicationStorageDirectory.nativePath , '' ) ; 
				prepend = ff.url.replace( File.applicationStorageDirectory.url , '' ) ; 
				prepend = prepend.replace( File.applicationDirectory.url , '' ) ; 
				var ee : Array = [ File.applicationStorageDirectory ] 
				//prepend  = prepend.replace( File.applicationStorageDirectory , '' ) ; 
				//prepend = prepend.slice(1, prepend.length ) ; 
				ff = ff.resolvePath( 'config.json' )
				var obj:Object;
				var fileStream:FileStream = new FileStream();
				fileStream.open(ff, FileMode.READ);
				obj = fileStream.readUTFBytes(fileStream.bytesAvailable ); 
				fileStream.close();
				
				return [obj,  prepend+"/"];
			}
			//return;
			return null;
		}		
		
	}
}