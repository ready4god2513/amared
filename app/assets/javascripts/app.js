var app = angular.module('amared', ['ngResource', 'ui.utils', 'ngAnimate']);

app.factory('Amared', ['$http', function($http){
  return {
    recentComments: function(subreddit, callback){
      $http.get('/r/' + subreddit + '/comments.json?limit=20').success(function(response){
        callback(response);
      });
    },
    recentPosts: function(subreddit, callback){
      $http.get('/r/' + subreddit + '/new.json?limit=100&images=true').success(function(response){
        callback(response);
      });
    },
  };
}]);

app.filter('unsafe', ['$sce', function($sce) {
  return function(val) {
    return $sce.trustAsHtml(val);
  };
}]);

app.filter('imageFilter', function() {
  return function(items) {
    var filtered = [];
    items.forEach(function(item){
      if(item.link.attributes.url.match(/\.png|\.jpg|\.jpeg|\.gif/i)){
        filtered.push(item);
      }
    });
    return filtered;
  };
});
