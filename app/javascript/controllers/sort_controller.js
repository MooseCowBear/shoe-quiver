import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  initialize() {
    this.observeMutations(sortChildren);
  }

  observeMutations(callback) {
    const observer = new MutationObserver((mutations) => {
      mutations.forEach(function (mutation) {
        console.log(mutation.type);
      });
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

/* 
function compareElements(left, right) {
  let functionName = this.element.getAttribute("data-method");
  const functionMap = {
    "compareRuns": (left, right) => {
      return getSortCode(right) - getSortCode(left);
    },
    "compareShoes": (left, right) => {

    }
  }
  return functionMap[functionName](left, right);
}
*/

function getSortCode(element) {
  // shouldn't ever need the 0 here..
  return element.getAttribute("data-sort-code") || 0;
}
