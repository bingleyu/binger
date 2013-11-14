updateCountdown = ->
  text =  jQuery('#micropost_content').val()  
  remaining = 140 - text.length
  jQuery('.countdown').text remaining + ' characters remaining'
  jQuery(".countdown").css "color", (if (140 >= remaining >= 21) then "gray")
  jQuery(".countdown").css "color", (if (21 > remaining >= 11) then "black")
  jQuery(".countdown").css "color", (if (11 > remaining)  then "red")
  jQuery('.countdown').addClass 'alert alert-error' if remaining < 0
  jQuery('.countdown').removeClass 'alert alert-error' if remaining > 0

jQuery(document).ready ->
  jQuery('#new_micropost').append '<span class="countdown">140 characters remaining</span>'
  jQuery('#micropost_content').change updateCountdown
  jQuery('#micropost_content').keyup updateCountdown
  return