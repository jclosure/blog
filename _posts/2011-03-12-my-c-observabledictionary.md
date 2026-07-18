---
layout: post
title: "My C# ObservableDictionary"
date: 2011-03-12 22:39:18 -0600
categories: []
tags: []
wordpress_id: 70
original_url: "https://joelholder.com/2011/03/12/my-c-observabledictionary/"
---

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.Collections.Specialized;

namespace DynamicSpikes
{
    public class ObservableDictionary<String, Object> : Dictionary<string, object>, INotifyPropertyChanged, INotifyCollectionChanged
    {
        public event PropertyChangedEventHandler PropertyChanged = delegate { };
        public event NotifyCollectionChangedEventHandler CollectionChanged = delegate { };

        private void OnCollectionChanged(object sender, NotifyCollectionChangedAction action, object value)
        {
            if (CollectionChanged != null)
            {
                CollectionChanged(sender, new NotifyCollectionChangedEventArgs(action, value));
            }
        }

        private void OnPropertyChanged(object sender, string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        public new void Add(string key, object value)
        {
            base.Add(key, value);
            OnCollectionChanged(this, NotifyCollectionChangedAction.Add, new KeyValuePair<string, object>(key, value));

            //OnPropertyChanged(this, "Values");
            //OnPropertyChanged(this, "Keys");
            //OnPropertyChanged(this, "Count");
        }

        public new bool Remove(string key)
        {
            var kvp = base[key];
            var result = base.Remove(key);
            if (result)
            {
                OnCollectionChanged(this, NotifyCollectionChangedAction.Remove, kvp);

                //OnPropertyChanged(this, "Values");
                //OnPropertyChanged(this, "Keys");
                //OnPropertyChanged(this, "Count");
            }
            return result;
        }

        public new object this[string key]
        {
            get
            {
                return base[key];
            }
            set
            {
                base[key] = value;
                PropertyChanged(this, new PropertyChangedEventArgs(key));
            }
        }
    }
}
```
