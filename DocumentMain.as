package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	
	
	public class DocumentMain extends MovieClip {
		//Declare variables
		private var _ball:Ball;
		private var _paddle:Paddle;
		var Bricks:Array; //array that will contain Brick() objects
		private const BALL_RADIUS = 20;
		private const PADDLE_WIDTH = 90;
		
		var _bx:Number; //ball horizontal velocity
		var _by:Number; //ball vertical velocity
		
		var _px:Number; //paddle horizontal velocity
		
		public function DocumentMain() {
			//Initialize ball
			_ball = new Ball;
			_ball.x = stage.stageWidth/2;
			addChild(_ball);
			
			//Initialize paddle
			_paddle = new Paddle;
			addChild(_paddle);
			
			//Set up brick array
			Bricks = new Array(10);
			
			//Set up everything for new game
			init();
			
			//add event listeners
			stage.addEventListener(Event.ENTER_FRAME, enterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
			
			
		}
		
		private function init(){
			//Set ball visibility and startingposition
			_ball.visible=true
			_ball.x = stage.stageWidth/2;
			_ball.y = stage.stageHeight/2;
			
			//Set paddle visibility and starting position
			_paddle.visible = true;
			_paddle.x = stage.stageWidth/2;
			_paddle.y = stage.stageHeight - 40;
			
			//Set starting velocities
			_bx = 5;
			_by = 5;
			_px = 0;
			
			buildBricks();
		}
		
		function enterFrame(event:Event):void{
			//things to happen per frame
			
			//check collisions
			paddleHit();
			brickHit();
			stageHit();
			
			//move the ball
			_ball.x += _bx;
			_ball.y += _by;
			
			//limit paddle speed
			if(_px > 10){
				_px = 10;
			}
			else if(_px < -10){
				_px = -10;
			}
			
			//move the paddle
			_paddle.x += _px;
			
		}
		
		private function onKeyPress(keyEvent:KeyboardEvent){
			var key:uint = keyEvent.keyCode;
			if(key == Keyboard.LEFT){
				_px -= 5;
			}
			else if(key ==Keyboard.RIGHT){
				_px += 5;
			}
		}
		
		private function onKeyRelease(keyEvent:KeyboardEvent){
			var key:uint = keyEvent.keyCode;
			if(key == Keyboard.LEFT){
				_px = 0;
			}
			else if(key ==Keyboard.RIGHT){
				_px = 0;
			}
		}
		
		//fills Bricks[] array with Brick() objects and adds them to the stage
		function buildBricks(){
			for(var i:int = 0; i< 11; i++){
				Bricks[i] = new Brick();
				Bricks[i].x = i*50;
				Bricks[i].y = 0;
				addChild(Bricks[i]);
			}
		}
		
		function paddleHit(){
			//tests hit test on paddle vs. bottom of ball, but only if the ball is going to hit the top of the paddle
			if(_ball.y <= _paddle.y){	
				if(_paddle.hitTestPoint(_ball.x, _ball.y) || _paddle.hitTestPoint(_ball.x, _ball.y-BALL_RADIUS)){
					_by = -_by;
					_bx = (_ball.x - _paddle.x)/8;
				}
			}
		}
		
		function brickHit(){
			//goes through Bricks array and checks hit on every brick
			for(var i:int = 0; i < 11; i++){
				if(Bricks[i] != null){	
					if((Bricks[i].hitTestPoint(_ball.x, _ball.y-BALL_RADIUS)) || Bricks[i].hitTestPoint(_ball.x, _ball.y)){
						_by = -_by;
						removeChild(Bricks[i]);
						Bricks[i] = null;
					}
					if (Bricks[i].hitTestPoint(_ball.x-BALL_RADIUS/2, _ball.y-BALL_RADIUS/2) || Bricks[i].hitTestPoint(_ball.x+BALL_RADIUS/2, _ball.y-BALL_RADIUS/2)){
						_bx = -_bx;
						removeChild(Bricks[i]);
						Bricks[i] = null;
					}
				}
			}
		}
		function stageHit(){
			//check if ball is off the stage
			
			//check right side
			if(_ball.x + BALL_RADIUS/2 > stage.stageWidth){
				_ball.x = stage.stageWidth - BALL_RADIUS/2
				_bx = -_bx;
			}
			//check left side
			else if (_ball.x - BALL_RADIUS/2 < 0){
				_ball.x = 0 + BALL_RADIUS/2;
				_bx = -_bx;
			}
			//check top
			if(_ball.y - BALL_RADIUS < 0){
				_ball.y = 0 + BALL_RADIUS;
				_by = -_by
			}
			if(_paddle.x - PADDLE_WIDTH/2 < 0){
				_paddle.x = 0 + PADDLE_WIDTH/2;
			}
			else if(_paddle.x + PADDLE_WIDTH/2 > stage.stageWidth){
				_paddle.x = stage.stageWidth - PADDLE_WIDTH/2;
			}
		}
	}
}
