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
    var $activeItem = void 0;
    var $items = Array.prototype.slice.call(accordion.querySelectorAll('.accordion-item'), 0);
    if ($items.length === 0) {
      return;
    }

    // find the active accordion, if any, and attach click handlers to them all
    $items.forEach(function (el) {
      if (el.classList.contains(isActive)) {
        $activeItem = el;
      }

      el.addEventListener('click', function () {
        if (el === $activeItem) {
          // clicking the active accordion, close it
          el.classList.remove(isActive);
          $activeItem = null;
        } else {
          // change the active accordion
          el.classList.add(isActive);
          if ($activeItem) {
            $activeItem.classList.remove(isActive);
          }
          $activeItem = el;
        }
      });
    });
  });
});

