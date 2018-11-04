// migrate.js
var path = require('path')
var config = require('./src/config')

require('sql-migrations').run({
    migrationsDir: path.resolve(__dirname, 'migrations'), // This is the directory that should contain your SQL migrations.
    host: config.database.host, // Database host
    port: config.database.port, // Database port
    db: config.database.database, // Database name
    user: config.database.user, // Database username
    password: config.database.password, // Database password
    adapter: 'mysql', // Database adapter: pg, mysql

})
