package dreamwisp.visual {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.visual.camera.ICamUser;
	import dreamwisp.visual.lighting.LightSource;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ContainerView contains basic functionality for
	 * a view that is a layer-based container of graphics.
	 * @author Brandon Li
	 */
	public class ContainerView implements ICamUser {
		
		public static const LABEL_BACKGROUND:String = "background";
		public static const LABEL_OVERLAY:String = "overlay";
		public static const LAYER_BOTTOM:uint = 0;
		public static const LAYER_TOP:uint = uint.MAX_VALUE;
		
		// Constants to handle relative positioning
		private const CENTER:String = "center";
		private const LEFT:String = "left";
		private const RIGHT:String = "right";
		private const MIDDLE:String = "middle";
		private const TOP:String = "top";
		private const BOTTOM:String = "bottom";
		
		//private var _layers:Array;
		private var _container:Sprite;
		/// Array of generic views. // do not make a vector, unable to sort
		private var genericViews:Array = [];
		
		private const NONE:uint = uint.MAX_VALUE;
		private const TOGGLE:uint = 2;
		
		public var x:Number;
		public var y:Number;
		public var alpha:Number = 1;
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var rotationX:int;
		public var rotationY:int;
		public var scrollRect:Rectangle;
		
		private var width:Number;
		private var height:Number;
		
		public function ContainerView(width:Number = 768, height:Number = 480) {
			container = new Sprite();
			this.width = width;
			this.height = height;
		}
		
		/*
		 * TODO: ContainerView might need to be made into a component of either GameState or Location.
		 * Instead of having its own x and y properties, it should retrieve x and y values from its host.
		 * And it may be necessary to continue to generalize the Location and GameState, or change some of their
		 * responsibilities. 
		 * The problem that this solves is preventing discrepencies between the view and the Location/GameStates given
		 * x and y positions. 
		 */
		
		public function render(interpolation:Number):void {
			container.x = x;
			container.y = y;
			container.alpha = alpha;
			container.scaleX = scaleX;
			container.scaleY = scaleY;
			if (scrollRect) {
				container.scrollRect = scrollRect;
			} else { // because setting rotation destroys the scrollRect, this logic is needed
				// TODO: WorldView scrollRect being destroyed affects AreaView
				//	 	 so either give the camera to WorldView, or never use rotation
				//		 and give the camera to AreaView, allowing WorldView to contain the
				//		 UI and various other things.

				//MonsterDebugger.trace(this, "destroying scroll rect", "", "", 0xFF2828);
				//container.rotationX = rotationX;
				//container.rotationY = rotationY;
			}
		}
		
		/**
		 * Visually attaches an Entity to the container.
		 * @param	entity
		 * @param	targetLayer
		 */
		public function addEntity(entity:Entity, targetLayer:uint = NONE):void {
			if (!entity.view) {
				throw new Error("ContainerView: The entity you are trying to add has no view.");
			}
			
			addDisplayObject(entity.view.displayObject, entity.view.layer, entity.body.x, entity.body.y);
			
			//addGenericView(new GenericView(entity.view.movieClip, entity.view.layer));
			
			if (entity.lightSource) {
				addLightSource(entity.lightSource);
				//addGraphic(entity.lightSource.lightMask, entity.lightSource.x, entity.lightSource.y, 9);
				// to allow light even outside of darkness, add the color mask to another layer
				//addGraphic(entity.lightSource.colorMask, entity.lightSource.x, entity.lightSource.y, 7);
			}
		}
		
		/*public function addGraphicsObject(graphicsObject:GraphicsObject, layer:uint = 0, label:String = ""):void {
			
			addGenericView( new GenericView(graphicsObject.getGraphicsData(), layer, label ) );
			graphicsObject.parentWidth = width;
			graphicsObject.parentHeight = height;
			graphicsObject.initialize();
			if (graphicsObject.relativeX != null && graphicsObject.relativeX != "")
				
				graphicsObject.x = graphicsObject.getGraphicsData().x = calculateRelativePosition( graphicsObject.relativeX, graphicsObject.getGraphicsData() );
			if (graphicsObject.relativeY != null && graphicsObject.relativeY != "")
				graphicsObject.y = graphicsObject.getGraphicsData().y = calculateRelativePosition( graphicsObject.relativeY, graphicsObject.getGraphicsData() );
		}*/
		
		/**
		 * Adds a depth-sortable DisplayObject to the container as a GenericView.
		 * @param	displayObject
		 * @param	layer
		 */
		public function addDisplayObject(displayObject:DisplayObject, layer:uint = 0, x:Number = 0, y:Number = 0, label:String = ""):void {
			displayObject.x = x;
			displayObject.y = y;
			container.addChild(displayObject);
			//addGenericView( new GenericView(displayObject, layer, label) );
		}
		
		public function addLightSource(lightSource:LightSource):void {
			//getViewByLabel(LABEL_OVERLAY).addChild(lightSource.lightMask);
			lightSource.lightMask.x = lightSource.x;
			lightSource.lightMask.y = lightSource.y;
			//getViewByLabel(LABEL_OVERLAY).addChild(lightSource.colorMask);
			lightSource.colorMask.x = lightSource.x;
			lightSource.colorMask.y = lightSource.y;
			
			//addGraphic(lightSource.lightMask, lightSource.x, lightSource.y, 1);
			//addGraphic(lightSource.colorMask, lightSource.x, lightSource.y, 1);
		}
		
		/*public function getViewByLabel(label:String):GenericView {
			for each (var genericView:GenericView in genericViews) {
				//if (genericView.label != "") {
					if (genericView.label == label) {
						return genericView;
					}
				//}
			}
			throw new Error("Could not find a GenericView by that label in this container.");
		}*/
		
		/*public function getViewByContent(displayObject:DisplayObject):GenericView {
			for each (var genericView:GenericView in genericViews) {
				if (genericView.displayObject === displayObject) {
					return genericView;
				}
			}
			throw new Error("Could not find a GenericView with that DisplayObject.");
		}*/
		
		public function removeEntity(entity:Entity):void {
			// use this b/c container.contains(child) returns true even when child isnt in container
			var child:DisplayObject = entity.view.displayObject;
			if (child.parent == container) {
				//MonsterDebugger.trace(this, "TRUE", "", "", 0xFF28DF);
				container.removeChild(child);
			}
			
			//if (entity.lightSource) {
				//getViewByLabel(LABEL_OVERLAY).removeChild(entity.lightSource.lightMask);
				//getViewByLabel(LABEL_OVERLAY).removeChild(entity.lightSource.colorMask);
			//}
			
			//removeGenericView( getViewByContent(entity.view.displayObject) ); 
		}
		
		public function get container():Sprite { return _container; }
		
		public function set container(value:Sprite):void { _container = value; }
		
		/**
		 * Toggles the visibility of the entire container or 
		 * layer if specified. 
		 * @param	layer Default set to <code>layers.length</code> in order to prevent use.
		 * @param	value The specific visibility code. 0 is false, 1 is true, 2 is toggle.
		 */
		public function toggleVisible(layer:uint = NONE, value:uint = TOGGLE):void {
			if (layer == NONE) {
				container.visible = !container.visible;
			} else {
				//TODO: make invisible all GenericViews with the specified layer
			}
		}
		
		/**
		 * Sets the scroll rect of this view according to the camera's center pos.
		 * This function is usually called by the <code>Camera</code> class itself. 
		 */
		public function followCamera(camX:Number, camY:Number):void {
			if (!scrollRect) throw new Error("ContainerView " + this + " tried to follow camera but did not instantiate a scrollRect");
			var newRect:Rectangle = scrollRect;
			newRect.x = (camX - (width / 2));
			newRect.y = (camY - (height / 2));
			scrollRect = newRect;
		}
		
		private function calculateRelativePosition(value:String, displayObject:DisplayObject):uint {
			var result:uint = 0;
			
			if (value == LEFT)
				result = 0;
			else if (value == RIGHT)
				result = width;
			else if (value == CENTER)
				result = (width - displayObject.width) / 2;
			else if (value == TOP)
				result = 0 + (displayObject.height / 2);
			else if (value == BOTTOM)
				result = height - (displayObject.height);
			else if (value == MIDDLE)
				result = (height - displayObject.height) / 2;
			else 
				throw new Error("THAT RELATIVE POSITION STRING IS INVALID. CHECK VALUES");
			
			return result;
		}
		
		/*private function addGenericView(genericView:GenericView):void {
			genericViews.push(genericView);
			var displayData:* = genericView.displayObject;
			container.addChild(genericView.displayObject);
			sortDisplayList();
		}*/
		
		/**
		 * Sorts the genericViews array, and then copies the indexes
		 * of each corresponding DisplayObject in the container.
		 */
		private function sortDisplayList():void {
			var i:int = container.numChildren;
			genericViews.sortOn("layer", Array.NUMERIC);
			// avoid scenarios where my construct GenericViews
			// becomes out of sync with Flash's display object children
			if (container.numChildren > genericViews.length)
				return;
			while(i--){
				if (genericViews[i].displayObject != container.getChildAt(i)) {
					container.setChildIndex(genericViews[i].displayObject, i);
				}
			}
		}
		
		/*private function removeGenericView(genericView:GenericView):void {
			genericViews.splice( genericViews.indexOf(genericView), 1 );
			sortDisplayList();
		}*/
		
	}

}