---
layout: post
title: "Object Bakery – Fun with .NET Serialization and Crypto: Part 1"
date: 2009-01-12 21:22:13 -0600
categories: []
tags: []
wordpress_id: 14
original_url: "https://joelholder.com/2009/01/12/object-bakery-fun-with-net-serialization-and-crypto-part-1/"
---

Being able to snapshot an object graph at runtime can be a valuable capability. I have had occasion to capture objects during a run for the purpose of analyzing and debugging problems that require comparison across multiple runs. Additionally, the power to dehydrate objects and store them in a disk based cache, can also prove quite useful in certain scenarios. Some other capabilities include capturing archetypal object instances to file and adding them as embedded resources to test projects to serve as stubs and/or test doubles. Some other ways to work with objects offline might include sending dehydrated objects through FTP, Email, Message Queues, etc. I present here a few helper classes that I have used for the purposes described and more.

First, when security is not a concern, serialization to plain text Xml can be an effective means of quick object dehydration. I wrote the SerializationHelper for this purpose. Below is a test that demonstrates instancing a serializable entity class (a Product), converting it to an Xml string representation, and converting the string back into an object.

```csharp
[TestMethod]
public void CanSerializeToandFromXml()
{
    Product product1 = new TestProductFactory().Build()[0];
    SerializationHelper serializationHelper = new SerializationHelper();
    string sProduct1 = serializationHelper.XmlSerialize(product1);

    Product product2 = serializationHelper.XmlDeserialize<Product>(sProduct1);
    XmlDocument testLoadDoc = new XmlDocument();
    testLoadDoc.LoadXml(sProduct1); //throws exception if not well formed

    Assert.IsTrue(product1.ID.Equals(product2.ID) &&
        product1.Name.Equals(product2.Name));

    //the products themselves are not the same instance, but instead deep copies
    Assert.IsFalse(product1.Equals(product2));
}
```

As you can see the assertions, show that the two Product objects have the same data, but they are in fact not the same object. With this we have created a deep copy of the original product as it makes it through the round trip. The dehydrated Product looks in this case looks something like this:

```xml
<?xml version="1.0"?>
<Product xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <ID>1</ID>
  <SKU>fa8f0777-74e7-4aeb-926f-a554b5dc191e</SKU>
  <Name>Monkey</Name>
  <Description>Squirrel Monkey.  Aggressive disposition.  Likes icecream and hugs.</Description>
  <Assets>
    <Asset>
      <Format>Docx</Format>
      <Data>UEsDBBQABgAIAAAAIQAeGe91cwEAAFQFAAATAAgCW0NvbnRlbnRfVHlwZXNdLnhtbCCiBAIooAACAAAAAAAAAAAAAAA</Data>
      <ID>1</ID>
      <Name>Brochure</Name>
    </Asset>
    <Asset>
      <Format>Jpg</Format>
      <Data>/9j/4U5uRXhpZgAATU0AKgAAAAgACgEPAAIAAAAGAAAAhgEQAAIAAAAPAAAAjAESAAMAAAABAAEAAAEaAAUAAAA</Data>
      <ID>2</ID>
      <Name>Image1</Name>
    </Asset>
    <Asset>
      <Format>Jpg</Format>
      <Data>/9j/4VsfRXhpZgAATU0AKgAAAAgACgEPAAIAAAAGAAAAhgEQAAIAAAAPAAAAjAESAAMAAAABAAEAAAEaAAUAAAAB</Data>
      <ID>3</ID>
      <Name>Image2</Name>
    </Asset>
  </Assets>
</Product>
```

Note that in this case, the Product class carries with it a generic List of Assets, which themselves carry byte arrays that represent images, documents, brochures, etc.. Thus with this approach I'm able to flatten an object graph that carries file assets send it somewhere as Xml, reconstitute it, save off its byte arrays to disk, and then open them with the appropriate program.

