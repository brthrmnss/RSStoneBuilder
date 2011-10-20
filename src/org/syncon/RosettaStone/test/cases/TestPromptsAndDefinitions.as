package org.syncon.RosettaStone.test.cases
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon.RosettaStone.vo.LessonVO;
	import org.syncon.RosettaStone.vo.PromptDefinitionVO;
	
	public class TestPromptsAndDefinitions
	{
		//private var service:EvernoteService;
		//private var serviceDispatcher:EventDispatcher = new EventDispatcher();
		
		[Before]
		public function setUp():void
		{
			/*serviceDispatcher = new EventDispatcher();
			service = new EvernoteService();
			service.eventDispatcher = serviceDispatcher;
			}*/
		}
		[After]
		public function tearDown():void
		{
			/*this.serviceDispatcher = null;
			this.service = null;*/
		}
		
		public function createPromtChangeType() : void
		{
			
			var lesson : LessonVO = new LessonVO(); 
			lesson.name = 'S'; 
			
			var set : LessonSetVO = new LessonSetVO(); 
			lesson.sets.addItem( set ) 
			
			for ( var i : int = 0 ; i < 4 ; i++ )
			{
				var item : LessonItemVO = new LessonItemVO(); 
				item.name = 'Item ' + i.toString()
				set.items.addItem( item ) ; 
			}
			
			
			var def : PromptDefinitionVO = new PromptDefinitionVO()
			def.name = 'Alt Pic'
			def.makePic(); 
			
			lesson.addPrompt( def ) ; 
			
			//	item.prompts = new ArrayCollection( lesson.clonePrompts( lesson.prompts.toArray() ) ) 
			//item.currentPrompt = 
			item.setPromptDefinition( def ,true, lesson.clonePrompts )
			
			assert( item.currentPrompt.def.isPic , true ) 
			assert( item.currentPrompt.def.isMovie , false ) 
		}	
		public function export() : void
		{
			
			var lesson : LessonVO = new LessonVO(); 
			lesson.name = 'S'; 
			lesson.baseFolder = 'units/l2'
			var set : LessonSetVO = new LessonSetVO(); 
			lesson.sets.addItem( set ) 
			
			for ( var i : int = 0 ; i < 4 ; i++ )
			{
				var item : LessonItemVO = new LessonItemVO(); 
				item.name = 'Item ' + i.toString()
				set.items.addItem( item ) ; 
			}
			
			
			var def : PromptDefinitionVO = new PromptDefinitionVO()
			var def1 : PromptDefinitionVO = def; 
			def.name = 'Alt Pic'
			def.makePic(); 
			
			lesson.addPrompt( def ) ; 
			
			//	item.prompts = new ArrayCollection( lesson.clonePrompts( lesson.prompts.toArray() ) ) 
			//item.currentPrompt = 
			item.setPromptDefinition( def ,true, lesson.clonePrompts )
			
			item.currentPrompt.data = 'test'
			var pomptData : String = item.getPromptData( def.name,false ) 
			assert(pomptData, item.currentPrompt.data , 'promtp data is not valid' ) 	
			var firstItem : LessonItemVO = item;
			
			//add promtp again
			def = new PromptDefinitionVO()
			def.name = 'Alt Pic 2'
			def.makeText(); 
			lesson.addPrompt( def ) ; 
			
			item.setPromptDefinition( def ,true, lesson.clonePrompts )
			
			item.currentPrompt.data = 'test2'
			var pomptData2 : String = item.getPromptData( def.name,false ) 
			assert(pomptData2, item.currentPrompt.data , 'promtp data is not valid' ) 	
			
			//test export ...do not export last empty one ....
			def = new PromptDefinitionVO()
			def.name = 'Alt Pic 3'
			def.makeText(); 
			lesson.addPrompt( def ) ; 
			item.setPromptDefinition( def ,true, lesson.clonePrompts )
			
			var x : String = lesson.export(); 
			var json : Object = JSON.decode( x ) 
			assert(json.sets[0].items[3].prompts.length, 2 , 'you are exporting too many prompts') 
			
			
			var l2 : LessonVO = new LessonVO()
			l2.importObj( json ) ; 
			l2.baseFolder = lesson.baseFolder; 
			var testLiForFolderPaths:  LessonItemVO= l2.sets.getItemAt( 0 ).items.getItemAt(3) as LessonItemVO
			assert(testLiForFolderPaths.getPromptData(def1.name, false ), 'test' , 'you are exporting too many prompts') 
			var dbg : Array = [testLiForFolderPaths.getPromptData(def1.name, false ), testLiForFolderPaths.getPromptData(def1.name, true )] 
			
			
			return;
		}	
		public function execute() : void
		{
			createPromtChangeType()
			export()
		}
		
		public function assert( a : Object, b : Object, msg : String = '' ) : void
		{
			if ( a == b ) 
			{
				
			}
			else
			{
				throw msg + ' ' + a.toString() + ' != ' + b.toString()
			}
		}
		
		
		
	}
}