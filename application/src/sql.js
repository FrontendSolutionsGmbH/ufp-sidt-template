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

const getTodos = () => {
    const connection = openConnection()
    connection.query(`SELECT * from ${tableName}`, function (error, results, fields) {
        if (error) throw error
        console.log('The stored todos are: ', results)
    })

    connection.end()

}

const saveTodo = ({text}) => {
    const connection = openConnection()
    connection.query(`INSERT INTO ${tableName}  (todo) VALUES ( '${text}');`, function (error, results, fields) {
        if (error) throw error
        console.log('The solution is: ', results[0])
    })

    connection.end()

}

saveTodo({text: 'HELLO'})
console.log('Stored todos are', getTodos())
module.exports = {
    getTodos: getTodos,
    saveTodo: saveTodo

}