If the entity objects that you are working with do not implement ISerializable, they should be tagged with the Serializable attribute. In the case where you have not explicitly implemented ISerializable and some of the properties are not set, you'll find that these properties are missing from the Xml that results from serialization with XmlSerializer, SoapFormatter, or BinaryFormatter. The DataContractSerialize/DataContractDeserialize helper methods allow you to provide a Type that is attributed with WCF DataContract and DataMember attributes to give the serializer hints on how to work with the object.

```csharp
[TestMethod]
public void CanDataContractSerializeDeserialize()
{
    Product product = new TestProductFactory().Build()[0];
    var serializationHelper = new SerializationHelper();

    var pBytes = serializationHelper.DataConractSerialize<Product>(product);
    string xstring = Encoding.UTF8.GetString(pBytes);

    var pBytes2 = Encoding.UTF8.GetBytes(xstring);
    Product product2 = serializationHelper.DataConractDeserialize<Product>(pBytes2);

    //verify
    Assert.IsTrue(product.Name.Equals(product2.Name) && product.ID.Equals(product2.ID));
    Assert.IsFalse(product.Equals(product2)); //deep copy
}
```

Now the Class..

```csharp
public class SerializationHelper
{
    public string XmlSerialize(object Member)
    {
        using (MemoryStream b = new MemoryStream())
        {
            XmlSerializer xs = new
                XmlSerializer(Member.GetType());
            xs.Serialize(b, Member);
            return Encoding.UTF8.GetString(b.ToArray());
        }
    }
    public T XmlDeserialize<T>(string Serialized)
    {
        using (MemoryStream b =
            new MemoryStream(Encoding.UTF8.GetBytes(Serialized)))
        {
            XmlSerializer xs = new XmlSerializer(typeof(T));
            return (T)xs.Deserialize(b);
        }
    }

    public byte[] SoapSerialize<T>(T obj)
    {
        byte[] bytes = null;

        using (MemoryStream b = new MemoryStream())
        {
            SoapFormatter formatter = new SoapFormatter();
            formatter.Serialize(b, obj);
            bytes = b.ToArray();
        }

        return bytes;
    }
    public T SoapDeserialize<T>(byte[] blob)
    {
        T obj = default(T);

        using (MemoryStream b = new MemoryStream(blob))
        {
            SoapFormatter formatter = new SoapFormatter();
            obj = (T)formatter.Deserialize(b);
        }

        return obj;
    }

    public byte[] BinarySerialize(object obj)
    {
        byte[] bytes = null;
        IFormatter formatter = new BinaryFormatter();
        using (MemoryStream stream = new MemoryStream())
        {
            formatter.Serialize(stream, obj);
            bytes = stream.ToArray();
        }
        return bytes;
    }

    public T BinaryDeserialize<T>(byte[] bytes)
    {
        T instance = default(T);
        IFormatter formatter = new BinaryFormatter();
        using (MemoryStream stream = new MemoryStream(bytes))
        {
            instance = (T)formatter.Deserialize(stream);
            bytes = stream.ToArray();
        }
        return instance;
    }

    public virtual T DataConractDeserialize<T>(byte[] bytes)
    {
        T result = default(T);
        using (var stream = new MemoryStream(bytes))
        {
            XmlReader reader = XmlReader.Create(stream);
            DataContractSerializer serializer = new DataContractSerializer(typeof(T));
            result = (T)serializer.ReadObject(reader);
        }
        return result;
    }

    public virtual byte[] DataConractSerialize<T>(T obj)
    {
        byte[] bytes = new byte[] { };
        using (var stream = new MemoryStream())
        {
            XmlWriter writer = XmlWriter.Create(stream);
            DataContractSerializer serializer = new DataContractSerializer(typeof(T));
            serializer.WriteObject(writer, obj);
            writer.Flush();
            bytes = stream.ToArray();
        }

        return bytes;
    }
}
```

Thats the basic scenario. In [part 2](http://uberpwn.spaces.live.com/blog/cns!3FC3980D58CF7EFB!479.entry) of this article, I'll demonstrate how to do secure object persistence to disk. You'll also be able to download the source for both parts. Enjoy and happy baking…
