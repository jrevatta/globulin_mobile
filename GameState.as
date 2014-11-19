package 
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import MobileHero;
	
	import aze.motion.eaze;
	
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingState;
	import citrus.input.controllers.Accelerometer;
	import citrus.input.controllers.Keyboard;
	import citrus.input.controllers.starling.VirtualButton;
	import citrus.input.controllers.starling.VirtualJoystick;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.Mobile;
	import citrus.utils.objectmakers.ObjectMaker2D;
	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.starlingview.StarlingCamera;
	
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;

	
	/**
	 * @author jrevatta
	 */
	
	public class GameState extends  StarlingState
	{
		
		
		private var ce:CitrusEngine;
		private var kb:Keyboard;
		
		private var al:Accelerometer;
		
		[Embed(source="assets/run_final.png")]
		private var heroAnimBitmap:Class;
		
		[Embed(source="assets/run_final.xml",mimeType="application/octet-stream")]
		private var heroAnimXML:Class;

		[Embed(source="assets/bacteria_0_new.png")]
		private var bacteria:Class;
		
		[Embed(source="assets/mapa7.tmx", mimeType="application/octet-stream")]
		private var tileMap:Class;
		
		[Embed(source="assets/tilemap_06.png")]
		private var tileView:Class;

		
		[Embed(source="assets/moneda.png")]
		private var moneda:Class;

		[Embed(source="assets/marco_m2.png")]
		public static const box:Class;
		
	
		[Embed(source="assets/bg_m.png")]
		public static const bg:Class;
		
			
		
		//variables
		
		private var velocity:int;
		private var clicked:Boolean;
		private var gameOver:Boolean = false;
		
		//variables para extender Hero
		
		private var _hp:uint = 30;
		private var _hitdamage:uint = 5;
		private var _puntaje:uint = 0;
		
		//parametros enemigos
		private var _num_enemy:uint = 5
		private var _num_position:uint = 0
			
		//textos en pantalla de juego
		private var scoreText:TextField = new TextField(300, 50, "vida:" + String(_hp), "Verdana", 20, Color.WHITE);

		private var textWin:TextField = new TextField(300, 50, "", "Verdana", 20, Color.WHITE);;
		
		private var hero:MobileHero;
		
		private var _myenemies:Array = new Array();
		private var TouchEvent:Object;
		
		public function GameState()
		{
			super();
			//var objects:Array = [Hero, Platform, Enemy, Coin];
			var objects:Array = [Platform, Enemy, Coin];
		}
		

			
		override public function initialize(): void
		{
			super.initialize();
			

			ce = CitrusEngine.getInstance();
			
			
			ce.sound.addSound("whoosh", {sound:"assets/whoosh.mp3"});
			
			ce.sound.addSound("ding", {sound:"assets/ding.mp3"});
			
			ce.sound.addSound("smack", {sound:"assets/smack.mp3"});
			
			ce.sound.addSound("BMG", { sound:"assets/pistagame.mp3" , permanent: true, loops:int.MAX_VALUE, timesToPlay:-1});

			
			//control para desktop
			kb = ce.input.keyboard;
			kb.addKeyAction("move", Keyboard.SPACE);	
			
			//control para mobile
	
			
			drawScreen();
			
		}
		
	
		
		private function drawScreen():void
		{
			


			var background:Image = Image.fromBitmap(new bg());
				
			background.x = 0;
			background.y = 0;
			background.width = 1024;
			background.height = 768;
			addChild(background);
			
			var marco:Image = Image.fromBitmap(new box());
			marco.width = 300;
			marco.height = 200;
			marco.x = 240;
			marco.y = 0;
			addChild(marco);
				

			
			var textField:TextField = new TextField(200, 200, "Globulin Game", "Flappy", 20, Color.NAVY);
			textField.x = 300;
			textField.y = -200;
			
			
			addChild(textField);
			
			var textField2:TextField = new TextField(200, 300, "Clic para iniciar.", "Flappy", 20, Color.NAVY);
			textField2.x = 300;
			textField2.y = -220;
			
			
			addChild(textField2);
			
			var textField3:TextField = new TextField(200, 400, "Créditos: J. Alvarado | O.Alfaro", "Flappy", 14, Color.NAVY);
			textField3.x = 300;
			textField3.y = -240;
			
			
			addChild(textField3);
			
			// box and textField have synced tweens
			eaze(marco).to(0.4, { y: 220 } );
			
			eaze(textField).to(0.4, { y: 180 } );
			
			eaze(textField2).to(0.4, { y: 180 } );
			
			eaze(textField3).to(0.4, { y: 180 } );
			
			ce.stage.addEventListener(MouseEvent.MOUSE_DOWN, start);
						
			
			function start(e:MouseEvent):void
			{
				eaze(marco).to(0.2, { y: -200 } );
				eaze(textField).to(0.2, { y: -200 } );
				newGame();
				removeChild(marco);
				removeChild(textField);
				removeChild(background);
				removeChild(textField2);
				removeChild(textField3);
				ce.stage.removeEventListener(MouseEvent.MOUSE_DOWN, start);
			}
			
		}
		
		private function randRange(min:Number, max:Number):Number {
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
			return randomNum;
		}
		
		private function newEnemies():void {
			
			//enemigo en plataforma
			var name_one:String = String("enemy_one");
			var enemy_one :Enemy =  new Enemy(name_one);
			
			
			enemy_one.view = new bacteria();
			enemy_one.leftBound = 100;
			enemy_one.rightBound = 1000;
			enemy_one.x = 190;
			enemy_one.y = 40;
			
			add(enemy_one);
			_myenemies.push(name_one);
			
			//enemigo en plataforma
			name_one = String("enemy_two");
			enemy_one = new Enemy(name_one);
			enemy_one.view = new bacteria();
			enemy_one.leftBound = 100;
			enemy_one.rightBound = 1000;
			enemy_one.x = 565;
			enemy_one.y = 232;
			
			add(enemy_one);
			_myenemies.push(name_one);
			
			
			var totalEnemies:uint = 5;
			
			//enemigos varios
			for (var i:uint =0; i<= totalEnemies; i++){

				var numEnemy:Number = randRange(1,100);
				
				name = "enemy" + String(numEnemy);
				var enemy :Enemy =  new Enemy(name);
				
				
				enemy.view = new bacteria();
				enemy.leftBound = 100;
				enemy.rightBound = 1000;
				enemy.x =300 + numEnemy;
				enemy.y = 380;
				
				add(enemy);
				_myenemies.push(name);
				
			}

			
		
		}
		
		private function newGame():void{
			
			clicked = true;
			
			var physics: Box2D = new Box2D("box2d");			
			add(physics);
			
			
			var bitmapView:Bitmap = new tileView();
			bitmapView.name = "tilemap_06.png";
			
			ObjectMaker2D.FromTiledMap(XML(new tileMap()),[bitmapView]);
			
			//var hero:Hero = getObjectByName("hero") as Hero;
			
			//hero = new Hero("hero");
			
			hero = new MobileHero("hero");
			hero.x = 235;
			hero.y = 215;
			hero.jumpHeight = 12;
			

			
			var ta:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new heroAnimBitmap()),XML(new heroAnimXML()));
			var animationSeq:AnimationSequence = new AnimationSequence(ta,["hurt","idle","jump","walk","duck", "ascent","descent","fly","reverse"],"idle",24);			
			hero.view = animationSeq;
		
			add(hero);
			
			if (Mobile.isAndroid()) {
				
				var vj:VirtualJoystick = new VirtualJoystick("joy",{radius:80});
				vj.x = 100;
				vj.y = 400;
				vj.circularBounds = true;
				
				var button:VirtualButton = new VirtualButton("button",{buttonAction:"jump", buttonradius:40});
				button.x = 360;
				button.y = 400;
			}
			
			
			//generador de enemigos
			newEnemies();

			var coin:Coin = getObjectByName("coin") as Coin;
			coin.view = new moneda();
			
			var enemy:Enemy = getObjectByName("enemy") as Enemy;
			enemy.view = new bacteria();
			_myenemies.push("enemy");
			
			scoreText.hAlign = "right";
			scoreText.x = 10;
			scoreText.y = -10;
			addChild(scoreText);
		
			
		//	hero.enemyClass = enemy;
		
		//evento para crear lógica cuando el hero es atacado.
			hero.onTakeDamage.add(heroHurt);
			hero.onGiveDamage.add(heroDamage);
			hero.onAnimationChange.add(heroMove);		
			
			
			//activar musica de fondo
			ce.sound.playSound("BMG");

			coin.onBeginContact.add(function(c:b2Contact):void{
				
				//revisar como mostrar texto

				ce.sound.playSound("ding");
				
				var s: String = "¡Your Win!";
				ce.sound.stopAllPlayingSounds();
				camera.target = null;
				gameover(s);
			});
			
			//configurar camara
			if (hero != null){
				var camera:StarlingCamera;
				camera = view.camera as StarlingCamera;
				camera.setUp(hero, new Rectangle(0,0, 1280, 480), new Point(.5,.5), new Point(.2, .2));
				camera.target = hero;
			}
						
			
		}
		
		private function heroMove(): void {
			if (hero!= null) {
				if (hero.x <=0) hero.x = 10;
				if (hero.x >= 1260) hero.x = 1260;			
			}
		}
		
		//función para decrecer la vida del heroe
		private function heroHurt():void {
		
			if (_hp - _hitdamage > 0){
				_hp -= _hitdamage;
			}
			else if (_hp - _hitdamage <=0) {
				_hp = 0;
				gameOver = true;

			}
			
			
			ce.sound.playSound("smack");
			var newscore:String = "vida:" + String(_hp);
			scoreText.text = newscore;
			scoreText.hAlign = "right";
			scoreText.x = 10;
			scoreText.y = 10;

			
		}
		
		private function heroDamage(): void {

			ce.sound.playSound("whoosh");
			_puntaje +=5;
			
		}
		
		
		
		public function move(e:MouseEvent):void
		{
			
			velocity = -7;
			ce.sound.playSound("whoosh");
			
		}
		
		override public function update(timeDelta:Number):void{
			

				super.update(timeDelta);
				//aqui controlamos los limites del escenario.
				
			
				if (gameOver == true){
					
					var s: String = "¡Game Over!";
					ce.sound.stopAllPlayingSounds();
					camera.target = null;
					gameover(s);
				}				

				
				
				if (hero!= null) {
					if (hero.x <=0) {
						hero.x = 10;
					}
					
					if (hero.x >= 1260) {
						hero.x = 1260;
					
					}	
					
					if (hero.y <=0) {
						hero.y = 5;
					}
					
					if (hero.y >= 830) {
						hero.y = 810;
						
					}	
					
					
					
				}
				
				
			}

		
		private function gameover(s:String):void {
			ce.playing = false;	
			gameOver = false;
			var marco:Image = Image.fromBitmap(new box());
			marco.width = 300;
			marco.height = -200;
			marco.x = 240;
			marco.y = -100;
			addChild(marco);
			
			var textField:TextField = new TextField(200, 200, s, "Flappy", 20, Color.NAVY);
			textField.x = 300;
			textField.y = -200;

			var textField2:TextField = new TextField(200, 200, "Jugar de nuevo", "Flappy", 20, Color.NAVY);
			textField2.x = 300;
			textField2.y = -220;
			
			var textField3:TextField = new TextField(200, 200, "Puntaje: "  + String(_puntaje), "Flappy", 20, Color.NAVY);
			textField3.x = 300;
			textField3.y = -230;

			
			addChild(textField);
			addChild(textField2);
			addChild(textField3);
			
			eaze(marco).to(0.4, { y: 380 } );
			
			eaze(textField).to(0.4, { y: 170 } );
			
			eaze(textField2).to(0.4, { y: 190 } );
			
			eaze(textField3).to(0.4, { y: 210 } );
			
			ce.stage.addEventListener(MouseEvent.MOUSE_DOWN, startAgain);
			
			
			function startAgain(e:MouseEvent):void
			{
				eaze(marco).to(0.2, { y: -200 } );
				eaze(textField).to(0.2, { y: -200 } );
				resetGame();
				removeChild(marco);
				removeChild(textField);
				removeChild(textField2);
				removeChild(textField3);
				ce.stage.removeEventListener(MouseEvent.MOUSE_DOWN, startAgain);
			}
			
		}

		private function resetGame():void{
			
			for (var i:int = 0; i < _myenemies.length; i++){
					var killEnemy:Enemy;
					killEnemy = getObjectByName(_myenemies[i]) as Enemy;
					
					if (killEnemy != null){
						killEnemy.kill = true;
					}
			}
			
			//reiniciar contador
			_hp = 30;
			_puntaje = 0;
			if (hero != null){
				hero.kill = true;
			}
			
			//hero = new Hero("hero");
			hero = new MobileHero("hero");
			
			
			hero.x = 235;
			hero.y = 215;
			hero.jumpHeight = 12;
			
			
			var ta:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new heroAnimBitmap()),XML(new heroAnimXML()));
			var animationSeq:AnimationSequence = new AnimationSequence(ta,["hurt","idle","jump","walk", "duck", "ascent","descent","fly","reverse"],"idle",24);			
			hero.view = animationSeq;
			
			add(hero);
						
			
			//evento para crear lógica cuando el hero es atacado.
			hero.onTakeDamage.add(heroHurt);
			hero.onGiveDamage.add(heroDamage);
			hero.onAnimationChange.add(heroMove);		

			
			var coin:Coin = getObjectByName("coin") as Coin;
			
			if (coin == null) {
				
				coin = new Coin("coin");
				coin.x = 71;
				coin.y = 34;
				coin.view = new moneda();
			}
			
			newEnemies()
			
			textWin.text = "";
			scoreText.text = "vida: " + String(_hp);
			_puntaje = 0;
			
			camera.setUp(hero, new Rectangle(0,0, 1280, 480), new Point(.5,.5), new Point(.2, .2));
			camera.target = hero;
			
			ce.sound.playSound("BMG");
			ce.playing = true;
			
		}
	}
}
		
		
	
	


	


		