
## widgets.Hash

The `Hash` class provides a basic structure to stores widgets with the DOM
element they handles as key. The keys and values are stored using two arrays
where the element at index `0` in the keys array is mapped to the value at
index `0` in the values array.

    class widgets.Hash

### widgets.Hash::constructor

Initialize this hash with empty arrays.

      constructor: ->
        @clear()

### widgets.Hash::clear

Returns this hash to an empty state where both keyx and values are empty.

      clear: ->
        @keys = []
        @values = []

### widgets.Hash::set

Sets the `value` of the specified `key`. If a value already exists for `key`
it will be overriden.

      set: (key, value) ->
        if @has_key key
          index = @keys.indexOf key
          @keys[index] = key
          @values[index] = value
        else
          @keys.push key
          @values.push value

### widgets.Hash::get

Returns the value associated with the given `key` if it exist.

      get: (key) ->
        @values[@keys.indexOf key]

### widgets.Hash::get_key

Returns the first key associated with the given `value` if there's any.

      get_key: (value) -> @keys[@values.indexOf value]

### widgets.Hash::has_key

Returns `true` if the `key` is present in the keys array.

      has_key: (key) -> @keys.indexOf(key) > 0

### widgets.Hash::unset

Deletes the value associated with the given key and removes it from
the keys array.

      unset: (key) ->
        index = @keys.indexOf key
        @keys.splice(index, 1)
        @values.splice(index, 1)

### widgets.Hash::each

Iterates over each value and call `block`.

      each: (block) -> @values.forEach block

### widgets.Hash::each_key

Iterates over each key and call `block`.

      each_key: (block) -> @keys.forEach block

### widgets.Hash::each_pair

Iterates over each pair of key and value and call `block` with them.

      each_pair: (block) -> @keys.forEach (key) => block? key, @get(key)
