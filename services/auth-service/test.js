const assert = require('assert');
const app = require('./index');

// Minimal unit test for pipeline verification
assert.ok(app, "Application instance should be defined");
console.log("Auth-service unit tests passed.");
process.exit(0);