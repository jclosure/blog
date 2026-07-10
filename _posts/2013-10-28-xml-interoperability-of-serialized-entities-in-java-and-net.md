---
layout: post
title: "XML Interoperability of  Serialized Entities in Java and .NET"
date: 2013-10-28 20:45:07 -0600
categories: []
tags: ["C#", "java", "Xml"]
wordpress_id: 393
original_url: "https://joelholder.com/2013/10/28/xml-interoperability-of-serialized-entities-in-java-and-net/"
---
<p>Abstract:</p>
<p>In order to exchange structured data directly between the platforms, we must be able to easily take the marshalled or serialized definition of the object and turn it into an object in memory.  There are standard ways of marshalling of objects to XML in both Java and .NET.  I have found it a little frustrating in the past when I’ve had to adopt large frameworks or external machinery in order to easily move structured data between the JVM and CLR.   It seems that we should be able to bring these worlds together in a simple set of OOTB idioms, while providing a convenient way (one liner) to move back and forth between object and stringified forms.   For this I have created a minimal helper class for both languages that does the following:</p>
<ul>
<li>Provides a common API between languages for moving between XML string and Objects (entities)</li>
<li>Provides adaptation capabilities between canonical XML representations for both Java’s JAXB and .NET’s XmlSerializer</li>
<li>Provides a façade to the underlying language and framework mechanics for going between representations</li>
<li>Implementation of SerializationHelper.java</li>
<li>Implementation of SerializationHelper.cs</li>
</ul>
<hr />
<p align="center"><b>The Need for Interoperable Xml Representation of Entities in Java and .NET</b></p>
<p>Both the Java and .NET ecosystems provide many ways to work with XML, JSON, Binary, YAML, etc. serialization.  In this article I’m focused on the base case between the standard platform-level mechanisms for moving between XML and Object graphs in memory.  The Web Services stacks in both platforms are of course built on top of their respective XML binding or serialization standards.  The standards however differ, in some slight but important ways.  Here I do not seek to build a bullet proof general purpose adapter between languages.  I’ll leave that to the WS-* ppl.  However, I think there is a common and often overlooked ability to do marshalling with XML with little to no additional framework or specialized stack.  Here are some scenarios that make sense with this kind capability.</p>
<ul>
<li>Intersystem Messaging</li>
<li>Transforming and Adapting Data Structures</li>
<li>Database stored and shared XML</li>
<li>Queue-based storage and shared XML</li>
<li>File-based storage and shared XML</li>
<li>Web Request/Response shared XML</li>
</ul>
<p>The Specifications:</p>
<p>Java:</p>
<p><a href="https://jaxb.java.net/">JAXB (Java XML Binding)</a></p>
<p>JSR: <a href="http://jcp.org/en/jsr/detail?id=222">222</a></p>
<p>.NET</p>
<p><a href="http://msdn.microsoft.com/en-us/library/system.xml.serialization.xmlserializer.aspx">XmlSerializer</a></p>
<p>Version >= .NET 2.0</p>
<p>First, we need to understand the default differences between the XML output by JAXB and XmlSerializer. To start we&#8217;ll create the same entity in both Java and C#. Then we can compare them.</p>
<p>The entity: DataObject</p>
<p>.NET Entity Class:</p>
<pre class="brush: csharp; title: ; notranslate" title="">
&#x5B;Serializable]
public class DataObject
{
   public string Id { get; set; }
   public string Name { get; set; }
   public bool Processed { get; set; }
}
</pre>
<p>Java Entity Class:</p>
<pre class="brush: java; title: ; notranslate" title="">
public class DataObject implements Serializable {

	private String id;
	private String name;
	private boolean processed = false;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public boolean isProcessed() {
		return processed;
	}

	public void setProcessed(boolean processed) {
		this.processed = processed;
	}
}
</pre>
<p>Java Entity XML:</p>
<pre class="brush: xml; title: ; notranslate" title="">
&lt;DataObject&gt;
  &lt;id&gt;ea9b96a6-1f8a-4563-9a15-b1ec0ea1bc34&lt;/id&gt;
  &lt;name&gt;blah&lt;/name&gt;
  &lt;processed&gt;false&lt;/processed&gt;
&lt;/DataObject&gt;
</pre>
<p>.NET Entity XML:</p>
<pre class="brush: xml; title: ; notranslate" title="">
&lt;DataObject xmlns:xsi=&quot;http://www.w3.org/2001/XMLSchema-instance&quot; xmlns:xsd=&quot;http://www.w3.org/2001/XMLSchema&quot;&gt;
  &lt;Id&gt;b3766011-a1ab-41bf-9ce2-8566fca5736f&lt;/Id&gt;
  &lt;Name&gt;blah&lt;/Name&gt;
  &lt;Processed&gt;false&lt;/Processed&gt;
