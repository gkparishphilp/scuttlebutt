
$( document ).ready ->

	comment_widgets = []
	comment_widget_url = null
	$('.has_current_user .scuttlebutt_comments_widget').each ->
		comment_widget_url ||= $(this).data('url').split("?")[0]
		comment_widgets.push( $(this).data('params') )
	if comment_widgets.length > 0
		$.getScript( comment_widget_url + "?" + jQuery.param( { comment_widgets: comment_widgets } ) )


	vote_widgets = []
	vote_widget_url = null
	$('.has_current_user .scuttlebutt_votes_widget').each ->
		vote_widget_url ||= $(this).data('url').split("?")[0]
		vote_widgets.push( $(this).data('params') )
	if vote_widgets.length > 0
		$.getScript( vote_widget_url + "?" + jQuery.param( { vote_widgets: vote_widgets } ) )

	subscription_widgets = []
	subscription_widget_url = null
	$('.has_current_user .scuttlebutt_subscriptions_widget').each ->
		subscription_widget_url ||= $(this).data('url').split("?")[0]
		subscription_widgets.push( $(this).data('params') )
	if subscription_widgets.length > 0
		$.getScript( subscription_widget_url + "?" + jQuery.param( { subscription_widgets: subscription_widgets } ) )
