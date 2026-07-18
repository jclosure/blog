---
layout: post
title: "Demonstration of Dynamic Type Creation and Resolution"
date: 2008-11-23 18:43:20 -0600
categories: []
tags: []
wordpress_id: 16
original_url: "https://joelholder.com/2008/11/23/demonstration-of-dynamic-type-creation-and-resolution/"
---

This is a modified sample from the .NET Framework SDK. Basically demonstrates how to programmatically drive the ILGenerator to emit code resulting in a method definition. Note that it is wrapped in a programmatically created assembly that exists only in memory. In the Main of this Application, the dynamic assembly is unwrapped and reflection is used to invoke the method that was generated.

Instuctions: Create a new Console Application. Replace the entire contents of Program.cs with the following. Then run.

```csharp
using System;
using System.Reflection;
using System.Reflection.Emit;
using System.Threading;
using System.Runtime.Remoting;

class App
{
    static Assembly TypeResolveHandler(Object sender, ResolveEventArgs e)
    {
        Console.WriteLine("In TypeResolveHandler");
        AssemblyName assemblyName = new AssemblyName();
        assemblyName.Name = "DynamicAssem";
        // Create a new assembly with one module
        AssemblyBuilder newAssembly =
        Thread.GetDomain().DefineDynamicAssembly(assemblyName, AssemblyBuilderAccess.Run);
        ModuleBuilder newModule = newAssembly.DefineDynamicModule("DynamicModule");
        // Define a public class named "ANonExistentType" in the assembly.
        TypeBuilder myType = newModule.DefineType("ANonExistentType", TypeAttributes.Public);
        // Define a method on the type to call
        MethodBuilder simpleMethod = myType.DefineMethod("SimpleMethod", MethodAttributes.Public, null, null);
        ILGenerator il = simpleMethod.GetILGenerator();
        il.EmitWriteLine("Method called in ANonExistentType");
        il.Emit(OpCodes.Ret);
        // Bake the type
        myType.CreateType();
        return newAssembly;
    }

    static void Main()
    {
        // Hook up the event handler
        Thread.GetDomain().AssemblyResolve += new ResolveEventHandler(App.TypeResolveHandler);
        // Find a type that should be in our assembly but isn't
        ObjectHandle oh = Activator.CreateInstance("DynamicAssem", "ANonExistentType");
        Type mt = oh.Unwrap().GetType();
        // Construct an instance of a type
        Object objInstance = Activator.CreateInstance(mt);
        // Find a method in this type and call it on this object
        MethodInfo mi = mt.GetMethod("SimpleMethod");
        mi.Invoke(objInstance, null);
        Console.ReadKey();
    }
}
```
