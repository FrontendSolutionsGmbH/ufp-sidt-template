var express = require('express')
var todos = require('./sql')
var app = express()

app.get('/todos', function (req, res) {
    res.send('Hello World')
})
app.get('/todos/:id', function (req, res) {

    res.send(`tODO ID: ${req.params.id}`)
})

app.listen(3001)
