---
layout: post
title: "C# Deserves A Better Message Passing API"
date: 2013-05-16 21:01:53 -0500
categories: []
tags: ["C#", "method_missing", "Reflection"]
wordpress_id: 288
original_url: "https://joelholder.com/2013/05/16/if-it-quacks-like-a-duck-its-probably-a-duck-like-object-behaving-like-duckishly/"
---
<p>The structured programming model of C# is decisive and straightforward. There is generally one or only a handful of idiomatically correct ways to facilitate a particular design need. In the case of API design, the language&#8217;s conception of access modifiers is fundamental. Exposures of behaviors to client code are controlled by applying public, private, or protected modifiers to individual methods. While this basic security mechanism, does allow us to build cleaner APIs, it does not strictly limit our ability to reach inside objects and work with their internal private methods. We can both interrogate and mutate the internal state of objects with no public API whatsoever.</p>
<p>In this post I&#8217;m going to show you how use reflection to add a feature to C# that mimics the simple message passing API that I like in Ruby. With this in place, we&#8217;ll be able to run any private method on any instance object with a more straightforward syntax.</p>
<p>First, we&#8217;ll give System.Object the ability to receive messages via an Extension Method called <em>send</em>.</p>

~~~ csharp
namespace MessagePassingExtensions
{
    public static class Extensions
    {
        //PUBLIC API
        public static bool respond_to(this object o, string responder, params object[] paramSoak)
        {
            return respond_by(o, responder, paramSoak) != null;
        }

        public static object send(this object o, string responder, params object[] paramSoak)
        {
            if (!o.respond_to(responder, paramSoak))
            {
                var reason = string.Format("This object does not respond to messages sent to: {0} with parameters: {1}",
                                           responder,
                                           string.Join(", ", paramSoak));
                throw new MissingMethodException(reason);
            }
            var result = o.respond_by(responder, paramSoak).InvokeMember(responder, send_flags, null, o, paramSoak);
            return result;
        }

        //PRIVATE HELPERS
        private const BindingFlags send_flags = BindingFlags.InvokeMethod | BindingFlags.Instance |
                                                BindingFlags.Public | BindingFlags.NonPublic;

        private static Type respond_by(this object o, string responder, params object[] paramSoak)
        {
            var class_lookup_path = o.GetType().GetBaseTypes().Reverse().Concat(new[] { o.GetType() }).Reverse().ToList();
            return class_lookup_path.FirstOrDefault(t => t.GetMethods(send_flags)
                                                          .Any(m => m.Name == responder &&
                                                                    m.GetParameters().Count() == paramSoak.Count() &&
                                                                    m.GetParameters().All(p => paramSoak[p.Position].GetType().IsAssignableFrom(p.ParameterType))));
        }

        private static IEnumerable<Type> GetBaseTypes(this Type type)
        {
            if (type.BaseType == null) return type.GetInterfaces();
            return Enumerable.Repeat(type.BaseType, 1)
                             .Concat(type.GetInterfaces())
                             .Concat(type.GetInterfaces().SelectMany<Type, Type>(GetBaseTypes))
                             .Concat(type.BaseType.GetBaseTypes())
                             .Distinct();
        }
    }
~~~

<p>This gives the API we need. Note that there are only 2 public methods added to the builtin object type:</p>
<p><strong>respond_to()</strong> – allows you to ask an instance if it can respond to a particular message.</p>
<p><strong>send()</strong> – allows you to send an instance a message.</p>
<p>Now let&#8217;s create a class that we can use as our test subject. We&#8217;ll use domain of the animal kingdom. First we need a base Animal:</p>

~~~ csharp
public class Animal
{
    private bool Eat()
    {
        return true;
    }
}
~~~

<p>Note that there is only a private method in here, an Eat() behavior. This symbol will not be visible to subclasses nor will it be available via the public API. Next, let&#8217;s derive a specific animal by inheriting from this base class. Say in this case, a Duck:</p>

~~~ csharp
public class Duck: Animal
{
    private string Quack(int times)
    {
        var noises = new List<string>();
        for (var i = 0; i < times; i++)
        {
            noises.Add(MethodBase.GetCurrentMethod().Name);
        }
        return string.Join(" ", noises);
    }

