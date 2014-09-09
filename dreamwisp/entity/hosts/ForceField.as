package dreamwisp.entity.hosts 
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.View;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Brandon
	 */
	public class ForceField extends Entity
	{
		private var strength:Number;
		private var radius:uint;
		private var maxRange:uint;
		private var sprite:Sprite;
		
		public function ForceField(strength:Number, radius:uint, maxRange:uint, diameter:uint = 32) 
		{
			this.strength = strength;
			this.radius = radius;
			this.maxRange = maxRange;
			
			sprite = new Sprite();
			body = new Body(this, diameter, diameter);
			view = new View(this, sprite);
			sprite.graphics.lineStyle(maxRange - radius, 0xAB2DFF, 0.3);
			sprite.graphics.drawCircle(diameter / 2, diameter / 2, radius + (maxRange - radius) / 2);
			sprite.graphics.lineStyle(0, 0, 0);
			sprite.graphics.beginFill(0xE7CFE9, 0.1);
			sprite.graphics.drawCircle(diameter / 2, diameter / 2, radius);
		}
		
		override public function update():void 
		{
			super.update();
			for each (var entity:Entity in entityManager.getEntitys()) 
			{
				var distance:Number = body.distanceTo(entity.body);
				if (radius < distance && distance < maxRange && entity.physics != null)
				{
					var dX:Number = entity.body.centerX - body.centerX;
					var dY:Number = entity.body.centerY - body.centerY;
					var force:Number = strength / Math.pow(distance - radius, 0.5);
					// avoid ridiculously high force values
					if (force > strength)
						force = strength;
					var angle:Number = Math.atan2(dY, dX);
					entity.physics.externalAccelerationX += Math.cos(angle) * force;
					entity.physics.externalAccelerationY += Math.sin(angle) * force;
					
				}
			}
		}
		
	}

}