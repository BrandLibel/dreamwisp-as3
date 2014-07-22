package dreamwisp.visual {
	
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.visual.camera.ICamUser;
	import dreamwisp.visual.lighting.LightSource;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
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
		
		private var layers:Vector.<DisplayObjectContainer>
		public var container:Sprite;
		/// Always appears over the layers in container
		public var overlay:Sprite;
		
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
		
		public function ContainerView(width:Number = 768, height:Number = 480, numLayers:uint = 1) {
			container = new Sprite();
			overlay = new Sprite();
			layers = new Vector.<DisplayObjectContainer>();
			while (layers.length < numLayers)
				createLayer();
			this.width = width;
			this.height = height;
		}
		
		/**
		 * Attaches a component (usually UI) that ignores Camera scrolling
		 * and sits atop all other layers in the Container.
		 */
		private function createLayer():void 
		{
			layers.push( new Sprite() );
			container.addChild(layers[layers.length -1]);
		}
		
		public function getLayer(layerNum:uint):DisplayObjectContainer
		{
			return layers[layerNum];
		}
		
		public function addOverlay(displayObject:DisplayObject):void 
		{
			overlay.addChild(displayObject);
		}
		
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
		 * Tracks the View of the Entity for any changes in the DisplayObject.
		 * @param	entity
		 * @param	targetLayer
		 */
		public function addEntity(entity:Entity, targetLayer:uint = NONE):void {
			if (!entity.view)
				throw new Error("ContainerView: The entity you are trying to add has no view.");
				
			entity.view.setContainerView(this);
			addDisplayObject(entity.view.displayObject, entity.view.layer, entity.body.x, entity.body.y);
			
			if (entity.lightSource) {
				addLightSource(entity.lightSource);
			}
		}
		
		/**
		 * Adds a depth-sortable DisplayObject to the container as a GenericView.
		 * @param	displayObject
		 * @param	layer
		 */
		public function addDisplayObject(displayObject:DisplayObject, layer:uint = 0, x:Number = 0, y:Number = 0, label:String = ""):void {
			displayObject.x = x;
			displayObject.y = y;				
			layers[layer].addChild(displayObject);
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
		
		public function removeDisplayObject(child:DisplayObject):void {
			if (child.parent == container) {
				container.removeChild(child);
			}
			else 
			{
				for each (var layer:DisplayObjectContainer in layers) 
				{
					if (child.parent == layer)
					{
						layer.removeChild(child);
						break;
					}
				}
			}
		}
		
		public function removeEntity(entity:Entity):void {
			// use this b/c container.contains(child) returns true even when child isnt in container
			var child:DisplayObject = entity.view.displayObject;
			removeDisplayObject(child);
			
			//if (entity.lightSource) {
				//getViewByLabel(LABEL_OVERLAY).removeChild(entity.lightSource.lightMask);
				//getViewByLabel(LABEL_OVERLAY).removeChild(entity.lightSource.colorMask);
			//}
			
			//removeGenericView( getViewByContent(entity.view.displayObject) ); 
		}
		
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
	}

}