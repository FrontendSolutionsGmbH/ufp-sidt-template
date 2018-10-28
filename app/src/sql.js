const mysql = require('mysql')
const path = require('path')
const migrations = require('sql-migrations')

const tableName = 'todos'

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
    connection.query('INSERT 1 + 1 AS solution', function (error, results, fields) {
        if (error) throw error
        console.log('The solution is: ', results[0].solution)
    })

    connection.end()

}

const runMigration = (index) => {
    // dang, need to configure migration using
    process.argv = [process.argv[0], process.argv[1], 'migrate']
    migrations.run({
        migrationsDir: path.resolve(__dirname, 'migrations'), // This is the directory that should contain your SQL migrations.
        host: config.host, // Database host
        port: config.port, // Database port
        db: config.database, // Database name
        user: config.user, // Database username
        password: config.password, // Database password
        adapter: 'mysql', // Database adapter: pg, mysql
        minMigrationTime: index
    })
}

const getMigration = () => {
    var result = 0
    const connection = openConnection()
    try {
        connection.tab
        connection.query('SELECT id from __migrations__ ORDER BY id DESC', function (error, results, fields) {
            if (error) {
                console.log('Warning ', error.message)
                runMigration(0)
            } else {

                try {
                    console.log('The highest migration is: ', results[0].id)
                    result = results[0].id
                    runMigration(results[0].id + 1)
                } catch (e) {

                    console.log('No migration found2 ', e)
                    runMigration(0)
                }
            }
        })
    } catch (e) {
        console.log('No migration found ', e)
        runMigration(0)
    }

    connection.end()

}
console.log('Executing Migration')
console.log('Executing Migration', path.resolve(__dirname, 'migrations'))
console.log('Executing Migration', getMigration())

module.exports = {
    getTodos: getTodos,
    saveTodo: saveTodo

}
