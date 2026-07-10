---
layout: post
title: "C#-powered JavaScript Expression Evaluator"
date: 2012-04-04 09:20:20 -0500
categories: []
tags: []
wordpress_id: 221
original_url: "https://joelholder.com/2012/04/04/c-string-javascript-expression-evaluator/"
---
<p>Here&#8217;s an interesting little class that I initially created to do dynamic arithmetic.  However, after getting the concept up and running, it turns out to be a lot more powerful.  The idea is to start up a hosted JavaScript runtime inside the CLR runtime and present it with string of JavaScript code for immediate inline execution.  The ExpressionEvaluator dutifully loads and evaluates the &#8220;scriptlet&#8221;, and then it returns the results back to .NET as a string, which can easily be coerced back into an instance of a native CLR Type.  In the original case, this allowed for a javascript-powered dynamic calculator from the statically typed C#.NET, VB.NET, or F# language runtimes.  However, there are more interested use cases for this technology, beyond what I demonstrate here, such as providing a user extensibility layer to the logic of a compiled application at runtime.  For example, allowing users to generate, extend, and mutate existing business rules could easily be achieved by allowing users to introduce script text directly into a captive execution sandbox.  User-specified business rules could be stored as simple text and spooled for execution in workflow engine&#8217;s, etc.  Another interesting use case, might be to hook up a REPL (Read Eval Print Loop) into a UI and allow users to issue any sort structured arithmetic expressions directly to the engine, having it respond back with answers in realtime.</p>
<p>Here is a simple unit test showing how to drive it:</p>

~~~ csharp
using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Unit.Core
{
 [TestClass]
 public class ExpressionEvaluatorTest
 {
 public TestContext TestContext { get; set; }

[TestMethod]
 public void EvaluateToStringTest()
 {
 var result = ExpressionEvaluator.EvaluateToString("(2+5) < 8");
 Assert.IsTrue(Convert.ToBoolean(result));
 }
 }
}&#91;/sourcecode&#93;

Here is the ExpressionEvaluator:

&#91;sourcecode lang="csharp"&#93;using System;
using System.CodeDom.Compiler;
using System.Globalization;
using System.Reflection;
using Microsoft.JScript;

namespace Core.Utils
{
 public static class ExpressionEvaluator
 {
 #region static members
 private static object _evaluator = GetEvaluator();
 private static Type _evaluatorType;
 private const string _evaluatorSourceCode =
 @"package Evaluator
 {
 class Evaluator
 {
 public function Eval(expr : String) : String
 {
 return eval(expr);
 }
 }
 }";

#endregion

#region static methods
 private static object GetEvaluator()
 {
 CompilerParameters parameters;
 parameters = new CompilerParameters();
 parameters.GenerateInMemory = true;

JScriptCodeProvider jp = new JScriptCodeProvider();
 CompilerResults results = jp.CompileAssemblyFromSource(parameters, _evaluatorSourceCode);

Assembly assembly = results.CompiledAssembly;
 _evaluatorType = assembly.GetType("Evaluator.Evaluator");

return Activator.CreateInstance(_evaluatorType);
 }

/// <summary>
 /// Executes the passed JScript Statement and returns the string representation of the result
 /// </summary>
 /// <param name="statement">A JScript statement to execute</param>
 /// <returns>The string representation of the result of evaluating the passed statement</returns>
 public static string EvaluateToString(string statement)
 {
 object o = EvaluateToObject(statement);
 return o.ToString();
 }

/// <summary>
 /// Executes the passed JScript Statement and returns the result
 /// </summary>
 /// <param name="statement">A JScript statement to execute</param>
 /// <returns>The result of evaluating the passed statement</returns>
 public static object EvaluateToObject(string statement)
 {
 lock (_evaluator)
 {
 return _evaluatorType.InvokeMember(
 "Eval",
 BindingFlags.InvokeMethod,
 null,
 _evaluator,
 new object[] { statement },
 CultureInfo.CurrentCulture
 );
 }
 }
 #endregion
 }
}
~~~
