package
{
	import org.flixel.FlxButton;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxParticle;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	import org.flixel.plugin.photonstorm.FlxColor;

	public class PlayState extends FlxState
	{
		[Embed(source="trophy.png")] public var trophyRaw:Class;
		
		public var player:FlxSprite;
		public var monster:FlxSprite;
		public var trophy:FlxSprite;
		public var platform1:FlxSprite;
		public var platform2:FlxSprite;
		
		public var monsterEmitter:FlxEmitter;
		
		public var platformGroup:FlxGroup;
		public var particleGroup:FlxGroup;
		
		public var newParticleGroup:FlxGroup;
		
		
		public var txtPixelCount:FlxText;
		public var txtYouWin:FlxText;
		
		public var pixelCount:int;
		
		public var isJumping:Boolean = false;
		
		public function PlayState()
		{
		
		}
		
		override public function create():void
		{	
			platformGroup = new FlxGroup();
			particleGroup = new FlxGroup();
			newParticleGroup = new FlxGroup();
			
			add( platformGroup );
			add( newParticleGroup );
			
			pixelCount = 0;
			
			player = new FlxSprite( 0, 0 );
			player.acceleration.y = 200;
			player.velocity.y = -50;
			player.makeGraphic( 30, 30 );
			add( player );
			
			monster = new FlxSprite( player.width + 50, 0 );
			monster.acceleration.y = 200;
			monster.acceleration.x = 0;
			monster.makeGraphic( 30, 30 );
			add( monster );
			
			trophy = new FlxSprite(player.width + 370, 0, trophyRaw );
			trophy.acceleration.y = 700;
			trophy.acceleration.x = 0;
			add( trophy );
			
			
			platform1 = new FlxSprite( 0, 500 );
			platform1.immovable = true;
			platform1.makeGraphic( FlxG.stage.width / 2 - 60, 500 );
			platform1.allowCollisions = FlxObject.UP;
			platformGroup.add( platform1 );
			
			platform2 = new FlxSprite( platform1.width + 130, 600 );
			platform2.immovable = true;
			platform2.makeGraphic( FlxG.stage.width, 500 );
			platform2.allowCollisions = FlxObject.UP;
			platformGroup.add( platform2 );
			
			txtYouWin = new FlxText( FlxG.stage.width / 2, 200, 200, "" );
			txtYouWin .size = 11;
			add( txtYouWin  );
			
			txtPixelCount = new FlxText( 0, 0, 200, "Pixel Count: 0" );
			txtPixelCount.size = 11;
			add( txtPixelCount );
			
			monsterEmitter = new FlxEmitter( 0, 0, 100 );
			monsterEmitter.gravity = 200;
			monsterEmitter.lifespan = 0;
			monsterEmitter.bounce = 0.8;
			
			add( monsterEmitter );
		
	
			for( var i:int = 0; i < 100; i++ )
			{
				var particle:FlxParticle = new FlxParticle();
				particle.makeGraphic( 5, 5, 0xFF0000FF );
			
				particleGroup.add( particle );
				monsterEmitter.add( particle );
			}
			
			var btnReset:FlxButton = new FlxButton(FlxG.stage.width - 100, 0, "Reset", function():void
			{
				FlxG.switchState( new PlayState() );
			});
			
			add( btnReset );
	
			FlxG.mouse.show();
		}
		
		override public function update():void
		{
			super.update();
			
			txtPixelCount.text = "Pixel Count: " + pixelCount.toString();
			
			updatePlayer();
			
			FlxG.collide( player, platformGroup );
			FlxG.collide( player, newParticleGroup );
			FlxG.collide( particleGroup, platformGroup );
			FlxG.collide( monster, platformGroup );
			FlxG.collide( trophy, platformGroup );
			
			if( FlxG.collide( player, monster ) )
			{
				monster.kill();
				monsterEmitter.at( monster );
				monsterEmitter.start();
			}
			
			if( FlxG.collide( player, trophy ) )
			{
				trophy.kill();
				txtYouWin.text = "YOU WIN!";
			}
			
			FlxG.collide( player, particleGroup, function( me:FlxObject, particle:FlxObject ):void
			{
				particle.kill();
				pixelCount++;
			} );
			
			if( FlxG.mouse.justReleased() )
			{
				if( pixelCount > 0 ) 
				{
					pixelCount--;
					
					var newParticle:FlxSprite = new FlxSprite( FlxG.mouse.screenX, FlxG.mouse.screenY );
					newParticle.immovable = true;
					newParticle.makeGraphic( 5, 5, 0xFF0000FF );
					
					newParticleGroup.add( newParticle );
				}	
			}
			
			
		}
		
		public function updatePlayer():void
		{
			
			if(player.y > FlxG.stage.height + 100 )
			{
				FlxG.switchState( new PlayState() );
			}
			
			/*
			if(FlxG.keys.justPressed( "UP" ))
			{
				isJumping = true;	
			}
			
			if( isJumping && player.isTouching( FlxObject.UP ) != true )
			{
				player.y = player.velocity.y;
			}
			else
			{
				isJumping = false;
			}
			
			*/
			
			if(FlxG.keys.RIGHT)
			{
				player.velocity.x = 50;	
			}
			else if(FlxG.keys.LEFT)
			{
				player.velocity.x = -50;	
			}
			else
			{
				player.velocity.x = 0;	
			}
		}
		
	}
}