# <link rel="stylesheet" href="../css/styles.css" media="screen">
#### Module 
#
# Modules allow polymorphism through mixins. 
#
# A Mixin is an object whose properties will
# be used to decorate a class prototype.
#
#     Serializable=
#         toString:-> ...
#         fromString:( string )-> ...
#      
#     Cloneable=
#         clone:-> ...
#
class Module
    # Call the static `@mixins` method in your class body
    # to specify the mixins that the class will implement.
    #
    #     class MyModule extends Module
    #         @mixins Serializable, Cloneable, Suspendable
    #
    #         # rest of the class definition... 
    # 
    @mixins: ( mixins... ) ->
        for mixin in mixins
            # Every member of the mixin is added to the current class
            # prototype, unless the member is a constructor hook. 
            for key, value of mixin when key isnt "constructorHook"
                @::[key] = value
            
            # Mixins can provide a function called `constructorHook`.
            # That function will be stored in a specific prototype 
            # property and then triggered at the end of the `Module`
            # constructor. 
            unless @::constructorHooks then @::constructorHooks = []
            if mixin.constructorHook? then @::constructorHooks.push mixin.constructorHook
        this
    
    # When `preventConstructorHooksInModule` is `true`, the `Module`
    # constructor will not triggers the constructors hook, allowing 
    # a subclass to handle the hooks in its own constructor. 
    #
    # Subclasses that prevent the `Module` constructor to trigger
    # the hooks should provide the same kind of guard in their
    # constructor to allow their subclasses to to do so.
    preventConstructorHooksInModule:false 

    constructorHooks:[]
    
    # The `Module` constructor behavior is to automatically 
    # triggers the constructor hooks.
    constructor:->
        unless @preventConstructorHooksInModule
            @triggerConstructorHooks()
    
    # Loop through all the constructor hooks and call
    # them with the current object as context.
    triggerConstructorHooks:->
        hook.call @ for hook in @constructorHooks

if window?
    window.Module = Module