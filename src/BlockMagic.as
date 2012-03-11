package
{
	import flash.net.SharedObject;
	
	import org.flixel.*;
	
	[SWF(width="480", height="640", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	//two hours twenty two minutes
	public class BlockMagic extends FlxGame
	{
		public function BlockMagic() 
		{
			super( 480,640,PlayState );
		}
	}
}