    private string Quack()
    {
        return Quack(1);
    }
}
&#91;/sourcecode&#93;

Note that Duck is an Animal, and that it only has a few private methods. It cannot see Animal.Eat(). Now, let's test it out. The following Test class exercises the implementation of Object.send() and demonstrates that we're able to run all of the private methods that we just created.

&#91;sourcecode language="csharp"&#93;
&#91;TestClass&#93;
public class SendTests
{
    &#91;TestMethod&#93;
    public void can_resolve_correct_signature_with_params()
    {
        var duck = new Duck();
        var result = duck.send("Quack", 2);
        Assert.AreEqual(result, "Quack Quack");
    }

    &#91;TestMethod&#93;
    public void can_resolve_correct_signature_with_no_params()
    {
        var duck = new Duck();
        var result = duck.send("Quack");
        Assert.AreEqual(result, "Quack");
    }

    &#91;TestMethod&#93;
    public void can_respond_to_messages_from_a_base_class()
    {
        var duck = new Duck();
        var result = duck.send("Eat");
        Assert.AreEqual(result, true);
    }

    &#91;TestMethod&#93;
    &#91;ExpectedException(typeof(MissingMethodException), "You sent a message that I could not respond to")&#93;
    public void blows_up_if_sent_message_cannot_be_responded_to()
    {
        var duck = new Duck();
        var result = duck.send("Bark");
    }
}
&#91;/sourcecode&#93;

All of these tests pass. They are self-explanatory. I think that the most interesting one is <span style="color:black;font-family:Consolas;font-size:9pt;"><span style="background-color:white;">can_respond_to_messages_from_a_base_class()</span>,</span> which shows that we can also get and run a private method from the underlying Animal class. By <em>sending a message</em> to a symbol on an instance object, we're able to program against it in a looser style. This opens up a number of interesting ways to work with an object. Suppose for example you wanted to build an XML-driven execution system. By simply reading in instructions from an external xml source, we can emit and drive code execution that was not known at design time. Here's an example of a declarative approach to driving execution.

<strong>DuckDriver.xml:</strong>

[sourcecode language="xml"]

<?xml version="1.0" encoding="UTF-8" ?>
<Obj type="DynamicSpikes.Tests.Duck">
  <Run method="Quack" times="3" />
</Obj>
~~~

<p>Given the above XML File, I can process and verify it like this:</p>

~~~ csharp
[TestClass]
[DeploymentItem(@".\Assets\DuckDriver.xml")]
public class XmlDeclarativeTests
{
    [TestMethod]
    public void can_create_and_run_from_xml()
    {
        var xml = XDocument.Load(@".\DuckDriver.xml");

        var objects = xml.Root.Descendants().Where(elem => elem.Name.LocalName == "Obj").ToList();
        objects.ForEach(objElem =>
            {
                var runs = objElem.Descendants().Where(elem => elem.Name.LocalName == "Run").ToList();
                runs.ForEach(runElem =>
                    {
                        var type = Type.GetType(objElem.Attribute("type").Value);
                        var method = runElem.Attributes().Where(attr => attr.Name == "method").FirstOrDefault().Value;
                        var parameters = runElem.Attributes().Where(attr => attr.Name != "method").Select(attr => attr.Value).Cast<object>().ToArray();

                        var obj = Activator.CreateInstance(type);
                        var result = obj.send(method, parameters);
                        Assert.AreEqual(result, "Quack Quack Quack"); //<Run method="Quack" times="3" />
                    });
            });
    }
}
~~~

<p>The test reads in the XML File, finds the Obj elements, finds the Run elements, and grabs the method name and parameters from the attributes. With this information, we have all we need to create the object and send it the message. This test passes as expected.</p>
<p>The ability to turn a markup into runnable code is not new, but the ease with which it can be done with the nuts and bolts of the C# language are impressive. The fact that we can easily marshal declarative instructions into an unknown but completely runnable instruction set is more than just a little bit awesome.</p>
<p>Namaste…</p>
