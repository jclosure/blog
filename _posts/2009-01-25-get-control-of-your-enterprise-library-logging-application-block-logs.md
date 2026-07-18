---
layout: post
title: "Get Control Of Your Enterprise Library Logging Application Block Logs"
date: 2009-01-25 21:38:05 -0600
categories: []
tags: []
wordpress_id: 15
original_url: "https://joelholder.com/2009/01/25/get-control-of-your-enterprise-library-logging-application-block-logs/"
---
Enterprise Library's Logger is powerful and convenient. It's default TextFormatter provides a suitable human readable format, and it also allows you to implement custom formatters to suite your needs. I think that being able to work with log data without having to manually parse strings, can really simplify the development of tools for mining logs. To this end, I whipped up [a small WinForms app](http://cid-3fc3980d58cf7efb.skydrive.live.com/self.aspx/Public/LogChewer.WinFormSample.zip) that demonstrates how to take log entries originating from a text spool, convert them into objects, and query them with Linq. The primary goal was to provide simple UI that enables log search, filter, and find, with sorting, grouping, etc.

First off, the heavy lifting in this sample is provided by the [EntLib Contrib](http://www.codeplex.com/entlibcontrib/SourceControl/ListDownloadableCommits.aspx) LogParser. Their FilteredLogReader class drives a tokenizer, which creates and populates LogEntry objects out of log text. The tokenizer will use any formatting template, in our case, I've used the built in "Text Formatter". When it executes, it generates a RegularExpression capable of matching and trapping the values involved in populating our collection of LogEntry objects. Ultimately, we are provided with a simple API for driving all of this. Here's a brief sample:

```csharp
string configFile = "abc.config";
string traceLog = "trace.log";

FilteredLogFileReader reader =
    new FilteredLogFileReader(traceLog, configFile,
        new TimeStampParser(CultureInfo.CurrentCulture));

Filter filter = new Filter
{
    StartTime = DateTime.Now.AddHours(-1),
    StopTime = DateTime.Now
};

IEnumerable<LogEntry> entries = reader.ParseLogFile(filter);
```

The basic idiom here is:

1. Get a FilteredLogFileReader
2. Setup a Filter
3. Feed the filter to the reader's ParseLogFile

To facilitate a flexible set of filtering concepts at the UI, I decided to use a simple FilterExpression class to represent a set of keys, values, and match operators. Here's a quick way to get the intersection result set from applying a set of filters with a single pass through the logs.

```csharp
private IList<LogEntry> FilterLogEntries(List<LogEntry> lst,
                                          List<FilterExpression> exprs)
{
    var matchAllExprs = new List<LogEntry>();
    List<PropertyInfo> props = typeof(LogEntry).GetProperties().ToList();
    lst.ForEach(entry =>
    {
        int matchCount = 0;
        exprs.ForEach(expr =>
        {
            string value = props.Find(prop => prop.Name.Equals(expr.Key))
                                 .GetValue(entry, null).ToString();
            switch (expr.Operator.ToLower())
            {
                case "contains":
                    if (value.Contains(expr.Value))
                        matchCount++;
                    break;
                case "!contains":
                    if (!value.Contains(expr.Value))
                        matchCount++;
                    break;
                case "regex match":
                    if (new Regex(expr.Value).IsMatch(value))
                        matchCount++;
                    break;
                case "==":
                    if (expr.Value.Equals(value))
                        matchCount++;
                    break;
                case "!=":
                    if (!expr.Value.Equals(value))
                        matchCount++;
                    break;
                default:
                    throw new Exception("operator not found");
            }
        });
        if (exprs.Count == matchCount)
            matchAllExprs.Add(entry);
    });
    return matchAllExprs;
}
```

If any of the LogEntries match all of the expressions, then those are returned to the caller. Now we can place the log data onto our screen for users.

```csharp
this.dataGridView1.DataSource =
    new BindingList<LogEntry>(FilterLogEntries(lst,
        lbxFilterExpressions.Items.Cast<FilterExpression>().ToList()));
```

The sample app that I've included, gives users the ability to create, configure, and apply FilterExpressions on the fly. Here's a screenshot.

[![LogChewer screenshot](http://r9ygpa.blu.livefilestore.com/y1pxGCPvsWy_YhqSqfSqGzHerP08teuLfipb9BcPEuB5g5iEP4_I324043npSGcThW5Om1Zo1dMfWGCjamxHiBKhA?PARTNER=WRITER)](http://r9ygpa.blu.livefilestore.com/y1p7EkivGncIEQEfhI-j4tYw7RZo79SMzEOk3SGarLigBbm0xnIeDSd577MDDSa1nPWSRifnoOTvKh_dOVAG6pFOw?PARTNER=WRITER)

You can get the source for this sample [here](http://cid-3fc3980d58cf7efb.skydrive.live.com/self.aspx/Public/LogChewer.WinFormSample.zip). Enjoy..
