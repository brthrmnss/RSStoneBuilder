package  org.syncon.RosettaStone.view.popup
{
	import com.evernote.edam.type.Tag;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.model.Notebook2;
	import org.syncon.evernote.basic.view.popup.PopupNotebookForm;
	
	public class PopupNotebookMediator extends Mediator
	{
		[Inject] public var ui:PopupNotebookForm;
		[Inject] public var model : EvernoteAPIModel;
			
		public function PopupNotebookMediator()
		{
		} 
		
		override public function onRegister():void
		{
			 
			this.ui.addEventListener( 'save', this.onSave )
			this.ui.addEventListener( 'cancel', this.onCancel )
		}
		
		private function onSave(e:Event) : void
		{
			var notebook : Notebook2 = new Notebook2()
			notebook.name = this.ui.txtNotebookName.text
			
			var ee :  EvernoteAPICommandTriggerEvent
			if ( this.ui.nb != null ) 
			{
				notebook.guid = this.ui.nb.guid;
				if ( this.ui.currentState != 'properties' ) 
				{
					notebook.defaultNotebook = this.ui.nb.defaultNotebook
				}
				else
				{
					notebook.defaultNotebook = this.ui.chkBox.selected; 
				}
				this.dispatch( 
					EvernoteAPICommandTriggerEvent.UpdateNotebook( notebook, this.onTagUpdatedResult, 
						this.onTagUpdateFault )
				)				
			}
			else
			{
				this.dispatch( 
					EvernoteAPICommandTriggerEvent.CreateNotebook( notebook, this.onTagCreateResult, 
						this.onTagCreateFault )
					)
			}
			//this.ui.treeControl.dataProvider = e.data as ArrayCollection
		}		
 
		public function onTagCreateResult(e:Tag):void
		{	
			this.ui.hide();
			return;
		}
		
		public function onTagCreateFault(e:Tag):void
		{
		}		
		
		/**
		 * Service returns numbers
		 * */
		public function onTagUpdatedResult(e: Number):void
		{	
			this.ui.nb.name = this.ui.txtNotebookName.text
			if ( this.ui.chkBox != null ) 
				this.ui.nb.defaultNotebook = this.ui.chkBox.selected
			this.ui.nb.notebookUpdated()
			this.ui.hide();
			return;
		}
		
		public function onTagUpdateFault(e:Tag):void
		{
		}			
		
		private function onCancel(e:Event) : void
		{
			this.ui.hide();
			//this.ui.listSavedSearches.dataProvider = e.data as ArrayCollection
		}				
	 
		
	}
}