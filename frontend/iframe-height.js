const script = document.currentScript;

const getDocumentHeight = () => {
  const body = document.body;
  const html = document.documentElement;
  return Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight);
};

const sendMessage = () => {
  window.parent.postMessage(
    {
      method: 'resize-iframe',
      id: script.dataset.id,
      height: getDocumentHeight(),
    },
    '*'
  );
};

sendMessage();
