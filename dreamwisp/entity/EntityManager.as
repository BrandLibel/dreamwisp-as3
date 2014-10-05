package dreamwisp.entity
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.entity.hosts.IEntityFactory;
	import dreamwisp.entity.hosts.IPlayerControllable;
	import dreamwisp.input.InputState;
	import org.osflash.signals.Signal;
	import tools.Belt;
	
	/**
	 * EntityManager handles creation and tracking of Entitys.
	 * Use entitySignals for the graphics and project-specific configuration.
	 * @author Brandon
	 */
	public dynamic class EntityManager
	{
		private var prototypesJSON:Object;
		private var entitys:Vector.<Entity> = new Vector.<Entity>;
		private var tempEntityList:Vector.<Entity> = new Vector.<Entity>;
		private var controllableEntitys:Vector.<IPlayerControllable> = new Vector.<IPlayerControllable>;
		
		private var factory:IEntityFactory;
		
		/// Signal to dispatch AFTER addEntity has been called
		public var entityAttached:Signal;
		/// Signal to dispatch AFTER destroyEntity has been called
		public var entityRemoved:Signal;
		
		private var markedForPurge:Boolean = false;
		
		public function EntityManager(factory:IEntityFactory, prototypesJSON:Object)
		{
			this.factory = factory;
			this.prototypesJSON = prototypesJSON;
			// defining signals
			entityAttached = new Signal(Entity);
			entityRemoved = new Signal(Entity);
		}
		
		/**
		 * Distributes input state to all IPlayerControlled - entitys that can recieve input
		 * @param	inputState
		 */
		public function handleInput(inputState:InputState):void
		{
			for each (var entity:IPlayerControllable in controllableEntitys)
				entity.handleInput(inputState);
		}
		
		public function update():void
		{
			// create a temp copy of the entity list and update that
			// to avoid confusion when updating an entity adds/removes another
			tempEntityList.length = 0;
			for each (var tempEntity:Entity in entitys)
				tempEntityList.push(tempEntity);
			for each (var entity:Entity in tempEntityList)
			{
				entity.update();
				if (markedForPurge)
				{
					markedForPurge = false;
					return;
				}
			}
		}
		
		public function render(interpolation:Number):void
		{
			for each (var entity:Entity in entitys)
				entity.render(interpolation);
		}
		
		public function spawnEntity(prototypeID:uint):Entity
		{
			var entity:Entity = factory.createEntity(prototypeID);
			addEntity(entity);
			return entity;
		}
		
		/**
		 * Attaches and orients an entity to the unique environment of this EntityManager.
		 * @param	entity
		 * @return
		 */
		public function addEntity(entity:Entity):Entity
		{
			entitys.push(entity);
			entity.destroyed.add(onEntityDestroyed);
			entity.entityCreated.add(addEntity);
			entity.entityManager = this;
			
			if (entity is IPlayerControllable)
				controllableEntitys.push(entity);
			
			if (entity.hasOwnProperty("lightSource"))
			{
				
			}
			
			entityAttached.dispatch(entity);
			
			return entity;
		}
		
		/**
		 * Returns the first entity found that has the specified name.
		 * @param	name
		 * @return
		 */
		public function getEntityByName(name:String):Entity
		{
			var numOfSameNames:uint = 0;
			var entityWithName:Entity = null;
			for each (var entity:Entity in entitys)
			{
				if (entity.name == name)
					return entity;
			}
			throw new Error("No entity found by requested name: " + name);
		}
		
		public function getEntitys():Vector.<Entity>
		{
			return entitys;
		}
		
		/**
		 * Retrieves a group of entitys with the specified name.
		 * @param	name
		 * @return	A vector containing the entitys with that name.
		 */
		public function getEntitysByName(name:String):Vector.<Entity>
		{
			var entitysWithName:Vector.<Entity> = new Vector.<Entity>;
			for each (var entity:Entity in entitys)
			{
				if (entity.name == name)
					entitysWithName.push(entity);
			}
			return entitysWithName;
		}
		
		public function getEntityByID(id:uint):Entity
		{
			for each (var entity:Entity in entitys)
			{
				if (entity.id == id)
					return entity;
			}
			throw new Error("No entity found by requested ID: " + id);
		}
		
		private function onEntityDestroyed(entity:Entity):void
		{
			// remove entity from the general entitys list
			entitys.splice(entitys.indexOf(entity), 1);
			if (controllableEntitys.indexOf(entity) != -1)
				controllableEntitys.splice(entitys.indexOf(entity), 1);
			
			entity.destroyed.remove(onEntityDestroyed);
			entity.entityCreated.remove(addEntity);
			
			entityRemoved.dispatch(entity);
		}
		
		public function purge():void
		{
			for (var i:int = entitys.length - 1; i >= 0; i--)
				entitys[i].destroy();
			markedForPurge = true;
		}
	
	}

}