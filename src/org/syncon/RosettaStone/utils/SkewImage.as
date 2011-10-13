package  org.syncon.RosettaStone.utils
{
	import flash.display.StageDisplayState;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import mx.geom.Transform;
	
	public  class   SkewImage  
	{
		//http://blog.flexexamples.com/2008/04/07/skewing-an-image-control-in-flex/
		static public function skewr( ui : DisplayObject, scale : Number = 1 ):void {
			var target : DisplayObject =  ui
			//target = this.ui.clock3.txtQuery.textDisplay as DisplayObject
			//target = this.ui; 
			//target = this.ui.clock3; 
			//target = this.ui; 
			target.x += .03*target.width; 
			//return; 
			var m:Matrix = target.transform.matrix;
			m.b = Math.tan(degreesToRadians(0));
			m.c = Math.tan(degreesToRadians(-6));
			m.scale( scale, scale ); 
			/*
			if ( this.model.flex ) 
			{
			var t:Transform = new Transform(target);
			t.matrix = m;
			
			target.transform = t;
			}
			else
			{
			*/
			var t:Transform = new Transform(target);
			t = new Transform(target);
			t.matrix = m;
			
			//var sss : StyleableTextField = this.ui.asdf.textDisplay as StyleableTextField
			target.transform = t;
			//sss.embedFonts = false; 
			//this.ui.clock3
			//target.transform.matrix = m; 
			//this.ui.clock3.transform = t;
			//this.ui.clock3.transform.matrix = m; 
			//target.tr
			/* this.ui.clock3.cacheAsBitmapMatrix = t.concatenatedMatrix
			this.ui.clock3.cacheAsBitmap = true*/
			
			/*		}*/
		}
		
		
		static private function radiansToDegrees(radians:Number):Number {
			return (radians * (180 / Math.PI));
		}
		
		static private function degreesToRadians(degrees:Number):Number {
			return (degrees * (Math.PI / 180));
		}
	}
}