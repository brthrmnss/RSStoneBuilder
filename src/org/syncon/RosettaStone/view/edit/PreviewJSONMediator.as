package  org.syncon.RosettaStone.view.edit
{
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	
	public class PreviewJSONMediator extends Mediator 
	{
		[Inject] public var ui : PreviewJSON;
		[Inject] public var model : RSModel;
		
		override public function onRegister():void
		{
			this.ui.addEventListener( PreviewJSON.UPDATE_JSON, 
				this.onUpdateJSON);	
		}
		
		private function onUpdateJSON(e:  CustomEvent): void
		{
			var obj : Object = e.data
			this.ui.txtJSON.text = obj.toJSON; 
			
		}		
		
		
		
	}
}