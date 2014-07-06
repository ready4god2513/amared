app.controller('CommentController', ['$scope', '$timeout', 'Amared', function($scope, $timeout, Amared){

  $scope.comments = [];
  $scope.allComments = [];
  $scope.subreddit = 'all';
  $scope.Search = '';
  $scope.maxLength = 100;

  $scope.getRecentComments = function(){
    Amared.recentComments($scope.subreddit, function(res){
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