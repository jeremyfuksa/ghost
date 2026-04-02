/* ==========================================================================
   The Cocktail Napkin — Main JS
   ========================================================================== */

(function () {
  'use strict';

  // TOC generation and scroll spy (post pages only)
  var content = document.querySelector('.gh-content');
  var tocContainer = document.querySelector('.toc');

  if (content && tocContainer) {
    var headings = content.querySelectorAll('h2');

    if (headings.length > 0) {
      // Add IDs and generate TOC links
      headings.forEach(function (h, i) {
        if (!h.id) {
          h.id = 'section-' + i;
        }

        var link = document.createElement('a');
        link.className = 'toc-item';
        link.href = '#' + h.id;
        link.textContent = h.textContent;
        tocContainer.appendChild(link);
      });

      // Scroll spy
      var tocItems = tocContainer.querySelectorAll('.toc-item');

      var observer = new IntersectionObserver(
        function (entries) {
          entries.forEach(function (entry) {
            if (entry.isIntersecting) {
              tocItems.forEach(function (item) {
                item.classList.remove('active');
              });
              var active = tocContainer.querySelector(
                '.toc-item[href="#' + entry.target.id + '"]'
              );
              if (active) {
                active.classList.add('active');
              }
            }
          });
        },
        { rootMargin: '-20% 0px -70% 0px' }
      );

      headings.forEach(function (h) {
        observer.observe(h);
      });
    }
  }
})();
