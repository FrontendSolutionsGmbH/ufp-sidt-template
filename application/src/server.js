var express = require('express')
var path = require('path')
var todos = require('./sql')
var app = express()
/**
 * @swagger
 *
 * definitions:
 *   NewToDo:
 *     type: object
 *     required:
 *       - todo
 *     properties:
 *       todo:
 *         type: string
 *   ToDo:
 *     type: object
 *     required:
 *       - todo
 *     properties:
 *       id:
 *         type: string
 *       todo:
 *         type: string
 *   ToDos:
 *     type: array
 *     items:
 *       $ref: '#/definitions/ToDo'
 *
 */
const HOST = '0.0.0.0'
const PORT = 3000
/**
 * @swagger
 *
 * /todos:
 *   get:
 *     description: Get all todos
 *     produces:
 *       - application/json
 *
 *     responses:
 *       200:
 *         description: All todos array
 *         schema:
 *            type: array
 *            items:
 *              $ref: '#/definitions/ToDo'
 */
app.get('/todos', function (req, res) {
    res.send('Hello World')
})
/**
 * @swagger
 *
 * /todos:
 *   post:
 *     description: Post a new entry
 *     produces:
 *       - application/json
 *     consumes:
 *       - application/json
 *     parameters:
 *       - name: todo
 *         description: The Todo Object to be added
 *         in: body
 *         required: true
 *         schema:
 *           $ref: '#/definitions/NewToDo'
 *     responses:
 *       200:
 *         description: entry created
 *         schema:
 *           type: object
 *           $ref: '#/definitions/ToDo'
 */
app.post('/todos', function (req, res) {
    res.send('Hello World')
})
/**
 * @swagger
 *
 * /todos/{id}:
 *   get:
 *     description: Get Single todo
 *     produces:
 *       - application/json
 *     parameters:
 *       - name: id
 *         description: Id of todo
 *         in: path
 *         required: true
 *         type: string
 *     responses:
 *       200:
 *         description: the entry
 *         schema:
 *           type: object
 *           $ref: '#/definitions/ToDo'
 */
app.get('/todos/:id', function (req, res) {

    res.send(`tODO ID: ${req.params.id}  ${todos.getTodos()}`)

})
/**
 * @swagger
 *
 * /todos/{id}:
 *   delete:
 *     description: Delete Single todo
 *     parameters:
 *       - name: id
 *         description: Id of todo
 *         in: path
 *         required: true
 *         type: string
 *     responses:
 *       200:
 *         description: empty result
 */
app.delete('/todos/:id', function (req, res) {

    res.send(`tODO ID: ${req.params.id}  ${todos.getTodos()}`)

})

/**
 * @swagger
 *
 * /v1/swagger.json:
 *   get:
 *     description: Get swagger definition
 *     produces:
 *       - application/json
 *
 *     responses:
 *       200:
 *         description: the swagger definition of this api
 */
app.get('/v1/swagger.json', function (req, res) {
    res.set('Access-Control-Allow-Origin', '*');
    res.sendFile(path.resolve(__dirname, '../api/swaggerDefinition.json'));
})

app.listen(PORT)
console.log(`Server running on ${HOST}:${PORT}`)
