package dreamwisp.core 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * SWFPlayer loads in sequence any number of SWFs and tracks completion of each.
	 * Every SWF provided should have a single MovieClip in its root.
	 * 
	 * SWFPlayer gives the option to manually specify a unique URL for every SWF that opens on click.
	 * @author Brandon
	 */
	
	public class SWFPlayer 
	{
		private var loader:Loader;
		private var loaderContext:LoaderContext;
		private var pendingSWFs:Vector.<ByteArray>;
		private var swfValues:Array;
		
		private var parent:DisplayObjectContainer;
		private var currentURL:String;
		
		private var currentFrame:uint = 0;
		private var endFrame:uint = 0;
		
		/**
		 * 
		 * @param	parent display object that SWFs will be loaded into
		 * @param	swf the first swf to load
		 * @param	url link to open when swf is playing
		 */
		public function SWFPlayer(parent:DisplayObjectContainer, swf:ByteArray, url:String = "", scale:Number = 1) 
		{
			loader = new Loader();
			loaderContext = new LoaderContext();
			loaderContext.allowCodeImport = true;
			pendingSWFs = new Vector.<ByteArray>;
			swfValues = new Array();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, finishLoad);
			
			add(swf, url, scale);
			loader.loadBytes(swf, loaderContext);
			
			this.parent = parent;
			parent.addChild(loader);
			parent.stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function run():void 
		{
			if (endFrame > 0)
			{
				currentFrame++;
				if (currentFrame >= endFrame)
				{
					endFrame = 0;
					currentFrame = 0;
					if (pendingSWFs.length > 0)
						loader.loadBytes(pendingSWFs[0], loaderContext);
				}
			}
		}
		
		public function add(swf:ByteArray, url:String = "", scale:Number = 1, stageColor:uint = 0x000000):void 
		{
			pendingSWFs.push(swf);
			swfValues.push( {"url": url, "scale": scale, "stageColor": stageColor } );
		}
		
		private function finishLoad(e:Event):void 
		{
			pendingSWFs.shift();
			var values:Object = swfValues.shift();
			currentURL = values.url;
			loader.x = (parent.stage.stageWidth - loader.width) / 2;
			loader.y = (parent.stage.stageHeight - loader.height) / 2;
			loader.scaleX = values.scale;
			loader.scaleY = values.scale;
			parent.stage.color = values.stageColor;
			endFrame = MovieClip(MovieClip(loader.content).getChildAt(0)).totalFrames;
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (currentURL == "" || loader.content == null) return;
			navigateToURL( new URLRequest(currentURL) );
		}
		
		public function isDone():Boolean
		{
			return pendingSWFs.length == 0 && currentFrame >= endFrame;
		}
		
		public function destroy():void 
		{
			parent.removeChild(loader);
			parent.stage.removeEventListener(MouseEvent.CLICK, onClick);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, finishLoad);
			loader.unloadAndStop();
		}
		
	}

}