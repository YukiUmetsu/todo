// Generated by CoffeeScript 1.10.0
var app;

app = angular.module('todo', ['ui.bootstrap', 'ngResource', 'ngRoute', 'mk.editablespan', 'ui.sortable']);

app.config(function($httpProvider) {
  var authToken;
  authToken = $("meta[name=\"csrf-token\"]").attr("content");
  return $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;
});

$(document).on('page:load', function() {
  return $('[ng-app]').each(function() {
    var module;
    module = $(this).attr('ng-app');
    return angular.bootstrap(this, [module]);
  });
});

app.config(function($routeProvider, $locationProvider) {
  $locationProvider.html5Mode(true);
  $routeProvider.when('/', {
    redirectTo: '/dashboard'
  });
  $routeProvider.when('/dashboard', {
    templateUrl: '/templates/dashboard.html',
    controller: 'DashboardCtrl'
  });
  return $routeProvider.when('/todo_lists/:list_id', {
    templateUrl: '/templates/todo_list.html',
    controller: 'TodoListCtrl'
  });
});
