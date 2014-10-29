package dreamwisp.audio 
{
	import com.demonsters.debugger.MonsterDebugger;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
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
		public static var volume:Number = 1;
		private static var mutedSound:Boolean = false;
		private static var mutedMusic:Boolean = false;
		
		private static var currentMusic:Music;
		private static var pendingMusic:Music;
		
		private static const DEFAULT_FADE_TIME:Number = 2000;
		
		public function SoundSystem() 
		{
			
		}
		
		public static function play(sound:Sound, volume:Number = 1):void 
		{
			if (mutedSound) return;
			
			transform.volume = volume * SoundSystem.volume;
			channel = sound.play(0, 0, transform);
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
			music.play();
		}
		
		private static function playNextMusic():void 
		{
			currentMusic.purge();
			setCurrentMusic(pendingMusic);
		}
		
		public static function toggleMuteSound():void 
		{
			mutedSound = !mutedSound;
		}
		
		public static function toggleMuteMusic():void 
		{
			mutedMusic = !mutedMusic;
			
			if (mutedMusic)
				currentMusic.stop();
			else if (!mutedMusic)
				currentMusic.play(); // restart the music playing before the mute
		}
		
		public static function stop():void 
		{
			SoundMixer.stopAll();
		}
		
	}

}