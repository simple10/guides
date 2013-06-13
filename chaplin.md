Views
-----

### Don't use events hash

Use @delegate in the initialize method instead of using Backbone's events hash.
Why? Events hash doesn't work well with inheritance.

### Regions

Set the view's region in the controller. For instance, a view might render 
the contents of a sidebar. The view's controller should attach the view to 
the sidebar region by passing it in when the view is created.

```coffeescript
@view = new WidgetView {region: 'sidebar'}
```

Not yet sure where to set regions. Chaplin docs don't make this very clear.


