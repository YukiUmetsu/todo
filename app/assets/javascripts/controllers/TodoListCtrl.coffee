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
    raisePositions($scope.list)
    # todoを追加する(POST /api/todo_lists/:todo_lsit_id/todos => Api::Todo#destroy)
    todo = @todoService.create(description: todoDescription, completed: false)
    # 追加されたものは最初に表示するためpositionを1にセット
    todo.position = 1
    # initメソッドで用意したtodosの一番最初にtodoを追加する
    $scope.list.todos.unshift(todo)
    # todo入力テキストフィールドを空にする
    $scope.todoDescription = ""

  # todoを削除する
  $scope.deleteTodo = (todo) ->
    lowerPositionsBelow($scope.list, todo)
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

  # todo_listを変更する
  $scope.listNameEdited = (listName) ->
    @todoListService.update($scope.list, name: listName)
  
  # todoを変更する
  $scope.todoDescriptionEdited = (todo) ->
    @todoService.update(todo, description: todo.description)

  $scope.sortListeners = {
    orderChanged: (event) ->
      console.log "sorted: #{event.dest.index}"
  }
  $scope.positionChanged = (todo) ->
    # TodoサービスクラスでTodoを更新する
    # サーバーには、params = { "todo" => {"target_position"=>2}, "todo_list_id"=>"1", "id"=>"5"} が送られる。
    @todoService.update(todo, target_position: todo.position)

  $scope.sortListeners = {

    orderChanged: (event) ->
      # 移動後のポジション番号を取得
      newPosition   = event.dest.index + 1
      # 移動させたTodoモデルを取得
      todo          = event.source.itemScope.modelValue
      # 移動させたTodoのpositionを更新（Angular内部）
      todo.position = newPosition
      # 移動させたTodoのpositionを更新（サーバーへ送信）
      $scope.positionChanged(todo)
  }

  raisePositions = (list) ->
    angular.forEach list.todos, (todo) ->
      todo.position += 1

  # list内の指定したtodoより下のtodosのpositionを-1する
  lowerPositionsBelow = (list, todo) ->
    angular.forEach todosBelow(list, todo), (todo) ->
      todo.position -= 1

  # list内の指定したtodoより下にあるtodosを取得する
  todosBelow = (list, todo) ->
    list.todos.slice(list.todos.indexOf(todo), list.todos.length)

  $scope.positionChanged = (todo) ->
    @todoService.update(todo, target_position: todo.position)
    updatePositions($scope.list)

  updatePositions = (list) ->
    angular.forEach list.todos, (todo, index) ->
      todo.position = index + 1