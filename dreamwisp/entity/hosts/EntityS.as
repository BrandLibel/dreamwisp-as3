package dreamwisp.entity.hosts 
{
	import dreamwisp.entity.components.ViewS;
	/**
	 * So ViewS functionality is remoted from EntityS
	 * @author 
	 */
	public class EntityS extends Entity 
	{
		private var _viewS:ViewS;
		public function EntityS(prototypeData:Object=null, prototypeID:uint=0) 
		{
			super(prototypeData, prototypeID);
			
		}
		
		override public function destroy():void 
		{
			if (viewS) viewS.displayObject.dispose();
			super.destroy();
		}
		
		override public function render(interpolation:Number):void {
			if (viewS) viewS.render(interpolation);
			super.render(interpolation);
		}
		
		public function get viewS():ViewS { return _viewS; }
		
		public function set viewS(value:ViewS):void { _viewS = value; }
		
	}

}