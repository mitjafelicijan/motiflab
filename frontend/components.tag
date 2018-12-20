<components>

  <section>
    <div each="{ group in groups }" class="group">
      <h1>{ group.label }</h1>
      <div each="{ component in group.components }" class="component">
        <a name="{ component.slug }">
          <h3>{ component.data.name }</h3>
        </a>

        <p><u>Templating engine</u>: { component.data.engine }</p>
        <p><u>Description</u>: { component.data.description }</p>

        <iframe id="iframe_{ component.id.replace(/=/g, '') }" src="/_/render/{ component.id }" frameborder="0"
          data-width="{ component.data.display.width }" data-height="{ component.data.display.height }">
        </iframe>

        <div class="tab-list">
          <button data-action="raw">Raw Template</button>
          <button data-action="context">Data & Context</button>
          <button data-action="open">Open in new window</button>
        </div>

        <div class="tab-content">
          <pre id="raw" class="prettyprint linenums language-html">{ component.raw }</pre>
          <pre id="context" class="prettyprint linenums language-json">{ JSON.stringify(component.data, undefined, 2) }</pre>
        </div>
      </div>
    </div>
  </section>

  <script>

    this.groups = [];
    this.on('mount', async () => {
      const response = await fetch('/_/meta');
      const data = await response.json();
      this.groups = data.groups;
      this.update();
    });

    addEventListener('load', (event) => {

      document.querySelectorAll('iframe').forEach(iframe => {
        iframe.style.width = iframe.dataset.width;
        iframe.style.display = 'block';
      });

      window.addEventListener('message', (evt) => {
        document.querySelector(`#${evt.data.id}`).style.height = `${evt.data.height}px`;
      })

      document.querySelectorAll('.tab-list button').forEach(button => {
        button.addEventListener('click', (evt) => {
          if (evt.target.dataset.action == 'open') {
            window.open(evt.target.parentNode.parentNode.querySelector('iframe').src)
          } else {
            let tabs = evt.target.parentNode.parentNode.querySelector('.tab-content');
            let selectedTab = tabs.querySelector(`#${evt.target.dataset.action}`);
            let allowShow = selectedTab.style.display == 'block' ? false : true;

            tabs.querySelectorAll('pre').forEach(tab => {
              tab.style.display = 'none';
            });

            if (allowShow) {
              selectedTab.style.display = 'block';
            }
          }
        });
      });

      PR.prettyPrint();
    }, false);

  </script>

  <style scoped>
    :scope {
      display: block;
      overflow: auto;
      position: fixed;
      left: 300px;
      top: 0;
      bottom: 0;
      right: 0;
      padding: 10px 50px;
    }

    .group {
      margin-bottom: 20px;
    }

    .component {
      margin: 20px 0 50px 0;
    }

    iframe {
      border: 2px solid #eee;
      border-bottom: 0;
      height: 200px;
      resize: horizontal;
      border-radius: 3px 3px 0 0;
      display: none;
      max-width: 100%;
      min-width: 320px;
      /*transition: width .3s ease-in-out, left .3s ease-in-out;*/
    }

    h1 {
      font-size: 200%;
    }

    h3 {
      margin-bottom: 20px;
      font-size: 140%;
      font-weight: 500;
    }

    u {
      color: #666;
    }

    .tab-list {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
      border: 2px solid #eee;
    }

    .tab-list button {
      border: 0;
      cursor: pointer;
      padding: 10px;
      font-weight: 600;
      background: rgb(245, 245, 245);
      color: #828282;
      font-size: 80%;
    }

    pre.prettyprint {
      border: 2px solid #eee;
      border-top: 0;
      padding: 20px 0;
      font-family: 'Inconsolata', monospace;
      font-size: 14px;
      font-weight: 400;
      overflow: auto;
      border-radius: 0 0 3px 3px;
      margin: 0;
      display: none;
      animation: fadeEffect .5s;
    }

    pre.prettyprint ol li {
      list-style-type: decimal;
    }

    pre.prettyprint ol li:nth-child(even),
    pre.prettyprint ol li:nth-child(odd) {
      background: transparent;
    }

    @keyframes fadeEffect {
      from {
        opacity: 0;
      }

      to {
        opacity: 1;
      }
    }
  </style>

</components>
