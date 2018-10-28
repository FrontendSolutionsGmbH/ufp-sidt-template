const mysql = require('mysql')
const path = require('path')
const migrations = require('sql-migrations')

const config = {
    host: process.env.DEMO_SQL_HOST || 'localhost',
    user: process.env.DEMO_SQL_USER || 'root',
    password: process.env.DEMO_SQL_PASSSWORD || 'root',
    database: process.env.DEMO_SQL_DATABASE || 'sidt-todo-app'
}

const openConnection = () => {
    var connection = mysql.createConnection(config)
    connection.connect()
    return connection
}

const getTodos = () => {
    const connection = openConnection()
    connection.query('SELECT 1 + 1 AS solution', function (error, results, fields) {
        if (error) throw error
        console.log('The solution is: ', results[0].solution)
    })

    connection.end()

}

const saveTodo = ({text}) => {
    const connection = openConnection()
    connection.query('SELECT 1 + 1 AS solution', function (error, results, fields) {
        if (error) throw error
        console.log('The solution is: ', results[0].solution)
    })

    connection.end()

}
saveTodo({})
console.log('Executing Migration')
console.log('Executing Migration', path.resolve(__dirname, 'migrations'))

// dang, need to configure migration using
process.argv = [process.argv[0], process.argv[1], 'migrate']
var mir = migrations.run({
    migrationsDir: path.resolve(__dirname, 'migrations'), // This is the directory that should contain your SQL migrations.
    host: config.host, // Database host
    port: config.port, // Database port
    db: config.database, // Database name
    user: config.user, // Database username
    password: config.password, // Database password
    adapter: 'mysql', // Database adapter: pg, mysql
})
console.log('Migration returned', mir)
module.exports = {
    getTodos: getTodos,
    saveTodo: saveTodo

}
