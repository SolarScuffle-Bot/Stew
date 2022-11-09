--[=[
    @class Stew
]=]

--[=[
    @within Stew
    @type Name any

    A name is a unique identifier used as a key to access components in entities.
]=]

--[=[
    @within Stew
    @type Component any

    A component is user-defined data that is stored in an entity. It is defined through the Stew.ConstructComponent function. It is created through the Stew.CreateComponent function.
]=]

--[=[
    @within Stew
    @tag Read Only
    @interface Entity
    .[Name] Component

    An entity is a table storing unique components by their names. It is created through the Stew.CreateEntity function. The entity's components can be accessed through the entity and modified. The entity table itself is read-only however.
]=]

--[=[
    @within Stew
    @type Collection {Entity}

    An array of entities containing at least specific components.
]=]

--[=[
    @within Stew
    @interface Template
    .Constructor|constructor (Entity : Entity, ... : any) -> Component
    .Destructor|destructor (Entity : Entity, Component : Component, ... : any) -> ()
]=]

--[=[
    @within Stew
    @function GetCollection
    @tag Read Only

    @param Names {Name} -- An array of component names.
    @return Collection -- Returns a collection of all entities that have all the components specified.

    Used to get all entities containing specific signatures. This is useful for implementing systems. **This array is unsafe to modify and should be treated as read-only.**

    ```lua
    local Collection : Stew.Collection = Stew.GetCollection{"Health", "Starving"}

    RunService.Heartbeat:Connect(function(DeltaTime : number)
        for _, Entity : Stew.Entity in ipairs(Collection) do
            Entity.Health -= DeltaTime
        end
    end)
    ```
]=]

--[=[
    @within Stew
    @function ConstructComponent

    @param Name Name -- The name of the component.
    @param Template Template? -- The template of the component.

    Sets up an internal constructor and destructor for a component. This is used to create and destroy components in entities.If a template is not provided, an empty table will be used instead.
    The constructor passes the entity as the first argument, and any additional arguments passed in. If no constructor is specified, a default constructor that returns true is used.
    The destructor passes the entity, the component being destructed, and any additional arguments passed in. If no destructor is specified, a default destructor that does nothing is used.


    ```lua
    Stew.ConstructComponent("Model", {
        Constructor = function(Entity : Stew.Entity, Model : Model)
            return Model:Clone()
        end;

        Destructor = function(Entity : Stew.Entity, Component : Model)
            Component:Destroy()
        end;
    })
    ```
]=]

--[=[
    @within Stew
    @function CreateComponent
    @param Entity Entity -- The entity to create the component in.
    @param Name Name -- The name of the component to be created.
    @param ... any -- The arguments of the constructor specified in the template.

    Creates a unique component in an entity.

    ```lua
    local Entity1 : Stew.Entity = Stew.CreateEntity()

    print(Entity1.Model) --> nil

    Stew.CreateComponent(Entity1, "Model", workspace.CoolModel)

    print(Entity1.Model) --> CoolModel
    ```
]=]

--[=[
    @within Stew
    @function DeleteComponent

    @param Entity Entity -- The entity to delete the component from.
    @param Name Name -- The name of the component to be deleted.
    @param ... any -- The arguments of the destructor specified in the template.

    Deletes the unique component from an entity.

    ```lua
    print(Entity1.Model) --> CoolModel

    Stew.DeleteComponent(Entity1, "Model")

    print(Entity1.Model) --> nil
    ```
]=]

--[=[
    @within Stew
    @function CreateEntity
    @return Entity

    Creates a new entity. Entities are tables that contain components via their names.

    ```lua
    local Entity1 : Stew.Entity = Stew.CreateEntity()
    ```
]=]

--[=[
    @within Stew
    @function DeleteEntity
    @param Entity Entity

    Removes all components from the entity and deletes from all internal storage.

    ```lua
    Stew.DeleteEntity(Entity1)
    ```
]=]