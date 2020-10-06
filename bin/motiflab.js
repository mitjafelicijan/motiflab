#!/usr/bin/env node

'use strict';

const FS = require('fs');
const OS = require('os');
const Path = require('path');
const Optionator = require('optionator');
const Express = require('express');
const Glob = require('glob');
const JSDOM = require('jsdom').JSDOM;
const SHA1 = require('sha1');
const Livereload = require('livereload');

const cors = require('cors');
const colors = require('colors');

global.homeDirectory = OS.homedir();
global.scriptDirectory = __dirname;
global.workingDirectory = process.cwd();

const loadProjectConfig = () => {
  global.projectConfig = JSON.parse(
    FS.readFileSync(Path.join(global.workingDirectory, global.options.source, 'project.json'), 'utf8')
  );
};

const loadPackageConfig = () => {
  global.packageConfig = JSON.parse(FS.readFileSync(Path.join(global.scriptDirectory, '../package.json'), 'utf8'));
};

const loadComponents = (display = false) => {
  if (display) {
    console.log('- project:'.blue);
    for (const key in global.projectConfig) {
      if (global.projectConfig.hasOwnProperty(key)) {
        console.log(`  - ${key}:`.blue);
        for (const option in global.projectConfig[key]) {
          console.log(`    - ${option}:`.blue, global.projectConfig[key][option]);
        }
      }
    }
  }

  global.components = [];
  const componentFiles = Glob.sync(
    Path.join(global.workingDirectory, global.options.source, 'elements/**/*{.html,.twig}')
  );
  for (const component of componentFiles) {
    const dom = new JSDOM(FS.readFileSync(component, 'utf8'));
    const componentMeta = dom.window.document.querySelector('script[type="application/json"').textContent;
    const componentDOM = dom.window.document.querySelector('component').innerHTML;

    try {
      global.components.push({
        id: SHA1(component),
        file: component,
        path: component.replace(global.workingDirectory, '').replace(global.options.source, ''),
        meta: JSON.parse(componentMeta),
        dom: componentDOM,
      });
    } catch (error) {
      console.log(error.message);
    }
  }

  // list all registered components
  if (display) {
    console.log('- components:'.blue);
    for (const component of global.components) {
      console.log(`  - ${component.file.replace(global.workingDirectory, '.')}:`.green);
      console.log(`    - id:`.blue, `${component.id.substring(0, 20)}...`);
      for (const key in component.meta) {
        console.log(`    - ${key}:`.blue, component.meta[key]);
      }
    }
  }
};

try {
  loadPackageConfig();
} catch (error) {
  console.log(error.message);
  process.exit(1);
}

const optionator = Optionator({
  prepend: 'Usage: motiflab [options]',
  append: `Version ${global.packageConfig.version}`,
  options: [
    {
      option: 'help',
      alias: 'h',
      type: 'Boolean',
      description: 'displays help',
    },
    {
      option: 'source',
      type: 'String',
      default: './',
      description: 'folder where components are located',
      example: 'motiflab --source project-folder',
    },
    {
      option: 'listen',
      type: 'Int',
      default: '7000',
      description: 'port on which service is listening',
      example: 'motiflab --port 7000',
    },
    {
      option: 'serve',
      type: 'Boolean',
      description: 'start server',
    },
    {
      option: 'reload',
      type: 'Boolean',
      description: 'autoreloads on css and javascript changes',
    },
  ],
});

global.options = optionator.parseArgv(process.argv);

try {
  if (options.help) {
    console.log(optionator.generateHelp());
    process.exit(1);
  }

  if (options.serve) {
    console.log();

    console.log('- source:'.blue, options.source);
    console.log('- listen:'.blue, options.listen);

    // trying to parse project.json
    loadProjectConfig();
    loadComponents(true);

    if (global.options.reload) {
      const reloadServer = Livereload.createServer({
        exts: ['json', 'js', 'css'],
        debug: false,
      }).watch(options.source);
    }

    const app = Express();
    app.use(cors());
    app.use('/', Express.static(Path.join(global.scriptDirectory, '../frontend')));
    app.use('/elements', Express.static(Path.join(global.workingDirectory, global.options.source, './elements')));

    for (const folder of Object.entries(projectConfig.static)) {
      app.use(folder[0], Express.static(Path.join(global.workingDirectory, global.options.source, folder[1])));
    }

    app.get('/_project', (req, res) => {
      loadProjectConfig();
      loadComponents();

      res.send({
        projectConfig: global.projectConfig,
        components: global.components,
      });
    });

    app.listen(options.listen, '0.0.0.0', () => {
      console.log(
        `\nListening on http://0.0.0.0:${options.listen} from ${options.source} ${global.options.reload ? 'with reload on' : ''
        }`
      );
    });
  }
} catch (error) {
  console.log(optionator.generateHelp());
  console.log();
  console.log(error.message);
  console.log(error);
  process.exit(1);
}
