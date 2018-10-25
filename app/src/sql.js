var mysql = require('mysql')

const openConnection = () => {
    var connection = mysql.createConnection({
        host: process.env.DEMO_SQL_HOST,
        user: process.env.DEMO_SQL_USER,
        password: process.env.DEMO_SQL_PASSSWORD,
        database: process.env.DEMO_SQL_DATABASE
    })
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

module.exports = {

    getTodos: getTodos,
    saveTodo: saveTodo

}
