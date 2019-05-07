'use strict';

/**
 * NAVBAR
 */
document.addEventListener('DOMContentLoaded', function () {
  // Get all "navbar-burger" elements
  var $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);
  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {
    // Add a click event on each of them
    $navbarBurgers.forEach(function (el) {
      el.addEventListener('click', function () {
        // Get the target from the "data-target" attribute
        var target = el.dataset.target;
        var $target = document.getElementById(target);
        // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
        el.classList.toggle('is-active');
        $target.classList.toggle('is-active');
      });
    });
  }
});

/**
 * ACCORDIONS
 */
document.addEventListener('DOMContentLoaded', function () {
  var isActive = 'is-active';
  var $accordions = Array.prototype.slice.call(document.querySelectorAll('.accordion'), 0);
  if ($accordions.length === 0) {
    return;
  }

  // iterate each accordion and track its active drawer
  $accordions.forEach(function (accordion) {
    var $activeAccordion = void 0;
    var $headers = Array.prototype.slice.call(accordion.querySelectorAll('.accordion-header'), 0);
    if ($headers.length === 0) {
      return;
    }

    // find the active accordion, if any, and attach click handlers to them all
    $headers.forEach(function (el) {
      if (el.classList.contains(isActive)) {
        $activeAccordion = el;
      }

      el.addEventListener('click', function () {
        if (el === $activeAccordion) {
          // clicking the active accordion, close it
          el.classList.remove(isActive);
          $activeAccordion = null;
        } else {
          // change the active accordion
          el.classList.add(isActive);
          if ($activeAccordion) {
            $activeAccordion.classList.remove(isActive);
          }
          $activeAccordion = el;
        }
      });
    });
  });
});