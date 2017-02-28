// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require tether
//= require bootstrap
//= require_tree .

$(document).ready(function(){

	//Disable cut copy paste on images
    $('img').bind('cut copy paste', function (e) {
        e.preventDefault();
    });

    // Disable mouse right click on images
    $("img").on("contextmenu",function(e){
        return false;
    });

	// Image Gallery - add class to image based on landscape or portrait
	//	$('.modal_image2 img').each(function(){
	//		alert((this.width) + " " +(this.height));
	//	    $(this).addClass(this.width > this.height ? 'image_gallery_landscape' : 'image_gallery_portrait');
	//	});

	// Image Gallery
	$('.image_gallery_hover_bar').hide();
	$(".image_gallery_panel").mouseenter(function() {
		$(this).find('.image_gallery_hover_bar').fadeIn('fast');
	});
	$(".image_gallery_panel").mouseleave (function() {
		$(this).find('.image_gallery_hover_bar').fadeOut('fast')
	});

	$('.image_gallery_caption').hide();
	//	$(".image_gallery_panel").mouseenter(function() {
	//		$(this).find('.image_gallery_caption').fadeIn('fast');
	//	});
	//	$(".image_gallery_panel").mouseleave (function() {
	//		$(this).find('.image_gallery_caption').fadeOut('fast')
	//	});
	
	$('.order_items').hide();
	$(".show_order_items").click(function() {
		$(this).closest("tr").next("tr").slideToggle("slow");
		// alert($(this).closest("tr").next("tr").text());
	});

	$('#order_credit_card_number').bind('input', function() {
		// define tests of credit card numbers
		var visa = new RegExp("^4");
		var amex = new RegExp("^3[47]");
		var mastercard = new RegExp("^5[1-5]");
		var discover = new RegExp("^(6011|622(1(2[6-9]|[3-9][0-9])|[2-8][0-9][0-9]|9([0-1][0-9]|2[0-5]))|64[4-9]|65)");

		// test inputted credit card number
		var value = ($(this).val());
		var visa_color = visa.test(value) ? "black" : "silver";
		var amex_color = amex.test(value) ? "black" : "silver";
		var mastercard_color = mastercard.test(value) ? "black" : "silver";
		var discover_color = discover.test(value) ? "black" : "silver";

		// set color based on what credit card number is inputted
		$('.visa').css('color', visa_color);
		$('.amex').css('color', amex_color);
		$('.mastercard').css('color', mastercard_color);
		$('.discover').css('color', discover_color);
	});

});

