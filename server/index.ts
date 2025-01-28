export {};

const config = require('chen.js').config('.config.js');
require('./logging/logger').init(config);

const api = require('./api');
const {Docker} = require('node-docker-api');
const docker = new Docker({
    protocol: 'http',  // Указываем протокол
    host: 'docker-dind',  // Хост
    port: 2375  // Порт
  });
const {Sandbox} = require('./Sandbox');

require('./esbuild');

process.on('unhandledRejection', (reason) => console.error('unhandledRejection', reason));

(async () => {
    Sandbox.build(docker, config);
    api(config);
})();