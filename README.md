# fork-func  

Executes a function in a child process but as easy as calling a ordinary function ;-)

```coffee-script
      
    # function script ./heavy-func
    module exports = (args...) ->
         # some heavy, long running stuff
         return result
         
         
    # main script ./main
    fork = require fork-func
    
    fork './heavy-func', args..., (error, result) ->
        if error
            console.log error
        else                                          
            console.log result  
                           
```
    
fork-func has the following signature:
    
```coffee-script
    
    fork path, args..., callback
    
```    

**path**    
The absolute or relative path to a module, exporting a function.     
If relative, it must be relative to the calling module. If the function is a named export of a module you can specify the name as appendix of the path seperated by ```::```.
For example, if you have a module ```./a``` exporting a function ```b```, you can do ```fork './a::b', arg0, arg1, ..., callback```.    

**args...**    
Any number of arguments, you want to pass to the function.

**callback**    
A function expecting two arguments. First a possible error and second the result of the function call.
    
Thats it ;-)
    
Ok, one more sugar. You can decorate any object with simpler to use functions like so:    
    
```coffee-script
    
    obj = {}
    fork.pimp obj, './heavy-func'
    
    # creates a method 'heavyFunc' on obj which you can call without the path argument
    
    obj.heavyFunc arg0, arg1, ..., callback
    
    # as you realized, snake-case will be converted to camelCase
    # and as you expected, if a named function is called (./a::b), this name (b) is used
    
    # if thats not enough, you can specify a custom name
    
    fork.pimp obj, 'tallFunc', './heavy-func'
    
    # will create obj.tallFunc
    
````        
    
Enjoy!        
    
### License  
   
fork-func is free and unencumbered public domain software. For more information, see http://unlicense.org/ or the accompanying UNLICENSE file.



   

