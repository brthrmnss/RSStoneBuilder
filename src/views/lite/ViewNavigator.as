////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2010 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package  views.lite
{
	
	
	import flash.utils.Dictionary;
	
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.events.ViewNavigatorEvent;
	
	import views.View;
	
	public class ViewNavigator extends Group
	{
		public var actionContent:Group;
		
		public var navigationContent:Group;
		
		public var topBar:Group;
		
		public var lbl : Label; 
		
		public function ViewNavigator() 
		{
			this.topBar = new  Group(); 
			this.addElement( this.topBar ) ; 
			
			this.actionContent = new  Group(); 
			this.topBar.addElement( this.actionContent ) ; 
			this.actionContent.setStyle('right', '10' )  ; 		
			this.actionContent.setStyle('verticalCenter', '0' )  ; 				
			this.topBar.height = 80 ; 
			this.topBar.percentWidth = 100 ; 
			
			this.navigationContent = new  Group(); 
			this.topBar.addElement( this.navigationContent ) ; 
			this.navigationContent.setStyle('left', '10' )  ; 	
			this.navigationContent.setStyle('verticalCenter', '0' )  ; 	
			
			this.lbl = new Label()
			this.topBar.addElement( this.lbl ) ; 
			this.lbl.setStyle('textAlign', 'center' )  ; 
			this.lbl.setStyle('fontWeight', 'bold' )  ; 
			this.lbl.setStyle('verticalCenter', '0' )  ; 			
			this.lbl.setStyle('horizontalCenter', '0' )  
			this.lbl.setStyle('fontSize', '32' )  				
		}
		public function set firstView( f : Class ) : void
		{
			this.pushView( f ) ; 
		}
		public function hideActionBar() : void
		{
			this.topBar.visible = false; 
			currentView.setStyle('top', 0 ) ; 
		}
		
		public function showActionBar() : void
		{
			this.topBar.visible = true
			currentView.setStyle('top', 80 ) ; ; 
		}
		
		public var lastAction :  String = ''; // = {}
		public var cache : Dictionary = new Dictionary(true); 
		public var currentView : Object; 
		public var viewStack : Array = []; 
		public function pushView(  clazz : Class , data : Object =null) : void
		{
			if ( this.currentView is clazz) 
				return; 
			
			instance = cache[clazz] ;
			if ( instance == null ) 
			{
				var instance : Object = new clazz ()
				cache[clazz]  = instance
				this.addElement( instance as IVisualElement ) ;
				instance.percentHeight = 100; 
				instance.percentWidth = 100; 
				//automate action bar
				instance.setStyle('top', 80 ) ; 
				instance.setStyle('bottom', 0 ) ; 
				instance.setStyle('left', 0 ) ; 
				instance.setStyle('right', 0 ) ; 
			}
			if ( data != null ) 
				instance.data = data; 
			if ( currentView != null ) 
			{
				currentView.dispatchEvent( new ViewNavigatorEvent(ViewNavigatorEvent.VIEW_DEACTIVATE) ) ;
			}
			this.activateView( instance ) ; 
			var stackEntry : Object= new Object()
			stackEntry.view = instance; 
			stackEntry.data = data; 
			viewStack.push(stackEntry); 
		}
		
		public var lastData : Object; 
		
		public function popView(   ) : void
		{
			if ( this.viewStack.length == 1 ) 
				return ; 
			
			
			if ( currentView != null ) 
			{
				this.deactivateView( currentView ) ; 
			}
			
			var prevStackEntry : Object= this.viewStack.pop();
			this.lastData = prevStackEntry.data; 
			
			var stackEntry : Object= this.viewStack[this.viewStack.length-1]
			
			var instance :  Object = stackEntry.view; 
			if ( stackEntry.data != null ) 
			{
				instance.data = stackEntry.data
			}
			
			this.activateView( instance ) ; 
			
		}
		use namespace mx_internal;
		private function activateView(instance:Object):void
		{
			instance.visible = true; 
			this.actionContent.mxmlContent = null
			var view :  View = instance as View; 
			if ( view.actionContent != null ) 
			{
				this.actionContent.mxmlContent =  view.actionContent
			}
			this.navigationContent.mxmlContent = null
			if ( view.navigationContent != null ) 
			{
				this.navigationContent.mxmlContent =  view.navigationContent
			}
			
			instance.mx_internal::setNavigator( this)
			//instance.naviagor = this; 
			instance.mx_internal::setActive( true)
			this.lbl.text = view.title;
			if (currentView != null ) 
			{
				this.deactivateView( currentView ) ; 
				
			}
			currentView = instance;
			if ( currentView.actionBarVisible )
			{
				this.showActionBar()
			}
			else
			{
				hideActionBar()
			}
			currentView.dispatchEvent( new ViewNavigatorEvent(ViewNavigatorEvent.VIEW_ACTIVATE) ) ; // TODO Auto Generated method stub
			
		}		
		
		private function deactivateView(view:Object):void
		{
			view.mx_internal::setActive( false)
			view.dispatchEvent( new ViewNavigatorEvent(ViewNavigatorEvent.VIEW_DEACTIVATE) ) ;
			view.visible = false; 
			
		}
		
		public function inject(  clazz : Class  ) : void
		{
			instance = cache[clazz] ;
			if ( instance == null ) 
			{
				var instance : Object = new clazz ()
				cache[clazz]  = instance
				this.addElement( instance as IVisualElement ) ;
				instance.percentHeight = 100; 
				instance.percentWidth = 100; 
				//automate action bar
				instance.setStyle('top', 80 ) ;
				instance.visible = false; 
			}
			
		}
	}
}
