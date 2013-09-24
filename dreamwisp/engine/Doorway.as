package engine {
	import flash.geom.Point;

	public final class Doorway {
		public var num:int, area:int, lvl:int, point:Point, target:int;
		public function Doorway(doorNum:int, a:int, l:int, p:Point, e:int) {
			num = doorNum;
			area = a;
			lvl = l;
			point = p;
			target = e;
		}
	}
}