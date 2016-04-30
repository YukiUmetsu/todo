# コントローラーを定義する。今はこのように記載すると覚えておけば良い。
angular.module('todo').controller "TodoListCtrl", ($scope, $routeParams, TodoList, Todo) ->

  # 初期データを用意するメソッド
  $scope.init = ->
    # TodoListとTodoのサービスオブジェクトを作成
    # TODO todo_listのidを動的に取得する(次の連載記事で対処)
    @todoListService = new TodoList()
    @todoService     = new Todo(1)
    # データを取得する(GET /api/todo_lists/:id => Api::TodoLists#show)
    $scope.list = @todoListService.find($routeParams.list_id, (res)-> $scope.totalTodos = res.totalTodos)

  # todoを追加する
  $scope.addTodo = (todoDescription) ->
    # todoを追加する(POST /api/todo_lists/:todo_lsit_id/todos => Api::Todo#destroy)
    todo = @todoService.create(description: todoDescription, completed: false)
    # initメソッドで用意したtodosの一番最初にtodoを追加する
    $scope.list.todos.unshift(todo)
    # todo入力テキストフィールドを空にする
    $scope.todoDescription = ""

  # todoを削除する
  $scope.deleteTodo = (todo) ->
    # todoをサーバーから削除する(DELETE /api/todo_lists/todo_list_id/todos/:id => Api::Todo#destroy)
    @todoService.delete(todo)
    # todoをangularjsのlistデータから削除する(indexOfメソッドでtodoのindexを探し、spliceメソッドで削除する)
    $scope.list.todos.splice($scope.list.todos.indexOf(todo), 1)

  serverErrorHandler = ->
    alert("サーバーでエラーが発生しました。画面を更新し、もう一度試してください。")

  # todoの完了カラムをON/OFFするメソッド
  $scope.toggleTodo = (todo) ->
    @todoService.update(todo, completed: todo.completed)

  $scope.search = ->
    # Ransackに対応したparamsを作成する
    params = {
      'q[description_cont]' : $scope.descriptionCont,
      'q[completed_true]'   : $scope.completedTrue,
      'page'                : $scope.currentPage
    }

     # init()と同様にtotalTodosに正しい値が入るように第2引数にコールバック関数を渡す
    $scope.list = @todoService.all(params, (res)-> $scope.totalTodos = res.totalTodos)
  