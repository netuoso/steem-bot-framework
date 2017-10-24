// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require bootstrap-sprockets
//= require bootstrap-multiselect
//= require_tree .

function showRelatedElements(selectedAction) {
	if (selectedAction == 'vote') {
		// Required
		$('#steemit-url')[0].disabled = false;
		$('#bot_action')[0].disabled = false;
		$('#bot_action')[0].required = true;
		$('#bots')[0].disabled = false;
		$('#bots')[0].required = true;
		$('#permlink')[0].disabled = false;
		$('#permlink')[0].required = true	;
		$('#author')[0].disabled = false;
		$('#author')[0].required = true;
		$('#power')[0].disabled = false;
		$('#power')[0].required = true;

		// Disallowed
		$('#tags')[0].disabled = true;
		$('#tags')[0].required = false;
		$('#title')[0].disabled = true;
		$('#title')[0].required = false;
		$('#body')[0].disabled = true;
		$('#body')[0].required = false;
		$('#parent_permlink')[0].disabled = true;
		$('#parent_permlink')[0].required = false;
		$('#parent_author')[0].disabled = true;
		$('#parent_author')[0].required = false;

	} else if (selectedAction == 'comment') {
		// Required
		$('#bot_action')[0].disabled = false;
		$('#bot_action')[0].required = true;
		$('#bots')[0].disabled = false;
		$('#bots')[0].required = true;
		$('#permlink')[0].disabled = false;
		$('#permlink')[0].required = true;
		$('#title')[0].disabled = false;
		$('#title')[0].required = true;
		$('#parent_permlink')[0].disabled = false;
		$('#parent_permlink')[0].required = true;

		// Allowed
		$('#tags')[0].disabled = false;
		$('#tags')[0].required = false;
		$('#body')[0].disabled = false;
		$('#body')[0].required = true;
		$('#parent_author')[0].disabled = false;
		$('#parent_author')[0].required = false;

		// Disallowed
		$('#author')[0].disabled = true;
		$('#author')[0].required = false;
		$('#power')[0].disabled = true;
		$('#power')[0].required = false;

	} else if (selectedAction == 'resteem') {
		// Required
		$('#bot_action')[0].disabled = false;
		$('#bot_action')[0].required = true;
		$('#bots')[0].disabled = false;
		$('#bots')[0].required = true;
		$('#permlink')[0].disabled = false;
		$('#permlink')[0].required = true;
		$('#author')[0].disabled = false;
		$('#author')[0].required = true;

		// Disallowed
		$('#power')[0].disabled = true;
		$('#power')[0].required = false;
		$('#tags')[0].disabled = true;
		$('#tags')[0].required = false;
		$('#title')[0].disabled = true;
		$('#title')[0].required = false;
		$('#body')[0].disabled = true;
		$('#body')[0].required = false;
		$('#parent_permlink')[0].disabled = true;
		$('#parent_permlink')[0].required = false;
		$('#parent_author')[0].disabled = true;
		$('#parent_author')[0].required = false;

	} else if (selectedAction === 'download') {
		// Disallowed
		$('#bot_action')[0].disabled = false;
		$('#bot_action')[0].required = true;
		$('#bots')[0].disabled = false;
		$('#bots')[0].required = true;
		$('#filename')[0].disabled = false;
		$('#filename')[0].required = true;
		$('#version')[0].disabled = false;
		$('#version')[0].required = true;
		$('#attachment-fields')[0].style = 'display: none;';
		$('#attachment')[0].disabled = true;
		$('#attachment')[0].required = false;
	} else if (selectedAction === 'upload') {
		// Disallowed
		$('#bot_action')[0].disabled = false;
		$('#bot_action')[0].required = true;
		$('#bots')[0].disabled = false;
		$('#bots')[0].required = true;
		$('#filename')[0].disabled = false;
		$('#filename')[0].required = true;
		$('#version')[0].disabled = false;
		$('#version')[0].disabled = false;
		$('#attachment-fields')[0].style = 'display: block;';
		$('#attachment')[0].disabled = false;
		$('#attachment')[0].required = true;
	} else {
		// Disallowed
		$('#bot_action')[0].disabled = true;
		$('#bot_action')[0].required = true;
		$('#bots')[0].disabled = true;
		$('#bots')[0].required = true;
		$('#permlink')[0].disabled = true;
		$('#permlink')[0].required = true;
		$('#author')[0].disabled = true;
		$('#author')[0].required = true;
		$('#power')[0].disabled = true;
		$('#power')[0].required = true;
		$('#tags')[0].disabled = true;
		$('#tags')[0].required = true;
		$('#title')[0].disabled = true;
		$('#title')[0].required = true;
		$('#body')[0].disabled = true;
		$('#body')[0].required = true;
		$('#parent_permlink')[0].disabled = true;
		$('#parent_permlink')[0].required = true;
		$('#parent_author')[0].disabled = true;
		$('#parent_author')[0].required = true;
	}
}

$(document).ready(function(){
	showRelatedElements($('select#bot_action')[0].value);

	$('select#bot_action').change(function(){
		showRelatedElements(this.value);
	});

	$('select#bots').multiselect({
		nonSelectedText: '0 bots selected'
	});

	$('#parse_url').on('click', function (){
		$.ajax({
			method: 'GET',
			url: '/parse_url',
			data: {steemit_url: $('input#steemit-url')[0].value}
		}).done(function(data){
			if ($('select#bot_action')[0].value == 'vote') {
				if (data.response.actions.indexOf('resteem') > 0) {
					showRelatedElements($('select#bot_action')[0].value);
					$('#permlink')[0].value = data.response.post_permlink;
					$('#author')[0].value = data.response.post_author;
					console.log($('#power')[0].val);
					if ($('#power')[0].value === "") {
						$('#power')[0].value = 5;
					}
				} else {
					showRelatedElements($('select#bot_action')[0].value);
					$('#permlink')[0].value = data.response.comment_permlink;
					$('#author')[0].value = data.response.comment_author;
					if ($('#power')[0].value === "") {
						$('#power')[0].value = 5;
					}
				}
			} else if ($('select#bot_action')[0].value == 'comment') {
				if (data.response.actions.indexOf('resteem') > 0) {
					showRelatedElements($('select#bot_action')[0].value);
					$('#permlink')[0].placeholder = 'unique permlink for your comment';
					$('#tags')[0].disabled = true;
					$('#tags')[0].required = false;
					$('#title')[0].value = 'comment made via <%= Settings.framework_name %>';
					$('#parent_permlink')[0].value = data.response.post_permlink;
					$('#parent_author')[0].value = data.response.post_author;
				} else {
					showRelatedElements($('select#bot_action')[0].value);
					$('#permlink')[0].placeholder = 'unique permlink for your comment';
					$('#tags')[0].disabled = true;
					$('#tags')[0].required = false;
					$('#title')[0].value = 'comment made via <%= Settings.framework_name %>';
					$('#parent_permlink')[0].value = data.response.comment_permlink;
					$('#parent_author')[0].value = data.response.comment_author;
				}

			} else if ($('select#bot_action')[0].value == 'resteem') {
				$('#permlink')[0].value = data.response.post_permlink;
				$('#author')[0].value = data.response.post_author;
			}
		});
	});
});
