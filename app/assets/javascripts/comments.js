var app = angular.module('amared', ['ngResource']);

app.factory('Amared', ['$http', function($http){
  return {
    recent: function(subreddit, callback){
      $http.get('/r/' + subreddit + '/comments.json?limit=1000').success(function(response){
        callback(response);
      });
    }
  };
}]);

app.filter('unsafe', function($sce) {
  return function(val) {
    return $sce.trustAsHtml(val);
  };
});


app.controller('CommentController', ['$scope', '$timeout', 'Amared', function($scope, $timeout, Amared){

  $scope.comments = [];
  $scope.subreddit = 'all';

  $scope.getRecentComments = function(){
    Amared.recent($scope.subreddit, function(res){
      $scope.comments = res;
      $timeout(function(){
        $scope.getRecentComments();
      }, 1000);

    });
  };

}]);