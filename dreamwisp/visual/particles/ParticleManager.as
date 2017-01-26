package dreamwisp.visual.particles 
{
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class ParticleManager 
	{
		public static var bitmap:Bitmap;
		private static var bitmapData:BitmapData;
		private static var bitmapRect:Rectangle;
		private static var particleList:CircularParticleArray;
		
		public static function init(capacity:uint):void 
		{
			particleList = new CircularParticleArray(capacity);
			bitmap = new Bitmap();
		}
		
		public static function createCanvas(width:uint, height:uint):void 
		{
			bitmapRect = new Rectangle(0, 0, width, height);
			bitmapData = new BitmapData(width, height, true, 0);
			bitmap.bitmapData = bitmapData;
		}
		
		/**
		 * 
		 * @param	img bitmap of the particle or sprite sheet of particle
		 * @param	rX x-coord to blit from img
		 * @param	rY y-coord to blit from img
		 * @param	rW width of rect to blit from img
		 * @param	rH height of rect to blit from img
		 * @param	x position to draw particle at
		 * @param	y position to draw particle at
		 * @param	velX change of x every update()
		 * @param	velY change of y every update()
		 * @param	duration number of update()s before death
		 * @param	scale only used when sizeBehavior == sizeShrink
		 * @param	color tint applied to the particle
		 * @param	moveBehavior defines how x and y are affected by velocity (default: friction)
		 * @param	sizeBehavior defines how scale changes over time (default: no change)
		 * @param	colorBehavior definees how color changes over time (default: alpha decrease) 
		 */
		public static function createParticle
			(img:BitmapData, rX:int, rY:int, rW:int, rH:int,
			x:int, y:int, velX:Number, velY:Number,
			duration:uint, color:int = 0xFFFFFF, scale:Number = 1,
			moveBehavior:Function = null, sizeBehavior:Function = null, colorBehavior:Function = null):void 
		{
			var particle:Particle;
			if (particleList.numActive == particleList.capacity())
			{
				particle = particleList.getP(0);
				particleList.setStart( particleList.getStart() + 1);
			}
			else 
			{
				particle = particleList.getP(particleList.numActive);
				particleList.numActive++;
			}
			
			particle.srcImage = img;
			particle.rect.x = rX;
			particle.rect.y = rY;
			particle.rect.width = rW;
			particle.rect.height = rH;
			
			// test for bitmapData size difference
			var bitmapData:BitmapData = particle.bitmap.bitmapData;
			if (rW != bitmapData.width || rH != bitmapData.height)
				particle.bitmap.bitmapData = new BitmapData(rW, rH);
			
			particle.x = x;
			particle.y = y;
			particle.velocityX = particle.origVelX = velX;
			particle.velocityY = particle.origVelY = velY;
			particle.duration = duration;
			particle.scale = scale;
			particle.color = color;
			particle.percentLife = 1.0;
			
			if (moveBehavior == null)
				particle.moveBehavior = moveStandard;
			else
				particle.moveBehavior = moveBehavior;
				
			if (sizeBehavior == null)
				particle.sizeBehavior = sizeStandard;
			else
				particle.sizeBehavior = sizeBehavior;
				
			if (colorBehavior == null)
				particle.colorBehavior = colorStandard;
			else
				particle.colorBehavior = colorBehavior;
		}
		
		public static function update():void 
		{
			bitmapData.fillRect(bitmapRect, 0);
			var removalCount:uint = 0;
			for (var i:uint = 0; i < particleList.numActive; i++) 
			{
				var p:Particle = particleList.getP(i);
				
				// update particle code here
				p.update(bitmapData);
				
				swap(particleList, i - removalCount, i);
				
				if (p.percentLife <= 0)
					removalCount++;
			}
			particleList.numActive -= removalCount;
		}
		
		private static function swap(list:CircularParticleArray, index1:uint, index2:uint):void 
		{
			const temp:Particle = list.getP(index1);
			list.setP(index1, list.getP(index2));
			list.setP(index2, temp);
		}
		
		public static function moveStandard(p:Particle):void 
		{
			p.x += p.velocityX;
			p.y += p.velocityY;
			p.velocityX *= p.friction;
			p.velocityY *= p.friction;
			
			p.point.x = p.x /*+ Math.random() * 3 * ParticleManager.randomSign()*/;
			p.point.y = p.y /*+ Math.random() * 3 * ParticleManager.randomSign()*/;
			
			if (Math.abs(p.velocityX) < 1)
			{				
				p.velocityX = 1 * (p.origVelX / Math.abs(p.origVelX));
			}
			if (Math.abs(p.velocityY) < 1)
			{				
				p.velocityY = 1 * (p.origVelY / Math.abs(p.origVelY));;
			}
		}
		
		public static function moveGravity(p:Particle):void 
		{
			p.x += p.velocityX;
			p.y += p.velocityY;
			p.velocityX *= p.friction;
			p.velocityY += 0.7;
			
			p.point.x = p.x/* + Math.random() * 3 * ParticleManager.randomSign()*/;
			p.point.y = p.y/* + Math.random() * 3 * ParticleManager.randomSign()*/;
			
			if (Math.abs(p.velocityX) < 0.1)
				p.velocityX = 0.1;
			if (Math.abs(p.velocityY) < 0.1)
				p.velocityY = 0.1;
		}
		
		public static function sizeStandard(p:Particle):void 
		{
			
		}
		
		public static function sizeShrink(p:Particle):void 
		{
			// scale down by contracting rect dimensions, works only for rect particles
			p.rect.width = Math.round(p.rect.width * p.scale);
			p.rect.height = Math.round(p.rect.height * p.scale);
			p.scale = p.percentLife;
		}
		
		public static function colorStandard(p:Particle):void 
		{
			//p.color = mergeRGB(Math.random() * 255, Math.random() * 255, Math.random() * 255);
			//p.alpha = Math.random();
			p.alpha = p.percentLife;
		}
		
		private static function mergeRGB(r:uint, g:uint, b:uint):uint 
		{
			return ((r << 16) | (g << 8) | b);
		}
		
		public static function purge():void 
		{
			bitmapData.dispose();
		}
		
	}

}