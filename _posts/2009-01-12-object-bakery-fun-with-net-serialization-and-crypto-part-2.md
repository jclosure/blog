---
layout: post
title: "Object Bakery – Fun with .NET Serialization and Crypto: Part 2"
date: 2009-01-12 21:53:00 -0600
categories: []
tags: []
wordpress_id: 19
original_url: "https://joelholder.com/2009/01/12/object-bakery-fun-with-net-serialization-and-crypto-part-2/"
---

In my [last article](http://uberpwn.spaces.live.com/blog/cns!3FC3980D58CF7EFB!475.entry), I demonstrated how to use .NET serialization to dehydrate and rehydrate objects with helpers that drive XmlSerializer, DataContractSerializer, SoapFormatter, and BinaryFormatter. This is part 2, where I expand upon these concepts demonstrating how to use the DESCryptoServiceProvider to securely save off your objects for later consumption. For this, I created a few helpers that encrypt an object stream and save it to disk, as well as the reverse. Only instead of using MemoryStream as we did in the last article, we use the CryptoStream and a shared key. Here is a test that shows a secure round trip that saves an encrypted Product instance to disk and reads it back out.

```csharp
[TestMethod]
public void CanEncyptToDecryptFromDisk()
{
    string strKey = ObjectHelper.GenerateKey();
    ObjectHelper objectHelper = new ObjectHelper();
    FileInfo file = new FileHelper().GetTempFile();

    List<Asset> assets = new TestAssetFactory().Build();

    objectHelper.EncryptObjectToDisk(file.FullName, assets, strKey);

    List<Asset> assets2 =
       (List<Asset>)objectHelper.DecryptObjectFromDisk(file.FullName, strKey);

    Assert.IsNotNull(assets2);

    file.Delete();
}
```

A notable difference from the samples in [part 1](http://uberpwn.spaces.live.com/blog/cns!3FC3980D58CF7EFB!475.entry) is that we generate a key first and then use it to symmetrically encrypt and decrypt our persisted object. The single assertion here is not particularly impressive, so here is a test that runs the same idiom with a DataSet and then compares the values of each field in each row for match fidelity.

```csharp
[TestMethod]
public void CanDehydrateRehydrateDataSetToFile()
{
    string dataKey = ObjectHelper.GenerateKey();

    FileInfo file = new FileHelper().GetTempFile();
    DataTable productsDataTable = new TestTableFactory().Build();
    DataSet productsDataSet = new DataSet("Products");
    productsDataSet.Tables.Add(productsDataTable);

    ObjectHelper objectHelper = new ObjectHelper();
    objectHelper.EncryptObjectToDisk(file.FullName, productsDataSet, dataKey);
    DataSet productsDataSet2 =
        (DataSet)objectHelper.DecryptObjectFromDisk(file.FullName, dataKey);

    Assert.IsTrue(productsDataSet2 != null);

    for (int j = 0; j < productsDataSet.Tables["Products"].Rows.Count; j++)
    {
        DataRow pRow = productsDataSet.Tables["Products"].Rows[j];
        DataRow pRow2 = productsDataSet2.Tables["Products"].Rows[j];

        for (int i = 0; i < pRow.ItemArray.Length; i++)
        {
            Assert.IsTrue(pRow.ItemArray[i].ToString() ==
               pRow2.ItemArray[i].ToString());
        }
    }

    file.Delete();
}
```

Finally, here is the ObjectHelper class demonstrated above..

```csharp
public class ObjectHelper
{
    public static string GenerateKey()
    {
        // Create an instance of Symetric Algorithm. Key and IV is generated automatically.
        DESCryptoServiceProvider desCrypto =
             (DESCryptoServiceProvider)DESCryptoServiceProvider.Create();

        // Use the Automatically generated key for Encryption.
        return ASCIIEncoding.ASCII.GetString(desCrypto.Key);
    }

    public bool EncryptObjectToDisk(string fileFullPath, object data, string eKey)
    {
        FileStream fsEncrypted =
             new FileStream(fileFullPath, FileMode.Create, FileAccess.Write);
        bool saveSuccess = false;
        try
        {
            DESCryptoServiceProvider des = new DESCryptoServiceProvider();
            des.Key = ASCIIEncoding.ASCII.GetBytes(eKey);
            des.IV = ASCIIEncoding.ASCII.GetBytes(eKey);
            CryptoStream cryptostream =
                 new CryptoStream(fsEncrypted, des.CreateEncryptor(), CryptoStreamMode.Write);
            BinaryFormatter bin =
                 new BinaryFormatter(null, new StreamingContext(StreamingContextStates.File));
            using (StreamWriter streamWriter = new StreamWriter(cryptostream))
            {
                bin.Serialize(streamWriter.BaseStream, data);
                streamWriter.Flush();
                streamWriter.Close();
                saveSuccess = true;
            }
        }
        finally
        {
            if (fsEncrypted != null)
                fsEncrypted.Close();
        }
        return saveSuccess;
    }

    public object DecryptObjectFromDisk(string fileFullPath, string eKey)
    {
        if (!File.Exists(fileFullPath))
            return null;
        FileStream fsEncrypted =
              new FileStream(fileFullPath, FileMode.Open, FileAccess.Read);
        try
        {
            DESCryptoServiceProvider des = new DESCryptoServiceProvider();
            des.Key = ASCIIEncoding.ASCII.GetBytes(eKey);
            des.IV = ASCIIEncoding.ASCII.GetBytes(eKey);
            CryptoStream cryptostream =
                 new CryptoStream(fsEncrypted, des.CreateDecryptor(), CryptoStreamMode.Read);
            object data = null;
            BinaryFormatter bin =
                 new BinaryFormatter(null, new StreamingContext(StreamingContextStates.File));
            using (StreamReader reader = new StreamReader(cryptostream))
            {
                data = bin.Deserialize(reader.BaseStream);
                reader.Close();
            }
            return data;
        }
        finally
        {
            if (fsEncrypted != null)
                fsEncrypted.Close();
        }
    }
}
```

The samples I provide here are from a Utility library that I use in some of my apps, you can download the working src and tests [here](http://www.codeplex.com/objectbakery/SourceControl/ListDownloadableCommits.aspx). If anyone out there finds some use in these or can suggest improvements or other applications, I'd love to hear about it. Thanks and happy baking..
