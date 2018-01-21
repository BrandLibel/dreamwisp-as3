package dreamwisp.visual
{
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.entity.hosts.EntityS;
	import dreamwisp.visual.lighting.LightSource;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ContainerView contains basic functionality for
	 * a view that is a layer-based container of graphics.
	 * @author Brandon Li
	 */
	public class ContainerViewS
	{
		private var layers:Vector.<DisplayObjectContainer>
		private var background:Sprite;
		public var container:Sprite;
		private var overlay:Sprite;
		
		public var x:Number;
		public var y:Number;
		public var alpha:Number = 1;
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var rotationX:int;
		public var rotationY:int;
		public var scrollRect:Rectangle;
		
		/// ViewPort (not total) width
		private var width:Number;
		/// ViewPort (not total) height
		private var height:Number;
		
		public function ContainerViewS(width:Number = 768, height:Number = 480, numLayers:uint = 1)
		{
			container = new Sprite();
			background = new Sprite();
			overlay = new Sprite();
			layers = new Vector.<DisplayObjectContainer>();
			while (layers.length < numLayers)
				createLayer();
			this.width = width;
			this.height = height;
		}
		
		private function createLayer():void
		{
			layers.push(new Sprite());
			container.addChild(layers[layers.length - 1]);
		}
		
		public function getLayer(layerNum:uint):DisplayObjectContainer
		{
			return layers[layerNum];
		}
		
		/**
		 * Adds a graphic that ignores Camera scrolling 
		 * and sits below all other layers in the Container.
		 * Calling this will replace any previously set background.
		 * @param	displayObject
		 */
		public function setBackground(displayObject:DisplayObject):void 
		{
			if (background.numChildren > 0)
				background.removeChildAt(0);
			background.addChild(displayObject);
		}
		
		/**
		 * Attaches a component (usually UI) that ignores Camera scrolling
		 * and sits atop all other layers in the Container.
		 */
		public function addOverlay(displayObject:DisplayObject):void
		{
			overlay.addChild(displayObject);
		}
		
		public function addToParent(parent:DisplayObjectContainer):void 
		{
			parent.addChild(background);
			parent.addChild(container);
			parent.addChild(overlay);
		}
		
		public function removeFromParent(parent:DisplayObjectContainer):void 
		{
			parent.removeChild(background);
			parent.removeChild(container);
			parent.removeChild(overlay);
		}
		
		public function render(interpolation:Number):void
		{
			background.x = container.x = overlay.x = x;
			background.y = container.y = overlay.y = y;
			background.alpha = container.alpha = overlay.alpha = alpha;
			background.scaleX = container.scaleX = overlay.scaleX = scaleX;
			background.scaleY = container.scaleY = overlay.scaleY = scaleY;
			
			if (scrollRect)
			{
				//container.scrollRect = scrollRect;
			}
			else
			{ 
				// because setting rotation destroys the scrollRect, this logic is needed
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
		public function addEntity(entity:EntityS):void
		{
			if (!entity.viewS)
				throw new Error("ContainerView: The entity you are trying to add has no view.");
			
			entity.viewS.setContainerView(this);
			addDisplayObject(entity.viewS.displayObject, entity.viewS.layer, entity.body.x, entity.body.y);
			
			if (entity.lightSource)
			{
				addLightSource(entity.lightSource);
			}
		}
		
		/**
		 * Adds a depth-sortable DisplayObject to the container as a GenericView.
		 * @param	displayObject
		 * @param	layer
		 */
		public function addDisplayObject(displayObject:DisplayObject, layer:uint = 0, x:Number = 0, y:Number = 0, label:String = ""):void
		{
			displayObject.x = x;
			displayObject.y = y;
			layers[layer].addChild(displayObject);
		}
		
		public function addLightSource(lightSource:LightSource):void
		{
			//getViewByLabel(LABEL_OVERLAY).addChild(lightSource.lightMask);
			lightSource.lightMask.x = lightSource.x;
			lightSource.lightMask.y = lightSource.y;
			//getViewByLabel(LABEL_OVERLAY).addChild(lightSource.colorMask);
			lightSource.colorMask.x = lightSource.x;
			lightSource.colorMask.y = lightSource.y;
		
			//addGraphic(lightSource.lightMask, lightSource.x, lightSource.y, 1);
			//addGraphic(lightSource.colorMask, lightSource.x, lightSource.y, 1);
		}
		
		public function removeDisplayObject(child:DisplayObject):void
		{
			if (child.parent == container)
			{
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
		
		public function removeEntity(entity:EntityS):void
		{
			// use this b/c container.contains(child) returns true even when child isnt in container
			var child:DisplayObject = entity.viewS.displayObject;
			removeDisplayObject(child);
		
			//if (entity.lightSource) {
			//getViewByLabel(LABEL_OVERLAY).removeChild(entity.lightSource.lightMask);
			//getViewByLabel(LABEL_OVERLAY).removeChild(entity.lightSource.colorMask);
			//}
		
			//removeGenericView( getViewByContent(entity.viewS.displayObject) ); 
		}
		
		/**
		 * Toggles the visibility of the entire container.
		 */
		public function toggleVisible():void
		{
			container.visible = !container.visible;
		}
		
		/**
		 * Sets the scroll rect of this view according to the camera's center pos.
		 * This function is usually called by the <code>Camera</code> class itself.
		 */
		public function followCamera(camX:Number, camY:Number):void
		{
			if (!scrollRect)
				throw new Error("ContainerView " + this + " tried to follow camera but did not instantiate a scrollRect");
			var newRect:Rectangle = scrollRect;
			newRect.x = (camX - (width / 2));
			newRect.y = (camY - (height / 2));
			scrollRect = newRect;
		}
	}

}