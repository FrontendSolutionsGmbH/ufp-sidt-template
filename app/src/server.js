var express = require('express')
var todos = require('./sql')
var app = express()

const HOST='0.0.0.0'
const PORT=3000

app.get('/todos', function (req, res) {
    res.send('Hello World')
})
app.get('/todos/:id', function (req, res) {

    res.send(`tODO ID: ${req.params.id}`)
})

app.listen(PORT)
console.log(`Server running on ${HOST}:${PORT}`)
