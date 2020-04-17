const aside = document.querySelector('aside');
const main = document.querySelector('main');

const componentList = aside.querySelector('nav');
const componentTemplate = document.querySelector('#component');

(async () => {
  const projectResponse = await fetch('/_project');
  const project = await projectResponse.json();

  console.log(project);

  Twig.cache(true);

  document.title = `${project.projectConfig.client.name} - ${document.title}`;

  aside.querySelector('.client h1').innerText = project.projectConfig.client.name;
  aside.querySelector('.client a').innerText = project.projectConfig.client.url;
  aside.querySelector('.client a').href = project.projectConfig.client.url;

  for (const component of project.components) {
    // attach to sidebar list
    const componentListItem = document.createElement('a');
    componentListItem.innerText = `» ${component.meta.name}`;
    componentListItem.dataset.id = component.id;
    componentListItem.href = `#${component.id}`;
    componentList.append(componentListItem);

    // attach component to main
    const componentItemAnchor = document.createElement('a');
    componentItemAnchor.name = component.id;
    main.append(componentItemAnchor);

    const componentItem = document.createElement('div');
    componentItem.classList.add('component');

    const componentItemHeader = document.createElement('h3');
    componentItemHeader.innerText = component.meta.name;
    componentItem.append(componentItemHeader);

    if (omponent.meta.description) {
      if (omponent.meta.description.length > 0) {
        const componentItemDescription = document.createElement('p');
        componentItemDescription.innerHTML = `Description: <span>${component.meta.description}</span>`;
        componentItem.append(componentItemDescription);
      }
    }

    //const componentItemOpenWindow = document.createElement('a');
    //componentItemOpenWindow.href = component.path;
    //componentItemOpenWindow.target = '_blank';
    //componentItemOpenWindow.innerText = 'Open component in new window';
    //componentItem.append(componentItemOpenWindow);

    const componentItemContent = document.createElement('iframe');
    componentItemContent.dataset.id = `iframe-${component.id}`;
    componentItemContent.addEventListener('load', () => {
      const template = Twig.twig({
        data: component.dom,
      });

      const ref = componentItemContent.contentWindow.document;
      ref.open('text/html', 'replace');
      ref.write(`
        ${template.render(component.meta.context)}
        <script src="//0.0.0.0:35729/livereload.js?snipver=1" async defer></script>
      `);
      ref.close();

      for (const file of project.projectConfig.autoInject) {
        if (file.endsWith('.js')) {
          const node = document.createElement('script');
          node.src = file;
          ref.head.append(node);
        }

        if (file.endsWith('.css')) {
          const node = document.createElement('link');
          node.rel = 'stylesheet';
          node.href = file;
          ref.head.append(node);
        }
      }

      // inject iframe height fix
      const iframeHeightScript = document.createElement('script');
      iframeHeightScript.dataset.id = component.id;
      iframeHeightScript.src = '/iframe-height.js';
      ref.head.append(iframeHeightScript);
    });
    componentItem.append(componentItemContent);

    main.append(componentItem);
  }
})();

window.addEventListener('message', (evt) => {
  if (evt.data.method == 'resize-iframe') {
    const iframe = document.querySelector(`[data-id="iframe-${evt.data.id}"]`);
    iframe.style.height = `${evt.data.height + 30}px`;
  }
});
