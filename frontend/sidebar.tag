<sidebar>

  <section if="{ project }">
    <h2>{ project.client.name }</h2>
    <p>
      <a href="{ project.client.url }" target="_blank">
        { project.client.url }
      </a>
    </p>
  </section>

  <div if="{ breakPoints.length > 0 }">
    <select id="break-points">
      <option each="{ point in breakPoints }" value="{ point.width }">
        { point.label } ({ point.width })
      </option>
    </select>
  </div>

  <nav>
    <div each="{ group in groups }">
      <h4>{ group.label }</h4>
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
      document.querySelector('#break-points').addEventListener('change', function (evt) {
        document.querySelectorAll('iframe').forEach(iframe => {
          iframe.style.width = evt.target.value;
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

    h4 {
      text-transform: capitalize
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

    select {
      border: 2px solid #eee;
      padding: 0 10px;
      font-family: inherit;
      display: inline-block;
      width: 100%;
      font-size: 100%;
      height: 40px;
      -webkit-appearance: none;
      -moz-appearance: none;
      appearance: none;
      border-radius: 0;
      background-image:
        linear-gradient(45deg, transparent 50%, #ccc 50%),
        linear-gradient(135deg, #ccc 50%, transparent 50%),
        linear-gradient(to right, #eee, #eee);
      background-position:
        calc(100% - 20px) 17px,
        calc(100% - 15px) 17px,
        calc(100% - 40px) 0px;
      background-size:
        5px 5px,
        5px 5px,
        2px 50px;
      background-repeat: no-repeat;
      cursor: pointer;
      padding-right: 55px;
      margin-bottom: 10px;
    }

    select::-ms-expand {
      display: block;
    }

    /*.breakpoints {
      margin-bottom: 20px;
    }*/

    /*.button-set button {
      background: #ddd;
      border: 0;
      border-radius: 5px;
      padding: 7px 10px;
      margin-right: 3px;
      font-size: 80%;
      font-weight: 600;
      color: #555;
      cursor: pointer;
    }*/
  </style>

</sidebar>
