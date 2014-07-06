app.controller('SubController', ['$scope', '$timeout', '$filter', 'Amared', function($scope, $timeout, $filter, Amared){

  $scope.posts = [];
  $scope.allPosts = [];
  $scope.subreddit = 'all';
  $scope.Search = '';
  $scope.maxLength = 500;

  $scope.getRecentPosts = function(){
    Amared.recentPosts($scope.subreddit, function(res){
      $scope.allPosts = $scope.allPosts.concat(res.reverse());
      $timeout(function(){
        $scope.getRecentPosts();
      }, 2000);

    });
  };

  $scope.addNewPost = function(){
    var allPostsLength = $scope.allPosts.length;

    if(allPostsLength){
      var new_post = $scope.allPosts.shift();
      $scope.posts.push(new_post);

      if($scope.posts.length > $scope.maxLength){
        $scope.posts.unshift();
      }
    }

    $timeout(function(){
      $scope.addNewPost();
    }, 200);
  }

  $scope.addNewPost();

}]);