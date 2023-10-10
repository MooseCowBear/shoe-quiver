import { Controller } from "@hotwired/stimulus";

// Q: will this work with changes to attributes as well?
export default class extends Controller {
  initialize() {
    console.log("sort controller was initialized on elem", this);
    this.observeMutations(sortChildren);
  }

  observeMutations(callback) {
    console.log("callback", callback);
    const observer = new MutationObserver((mutations) => {
      mutations.forEach(function (mutation) {
        console.log(mutation.type);
      });
      callback(this.element);
    });
    const config = { attributes: true, childList: true, subtree: true };
    console.log("in observe mutations", this, this.element);
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
