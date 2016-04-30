# AngularJSの設定ファイル
# 依存ライブラリを記述する
app = angular.module('todo', ['ui.bootstrap', 'ngResource', 'ngRoute'])

# CSRFのトークンを設定するようにする
app.config ($httpProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

# AngularJSがturbolinksと一緒に動くようにする
$(document).on 'page:load', ->
  $('[ng-app]').each ->
    module = $(this).attr('ng-app')
    angular.bootstrap(this, [module])


# ルートの設定
app.config ($routeProvider, $locationProvider) ->
  # html5モードを有効にする
  # / にアクセスすると、 /dashboard にリダイレクトする
  # /dashboard にアクセスすると、 /templates/dashboard.html を表示する（合わせてDashboardCtrlを読み込む)
  # /todo_lists/:list_id にアクセスすると、 /templates/task_list.html を表示する（合わせてTodoListCtrlを読み込む)
  $locationProvider.html5Mode true
  $routeProvider.when '/',                    redirectTo:  '/dashboard'
  $routeProvider.when '/dashboard',           templateUrl: '/templates/dashboard.html', controller: 'DashboardCtrl'
  $routeProvider.when '/todo_lists/:list_id', templateUrl: '/templates/todo_list.html', controller: 'TodoListCtrl'
