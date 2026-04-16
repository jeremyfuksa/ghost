/* ==========================================================================
   The Cocktail Napkin — Main JS
   ========================================================================== */

(function () {
  'use strict';

  // Theme toggle
  var toggle = document.querySelector('.theme-toggle');
  if (toggle) {
    var stored = localStorage.getItem('theme');
    if (stored) {
      document.documentElement.setAttribute('data-theme', stored);
      document.documentElement.classList.toggle('dark', stored === 'dark');
    }

    toggle.addEventListener('click', function () {
      var current = document.documentElement.getAttribute('data-theme');
      var isDark;

      if (current) {
        isDark = current === 'dark';
      } else {
        isDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      }

      var next = isDark ? 'light' : 'dark';
      document.documentElement.setAttribute('data-theme', next);
      document.documentElement.classList.toggle('dark', next === 'dark');
      localStorage.setItem('theme', next);
    });
  }

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
