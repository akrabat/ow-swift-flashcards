'use strict';

var flashcards = {}

flashcards.cards = []

flashcards.appInit = function() {
    flashcards.fetchAll()
    window.onhashchange = function() {
        flashcards.routeTo(window.location.hash)
    }
    flashcards.routeTo(window.location.hash)
}

flashcards.routeTo = function(name) {
    var routes = {
        '#cards': flashcards.cardsView,
        '#card': flashcards.cardView,
        '#addcard': flashcards.addCardView
    }

    var nameParts = name.split('-')
    var viewFunction = routes[nameParts[0]]
    if (viewFunction) {
        $('.view-container').empty().append(viewFunction(nameParts[1]));
    } else {
        $('.view-container').empty().append(flashcards.homeView);
    }
}

flashcards.addButtonClick = function() {
    var view = $('.templates .addcard-view').clone()
    var card = flashcards.extractObject(view.find('form'))
    flashcards.cards.push(card)
    console.log(flashcards.cards)
    flashcards.routeTo("#cards")
    return false
}


// == Model ==

flashcards.applyObject = function(obj, elem) {
    for (var key in obj) {
        elem.find('[data-name="' + key + '"]').text(obj[key])
    }
}

flashcards.extractObject = function(elem) {

    var card = {}
    elem.find("[data-name]").each(function(){
        var key = $(this).data('name');
        var value = $(this).val();
        card[key] = value
    });
    card["type"] = "card"
    card["deck"] = "authors"

    return card
}

flashcards.fetchAll = function() {
    jQuery.ajax({
        url: "https://openwhisk.ng.bluemix.net/api/v1/web/19FT_dev/flashcards/cards",
        type: "GET",

        contentType: 'application/json; charset=utf-8',
        success: function(resultData) {
            $.each( resultData.cards, function( i, item ) {
                item.id = i
                flashcards.cards.push(item)
            });
        },
        error : function(jqXHR, textStatus, errorThrown) {
        },
        timeout: 120000,
    });
}


// == View ==

flashcards.homeView = function(number) {
    var view = $('.templates .landing-view').clone()
    return view
}

flashcards.cardsView = function() {
    var view = $('.templates .cards-view').clone()

    // get template from UL and then remove it from list
    var list = view.find('.cards')
    var cardTemplate = view.find('.card-template').clone()
    cardTemplate.removeClass('card-template');
    view.find('.card-template').remove()

    // iterate over data and append each one to the list
    for (var key in flashcards.cards) {
        var card = cardTemplate.clone()
        flashcards.applyObject(flashcards.cards[key], card)
        card.appendTo(list)
    }
    return view
}

flashcards.cardView = function(number) {
    var view = $('.templates .card-view').clone()
    view.find('.title').text('Card #' + number)
    flashcards.applyObject(flashcards.cards[number - 1], view)
    view.find('.answer').hide()

    var next = parseInt(number)+1;
    if (next > flashcards.cards.length) {
        next = 1
    }
    view.find('.next').attr('href','#card-' + next);
    return view
}

flashcards.addCardView = function(number) {
    var view = $('.templates .addcard-view').clone()

    view.find(".add-btn").click(flashcards.addButtonClick)
    
    return view
}
