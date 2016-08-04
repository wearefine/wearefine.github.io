---
---
# Fine Forever

[![Build Status](https://travis-ci.org/wearefine/fine-forever.svg?branch=master)](https://travis-ci.org/wearefine/fine-forever) [![Code Climate](https://codeclimate.com/github/wearefine/fine-forever/badges/gpa.svg)](https://codeclimate.com/github/wearefine/fine-forever)

A native infinite scroll JavaScript solution.

## Quick start

Make sure your markup includes pagination and with a link to the next page of results. This can be hidden from view in CSS (`display: none` or `visibility: hidden; height: 0`). This should be after your items' container class.

```html
<div class="wrapper"> ... </div>
<div class="pagination">
  <a href="?page=2">Page 2</a>
</div>
```

Initialize the listener with options and a callback. The callback's first param is the collection of items to be added.

```javascript
var wrapper = document.querySelector('.wrapper');

var infinite = new FineForever({}, function(items) {
  var html = '';

  for(var i = 0; i < items.length; i++) {
    html += items[i].outerHTML;
  });

  wrapper.innerHTML = wrapper.innerHTML + html;
});
```

## Options/Defaults

```javascript
navSelector: '.pagination', // Pagination selector
nextSelector: 'a:first-child', // Link within the pagination selector that has an href to the next page of items
itemSelector: '.item', // Selector of each item to load
offset: 500, // Distance from pagination nav
loadingHTML: null // Optional markup to display before items are loaded in. 
```

## Testing

Install all dependencies:

```bash
npm install --save-dev
```

* `npm test` provides a quick, one-run test as defined in [test/karma.conf.js](test/karma.conf.js)
* `npm run test:dev` opens a Karma instance that watches for file changes, as defined in [test/karma.conf.js](test/local.karma.conf.js)
