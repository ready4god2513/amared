# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(".render-video").click (e) ->
    e.preventDefault()

    vid = $(this).data("video")
    $(this).parent(".media").html(vid)