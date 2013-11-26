config = ($routeProvider, $locationProvider, $httpProvider)->
  $locationProvider.html5Mode(true)

  unauthorizedInterceptor = ['$rootScope', '$q', '$location', (scope, $q, $location)->
      success = (response)-> response
      error   = (response)->
        console.log "INTERCEPTER", response
        return $q.reject(response) if response.status != 401
        $location.path("/login") if $location.path != "/login"

      return ((promise)-> promise.then(success, error))
    ]
  $httpProvider.responseInterceptors.push(unauthorizedInterceptor)
  $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'


  $routeProvider.when('/',
      templateUrl: '/static/partials/hello.html',
      controller: 'ThreadsCtrl'
      resolve:
        threads: AppResolvers.threads
        auth: AppResolvers.auth
    ).when('/login',
      templateUrl: '/static/partials/login.html'
      controller: 'SessionCtrl'
      resolve:
        auth: AppResolvers.auth
    ).when('/threads/:category',
      templateUrl: '/static/partials/threads.html',
      controller: 'ThreadsCtrl'
    ).when('/domains',
      templateUrl: '/static/partials/domains.html'
      controller: 'DomainsCtrl'
      resolve:
        domains: AppResolvers.domains
        auth: AppResolvers.auth
    ).when('/users',
      templateUrl: '/static/partials/users/list.html'
      controller: 'UsersListCtrl'
      resolve:
        users: AppResolvers.users
        auth: AppResolvers.auth
    ).when('/users/new',
      templateUrl: '/static/partials/users/user.html'
      controller: 'UserCtrl'
      resolve:
        auth: AppResolvers.auth
        user: AppResolvers.user
    ).when('/users/:user_id/:edit',
      templateUrl: '/static/partials/users/user.html'
      controller: 'UserCtrl'
      resolve:
        user: AppResolvers.user
        auth: AppResolvers.auth
    ).otherwise(redirectTo: '/not_found')


window.app = angular
  .module('Firebrick', ['ngRoute', 'ngResource', 'ngSanitize'])
  .config ['$routeProvider', '$locationProvider', '$httpProvider', config]
