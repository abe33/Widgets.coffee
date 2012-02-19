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
    @mixins:( mixins... )->
        # Calling `super` inside a mixin method that overides
        # a inherited method will fail. To resolve it, a `@super`
        # method is provided on instances. And to avoid issues
        # when accessing the constructor of the overridden method
        # in a subclass, the constructor of a mixin method (the class
        # the method was originally mixed in) is registered in a hash
        # stored on the prototype.
        #
        # A copy the hash is made each time the `mixins` method is called.
        # It prevents the hash of a parent class to be affected by changes
        # made in child class.
        @::__superOf__ = @copy @::__superOf__

        # Each member of each mixin is added to the current class
        # prototype, unless the member is a constructor hook.
        for mixin in mixins
            for key, value of mixin when key isnt "constructorHook"
                @::[key] = value

                # The current class is registered as constructor for
                # for the mixed method.
                if value instanceof Function
                    @::__superOf__[key] = @__super__

            # Mixins can provide a function called `constructorHook`.
            # That function will be stored in a specific prototype
            # property and then triggered at the end of the `Module`
            # constructor.
            if mixin.constructorHook?
                hook = mixin.constructorHook
                @::__constructorHooks__ = @::__constructorHooks__.concat hook
        this

    # Returns a clone of the passed-in object `o`.
    @copy:( o )->
        r = {}
        r[i] = o[i] for i in o if o?
        r

    # Stores the mixins constructor hooks.
    __constructorHooks__:[]
    # Stores the respective super objects of mixed methods.
    __superOf__:{}

    # When `preventConstructorHooksInModule` is `true`, the `Module`
    # constructor will not triggers the constructors hook, allowing
    # a subclass to handle the hooks in its own constructor.
    #
    # Subclasses that prevent the `Module` constructor to trigger
    # the hooks should provide the same kind of guard in their
    # constructor to allow their subclasses to to do so.
    preventConstructorHooksInModule:false

    # The `Module` constructor behavior is to automatically
    # triggers the constructor hooks.
    constructor:->
        unless @preventConstructorHooksInModule
            @triggerConstructorHooks()

    # Loop through all the constructor hooks and call
    # them with the current object as context.
    triggerConstructorHooks:->
        hook.call @ for hook in @__constructorHooks__

    # Use `@super "methodName"` in a mixin's function to call the
    # super function of the specified method.
    super:( method, args... )->
        @__superOf__[method]?[method]?.apply this, args

@Module = Module
