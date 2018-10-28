module.exports = {
    tableName: 'todos',
    server: {
        port: 3000
    },
    database: {
        host: process.env.DEMO_SQL_HOST || 'localhost',
        user: process.env.DEMO_SQL_USER || 'root',
        password: process.env.DEMO_SQL_PASSSWORD || 'root',
        database: process.env.DEMO_SQL_DATABASE || 'sidt-todo-app'
    }

}
