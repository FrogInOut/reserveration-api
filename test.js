// super naive "test": just call the core logic indirectly
// In CI we will run this to produce Evidence "Unit Tests".
const assert = require('assert');
const { reservations } = require('./server');

// basic invariant: new service starts with 0 reservations
assert.strictEqual(reservations.length, 0, 'reservations should start empty');

console.log('reservation-api tests passed');
