module "module tests"

test "The include class method should fill the class prototype
      with the corresponding content", ->

  methodWasCalled = false
  methodContext = null

  TestMixin =
    foo: "bar"
    method: ->
      methodWasCalled = true
      methodContext = this

  class MockModule extends Module
    @include TestMixin

  instance = new MockModule

  instance.method()

  assertThat instance.foo, equalTo "bar"
  assertThat methodWasCalled
  assertThat methodContext is instance

test "Module should provides a hook on instanciation for mixins", ->

  methodWasCalled = false
  methodContext = null

  TestMixin =
    constructorHook: ->
      methodWasCalled = true
      methodContext = this

  class MockModule extends Module
    @include TestMixin

  instance = new MockModule

  assertThat methodWasCalled
  assertThat methodContext is instance

test "Mixins should be able to call the super function they overrides", ->

  methodWasCalled = false
  methodContext = null

  TestMixin =
    method: ->
      @super "method"

  class MockModuleA extends Module
    method:->
      methodWasCalled = true
      methodContext = this

  class MockModuleB extends MockModuleA
    @include TestMixin

  instance = new MockModuleB

  instance.method()

  assertThat methodWasCalled
  assertThat methodContext is instance

test "Mixins hooks defined in the parent should be triggered in children
      but children hooks will not affect its parent", ->

  hookACalls = 0
  hookBCalls = 0

  MixinA =
    constructorHook: ->
      hookACalls++

  MixinB =
    constructorHook: ->
      hookBCalls++

  class MockModuleA extends Module
    @include MixinA

  class MockModuleB extends MockModuleA
    @include MixinB

  new MockModuleA
  new MockModuleB

  assertThat hookACalls, equalTo 2
  assertThat hookBCalls, equalTo 1

test "Mixins should receive a notification when included in a class", ->

  methodWasCalled = false
  methodContext = null
  methodArgument = null

  TestMixin =
    included: (base) ->
      methodWasCalled = true
      methodContext = this
      methodArgument = base

  class MockModule extends Module
    @include TestMixin

  instance = new MockModule

  assertThat methodWasCalled
  assertThat methodContext is TestMixin
  assertThat methodArgument is MockModule

test "Module should exclude members of a mixin listed in the excluded
      property of the mixin", ->

  TestMixin =
    foo:"bar"
    bar:"foo"
    excluded:["bar"]

  class MockModule extends Module
    @include TestMixin

  instance = new MockModule

  assertThat not instance.bar?
  assertThat not instance.excluded?


module "mixins tests"

test "Mixins could be created through the Mixin construct", ->

  TestMixin = Mixin
    foo: "bar"
    bar: "foo"

  class MockModule extends Module
    @include TestMixin

  instance = new MockModule

  assertThat instance.foo, equalTo "bar"
  assertThat instance.bar, equalTo "foo"

test "Mixins created through the Mixin construct should provide a way to test
      if an object has included the mixin", ->

  TestMixin = Mixin
    foo: "bar"
    bar: "foo"

  class MockModuleA extends Module
    @include TestMixin

  class MockModuleB extends Module
    @include TestMixin

  class MockModuleC extends MockModuleB

  instanceA = new MockModuleA
  instanceB = new MockModuleB
  instanceC = new MockModuleC
  object = {}

  assertThat TestMixin.isMixinOf instanceA
  assertThat TestMixin.isMixinOf instanceB
  assertThat TestMixin.isMixinOf instanceC
  assertThat not TestMixin.isMixinOf object

module "quacksLike tests"

test "quacksLike should be able to tell when an object match the definition
      of a given mixin", ->

  TestMixinA = Mixin
    foo: "bar"
    bar: "foo"
    method: -> "quack!"
    __definition__:
      foo: "string"
      bar: "*"
      method: "function"

  TestMixinB = Mixin
    foo: "bar"
    bar: "foo"

  TestMixinC = Mixin
    foo:"bar"
    bar:"foo"
    __definition__: (o) ->
      o.foo is "bar" and o.bar is "foo"

  class MockModuleA extends Module
    @include TestMixinA

  class MockModuleB extends Module
    @include TestMixinB

  class MockModuleC extends Module
    @include TestMixinA, TestMixinC

  class MockModuleD extends Module
    @include TestMixinB
    @__definition__:
      foo: "string"
      bar: "string"

  instanceA1 = new MockModuleA
  instanceA2 = new MockModuleA
  instanceA3 = new MockModuleA
  instanceA3.foo = 42
  instanceA4 = new MockModuleA
  instanceA4.method = 42
  instanceB = new MockModuleB
  instanceC1 = new MockModuleC
  instanceC2 = new MockModuleC
  instanceC2.foo = 42
  instanceD1 = new MockModuleD
  instanceD2 = new MockModuleD
  instanceD2.foo = 42
  object1 =
    foo: "bar"
    bar: "foo"
    method: -> "woof!"
  object2 = {}

  assertThat quacksLike instanceA1, TestMixinA
  assertThat quacksLike instanceA2, TestMixinA
  assertThat not quacksLike instanceA3, TestMixinA
  assertThat not quacksLike instanceA4, TestMixinA
  assertThat not quacksLike instanceB, TestMixinB
  assertThat quacksLike instanceC1, TestMixinA
  assertThat quacksLike instanceC1, TestMixinC
  assertThat not quacksLike instanceC2, TestMixinA
  assertThat not quacksLike instanceC2, TestMixinC
  assertThat quacksLike instanceD1, MockModuleD
  assertThat not quacksLike instanceD2, MockModuleD
  assertThat quacksLike object1, TestMixinA
  assertThat not quacksLike object2, TestMixinA

test "quacksLike should allow custom type checking for members", ->

  TestMixin = Mixin
    foo: /regexp/
    bar: { foo:"foo" }

    __definition__:
      foo: "regexp"
      bar: (o)-> typeof o is "object"

  class MockModule extends Module
    @include TestMixin

  instance1 = new MockModule
  instance2 = new MockModule
  instance2.bar = 42

  assertThat quacksLike instance1, TestMixin
  assertThat not quacksLike instance2, TestMixin




