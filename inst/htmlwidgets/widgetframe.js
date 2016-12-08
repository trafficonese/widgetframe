HTMLWidgets.widget({

  name: 'widgetframe',

  type: 'output',

  factory: function(el, width, height) {

    return {

      renderValue: function(x) {

         var pymParent = new pym.Parent(el.id, x.url, {});

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});