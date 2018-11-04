const mysql = require('mysql')
const path = require('path')

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

const getTodos = (cb) => {
    const connection = openConnection()
    connection.query(`SELECT * from ${tableName}`, function (error, results, fields) {
        if (error) throw error
        console.log('The stored todos are: ', cb, results)
        cb(results)
    })

    connection.end()
}

const getTodo = (id, cb) => {
    const connection = openConnection()
    const queryString = `SELECT * from ${tableName} where id =${Number.parseFloat(id)}`
    console.log('Executing Query', queryString)
    connection.query(queryString, function (error, results, fields) {
        if (error) throw error
        console.log('The stored todos are: ', cb, results)
        cb(results)
    })

    connection.end()
}
const deleteTodo = (id, cb) => {
    const connection = openConnection()
    const queryString = `DELETE FROM ${tableName} where id =${Number.parseFloat(id)}`
    console.log('Executing Query', queryString)
    connection.query(queryString, function (error, results, fields) {
        if (error) throw error
        console.log('The stored todos are: ', cb, results)
        cb(results)
    })

    connection.end()
}

const saveTodo = ({todo},cb) => {
    const connection = openConnection()
    connection.query(`INSERT INTO ${tableName}  (todo) VALUES ( '${todo}');`, function (error, results, fields) {
        if (error) throw error
        console.log('The solution is: ', results[0])
        cb(results)
    })

    connection.end()

}

console.log('Stored todos are', getTodos((data => console.log)))
module.exports = {
    getTodos: getTodos,
    getTodo: getTodo,
    deleteTodo: deleteTodo,
    saveTodo: saveTodo

}
