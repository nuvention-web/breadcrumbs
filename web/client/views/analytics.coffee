# Template.analytics.rendered = ->
#   console.log 'pregaq'
#   if !window._gaq?
#     window._gaq = []
#     _gaq.push(['_setAccount', 'UA-58703434-1'])
#     _gaq.push(['_trackPageview'])
#     console.log 'here gaq'
#     (->
#       ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
#       gajs = '.google-analytics.com/ga.js'
#       ga.src = if 'https:' is document.location.protocol then 'https://ssl'+gajs else 'http://www'+gajs
#       s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s)
#     )()