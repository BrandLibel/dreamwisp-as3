package dreamwisp.audio 
{
	import com.demonsters.debugger.MonsterDebugger;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * A piece of sound that can fade out and has its own channel and transform.
	 * @author Brandon
	 */
	
	internal class Music 
	{
		private var startVolume:Number = 1;
		internal var sound:Sound;
		
		private var channel:SoundChannel;
		private var transform:SoundTransform;
		
		private var timer:Timer;
		private static const TIME_INTERVAL:Number = 200;
		
		public function Music(startVolume:Number, sound:Sound) 
		{
			this.startVolume = startVolume;
			this.sound = sound;
			transform = new SoundTransform();
			
			timer = new Timer(TIME_INTERVAL);
			timer.addEventListener(TimerEvent.TIMER, fadeTick);
		}
		
		internal function play():void 
		{
			volume = startVolume;
			channel = sound.play(0, int.MAX_VALUE, transform);
		}
		
		/**
		 * Starts fading out the audio
		 * @param	time Length of fade out in milliseconds
		 */
		internal function fadeOut(time:Number, onFinish:Function):void 
		{
			timer.start();
			fadeDuration = time;
			onFinishFade = onFinish;
		}
		
		private var time:Number = 0;
		private var fadeDuration:Number = 0;
		private var onFinishFade:Function;
		private function fadeTick(e:TimerEvent):void 
		{
			time += TIME_INTERVAL;
			volume = startVolume - (startVolume * (time / fadeDuration));
			channel.soundTransform = transform;
			
			if (time >= fadeDuration)
				onFinishFade.call();
		}
		
		internal function purge():void 
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, fadeTick);
			timer = null;
		}
		
		internal function stop():void 
		{
			channel.stop();
			if (onFinishFade != null) onFinishFade.call();
		}
		
		internal function get volume():Number { return transform.volume; }
		internal function set volume(value:Number):void 
		{ 
			transform.volume = value * SoundSystem.volume;
		}
		
	}

}