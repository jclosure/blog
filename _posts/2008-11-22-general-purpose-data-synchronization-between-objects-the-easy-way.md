---
layout: post
title: "General Purpose Data Synchronization Between Objects – The Easy Way"
date: 2008-11-22 02:37:48 -0600
categories: []
tags: []
wordpress_id: 23
original_url: "https://joelholder.com/2008/11/22/general-purpose-data-synchronization-between-objects-the-easy-way/"
---

When moving messages between systems, I've often found myself confronted with the need to copy values from one object representation to another. The objects may or may not have any Properties whose names and Types match, so the solution to this problem must be tolerant of incongruent data shapes. This can always be achieved by writing specific Type mapping and converter classes to do this work, however I wanted to deal with this problem in the most generic way possible. With the aim of flexibility being the main goal, I present a solution that can synchronize properties between objects accurately, and yet is generic enough to work with any two objects. I do not require nor enforce any data contract(s) between the objects being synchronized, such as by implementing a common interface or inheriting from a common base class.

example 1:

```csharp
SomeObjectA sourceObjRef = new SomeObjectA();
SomeObjectB targetObjRef = new SomeObjectB();

new ReflectionSynchronizer().Sync(sourceObjRef, targetObjRef);
```

example 2:

```csharp
IDictionary sourceDictionary = new Hashtable();
SomeObject targetObjRef = new SomeObject();

new ReflectionSynchronizer().Sync(sourceDictionary, targetObjRef);
```

here is the class:

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Reflection;
using System.Diagnostics;
using System.Collections;

namespace Helpers
{
    public class ReflectionSynchronizer
    {
        /// <summary>
        /// synchronizes a Dictionary to an objects properties
        /// uses reflection to figure out types to convert objects in entry.Value to when setting object's properties
        /// </summary>
        /// <param name="source"></param>
        /// <param name="target"></param>
        public void Sync(IDictionary source, object target)
        {
            foreach (DictionaryEntry entry in source)
            {
                try
                {
                    PropertyInfo targetObjectProperty = target.GetType().GetProperty(entry.Key.ToString());

                    if (targetObjectProperty != null)
                    {
                        object sourceObjectValue = entry.Value;

                        if (sourceObjectValue != null)
                        {
                            //does handle nullable types – see overload for known in advanced
                            object valueToAssign = null;
                            To(sourceObjectValue, out valueToAssign, sourceObjectValue.GetType());

                            if (valueToAssign != null)
                            {
                                targetObjectProperty.SetValue(target, valueToAssign, null);
                            }
                        }
                    }
                }
                catch (ApplicationException ex)
                {
                    Debug.WriteLine(ex.Message);
                }
            }
        }

        /// <summary>
        /// synchronizes an object reference's properties' values to another object reference's properties' values
        /// </summary>
        /// <param name="source"></param>
        /// <param name="target"></param>
        public void Sync(object source, object target)
        {
            foreach (PropertyInfo sourceObjectProperty in source.GetType().GetProperties())
            {
                try
                {
                    PropertyInfo targetObjectProperty = target.GetType().GetProperty(sourceObjectProperty.Name);

                    if (targetObjectProperty != null && targetObjectProperty.PropertyType.Equals(sourceObjectProperty.PropertyType))
                    {
                        object sourceObjectValue = sourceObjectProperty.GetValue(source, null);

                        if (sourceObjectValue != null)
                        {
                            //does handle nullable types – see overload for known in advanced
                            object valueToAssign = null;
                            To(sourceObjectValue, out valueToAssign, sourceObjectValue.GetType());

                            if (valueToAssign != null)
                            {
                                targetObjectProperty.SetValue(target, valueToAssign, null);
                            }
                        }
                    }
                }
                catch (ApplicationException ex)
                {
                    Debug.WriteLine(ex.Message);
                }
            }
        }

        /// <summary>
        /// copies a value to another
        /// </summary>
        /// <param name="srcValue"></param>
        /// <param name="targetValue"></param>
        /// <param name="t"></param>
        public void To(object srcValue, out object targetValue, Type t)
        {
            targetValue = null;
            if (srcValue == DBNull.Value) return;

            if (IsNullable(t))
            {
                if (srcValue == null)
                {
                    return;
                }
                targetValue = UnderlyingTypeOf(t);
            }

            targetValue = Convert.ChangeType(srcValue, t);
        }

        /// <summary>
        /// generic version of To
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="value"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public T To<T>(object value, T defaultValue)
        {
            if (value == DBNull.Value) return defaultValue;
            Type t = typeof(T);
            if (IsNullable(t))
            {
                if (value == null) return default(T);
                t = UnderlyingTypeOf(t);
            }

            return (T)Convert.ChangeType(value, t);
        }

        /// <summary>
        /// figures out if the Type is Nullable
        /// </summary>
        /// <param name="t"></param>
        /// <returns></returns>
        private bool IsNullable(Type t)
        {
            if (!t.IsGenericType) return false;
            Type g = t.GetGenericTypeDefinition();
            return (g.Equals(typeof(Nullable<>)));
        }

        /// <summary>
        /// gets the underlying Type
        /// </summary>
        /// <param name="t"></param>
        /// <returns></returns>
        private Type UnderlyingTypeOf(Type t)
        {
            return t.GetGenericArguments()[0];
        }
    }
}
```
