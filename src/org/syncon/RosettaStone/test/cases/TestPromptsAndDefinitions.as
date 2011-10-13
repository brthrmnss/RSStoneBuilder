package org.syncon.RosettaStone.test.cases
{
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
			
			lesson.prompts.addItem( def  ) ; 
			
			//	item.prompts = new ArrayCollection( lesson.clonePrompts(  lesson.prompts.toArray() ) ) 
			//item.currentPrompt = 
			item.setPromptDefinition( def ,true, lesson.clonePrompts )
			
			assert( item.currentPrompt.def.isPic , true ) 
			assert( item.currentPrompt.def.isMovie , true ) 
		}	
		
		public function execute() : void
		{
			createPromtChangeType()
		}
		
		public function assert( a  : Object, b : Object, msg : String = '' ) : void
		{
			if ( a == b ) 
			{
				
			}
			else
			{
				throw msg + '  ' + a.toString() + '  != ' + b.toString()
			}
		}
		
		
		
	}
}