&lt;/DataObject&gt;
</pre>
<p>The notable differences in the XML are these:</p>
<ul>
<li>xsi and xsd namespaces are put in by .NET and not by Java</li>
<li>The casing of the element names are different.  In fact, they follow the style convention used to create the entity.  The property naming styles between the languages are as follows:
<ul>
<li>Java: CamelCase</li>
<li>.NET: PascalCase</li>
</ul>
</li>
</ul>
<p>Let&#8217;s have a look at how we can use a class called SerializationHelper to round-trip objects to xml and back objects. We want it to easily dehydrate (stringify) and rehydrate (objectify) data objects.</p>
<p>The implementation of this class in both Java and C# provides the following api:</p>
<pre class="brush: plain; title: ; notranslate" title="">
String serialize(Object object)
Object deserialize(String str, Class klass)
</pre>
<p>This is useful for quickly reversing objects to XML and visaversa.</p>
<p>I&#8217;ll walk you through how to use it with some tests.</p>
<p>Round Tripping (Java Usage):</p>
<pre class="brush: java; title: ; notranslate" title="">
@Test
public void can_round_trip_a_pojo_to_xml() throws Exception
{
	SerializationHelper helper = new SerializationHelper();
	DataObject obj = buildDataObject();

	String strObj = helper.serialize(obj);

	DataObject obj2 = (DataObject) helper.deserialize(strObj, DataObject.class);

	Assert.isTrue(obj.getId().equals(obj2.getId()));
	Assert.isTrue(obj.getName().equals(obj2.getName()));

}
</pre>
<p>Round Tripping (C# Usage):</p>
<pre class="brush: csharp; title: ; notranslate" title="">
&#x5B;TestMethod]
public void can_round_trip_a_poco_to_xml()
{
    SerializationHelper helper = new SerializationHelper();
    DataObject obj = BuildDataObject();

    string strObj = helper.serialize(obj);

    DataObject obj2 = (DataObject)helper.deserialize(strObj, typeof(DataObject));

    Assert.IsTrue(obj.Id.Equals(obj2.Id));
    Assert.IsTrue(obj.Name.Equals(obj2.Name));
}
</pre>
<p>No problem. A simple single line expression reverses the representation. Now lets see if we can move the stringified representations between runtimes to become objects.</p>
<p>Adapting .NET XML to Java (Java Usage):</p>
<pre class="brush: java; title: ; notranslate" title="">
@Test
public void can_materialize_an_object_in_java_from_net_xml() throws Exception
{
	SerializationHelper helper = new SerializationHelper();

	String netStrObj = Files.toString(new File(&quot;DOTNET_SERIALIZED_DATAOBJECT.XML&quot;), Charsets.UTF_8);

	DataObject obj2 = (DataObject) helper.deserialize(netStrObj, DataObject.class);

	Assert.isTrue(obj2.getName().equals(&quot;blah&quot;));
}
</pre>
<p>Behind the scenes here there is a <a href="http://blog.bdoughan.com/2010/12/case-insensitive-unmarshalling.html">StreamReaderDelegate</a>under the hood in the SerializationHelper that is intercepting the inbound XML and camel-casing the names before it attempts to bind them onto the DataObject instance directly.</p>
<p>SerializationHelper.java:</p>
<pre class="brush: java; title: ; notranslate" title="">
public class SerializationHelper {

	public String serialize(Object object) throws Exception{
		StringWriter resultWriter = new StringWriter();
		StreamResult result = new StreamResult( resultWriter );
		XMLStreamWriter xmlStreamWriter =
		           XMLOutputFactory.newInstance().createXMLStreamWriter(result);

		JAXBContext context = JAXBContext.newInstance(object.getClass());
		Marshaller marshaller = context.createMarshaller();
		marshaller.marshal(new JAXBElement(new QName(object.getClass().getSimpleName()), object.getClass(), object), xmlStreamWriter);

		String res = resultWriter.toString();
	    return res;
	}

	public Object deserialize(String str, Class klass) throws Exception{

        InputStream is = new ByteArrayInputStream(str.getBytes(&quot;UTF-8&quot;));
        XMLStreamReader reader = XMLInputFactory.newInstance().createXMLStreamReader(is);
        reader = new CamelCaseTransfomingReaderDelegate(reader, klass);

		JAXBContext context = JAXBContext.newInstance(klass);
		Unmarshaller unmarshaller = context.createUnmarshaller();

		JAXBElement elem = unmarshaller.unmarshal(reader, klass);
		Object object = elem.getValue();

		return object;
	}

	//adapts to Java property naming style
	private static class CamelCaseTransfomingReaderDelegate extends StreamReaderDelegate {

		Class klass = null;

        public CamelCaseTransfomingReaderDelegate(XMLStreamReader xsr, Class klass) {
        	super(xsr);
        	this.klass = klass;
        }

        @Override
        public String getLocalName() {
            String nodeName = super.getLocalName();
            if (!nodeName.equals(klass.getSimpleName()))
            {
            	nodeName = nodeName.substring(0, 1).toLowerCase() +
            			   nodeName.substring(1, nodeName.length());
            }
            return nodeName.intern(); //NOTE: intern very important!..
        }
    }
}
</pre>
<p>Note the deserialize method is able to do just-in-time fixup of the property name xml nodes to ensure they meet the expection (a camelCased fieldname) of the default jaxb unmarshalling behavior.</p>
<p>Now to go from XML produced by the default JAXB serializer to .NET objects with the same api. To do this I&#8217;ll switch back to C# now.</p>
<p>Adapting Java XML to .NET (C# Usage):</p>
<pre class="brush: csharp; title: ; notranslate" title="">
&#x5B;TestMethod]
public void can_materialize_an_object_in_net_from_java_xml()
{
    string javaStrObj = File.ReadAllText(&quot;JAVA_SERIALIZED_DATAOBJECT.XML&quot;);

    SerializationHelper helper = new SerializationHelper();

    DataObject obj2 = (DataObject)helper.deserialize(javaStrObj, typeof(DataObject));

    Assert.isTrue(obj2.getName().equals(&quot;blah&quot;));
}
</pre>
<p>In this case, I’m using a custom <a href="http://weblogs.asp.net/cazzu/archive/2004/05/10/129106.aspx">XmlReader</a> that adapts the XML from Java style property names to .NET style. The pattern in Java and .NET is roughly the same for adapting the XML into a consumable form. This is the convenience and power that using an intermediary stream reader gives you. It basically applies changes to the node names it needs to bind them to the correct property names. The nice thing is that this happens just-in-time, as the XML being deserialized into a local Object.</p>
<p>Here is the C# implementation of the same SerializationHelper api in .NET.</p>
<p>SerializationHelper.cs:</p>
<pre class="brush: csharp; title: ; notranslate" title="">
public class SerializationHelper
{

    public string serialize(object obj)
    {
        using (MemoryStream stream = new MemoryStream())
        {
            XmlSerializer xs = new XmlSerializer(obj.GetType());
            xs.Serialize(stream, obj);
            return Encoding.UTF8.GetString(stream.ToArray());
        }
    }

    public object deserialize(string serialized, Type type)
    {
        using (MemoryStream stream = new MemoryStream(Encoding.UTF8.GetBytes(serialized)))
        {
            using (var reader = new PascalCaseTransfomingReader(stream))
            {
                XmlSerializer xs = new XmlSerializer(type);
                return xs.Deserialize(reader);
            }
        }
    }

    private class PascalCaseTransfomingReader : XmlTextReader
    {
        public PascalCaseTransfomingReader(Stream input) : base(input) { }

        public override string this&#x5B;string name]
        {
            get { return this&#x5B;name, String.Empty]; }
        }

        public override string LocalName
        {
            get
            {
                // Capitalize first letter of elements and attributes.
                if (base.NodeType == XmlNodeType.Element ||
                    base.NodeType == XmlNodeType.EndElement ||
                    base.NodeType == XmlNodeType.Attribute)
                {
                    return base.NamespaceURI == &quot;http://www.w3.org/2000/xmlns/&quot; ?
                           base.LocalName : MakeFirstUpper(base.LocalName);
                }
                return base.LocalName;
            }
        }

        public override string Name
        {
            get
            {
                if (base.NamespaceURI == &quot;http://www.w3.org/2000/xmlns/&quot;)
                    return base.Name;
                if (base.Name.IndexOf(&quot;:&quot;) == -1)
                    return MakeFirstUpper(base.Name);
                else
                {
                    // Turn local name into upper, not the prefix.
                    string name = base.Name.Substring(0, base.Name.IndexOf(&quot;:&quot;) + 1);
                    name += MakeFirstUpper(base.Name.Substring(base.Name.IndexOf(&quot;:&quot;) + 1));
                    return NameTable.Add(name);
                }
            }
        }

        private string MakeFirstUpper(string name)
        {
            if (name.Length == 0) return name;
            if (Char.IsUpper(name&#x5B;0])) return name;
            if (name.Length == 1) return name.ToUpper();
            Char&#x5B;] letters = name.ToCharArray();
            letters&#x5B;0] = Char.ToUpper(letters&#x5B;0]);
            return NameTable.Add(new string(letters));
        }

    }
}
</pre>
<p>I think it’s important to have a thorough understanding and good control of the basics of serialization. In some cases, we&#8217;re just consuming a serialized object from a message queue, a file, or a database. The ability to move entities between process and stack boundaries should be easy.</p>
<p>It should take only 1 line of code.</p>
