Memory Management
=================

http://polar.me/blog/2013/05/anaging-memory-in-javascript-is-hard

## Profiling

Use the [Timeline](https://developer.chrome.com/devtools/docs/javascript-memory-profiling) view in Chrome Developer Tools to debug memory leaks.

[YouTube Video](https://www.youtube.com/watch?v=0UNWi7FA36M&t=28m43s) – mobile JS apps optimizations
- use advanced image compression like [WebP](https://developers.google.com/speed/webp/?csw=1) or tools like [ImageOptim](https://imageoptim.com/)
- use gzip, spdy, etc. on server side
- batch network calls to avoid mobile latency when radio turns off; also helps preserve battery
- reduce CSS render weight
- batch DOM manipulation
- use static memory usage patterns
  - preallocate objects, etc.


## Tail Recursion

ECMA6 introduced an optimization for [tail-call recursion](http://duartes.org/gustavo/blog/post/tail-calls-optimization-es6/) 
where the last call in a function is purely a recursive call with no other operations.
This optimization makes it possible for recursion to be performant by not growing 
the size of the call stack.

```javascript
// Tail recursive
function recursive(a, b) {
  a = a + b;
  return recursive(a, b);
}

// Not tail recursive since 'a' must be kept in the call stack
function recursive(a) {
  return a + recursive(a, b);
}
```


Performance
===========

Avoid delete
https://groups.google.com/forum/#!msg/v8-users/zE4cOHBkAnY/HCWLAfmmChoJ

