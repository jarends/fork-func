# fork-func   

Executes a function in a child process, as easy as simply calling it ;-)  
<br/>

**usage**
```text
    
    npm install fork-func --save
      
```
```coffee
    
    fork = require 'fork-func'
    
    fork './myFunc', args..., (error, result) ->  # external
    fork myFunc, args..., (error, result) ->      # by reference
      
```   
<br/>

**calling external source**  
```coffee
      
    # function script './heavy-func'
    module.exports = (args...) ->
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
<br/>  

**calling functions by reference**  
You also can execute a function, existing somewhere in your code, in a child process.  
This only works, if the function doesn't use references to an outer scope and is done by performing a ```toSreing()``` on the function and using ```eval()``` in the child process to execute the function. 
```coffee
      
    # blocking function
    wait = (delay, msg) ->
        start = Date.now()
        while Date.now() - start < delay
            null
        delay + 'ms later ... ' + msg
         
         
    fork = require 'fork-func'
    
    fork wait, 1000, 'not blocked', (error, result) ->
        if error
            console.log error
        else                                          
            console.log result  
            
    # logs: 1000ms later ... not blocked                
                           
```
<br/>  

**signature**
```coffee
    
    cp = fork pathOrFunc, args..., callback
    
```    
<br/>

**pathOrFunc**  
You can pass an absolute or relative path to a module, exporting a function.
If relative, it must be relative to the calling module like you would do in ```require```.
You can also reference node_modules by their name like you would do in ```require```.   
If the function is a named export of a module you can append the name separated by ```::``` to the path.  
For example, if you have a module ```'./a'``` exporting a function ```b```, you can do:
  
```fork './a::b', arg0, arg1, ..., callback```
  
If you pass a function, this function will be called in a child process.  
<br/>
  
**args...**    
Any number of arguments, you want to pass to the function. The values you use must be serializable by JSON.stringify.  
<br/>
  
**callback**    
A function expecting two arguments. First a possible error and second the result of the function call.  
<br/>
  
**return**    
The child-process instance is returned. You can use it, to kill the processor or do other stuff.  
<br/>
<br/>
  
That's it ;-)
<br/>   
<small>But wait...</small>
<br/>  
What, if the function we want to call itself is asynchronous and the result is unknown, when the function returns.
For example, can we use ```setTimeout```?
  
**async**
```coffee
    
    # function script './heavy-async-func' - could also be inlined
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
    
    # function script './heavy-async-func' - could also be inlined
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
And whatever your function returns will be ignored (i currently can't find any reasonable task for the returned value, within this asynchronous variant).
<br/>
<br/>  
    
**Ok, one more sugar.**    
You can decorate any object with simpler to use functions like so:  

**pimp**
```coffee
      
    obj = {}
    fork.pimp obj, './heavy-func', async 
    
    # creates a method 'heavyFunc' on obj which you can call without the path argument
    
    # async = true creates a fork.async version
    # async = false creates a fork.sync version
    # async = undefined/null creates the normal fork version
    
    obj.heavyFunc arg0, arg1, ..., callback
    
    # as you realized, kebab-case will be converted to camelCase
    # and as you expect, if a named function is called ('./a::b'), that name (b) is used
    
    # if thats not enough, you can specify a custom name:
    
    fork.pimp obj, 'tallFunc', './heavy-func'
    
    # will create obj.tallFunc
    
```        
  
<br/>  
<br/>  
  
**The following definitely doesn't make sense!**      
I had the use case to require a js or coffee file which exports a config and changed over time. I wanted to require the new file but got the same instance as before. The result was cached by nodes module system.  
With fork-func you could do it easily in a child process to get a fresh config ;-)  
But, as i noticed later, you better can do ```delete require.cache[path]```!!!  
So, for me the sync variant is definitely useless.
<br/>

**sync**  
```coffee
    
    getCfg = (path) -> require path
        
    cfg = fork.sync getCfg, path  # path must be absolute!!! 
             
```
(I will keep the sync method, only for remembering me not to implement senseless stuff caused by not knowing the api ;-) )  
<br/>          
   
**P.S.:** fork-func tries to capture errors by either serializing the ```name```, ```message``` and ```stack``` of a child process error
or delegating an ipc error or one, witch is thrown on child process creation.      
<br/>     
Enjoy!
<br/>  
<br/>  

### License    
   
fork-func is free and unencumbered public domain software. For more information, see http://unlicense.org/ or the accompanying UNLICENSE file.
  