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
		private static var muteSound:Boolean = false;
		private static var muteMusic:Boolean = false;
		
		private static var currentMusic:Music;
		private static var pendingMusic:Music;
		
		private static const DEFAULT_FADE_TIME:Number = 2000;
		
		public function SoundSystem() 
		{
			
		}
		
		public static function play(sound:Sound, volume:Number = 1):void 
		{
			if (muteSound) return;
			
			transform.volume = volume * SoundSystem.volume;
			channel = sound.play(0, 0, transform);
		}
		
		public static function playMusic(sound:Sound, volume:Number = 1, fadeTime:Number = DEFAULT_FADE_TIME):void 
		{
			if (currentMusic == null)
				setCurrentMusic(new Music(volume, sound));
			else if (sound != currentMusic.sound)
			{
				pendingMusic = new Music(volume, sound);
				currentMusic.fadeOut(fadeTime, playNextMusic);
			}
		}
		
		private static function setCurrentMusic(music:Music):void 
		{
			if (muteMusic) return;
			currentMusic = music;
			music.play();
		}
		
		private static function playNextMusic():void 
		{
			currentMusic.purge();
			stop();
			setCurrentMusic(pendingMusic);
		}
		
		public static function toggleMuteSound():void 
		{
			muteSound = !muteSound;
		}
		
		public static function toggleMuteMusic():void 
		{
			muteMusic = !muteMusic;
			stop();
			// resume the music playing before the mute
			if (!muteMusic)
				currentMusic.play();
		}
		
		public static function stop():void 
		{
			SoundMixer.stopAll();
		}
		
	}

}