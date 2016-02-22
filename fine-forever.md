---
layout: page
title: Fine Forever
repository_slug: fine-forever
js_download: true
permalink: /fine-forever/
tagline: Infinite scroll in native JavaScript 
logo: fine-forever.svg
---

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

var infinite = new fineForever({}, function(items) {
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
