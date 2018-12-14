<sidebar>

  <section if="{ project }">
    <h2>{ project.client.name }</h2>
    <p>
      <a href="{ project.client.url }" target="_blank">
        { project.client.url }
      </a>
    </p>
  </section>

  <div class="button-set" if="{ breakPoints.length > 0 }">
    <button each="{ point in breakPoints }">
      {point}
    </button>
  </div>

  <nav if="{ groups.length > 0 }">
    <div each="{ group in groups }">
      <h3>{ group.data.name }</h3>
      <ul>
        <li each="{ component in group.components }">
          <a href="#{ component.slug }">{ component.data.name }</a>
        </li>
      </ul>
    </div>
  </nav>

  <script>

    this.project = null;
    this.breakPoints = [];
    this.groups = [];

    this.on('mount', async () => {
      const response = await fetch('/_/meta');
      const data = await response.json();
      this.project = data.project;
      this.groups = data.groups;
      this.breakPoints = data.project.breakPoints;
      this.update();
    });

    addEventListener('load', (event) => {
      document.querySelectorAll('.button-set button').forEach(button => {
        button.addEventListener('click', (evt) => {
          let width = evt.target.innerText;
          document.querySelectorAll('iframe').forEach(iframe => {
            iframe.style.width = width;
          });
        });
      });
    });

  </script>

  <style scoped>
    :scope {
      display: block;
      overflow: auto;
      position: fixed;
      left: 0;
      top: 0;
      bottom: 0;
      padding: 20px;
      width: 300px;
      border-right: 2px solid #eee;
    }

    section {
      margin-bottom: 30px;
    }

    ul {
      margin-bottom: 20px;
      padding-left: 10px;
      list-style-type: none;
    }

    ul li {
      margin-bottom: 10px;
    }

    a {
      color: #333;
      font-weight: 500;
    }

    .button-set {
      margin-bottom: 20px;
    }

    .button-set button {
      background: #ddd;
      border: 0;
      border-radius: 5px;
      padding: 7px 10px;
      margin-right: 3px;
      font-size: 80%;
      font-weight: 600;
      color: #555;
      cursor: pointer;
    }
  </style>

</sidebar>
