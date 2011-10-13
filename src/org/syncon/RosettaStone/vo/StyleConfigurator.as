package  org.syncon.RosettaStone.vo
{
	import mx.core.UIComponent;
	import mx.styles.CSSStyleDeclaration;

	/**
	 * Combine recurrent code in one place ... 
	 * update the font and background color 
	 * */
	public class StyleConfigurator 
	{
		private var lastActivteFontSize:Number;
		private var lastActiveReverseText : Boolean ; 
		private var ui:Object;
		public var fontChanged:Boolean;
		public var bgChanged:Boolean;
		private var fxExtraUpdate:Function;
		/**
		 * Called when component first created ... 
		 * */
		public function init( ui :   Object, config :  NightStandConfigVO, extraUpdateFx : Function =null ): void
		{
			this.ui = ui; 
			this.fxExtraUpdate = extraUpdateFx; 
			var css : CSSStyleDeclaration = this.ui.styleManager.getStyleDeclaration('global')
			var fontSize : Number = css.getStyle('fontSize'); 
			this.lastActivteFontSize = fontSize
			//var bgColor : uint  = css.getStyle('backgroundColor'); 
			this.lastActiveReverseText = config.reverseText; 		
			if ( config.reverseText ) 
			{
				ui.setStyle('backgroundColor', 0 ) 
			}
			else
			{
				ui.setStyle('backgroundColor', 0xFFFFFF ) 
			}
			if ( this.fxExtraUpdate != null ) { fxExtraUpdate(true) } 
		}
		
		public function changedCheck( config : NightStandConfigVO ) : void{
			
			
			this.fontChanged = lastActivteFontSize != config.fontSize; 
			this.lastActivteFontSize = config.fontSize
			lastActivteFontSize = config.fontSize; 
			this.bgChanged = lastActiveReverseText != config.reverseText
			this.lastActiveReverseText = config.reverseText; 		
			if ( this.bgChanged ) 
			{
				if ( config.reverseText ) 
				{
					ui.setStyle('backgroundColor', 0 ) 
				}
				else
				{
					ui.setStyle('backgroundColor', 0xFFFFFF ) 
				}
				
			}
			if ( this.fxExtraUpdate != null  ) { fxExtraUpdate() } 
		}
		 
		
		 
		
	}
}