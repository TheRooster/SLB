﻿package edu.ewu.networking
{
	import com.reyco1.multiuser.data.UserObject;
	import com.reyco1.multiuser.MultiUserSession;
	import edu.ewu.components.attacks.Attack;
	import edu.ewu.components.player.Player;
	import edu.ewu.components.player.NetworkPlayer;
	import flash.utils.Dictionary;
	import org.osflash.signals.Signal;
	
	/**
	 * Allow for easy managment of Playerss.
	 * 
	 * @author Justin Breitenbach
	 */
	public class NetworkManager
	{
		/** String for moved OPCODE. */
		public static const		OPCODE_MOVED		:String = "OPCODE_MOVED";
		/** String for attack OPCODE. */
		public static const		OPCODE_ATTACK		:String = "OPCODE_ATTACK";
		/** String for death OPCODE. */
		public static const		OPCODE_DEATH		:String = "OPCODE_DEATH";
		/** String for heartbeat OPCODE. */
		public static const		OPCODE_HEARTBEAT	:String = "OPCODE_HEARTBEAT";
		
		
		/** Stores a reference to the singleton instance. */  
		private static const _instance				:NetworkManager 	= new NetworkManager(SingletonLock);
		/** Reference to a Dictionary of Player */
		protected var		_dPlayers				:Dictionary 	= new Dictionary();
		/** Signal that is dispatched when a player joins. */
		public var			playerJoinedSignal		:Signal = new Signal(Player);
		/** Signal that is dispatched when a player is removed. */
		public var			playerRemovedSignal		:Signal = new Signal(Player);
		/** Connection for AS3mul */
		protected var		_connection				:MultiUserSession;

		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the PlayerManager object.
		 */
		public function NetworkManager($lock:Class)
		{
			if ($lock != SingletonLock)
				throw new Error("PlayerManager is a singleton and should not be instantiated. Use PlayerManager.instance instead");
		}

		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns instance of PlayerManager if it exists.
		 * 
		 * @return			Returns singleton instance of PlayerManager.
		 */
		public static function get instance():NetworkManager
		{
			return _instance;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Add Player to PlayerManager overwriting Player if one with the same $name is found.
		 *
		 * @param	$sName		Name player will be added under.
		 * @param	$oNewPlayer	The Player to be added.
		 */
		public function add($sName:String, $oNewPlayer:Player):void
		{
			this._dPlayers[$sName] = $oNewPlayer;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Removes a Player from PlayerManager if one with the same $sName is found.
		 *
		 * @param	$sName 		The name the Player was added under to be removed.
		 * @return				The Player which was removed.
		 */
		public function remove($sName:String):Player
		{
			var oRemovedPlayer:Player = this._dPlayers[$sName];
			this._dPlayers[$sName] = null;
			return oRemovedPlayer;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns a collection of all connected players.
		 *
		 * @return				Collection of all connected Players.
		 */
		public function get players():Dictionary
		{
			return _dPlayers;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Removes a Player from PlayerManager if one with the same $sName is found.
		 *
		 * @param	$sKey 		Server to be connected to.
		 */
		public function initConnection($sKey):void 
		{
			_connection = new MultiUserSession($sKey, "SimpleDemoGroup");
			if (_connection.userCount > 4)
			{
				trace("cannot connect");
				//TODO: change state to error screen
			}
			else
			{
				_connection.onConnect = handleConnect;
				_connection.onObjectRecieve = onDataRecieved;
				_connection.onUserAdded = onUserAdded;
				_connection.onUserRemoved = onUserRemoved;
				_connection.onUserExpired = onUserRemoved;
			}
			
		}
		
		private function onUserAdded(user:UserObject):void 
		{
			trace("User added: " + user.name);
			var p:NetworkPlayer = new NetworkPlayer(user.name, user.details.charName);// user.details.color);
			this.add(user.name, p);
			this.playerJoinedSignal.dispatch(p);
		}
		
		private function onUserRemoved(user:UserObject):void 
		{
			trace("User left:" + user.name);
			var p:Player = _dPlayers[user.name];
			if (p != null)
			{
				p.destroy();
				this.playerRemovedSignal.dispatch(p);
			}
			this.remove(user.name);
		}
		
		private function onDataRecieved(peerID:String, dataObj:Object):void 
		{
			//TODO: refactor to recieve movement/attack commands rather than positions
			if (dataObj.OPCODE == NetworkManager.OPCODE_HEARTBEAT)
			{
				var player:Player = _dPlayers[dataObj.name];
				if (player)
				{
					player.x = dataObj.x;
					player.y = dataObj.y;
					player.rotation = dataObj.rotation;
					//player.nLives = dataObj.lives;
					//player.nHealth = dataObj.health;
				}
			}
			else if (dataObj.OPCODE == NetworkManager.OPCODE_MOVED)
			{
				var player:Player = _dPlayers[dataObj.name];
				if (player)
				{
					player.x = dataObj.x;
					player.y = dataObj.y;
				}
			}
			else if (dataObj.OPCODE == NetworkManager.OPCODE_ATTACK)
			{
				//var attack:Attack = new (dataObj.sAttackName)(dataObj.creator, dataObj.x, dataObj.y, dataObj.angle);
				//Damage values etc. will be removed when we have specific versions of each attack.
				var attack:Attack = new Attack(dataObj.creator, dataObj.x, dataObj.y, dataObj.angle, 100, 0, 1000, true);
			}
			else if (dataObj.OPCODE == NetworkManager.OPCODE_DEATH)
			{
				//TODO: Handle death
				//var player:Player = _dPlayers[dataObj.name];
				//if (player)
				//{
				//	player.defeated();
				//}
			}
		}
		
		private function handleConnect(user:UserObject):void 
		{
			trace("I'm connected: " + user.name);
		}
		
		/**
		 * Constructs the Main object.
		 * 
		 * @param	$sOPCODE	What type of data is being sent
		 */
		public function sendData($sOPCODE:String, $oObject:Object):void 
		{
			if (_connection && _connection.channelManager)
			{
				try
				{
					if ($sOPCODE == NetworkManager.OPCODE_HEARTBEAT)
					{
						_connection.sendObject( { OPCODE:NetworkManager.OPCODE_MOVED, name:$oObject.PlayerName, x:$oObject.x, y:$oObject.y, rotation:$oObject.rotation } );
					}
					else if ($sOPCODE == NetworkManager.OPCODE_MOVED)
					{
						_connection.sendObject( { OPCODE:NetworkManager.OPCODE_MOVED, name:$oObject.PlayerName, x:$oObject.x, y:$oObject.y/*, health:$oObject.nHealth, lives:$oObject.nLives*/ } );
					}
					else if ($sOPCODE == NetworkManager.OPCODE_ATTACK)
					{
						//_connection.sendObject( { OPCODE:NetworkManager.OPCODE_ATTACK, name:$oObject.sAttackName, creator:$oObject.sCreator, x:$oObject.x, y:$oObject.y, angle:$oObject.angle } );
						_connection.sendObject( { OPCODE:NetworkManager.OPCODE_ATTACK, creator:$oObject.sCreator, x:$oObject.x, y:$oObject.y, angle:$oObject.angle } );
					}
					else if ($sOPCODE == NetworkManager.OPCODE_DEATH)
					{
						//TODO: Handle death
						// _connection.sendObject( { OPCODE:NetworkManager.OPCODE_DEATH, name:$oObject.PlayerName, x:$oObject.x, y:$oObject.y } );
					}
				}
				catch (e:Error)
				{
					trace(e.message);
					trace("Error sending data.");
				}
			}
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Connects the user to the server
		 *
		 * @param	$sName		Name to connect with
		 * @param	$oPlayer	Player that is connecting
		 */
		public function connect($sName:String, $oPlayer:Player):void
		{
			_connection.connect($sName,  {charName:$oPlayer._charName, x:$oPlayer.x, y:$oPlayer.y } );
		}
	}
}

class SingletonLock{};

