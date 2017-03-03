Package.describe({
  name: 'pangolinrex:custom-console',
  version: '0.0.2',
  summary: 'A custom repl console',
  git: 'https://github.com/hartreed/custom-console.git',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.4.0.1');
  api.use([
    'coffeescript',
    'templating',
    'reactive-var',
    'mquandalle:jade',
    'mquandalle:stylus'
  ], 'client');
  api.addFiles([
    'classes/Console.coffee',
    'customConsole.tpl.jade',
    'customConsole.styl',
    'customConsole.coffee',
  ], 'client');
});

Package.onTest(function(api) {
  api.use('ecmascript');
  api.use('tinytest');
  try {
    api.mainModule('custom-console-tests.js');
  } catch (error) {}
});
