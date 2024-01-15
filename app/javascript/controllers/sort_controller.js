import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  initialize() {
    this.observeMutations(sortChildren);
  }

  observeMutations(callback) {
    const observer = new MutationObserver(() => {
      callback(this.element);
    });
    const config = { attributes: true, childList: true, subtree: true };
    observer.observe(this.element, config);
  }
}

function sortChildren(elem) {
  const children = Array.from(elem.children);
  if (elementsAreSorted(children)) {
    return;
  }
  children.sort(compareElements);
  elem.replaceChildren(...children);
}

function elementsAreSorted([left, ...rights]) {
  for (const right of rights) {
    if (compareElements(left, right) > 0) return false;
    left = right;
  }
  return true;
}

function compareElements(left, right) {
  return getSortCode(right) - getSortCode(left);
}

function getSortCode(element) {
  return element.getAttribute("data-sort-code") || 0;
}
