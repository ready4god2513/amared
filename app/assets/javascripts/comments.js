var app = angular.module('amared', ['ngResource']);

app.factory('Amared', ['$http', function($http){
  return {
    recent: function(callback){
      $http.get('/r/all/comments.json?limit=1000').success(function(response){
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

  $scope.comments = []

  $scope.getRecentComments = function(){
    Amared.recent(function(res){
      res.forEach(function(item){
        $scope.comments.unshift(item); // Let's add one at a time to the top.
      });

      $timeout(function(){
        $scope.getRecentComments();
      }, 3000);

    });
  };

}]);