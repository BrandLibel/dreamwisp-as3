package dreamwisp.audio 
{
	//import com.demonsters.debugger.MonsterDebugger;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import org.osflash.signals.Signal;
	
	/**
	 * Static class that manages audio.
	 * Audio can be played as a one-time sound or music that loops and fades.
	 * @author Brandon
	 */
	
	public class SoundSystem 
	{
		private static var channel:SoundChannel = new SoundChannel();
		private static var transform:SoundTransform = new SoundTransform();
		/// The master volume for all audio in the game
		private static var _volume:Number = 1;
		private static var mutedSound:Boolean = false;
		private static var mutedMusic:Boolean = false;
		
		private static var currentMusic:Music;
		private static var pendingMusic:Music;
		private static const DEFAULT_FADE_TIME:Number = 2000;
		
		public static var volumeChanged:Signal = new Signal(Number);
		public static var muteToggled:Signal = new Signal(Boolean, Boolean);
		
		public function SoundSystem() 
		{
			
		}
		
		public static function play(sound:Sound, volume:Number = 1, onComplete:Function = null):void 
		{
			if (mutedSound) return;
			
			transform.volume = volume * SoundSystem.volume;
			channel = sound.play(0, 0, transform);
			
			if (onComplete == null) return;
			channel.removeEventListener(Event.SOUND_COMPLETE, onComplete);
			channel.addEventListener(Event.SOUND_COMPLETE, onComplete);
		}
		
		public static function playMusic(music:Sound, volume:Number = 1, fadeTime:Number = DEFAULT_FADE_TIME):void 
		{
			if (currentMusic == null)
				setCurrentMusic(new Music(volume, music));
			else if (music != currentMusic.sound)
			{
				pendingMusic = new Music(volume, music);
				currentMusic.fadeOut(fadeTime, playNextMusic);
			}
		}
		
		private static function setCurrentMusic(music:Music):void 
		{
			currentMusic = music;
			if (mutedMusic) return;
			currentMusic.play();
		}
		
		private static function playNextMusic():void 
		{
			currentMusic.purge();
			setCurrentMusic(pendingMusic);
		}
		
		public static function setMuteSound(muted:Boolean):void 
		{
			if (mutedSound == muted) return;
			mutedSound = muted;
			muteToggled.dispatch(mutedSound, mutedMusic);
		}
		
		public static function setMuteMusic(muted:Boolean):void 
		{
			if (mutedMusic == muted) return;
			mutedMusic = muted;
			muteToggled.dispatch(mutedSound, mutedMusic);
			
			if (mutedMusic)
				currentMusic.stop();
			else if (!mutedMusic)
				currentMusic.play(); // restart the music playing before the mute
		}
		
		public static function toggleMuteSound():void 
		{
			setMuteSound(!mutedSound);
		}
		
		public static function toggleMuteMusic():void 
		{
			setMuteMusic(!mutedMusic);
		}
		
		public static function stop():void 
		{
			SoundMixer.stopAll();
		}
		
		public static function isMutedSound():Boolean { return mutedSound; }
		public static function isMutedMusic():Boolean { return mutedMusic; }
		
		static public function get volume():Number { return _volume; }
		static public function set volume(value:Number):void
		{
			_volume = value;
			volumeChanged.dispatch(_volume);
		}
		
	}

}