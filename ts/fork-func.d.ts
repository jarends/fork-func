import * as child from 'child_process';

// this is a bad way to fake a variable argument count between typed first and last argument
// works up to 10 variable arguents
declare function ForkFunc(path:string, callback:(error:any, result:any) => void):child.ChildProcess;
declare function ForkFunc(path:string, arg0:any, callback:(error:any, result:any) => void):child.ChildProcess;
declare function ForkFunc(path:string, arg0:any, arg1:any, callback:(error:any, result:any) => void):child.ChildProcess;
declare function ForkFunc(path:string, arg0:any, arg1:any, arg2:any, callback:(error:any, result:any) => void):child.ChildProcess;
declare function ForkFunc(path:string, arg0:any, arg1:any, arg2:any, arg30:any, callback:(error:any, result:any) => void):child.ChildProcess;
declare function ForkFunc(path:string, arg0:any, arg1:any, arg2:any, arg3:any, arg4:any, callback:(error:any, result:any) => void):child.ChildProcess;
declare function ForkFunc(path:string, arg0:any, arg1:any, arg2:any, arg3:any, arg4:any, arg5:any, callback:(error:any, result:any) => void):child.ChildProcess;
declare function ForkFunc(path:string, arg0:any, arg1:any, arg2:any, arg3:any, arg4:any, arg5:any, arg6:any, callback:(error:any, result:any) => void):child.ChildProcess;
declare function ForkFunc(path:string, arg0:any, arg1:any, arg2:any, arg3:any, arg4:any, arg5:any, arg6:any, arg7:any, callback:(error:any, result:any) => void):child.ChildProcess;
declare function ForkFunc(path:string, arg0:any, arg1:any, arg2:any, arg3:any, arg4:any, arg5:any, arg6:any, arg7:any, arg8:any, callback:(error:any, result:any) => void):child.ChildProcess;
declare function ForkFunc(path:string, arg0:any, arg1:any, arg2:any, arg3:any, arg4:any, arg5:any, arg6:any, arg7:any, arg8:any, arg9:any, callback:(error:any, result:any) => void):child.ChildProcess;


declare module ForkFunc
{
    // same as above
    export function async(arg:any):child.ChildProcess;
    export function async(path:string, callback:(error:any, result:any) => void):child.ChildProcess;
    export function async(path:string, arg0:any, callback:(error:any, result:any) => void):child.ChildProcess;
    export function async(path:string, arg0:any, arg1:any, callback:(error:any, result:any) => void):child.ChildProcess;
    export function async(path:string, arg0:any, arg1:any, arg2:any, callback:(error:any, result:any) => void):child.ChildProcess;
    export function async(path:string, arg0:any, arg1:any, arg2:any, arg30:any, callback:(error:any, result:any) => void):child.ChildProcess;
    export function async(path:string, arg0:any, arg1:any, arg2:any, arg3:any, arg4:any, callback:(error:any, result:any) => void):child.ChildProcess;
    export function async(path:string, arg0:any, arg1:any, arg2:any, arg3:any, arg4:any, arg5:any, callback:(error:any, result:any) => void):child.ChildProcess;
    export function async(path:string, arg0:any, arg1:any, arg2:any, arg3:any, arg4:any, arg5:any, arg6:any, callback:(error:any, result:any) => void):child.ChildProcess;
    export function async(path:string, arg0:any, arg1:any, arg2:any, arg3:any, arg4:any, arg5:any, arg6:any, arg7:any, callback:(error:any, result:any) => void):child.ChildProcess;
    export function async(path:string, arg0:any, arg1:any, arg2:any, arg3:any, arg4:any, arg5:any, arg6:any, arg7:any, arg8:any, callback:(error:any, result:any) => void):child.ChildProcess;
    export function async(path:string, arg0:any, arg1:any, arg2:any, arg3:any, arg4:any, arg5:any, arg6:any, arg7:any, arg8:any, arg9:any, callback:(error:any, result:any) => void):child.ChildProcess;


    export function pimp(obj:any, path:string):any
}


export default ForkFunc;