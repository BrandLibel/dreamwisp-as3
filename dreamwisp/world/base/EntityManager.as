package dreamwisp.world.base {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.components.platformer.IPlatformMovementState;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.entity.hosts.IEntityFactory;
	import dreamwisp.entity.hosts.IInteractible;
	import dreamwisp.entity.hosts.IPlatformEntity;
	import dreamwisp.entity.hosts.Door;
	import org.osflash.signals.Signal;
	import tools.Belt;
		
	/**
	 * ...
	 * @author Brandon
	 */
	public dynamic class EntityManager implements IEntityManager {

		private var entityList:Object = Data.entityList.entitys;
		private var entitys:Vector.<Entity>;
		
		private var factory:IEntityFactory;
		
		private var index:uint;
		
		/// Signal to dispatch AFTER spawnEntity has been called
		public var entitySpawned:Signal;
		/// Signal to dispatch AFTER addEntity has been called
		public var entityAttached:Signal;
		/// Signal to dispatch AFTER destroyEntity has been called
		public var entityRemoved:Signal;
		
		public function EntityManager(factory:IEntityFactory) {
			this.factory = factory;
			init();
		}
		
		private function init():void {
			entitys = new Vector.<Entity>;
			// defining signals
			entitySpawned = new Signal(Entity);
			entitySpawned.add( addEntity );
			entityAttached = new Signal(Entity);
			entityRemoved = new Signal(Entity);
		}
		
		public function update():void {
			// loop uses index++ to allow for index-- compensation on entity destruction
			for (index; index < entitys.length; index++) {
				var entity:Entity = entitys[index];
				entity.update();
			}
			index = 0;
			
		}
		
		public function render():void {
			for each (var entity:Entity in entitys) entity.render();
		}
		
		/**
		 * Creates a new unique entity through an action call and initializes it.
		 * 
		 * @param	actionData Needs entityNum, x, y
		 * @return
		 */
		public function spawnEntity(actionData:Object):Entity {
			// entityList is the JSON file
			const entityData:Object = entityList[actionData.entityNum];
			var entity:Entity = factory.createEntity(entityData.className);
			// TODO: make it so that any aspect of the Entity can be overriden through the specific JSON action call, like HP, color, light, etc.
			
			// giving the entity its identity (unique ID)
			entity.actorID = actionData.actorID;
			entity.name = entityData.name;
			
			// Values normally defined in the entity's own class, but if specified
			// here it will override the class values. 
			if (entityData.group) entity.groupName = entityData.group;
			if (entityData.targetGroup) entity.targetName = entityData.targetGroup;
			if (entity.view) {
				// attach movieClip if it the Class hasn't defined one for itself
				if (!entity.view.movieClip) {
					// E + entity num is the name of the movieClip for the entity
					entity.view.movieClip = Belt.addClassFromLibrary("E" + actionData.entityNum, Belt.CLASS_MOVIECLIP);
				}
				if (entityData.layer) entity.view.layer = entityData.layer;
			}
			
			// attaching entity according to actionData
			if (actionData.conversation) {
				entity.actor.setConversation( Data.dialogue[actionData.conversation] );
			}
			if (actionData.destination) {
				// for doors
				Door(entity).destination = actionData.destination;
			}
			// position entity and shift it according to the location's position
			entity.body.x = actionData.x /*+ location.rect.left*/;
			entity.body.y = actionData.y /*+ location.rect.top*/;
			
			entitySpawned.dispatch(entity);
			
			//addEntity(entity);
			
			return entity;
		}
		
		/**
		 * Adds the entity to the general entitys list.
		 * @param	entity
		 * @return
		 */
		public function addEntity(entity:Entity):Entity {
			entitys.push(entity);
			entity.destroyed.add(onEntityDestroyed);
			entity.entityCreated.add(addEntity);
			
			if (entity.interactibles) entity.interactibles = new Vector.<Entity>;
			
			// give the entity a reference to the Location.
			// each specific Project entity class decides what to do with it,
			// grabbing optional data such as tileGrid
			//entity.myLocation = this.location;
			// group creation and management whenever an entity enters a location
			if (entity.groupName) {
				if (!this[entity.groupName]) {
					this[entity.groupName] = new Vector.<Entity>;
				}
				entity.group = this[entity.groupName];
			}
			
			// HANDLING CREATION OF 
			// even if does not exist, reserve the space and pass a reference to the empty
			// space so anything that spawns later can be reached by the entity
			
			// target-group management; finding groups whenever entity enters a locatoin
			if (entity.targetName) {
				if (!this[entity.targetName]) this[entity.targetName] = new Vector.<Entity>;
				entity.targets = this[entity.targetName];
			}
			
			if (entity.interactibles) {
				if (!this["Interactibles"]) this["Interactibles"] = new Vector.<Entity>;
				entity.interactibles = this["Interactibles"];
			}
			
			if (entity is IPlatformEntity) {
				// Interface casting must be done this way in order to access platformController
				// and pass the tileGrid to the entity.
				// TODO: make a better system for keeping entitys with tileGrids;
				//var iEntity:IPlatformEntity = entity as IPlatformEntity;
				//iEntity.platformController.tileGrid = location.tileScape.tileGrid;
				//iEntity = null;
			}
			if (entity.hasOwnProperty("lightSource")) {
				
			}
			//if (entity.view) this.location.view.add(entity.view);
			
			entityAttached.dispatch(entity);
			
			return entity;
		}
		
		public function destroyEntity(action:Object):void {
			MonsterDebugger.trace(this, entitys.length);
			getEntityByID(action.actorID).destroy();
			for (var i:uint = 0; i < entitys.length; i++) {
				MonsterDebugger.trace(this, "looping: " + i);
				if (entitys[i].actorID == action.actorID || !action.actorID) {
					entitys[i].destroy();
					i--; // need to push loop back to compensate for destroyed enemy
				}
			}
		}
		
		/**
		 * Returns the first entity found that has the specified name.
		 * @param	name
		 * @return
		 */
		public function getEntityByName(name:String):Entity {
			var numOfSameNames:uint = 0;
			var entityWithName:Entity = null;
			for each (var entity:Entity in entitys) {
				if (entity.name == name) {
					return entity;
				}
			}
			throw new Error("No entity found by requested name: " + name);
		}
		
		/**
		 * Retrieves a group of entitys with the specified name.
		 * @param	name 
		 * @return	A vector containing the entitys with that name.
		 */
		public function getEntitysByName(name:String):Vector.<Entity> {
			var entitysWithName:Vector.<Entity> = new Vector.<Entity>;
			for each (var entity:Entity in entitys) {
				if (entity.name == name) {
					entitysWithName.push(entity);
				}
			}
			return entitysWithName;
		}
		
		public function getEntityByID(id:uint):Entity {
			for each (var entity:Entity in entitys) {
				if (entity.actorID == id) {
					return entity;
				}
			}
			throw new Error("No entity found by requested ID: " + id);
		}
		
		public function onEntityDestroyed(entity:Entity):void {
			// remove entity from the general entitys list
			entitys.splice( entitys.indexOf(entity), 1 );
			// remove the entity from its own group
			if (entity.group) entity.group.splice ( entity.group.indexOf(entity), 1 );
			//if (entity.view) location.view.removeChild(entity.view.movieClip);
			entity.destroyed.remove(onEntityDestroyed);
			entity.entityCreated.remove(addEntity);
			
			entityRemoved.dispatch(entity);
			
			// compensate for the loop through entitys array
			index--;
		}
		
	}

}