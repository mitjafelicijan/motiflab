const actualHeight = () => {
  let wrapperElement = document.querySelector('.motif-component');
  return wrapperElement.offsetHeight + 30;
};

const sendMessage = () => {
  window.parent.postMessage({
    "id": "iframe_{{id}}",
    "height": actualHeight()
  }, "*");
};

window.addEventListener('load', (event) => {
  sendMessage();
});

window.addEventListener('resize', (event) => {
  sendMessage();
});
