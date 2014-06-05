package edu.ewu.components.player 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.TweenMax;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import com.natejc.utils.StageRef;
	import edu.ewu.components.attacks.Attack;
	import edu.ewu.components.attacks.BurgerKingBasicAttack;
	import edu.ewu.components.attacks.BurgerKingChargedAttack;
	import edu.ewu.components.attacks.BurgerKingRangedAttack;
	import edu.ewu.components.attacks.ColonelSandersBasicAttack;
	import edu.ewu.components.attacks.ColonelSandersChargedAttack;
	import edu.ewu.components.attacks.ColonelSandersChargedSubAttack;
	import edu.ewu.components.attacks.ColonelSandersRangedAttack;
	import edu.ewu.components.attacks.JackBasicAttack;
	import edu.ewu.components.attacks.JackChargedAttack;
	import edu.ewu.components.attacks.JackRangedAttack;
	import edu.ewu.components.attacks.PapaJohnBasicAttack;
	import edu.ewu.components.attacks.PapaJohnChargedAttack;
	import edu.ewu.components.attacks.PapaJohnRangedAttack;
	import edu.ewu.components.attacks.RonaldMcDonaldBasicAttack;
	import edu.ewu.components.attacks.RonaldMcDonaldChargedAttack;
	import edu.ewu.components.attacks.RonaldMcDonaldRangedAttack;
	import edu.ewu.components.attacks.WendyBasicAttack;
	import edu.ewu.components.attacks.WendyChargedAttack;
	import edu.ewu.components.attacks.WendyRangedAttack;
	import edu.ewu.components.collectables.Burger;
	import edu.ewu.components.collectables.Collectable;
	import edu.ewu.components.collectables.Jalepeno;
	import edu.ewu.components.collectables.Soda;
	import edu.ewu.components.Collideable;
	import edu.ewu.components.CollisionManager;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.SoundManager;
	import edu.ewu.ui.screens.ScreenManager;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;

	/**
	 * ...
	 * @author Jon Roster
	 */
	public class LocalPlayer extends Player
	{
		/** The last x position of the player if they have moved. */
		protected var	_nLastX:uint;
		/** The last y position of the player if they have moved. */
		protected var	_nLastY:uint;
		private var _left:Boolean = false;
		private var _right:Boolean = false;
		private var _up:Boolean = false;
		private var _down:Boolean = false;
		private var _heartbeatTimer:Timer;
		private var _bSentInitial:Boolean = false;
		

		/** List of attacks for the compiler */
		private var _attack:Attack;
		
		private var _rmdBasicAttack:RonaldMcDonaldBasicAttack;
		private var _rmdRangedAttack:RonaldMcDonaldRangedAttack;
		private var _rmdChargedAttack:RonaldMcDonaldChargedAttack;

		private var _bkBasicAttack:BurgerKingBasicAttack;
		private var _bkRangedAttack:BurgerKingRangedAttack;
		private var _bkChargedAttack:BurgerKingChargedAttack;
		
		private var _wBasicAttack:WendyBasicAttack;
		private var _wRangedAttack:WendyRangedAttack;
		private var _wChargedAttack:WendyChargedAttack;
		
		private var _jBasicAttack:JackBasicAttack;
		private var _jRangedAttack:JackRangedAttack;
		private var _jChargedAttack:JackChargedAttack;
		
		private var _pBasicAttack:PapaJohnBasicAttack;
		private var _pRangedAttack:PapaJohnRangedAttack;
		private var _pChargedAttack:PapaJohnChargedAttack;
		
		private var _cBasicAttack:ColonelSandersBasicAttack;
		private var _cRangedAttack:ColonelSandersRangedAttack;
		private var _cChargedAttack:ColonelSandersChargedAttack;
		
		/** To help keep track of score */
		public var sLastHitBy:String;
		
		public var nP1Score:int = 0;
		public var nP2Score:int = 0;
		public var nP3Score:int = 0;
		public var nP4Score:int = 0;
		
		public var invulnerable:Boolean;
		


	
		/* ---------------------------------------------------------------------------------------- */

		

		public function LocalPlayer($pName:String, $charName:String) 
		{
			super($pName, $charName);
			_bAlive = false;
			KeyboardManager.instance.addKeyDownListener(KeyCode.W, wDownHandler);
			KeyboardManager.instance.addKeyDownListener(KeyCode.A, aDownHandler);
			KeyboardManager.instance.addKeyDownListener(KeyCode.S, sDownHandler);
			KeyboardManager.instance.addKeyDownListener(KeyCode.D, dDownHandler);
			KeyboardManager.instance.addKeyUpListener(KeyCode.W, wUpHandler);
			KeyboardManager.instance.addKeyUpListener(KeyCode.A, aUpHandler);
			KeyboardManager.instance.addKeyUpListener(KeyCode.S, sUpHandler);
			KeyboardManager.instance.addKeyUpListener(KeyCode.D, dUpHandler);
			
			//spawn a jalepeno to the screen
			KeyboardManager.instance.addKeyDownListener(KeyCode.T, function() {
				ScreenManager.instance.mcActiveScreen.addChild(new Burger());
			});
			
			//commit suicide
			KeyboardManager.instance.addKeyDownListener(KeyCode.L, this.defeated);
			
			KeyboardManager.instance.addKeyDownListener(KeyCode.SPACEBAR, spaceDownHandler);
			KeyboardManager.instance.addKeyUpListener(KeyCode.SPACEBAR, spaceUpHandler);

			this.addEventListener(Event.ENTER_FRAME, update);
			
			this._heartbeatTimer = new Timer(88.8);
			this._heartbeatTimer.addEventListener(TimerEvent.TIMER, heartbeat);
			this._heartbeatTimer.start();
			
			this.addCollidesWithType(CollisionManager.TYPE_PLAYER);
			this.addCollidesWithType(CollisionManager.TYPE_ATTACK);
			this.addCollidesWithType(CollisionManager.TYPE_WALL);
			this.addCollidesWithType(CollisionManager.TYPE_PIT);
		}

		/* ---------------------------------------------------------------------------------------- */

		override protected function init(e:LoaderEvent):void
		{
			super.init(e);
			//need to have these here so that we're sure the sprite is loaded before we try to 
			//trigger the animations
			KeyboardManager.instance.addKeyDownListener(KeyCode.E, eDownHandler);
			StageRef.stage.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			
			_bAlive = false;
			this.invulnerable = false;
			
			//Try moving off top left of screen until initial spawn, doesn't always work.
			this.x = -50;
			this.y = -50;
		}

		/* ---------------------------------------------------------------------------------------- */

		private function wDownHandler():void 
		{
			if (_bAlive)
			{
				this._up = true;
				this.gotoAndPlaySprite("Walk_Enter");
			}
		}

		/* ---------------------------------------------------------------------------------------- */
		
		private function aDownHandler():void 
		{
			if (_bAlive)
			{
				this._left = true;
				this.gotoAndPlaySprite("Walk_Enter");
			}
		}	

		/* ---------------------------------------------------------------------------------------- */
		
		private function sDownHandler():void 
		{
			if (_bAlive)
			{
				this._down = true;
				this.gotoAndPlaySprite("Walk_Enter");
			}
		}
				
		/* ---------------------------------------------------------------------------------------- */

		private function dDownHandler():void 
		{
			if (_bAlive)
			{
				this._right = true;
				this.gotoAndPlaySprite("Walk_Enter");
			}
		}
				
		/* ---------------------------------------------------------------------------------------- */
		
		private function wUpHandler():void 
		{
			if (_bAlive)
			{
				this._up = false;
				if (_left == false && _right == false && _down == false)
				{
					this.gotoAndPlaySprite("Walk_Exit");
				}
			}
		}

		/* ---------------------------------------------------------------------------------------- */
		
		private function aUpHandler():void 
		{
			if (_bAlive)
			{
				this._left = false;
				if (_up == false && _right == false && _down == false)
				{
					this.gotoAndPlaySprite("Walk_Exit");
				}
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function sUpHandler():void 
		{
			if (_bAlive)
			{
				this._down = false;
				if (_left == false && _right == false && _up == false)
				{
					this.gotoAndPlaySprite("Walk_Exit");
				}
			}
		}

		/* ---------------------------------------------------------------------------------------- */
		
		private function dUpHandler():void 
		{
			if (_bAlive)
			{
				this._right = false;
				if (_left == false && _up == false && _down == false)
				{
					this.gotoAndPlaySprite("Walk_Exit");
				}
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function eDownHandler():void 
		{
			if (_bAlive)
			{
				this.gotoAndPlaySprite("Ranged_Attack");
				var customAttack:Class = getDefinitionByName("edu.ewu.components.attacks." + this._charName + "RangedAttack") as Class;
				new customAttack(this, this.x, this.y, this.SpriteRotation < 0 ? this.SpriteRotation + 360 : this.SpriteRotation, this.nBaseForce, this.nBaseDamage);
			}
		}
		
		private function spaceDownHandler():void
		{
			if (_bAlive)
			{
				this.gotoAndPlaySprite("Charged_Attack");
				SoundManager.instance.playSound("Charge", true);
				TweenMax.delayedCall(this._nChargeDelay, chargedAttackExecute);
			}
		}
		
		private function spaceUpHandler():void
		{
			if (_bAlive && !_bChargedAttackExecuting)
			{
				gotoAndPlaySprite("Idle");
				TweenMax.killTweensOf(chargedAttackExecute);//stop the delayed call

			}
		}
		
		private function chargedAttackExecute()
		{
			if (_bAlive)
			{
				this._bChargedAttackExecuting = true;
				TweenMax.delayedCall(3, function() { this._bChargedAttackExecuting = false; } );//reset the execute flag
				gotoAndPlaySprite("Charged_Execute");
				var customAttack:Class = getDefinitionByName("edu.ewu.components.attacks." + this._charName + "ChargedAttack") as Class;
				new customAttack(this, this.x, this.y, this.SpriteRotation < 0 ? this.SpriteRotation + 360 : this.SpriteRotation, this.nBaseForce, this.nBaseDamage);
			}
		}
		
		

		/* ---------------------------------------------------------------------------------------- */

		private function update(e:Event):void
		{
			var AngCos = Math.cos((this.SpriteRotation / 180) * Math.PI);
			var AngSin = Math.sin((this.SpriteRotation / 180) * Math.PI);
			if (this._bAlive && this.nLives>0)
			{
				if (this._bSentInitial == false)
				{
					this._bSentInitial = true;
					NetworkManager.instance.sendData(NetworkManager.OPCODE_MOVED, this);
				}
				
				//I am leaving these comments incase we want to use them later. --Tyler
				if (_left)
				{
					//this.x += this.nSpeed * AngSin;
					//this.y += this.nSpeed * -AngCos;
					this.x -= this.nSpeed;
				}

				if (_right)
				{
					//this.x += this.nSpeed * -AngSin;
					//this.y += this.nSpeed * AngCos;
					this.x += this.nSpeed;
				}
					
				if (_up )
				{
					//this.x += this.nSpeed * AngCos;
					//this.y += this.nSpeed * AngSin;
					this.y -= this.nSpeed;
				}

				if (_down)
				{
					//this.x += this.nSpeed * -AngCos;
					//this.y += this.nSpeed * -AngSin;
					this.y += this.nSpeed;
				}
				
				var distanceX : Number = StageRef.stage.mouseX - this.x;
				var distanceY : Number = StageRef.stage.mouseY - this.y;

				var angleInRadians : Number = Math.atan2(distanceY, distanceX);
				var angleInDegrees : Number = angleInRadians * (180 / Math.PI);

				if (angleInDegrees < 0)
				{
					angleInDegrees += 360;
				}
				this.SpriteRotation = angleInDegrees;
				
				if (_down || _left || _right || _up)
				{
					NetworkManager.instance.sendData(NetworkManager.OPCODE_MOVED, this);
				}
			}
		}

		/**
		 * @private
		 * Send heartbeat message.
		 * 
		 * @param	$e		The dispatched TimerEvent.
		 */

		protected function heartbeat($e:TimerEvent = null):void
		{
			NetworkManager.instance.sendData(NetworkManager.OPCODE_HEARTBEAT, this);
		}

		/* ---------------------------------------------------------------------------------------- */

		/**
		 * @private
		 * Create first attack.
		 * 
		 * @param	$e		The dispatched MouseEvent.
		 */
		protected function mouseClickHandler($e:MouseEvent = null):void
		{
			if (this._bAlive)
			{
				this.gotoAndPlaySprite("Light_Attack");
				var customAttack:Class = getDefinitionByName("edu.ewu.components.attacks." + this._charName + "BasicAttack") as Class;
				new customAttack(this, this.x, this.y, this.SpriteRotation < 0 ? this.SpriteRotation + 360 : this.SpriteRotation, this.nBaseForce, this.nBaseDamage);
			}
		}

		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Logic to be run when a collision is detected.
		 *
		 * @param	$oObjectCollidedWith	The object which was collided with.
		 */
		override public function collidedWith($oObjectCollidedWith:Collideable):void
		{
			if ($oObjectCollidedWith.sCollisionType == CollisionManager.TYPE_PLAYER || $oObjectCollidedWith.sCollisionType == CollisionManager.TYPE_WALL)
			{
				if ($oObjectCollidedWith is Player)
				{
					var player:Player = $oObjectCollidedWith as Player;
					if (this.PlayerName != player.PlayerName)
					{
						TweenMax.killTweensOf(this);
						this.x = this._nLastX;
						this.y = this._nLastY;
					}
				}
				else
				{
					TweenMax.killTweensOf(this);
					this.x = this._nLastX;
					this.y = this._nLastY;
					this._nLastX = this.x;
					this._nLastY = this.y;
				}
			}

			else if ($oObjectCollidedWith.sCollisionType == CollisionManager.TYPE_ATTACK)
			{
				if (this.invulnerable == false)
				{
					var attack:Attack = $oObjectCollidedWith as Attack;
					TweenMax.killTweensOf(chargedAttackExecute);
					attack.apply(this);
				}
			}

			else if ($oObjectCollidedWith.sCollisionType == CollisionManager.TYPE_PIT)
			{
				if (this._bAlive)
				{
					if (this.invulnerable == false)
					{
						this.defeated();
					}
					else
					{
						this.x = this._nLastX;
						this.y = this._nLastY;
					}
				}
			}
		}

		override public function set x($x:Number):void
		{
			this._nLastX = this.x;
			super.x = $x
		}
		
		override public function set y($y:Number):void
		{
			this._nLastY = this.y;
			super.y = $y
		}
		
		public function defeated():void
		{
			SoundManager.instance.playSound("Death");
			this._bAlive = false;
			this.nLives--;
			NetworkManager.instance.sendData(NetworkManager.OPCODE_DEATH, this);
			_left = false;
			_right = false;
			_up = false;
			_down = false;
			//keep track of who killed you.
			if (sLastHitBy == NetworkManager.instance.players[0])
				nP1Score++;
			else if (sLastHitBy == NetworkManager.instance.players[1])
				nP2Score++;
			else if (sLastHitBy == NetworkManager.instance.players[2])
				nP3Score++;
			else if (sLastHitBy == NetworkManager.instance.players[3])
				nP4Score++;

			this.gotoAndPlaySprite("Death");
			
			if (this.nLives == 0)
			{
				//var aliveCount:int = 0;
				//var hasLivesCount:int = 0;
				//for (var p:String in NetworkManager.instance.players)
				//{
					//if (NetworkManager.instance.players[p])
					//{
						//if (Player(NetworkManager.instance.players[p]).alive)
						//{
							//trace(p + ": is alive");
							//aliveCount++;
							//
							//
						//}
						//if (Player(NetworkManager.instance.players[p]).nLives != 0)
						//{
							//trace(p + ": has lives");
							//hasLivesCount++;
							//
							//
						//}
					//}
				//}
				//if (aliveCount == 1 && NetworkManager.instance.userCount() > 1 && hasLivesCount == 1)
				//{
					//trace("All Dead");
					//ScreenManager.instance.getScreen("Results").setKOs(this.kills, this.nLives);
					//NetworkManager.instance.disconnect();
					//TweenMax.delayedCall(4, ScreenManager.instance.mcActiveScreen.end);
				//}
			}
			else
			{
				TweenMax.delayedCall(5, respawn);
			}
		}
		
		public function respawn():void
		{
			this.invulnerable = true;
			var onComplete:Function = function(player:LocalPlayer):void 
			{ 
				TweenMax.to(player, 0, { tint:null } ); 
				player.invulnerable = false; 
			}
			TweenMax.to(this, 0.1, { tint:0xFFFFFF, repeat: 10, yoyo:true, repeatDelay:0, onComplete:onComplete, onCompleteParams:[this] } );
			
			var hitTest:Collideable = new PlayerHitTest();
			hitTest.addCollidesWithType(CollisionManager.TYPE_WALL);
			hitTest.addCollidesWithType(CollisionManager.TYPE_PIT);
			hitTest.addCollidesWithType(CollisionManager.TYPE_PLAYER);
			
			var randX:Number = Math.floor(Math.random() * (StageRef.stage.stageWidth + (this.mcHitTest.width * 0.5)));
			var randY:Number = Math.floor(Math.random() * (StageRef.stage.stageHeight + + (this.mcHitTest.height * 0.5)));
			hitTest.x = randX - 25;
			hitTest.y = randY - 25;
			
			while(CollisionManager.instance.doesObjectCollide(hitTest))
			{
				randX = Math.floor(Math.random() * (StageRef.stage.stageWidth + (this.mcHitTest.width * 0.5)));
				randY = Math.floor(Math.random() * (StageRef.stage.stageHeight + (this.mcHitTest.height * 0.5)));
				hitTest.x = randX - 25;
				hitTest.y = randY - 25;
			}
			
			hitTest = null;
			
			this.x = randX;
			this.y = randY;
			this._nLastX = this.x;
			this._nLastY = this.y;

			this.scaleX = 1;
			this.scaleY = 1;
			
			this.nHealth = 0;
			
			this.sLastHitBy = "";
			this.gotoAndPlaySprite("Idle");
			
			this._bAlive = true;
		}
		
		public function getHealth():int
		{
			return this.nHealth;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function getLives():int
		{
			return this.nLives;
		}

	}
}