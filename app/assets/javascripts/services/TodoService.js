// Generated by CoffeeScript 1.10.0
angular.module('todo').factory('Todo', function($resource, $http) {
  var Todo;
  return Todo = (function() {
    function Todo(todoListId, errorHandler) {
      this.service = $resource('/api/todo_lists/:todo_list_id/todos/:id', {
        todo_list_id: todoListId
      }, {
        query: {
          isArray: false
        },
        update: {
          method: 'PUT'
        }
      });
      this.errorHandler = errorHandler;
    }

    Todo.prototype.create = function(attrs) {
      new this.service({
        todo: attrs
      }).$save((function(todo) {
        return attrs.id = todo.id;
      }), this.errorHandler);
      return attrs;
    };

    Todo.prototype["delete"] = function(todo) {
      return new this.service().$delete({
        id: todo.id
      }, (function() {
        return null;
      }), this.errorHandler);
    };

    Todo.prototype.update = function(todo, attrs) {
      return new this.service({
        todo: attrs
      }).$update({
        id: todo.id
      }, (function() {
        return null;
      }), this.errorHandler);
    };

    Todo.prototype.all = function(params, successHandler) {
      return this.service.query(params, (function(list) {
        return typeof successHandler === "function" ? successHandler(list)(list) : void 0;
      }), this.errorHandler);
    };

    return Todo;

  })();
});
