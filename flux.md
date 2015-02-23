# FLUX

- http://ryanclark.me/getting-started-with-flux/
  - https://news.ycombinator.com/item?id=9095023

- https://reactjsnews.com/the-state-of-flux/
- https://github.com/facebook/react/wiki/Complementary-Tools
- http://blog.risingstack.com/flux-inspired-libraries-with-react/
- http://davidandsuzi.com/yo-in-flux/
- http://blog.hertzen.com/post/102991359167/flux-inspired-reactive-data-flow-using-react-and
- http://jonathancreamer.com/what-the-flux/
- http://www.cidrdb.org/cidr2015/Papers/CIDR15_Paper16.pdf


- http://conceptualitis.github.io/react-flux-libraries/

- https://tuxedojs.org/
- https://github.com/yahoo/fluxible
- http://martyjs.org/ - has chrome dev tool for visualizing state
- https://github.com/optimizely/nuclear-js - immutable, ui independent flux architecture
- https://github.com/acdlite/flummox
- https://github.com/kenwheeler/mcfly
- https://github.com/goatslacker/alt

- https://github.com/jhollingworth/marty
- https://github.com/kjda/ReactFlux
- https://github.com/foss-haas/fynx
- https://github.com/flow-stack/flow

- https://github.com/moreartyjs/moreartyjs

- https://github.com/muut/riotjs
- http://lhorie.github.io/mithril/getting-started.html

undo:
http://ameyakarve.com/jekyll/update/2014/02/06/Undo-React-Flux-Mori.html


flummox
- truly isomorphic with examples
- built-in promise support
- works well with react-router

alt
- really nice, clean syntax
- limited isomorphic support

nuclear
- immutable data
- powerful Getter util, eliminates need for waitFor
- not isomorphic

fluxy
- pure flux with immutable data
- immutable data via mori
- depends on react

delorean
- pure flux
- no view dependency

reflux
- popular
- merges actions and dispatcher
- bad: pete hunt thinks actions should be serializable and doesn't like reflux?

React
- http://aeflash.com/2015-02/react-tips-and-best-practices.html


IDEAL
- pure flux, or close to it
- immutable data
- no view dependency

...

delorian with immutable data ???
- ancient oak or immutable.js ???

mecury ???
- needs director for url routing


PERFORMANCE
- https://localvoid.github.io/vdom-benchmark/
- http://matt-esch.github.io/mercury-perf/

NOTES
- in flux, async API / REST should be handled in create actions, not stores if triggered by view
- typescript is a pain to get working with webpack and other builders; grunt is the only decent support

