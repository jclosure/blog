---
layout: post
title: "Meditation on JavaScript’s SetTimeout(), Recursion, and Execution Context"
date: 2014-01-12 21:59:35 -0600
categories: []
tags: ["async", "context", "JavaScript"]
wordpress_id: 490
original_url: "https://joelholder.com/2014/01/12/meditation-on-settimeout/"
---
<p>JavaScript&#8217;s setTimout and setInterval functions are for scheduling future work. They provide a way to schedule either a single or recurring execution of a function. In this article, we&#8217;ll play around with some fun and interesting capabilities that can be had using setTimeout.</p>
<p>To get going we&#8217;ll need a few examples in place.</p>
<p>Here is a a simple Calculator object that we can use for our testing. Note that it has 2 methods (add and multiply). It also contains a piece of state (value) that it uses to track its computational output.</p>

~~~ javascript
//an object with methods
function Calculator (seed) {
    return {
          value: seed,
          add: function(b) {
            value = value || 0; //guard with default accumulator for addition
            this.value += b;
            console.log(this.value);
            return this;
          },
          multiply: function(b) {
            value = value || 1; //guard with default accumulator for multiplication
            this.value *= b;
            console.log(this.value);
            return this;
          }
    };
}
var calculator = new Calculator();

//basic math fluency
var twentyFive = calculator.add(1 + 1)
                           .add(3)
                           .multiply(5)
                           .value;
~~~

<p>Now, let&#8217;s have some fun by giving all JavaScript objects in the runtime the ability to defer their own method execution until a time in the future. We do this by extending the Object prototype for the whole JavaScript runtime. </p>
<p>This implementation is as follows. Note that, that it imbues all objects with a new ability, to run future functions with themselves as the reciever.</p>

~~~ javascript
if (typeof Object.prototype.later !== 'function') {
    Object.prototype.later = function (msec, method) {
        var that = this,
            args = Array.prototype.slice.apply(arguments, [2]);
        if (typeof method === 'string') {
            method = that[method];
        }
        setTimeout(function() {
            method.apply(that, args);
        }, msec);
        return that;
    };
}
~~~

<p>Source: <a title="Crockford on JavaScript - Act III: Function the Ultimate" href="http://www.youtube.com/watch?v=ya4UHuXNygM" target="_blank">Douglas Crockford</a>.</p>
<p>This in effect shims all objects with an additional behavior called &#8220;later&#8221;.  It changes the receiver of the function call in the future to the object from which later() was invoked. </p>
<p>The function expects these things:</p>
<p><strong>Parameter 1:</strong> The number of milliseconds to wait before executing</p>
<p><strong>Parameter 2:</strong> Either a function or a string function name to execute</p>
<p><strong>Additional Optional Parameters:</strong> The arguments for the method to be executed in the future</p>
<p>The later method takes in the parameters and schedules the function (parameter 2) with its arguments (parameters 3,4,5,&#8230;) to be executed in the specified milliseconds (parameter 1). Note that we use a closure to refer to the receiver (&#8220;this&#8221;) as &#8220;that&#8221; during the setup and scheduling phase of its execution. This ensures that the &#8220;this&#8221; inside of scope of execution is the object from which the .later() method is called. This overrides the pointer in setTimeout() for &#8220;this&#8221; from the default &#8220;global&#8221; JavaScript object to the object from which later() is invoked. This simple but elegant replacing of the execution context object is perhaps one of the most powerful features of JavaScript. Now that we&#8217;ve got this extension to the Object prototype in place, all objects in our system, including Calculator will have this behavior.</p>
<p>So let&#8217;s have some fun with the calculator by exercising the Chaining API it inherited from Object. Here are some tricks taking advantage of the fluent later() method&#8217;s ability to drive a series of asynchronous calls over the object from which the expression chain originates. Since calculator&#8217;s prototype is Object, it can drive its own api. This example demonstrates several different ways to invoke the later() method in a single expression chain. Let&#8217;s turn a calculator into an adding machine.</p>

~~~ javascript
calculator
    //can pass a method name as a string.  targeting calculator.add
    .later(100, "add", 1)

    //can pass a method reference directly from the object
    .later(1000, calculator.add, 1)

    //can pass an anonymous function.
    .later(100, function(argument) {
        this.value += argument;
    }, 1)

    //close back onto chain originator
    .later(999, function(argument) { calculator.value += argument; }, 1);

//start an async message loop
calculator.later(0, function loop(argument) {
    this.value += argument;
    console.log(this.value);
    this.later(0, loop, argument);
}, "Looping");
~~~

<p>Now lets have some fun with arrays.  Since JavaScript arrays inherit their prototype from Object, and we extended Object&#8217;s prototype with the later() method, arrays now also have the later() method.</p>
<p>Process an Array Asychronously:</p>

~~~ javascript
var sequence = [1,2,3,4,5];
sequence.forEach(function(n) {
    sequence.later(0, function(i) {
        console.log("got: " + i);
    }, n);
});
~~~

<p>This is cool..</p>
<p>Now lets replace the execution context object with a new Calculator.</p>
<p>Driving Execution Over an Array &#8211; Compute Factorial:</p>

~~~ javascript
[1,2,3,4,5].forEach(function(n) {
    return this.multiply(n).value;
}, new Calculator());
~~~

<p>Lets Add Laterness:</p>

~~~ javascript
//scheduled execution
[1,2,3,4,5].forEach(function(n) {
    this.later(100, this.multiply, n);
}, new Calculator());
~~~

<p>Decaying Scheduled Array Processing:</p>

~~~ javascript
[1,2,3,4,5].forEach(function(n) {
    this.wait = (this.wait || 0) + 1000 ;
    this.later(this.wait, this.multiply, n);
}, new Calculator());
~~~

<p>Randomly Scheduled Array Processing:</p>

~~~ javascript
[1,2,3,4,5].forEach(function(n) {
    this.later(Math.floor((Math.random()*1000)+1), this.multiply, n);
}, new Calculator());
~~~

<p>Namaste&#8230;</p>
