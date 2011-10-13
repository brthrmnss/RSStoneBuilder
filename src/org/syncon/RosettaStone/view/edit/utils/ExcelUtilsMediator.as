package org.syncon.RosettaStone.view.edit.utils
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.RSModel;
	
	public class ExcelUtilsMediator extends Mediator 
	{
		[Inject] public var ui : ExcelUtils;
		[Inject] public var model : RSModel;
		
		override public function onRegister():void
		{
			this.ui.addEventListener( ExcelUtils.INPUT_CHANGED, 
				this.onInputChanged);	
		}
		
		private function onInputChanged(e: Event): void
		{
			this.excelParse(); 
			var txt : String = this.ui.txtInput.text; 
			/*
			this.dispatch( new ConvertStringToLessonCommandTriggerEvent( 
			ConvertStringToLessonCommandTriggerEvent.CONVER_STRING, txt, this.currentLesson, 
			this.newItemsCreated, true) ) 
			*/
			//this.automateItems(arr ) ; 
			return; 
			
		}
		
		private function excelParse():void
		{
			var newline: RegExp = /\n/;			
			var returncarriage: RegExp = /\r/;
			var tab : RegExp = /\t/;
			
			var str:String = this.ui.txtInput.text; 
			//str = this.ui.rawInputString
			
			var errors : Array = [];
			
			var result:Array = str.split( returncarriage )
			if ( str.indexOf('\r') == -1 ) 
				result = str.split( newline )			
			var results : Array = [] ; 
			var perLine : int = int( this.ui.txtRows.text )
			var lines : Array = []  ; 
			var ix : int = 0 ; 
			for   ( var i : int = 0 ; i < result.length;i++ ) 
			{
				var word : String = result[i] 
				if ( word == '' ) 
					continue; 
				if ( ix == 0 ) 
				{
					var row : Array = [ ];
				}
				
				row.push( word ) 
				ix++
				if ( ix == perLine ) 
				{
					ix = 0
					lines.push( row.join('\t') ) 
					row = [] 
				}
				
			}
			if ( row.length > 0 ) 
				lines.push( row.join('\t') ) 
			this.ui.txtOutput.text = lines.join('\n')
			return; 
		}
		public function newItemsCreated() : void
		{
			trace('lesson sets created'); 
			//this.updateCurrentLessonSet( newItems ) ; 	
			/*if ( this.ui.chkSaveAfter.selected ) 
			this.model.saveLesson(); */
		}
		
		
		
		
	}
}