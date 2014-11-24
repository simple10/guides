Memory Management
=================

http://polarmobile.com/blog/2013/5/managing-memory-in-javascript-is-hard

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

