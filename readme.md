# Motiflab

Motiflab is a style guide tool for building components and is similar to Pattern Lab, Fractal or Astrum but much simpler to use or get started with.

Motiflab is focused around components and not atomic design, because it tends to be too fragmented. The basic idea behind Motiflab is to support many templating engines and make it easier for developer to preview and show components.

![Motiflab](https://user-images.githubusercontent.com/296714/50259672-475aee80-0405-11e9-8af2-308e7c75cc5d.png)

## Installation

Motiflab is written in NodeJS so installation is pretty simple.

```bash
npm install motiflab --save-dev
```

Or if you want to install it globally.

```bash
[sudo] npm install -g motiflab
```

## Running Motiflab

**Before you execute this read entire documentation.**

After install you can run Motiflab by `motiflab ./example/components` where first argument is path to the components folder.

```bash
$ motiflab --help
usage: motiflab [path] [options]

options:
  -p --port    Port to use [7000]
  -a           Address to use [0.0.0.0]
  -h --help    Print this list and exit.
```

If you installed it as `--save-dev` you can use it from `package.json` file.

```json
{
  "scripts": {
    "motiflab": "motiflab ./example/components"
  }
}
```


## Project structure

Each project has simple directory and file system.

```
components/
  project.json
  group-name/
    component.njk
    component.json
```

- Groups can be nested.
- Component view (component.njk) can have different name from component meta data (component.json) but it is advised they share the same name.
- Assets such as JS, CSS can be hosted outside of components folder. If you use Sass you will probably have this separated.

### project.json

In root of

```json
{
  "client": {
    "name": "Example",
    "url": "https://example.com"
  },
  "breakPoints": [
    {
      "label": "Full width",
      "width": "100%"
    },
    {
      "label": "Mobile",
      "width": "360px"
    }
  ],
  "assets": {
    "css": [
      "./example/assets/style.css"
    ],
    "js": [
      "./example/assets/style.js"
    ]
  }
}
```

- Client info is displayed in UI.
- Break points are rendered as a select box and you can change all the widths of components easily.
- Assets are included into each components. All you need to provide is array of relative paths to files.

### Component

Each component has two files.

**Template (component.njk)**
```nunjucks
<h3>{{ title }}</h3>

<ul>
  {% for element in elements %}
  <li>{{ element }}</li>
  {% endfor %}
</ul>

{% include "./partial.njk" %}
```

**Meta data (component.json)**
```json
{
  "name": "Example card",
  "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
  "file": "component.njk",
  "engine": "nunjucks",
  "display": {
    "width": "100%"
  },
  "context": {
    "title": "nunjucks card",
    "elements": [
      "Titanium",
      "Vanadium",
      "Chromium",
      "Manganese",
      "Iron"
    ]
  }
}
```

- Context variable from JSON meta file gets send to template and rendered.
- File is location of template file.
- Engine points to templating engine.
- Display width is the initial width of component.

You can view [example project](https://github.com/mitjafelicijan/motiflab/tree/develop/example).

## Templating engines

- Twig
- Nunjucks
- Mustache
- Handlebars

Handlebars and Mustache does currently not support importing partials.
