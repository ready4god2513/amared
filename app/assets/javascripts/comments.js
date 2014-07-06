var app = angular.module('amared', ['ngResource', 'ui.utils', 'ngAnimate']);

app.factory('Amared', ['$http', function($http){
  return {
    recent: function(subreddit, callback){
      $http.get('/r/' + subreddit + '/comments.json?limit=20').success(function(response){
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
  $scope.allComments = [];
  $scope.subreddit = 'all';
  $scope.Search = '';
  $scope.maxLength = 100;

  $scope.getRecentComments = function(){
    Amared.recent($scope.subreddit, function(res){
      $scope.allComments = $scope.allComments.concat(res);
      $timeout(function(){
        $scope.getRecentComments();
      }, 3000);

    });
  };

  $scope.addNewComment = function(){
    var allCommentsLength = $scope.allComments.length;

    if(allCommentsLength){
      $scope.comments.unshift($scope.allComments.shift());

      if($scope.comments.length > $scope.maxLength){
        $scope.comments.pop();
      }
    }

    $timeout(function(){
      $scope.addNewComment();
    }, Math.random() * 1500);
  }

  $scope.addNewComment();

}]);