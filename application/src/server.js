var express = require('express')
var path = require('path')
var todos = require('./sql')
var app = express()

var SwaggerValidator = require('swagger-object-validator');
var swagger = require('../api/swaggerDefinition');
var validator = new SwaggerValidator.Handler(swagger)
app.use(express.json());
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
 *     responses:
 *       200:
 *         description: All todos array
 *         schema:
 *            type: array
 *            items:
 *              $ref: '#/definitions/ToDo'
 */
app.get('/todos', function (req, res) {
    console.log('Getting todos')
    todos.getTodos(async data => {
        console.log('Todos returned', res)
        console.log('Todos returned', data)

        res.set('Access-Control-Allow-Origin', '*')
        // res.send("HALLO")
        res.json(data).sendStatus(200)
    })
})
/**
 * @swagger
 *
 * /todos:
 *   post:
 *     description: Post a new entry
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
 *       204:
 *         description: entry created
 *
 *       400:
 *         description: Bad request with syntax errors in response oject
 *         schema:
 *           type: object
 */
app.post('/todos', function (req, res) {
    console.log('Post Todos IS ', req.body)
    const input = req.body

    validator.validateModel(input, 'ToDo', (err, result) => {
        console.log(JSON.stringify(err), result);

        if (err) {
            res.sendStatus(500)
        } else {
            console.log(result.humanReadable());
            if (result.errors.length === 0) {
                todos.saveTodo(input, async data => {
                    res.sendStatus(204)
                })
            } else {
                console.log('Todo Errors are', result.errors)
                res.status(400).json(result.errorsWithStringTypes())
            }
        }

    });

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
 *
 */
app.get('/todos/:id', function (req, res) {

    console.log('Getting todo')
    todos.getTodo(req.params.id, async data => {
        console.log('Todo returned', res)
        console.log('Todo returned', data)

        res.set('Access-Control-Allow-Origin', '*')
        // res.send("HALLO")
        res.status(400).json(data[0])
    })
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

    console.log('Deleting todo')
    todos.getTodo(req.params.id, async data => {
        console.log('Todo returned', res)
        console.log('Todo returned', data)
        res.set('Access-Control-Allow-Origin', '*')
        res.sendStatus(200)
    })
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
    res.set('Access-Control-Allow-Origin', '*')
    res.sendFile(path.resolve(__dirname, '../api/swaggerDefinition.json'))
})
app.options("/*", function (req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS');
    res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With');
    res.sendStatus(200);
});

app.listen(PORT)
console.log(`Server running on ${HOST}:${PORT}`)
