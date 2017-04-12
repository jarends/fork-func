# fork-func  

Executes a function in a child process, as easy as calling a ordinary function ;-)

```coffee
      
    # function script './heavy-func'
    module exports = (args...) ->
         # some heavy, long running stuff
         return result
         
         
    # main script './main'
    fork = require 'fork-func'
    
    fork './heavy-func', arg0, arg1, ..., (error, result) ->
        if error
            console.log error
        else                                          
            console.log result  
                           
```

fork-func has the following signature:
    
```coffee
    
    cp = fork path, args..., callback
    
```    

**path**    
The absolute or relative path to a module, exporting a function.
If relative, it must be relative to the calling module.  
If the function is a named export of a module you can append the name separated by ```::``` to the path.  
For example, if you have a module ```'./a'``` exporting a function ```b```, you can do:  

```fork './a::b', arg0, arg1, ..., callback```
<br>  
**args...**    
Any number of arguments, you want to pass to the function.
<br>  
**callback**    
A function expecting two arguments. First a possible error and second the result of the function call.
<br>  
**return**    
The child-process instance is returned. You can use it, to kill the process, if necessary.
<br>  
That's it ;-)
<br>   
<small>But wait...</small>
<br>  
What, if the function we want to call itself is asynchronous and the result is unknown, when the function returns.
For example, can we use ```setTimeout```?

```coffee
    
    # function script './heavy-async-func'
    module exports = (delay, args...) ->
        setTimeout () ->
            # we now know, what we want to return
        , delay
        null # we don't know, what to return
        
```

We can simply do this:

```coffee
    
    # main script './main'
    fork = require 'fork-func'
    
    fork.async './heavy-async-func', 1000, arg1, ..., (error, result) ->
        if error
            console.log error
        else                                          
            console.log result  
    
```
    
Looks similar to the synchronous version, except that we call ```async``` on fork-func, doesn't it?  
But we have to do one more thing:
 
```coffee
    
    # function script './heavy-async-func'
    module exports = (delay, callback) ->
        setTimeout () ->
            # if we had an error
            # error = 'we had a bad error!'
            callback error, 'we now know, what we want to return'
        , delay
        null # we don't know, what to return
    
    # the passed callback has the same signature as the callback passed to fork-func:
    
    callback = (error, result) ->
    
```

You can expect (and have to use) that callback in your function when you call ```fork-func.async```.    
Whatever your function returns will be ignored (i currently can't find any reasonable task for the returned value, within this asynchronous variant).
<br>  
Ok, one more sugar. You can decorate any object with simpler to use functions like so:

```coffee
      
    obj = {}
    fork.pimp obj, './heavy-func'
    
    # creates a method 'heavyFunc' on obj which you can call without the path argument:
    
    obj.heavyFunc arg0, arg1, ..., callback
    
    # as you realized, kebab-case will be converted to camelCase
    # and as you expect, if a named function is called ('./a::b'), that name (b) is used
    
    # if thats not enough, you can specify a custom name:
    
    fork.pimp obj, 'tallFunc', './heavy-func'
    
    # will create obj.tallFunc
    
```        

Enjoy!
<br>  
<br>  

### License    
   
fork-func is free and unencumbered public domain software. For more information, see http://unlicense.org/ or the accompanying UNLICENSE file.
  