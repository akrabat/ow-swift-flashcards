'use strict';

var flashcards = {}

flashcards.cards = [
    {
        "front": "Author of Gregor the Overlander",
        "back": "Suzanne Collins"
    },
    {
        "front": "Author of Dragonflight",
        "back": "Anne McCaffrey"
    }
]

flashcards.appInit = function() {
    window.onhashchange = function() {
        flashcards.routeTo(window.location.hash)
    }
    flashcards.routeTo(window.location.hash)
}

flashcards.routeTo = function(name) {
    var routes = {
        '#card': flashcards.cardView
    }

    var nameParts = name.split('-')
    var viewFunction = routes[nameParts[0]]
    if (viewFunction) {
        $('.view-container').empty().append(viewFunction(nameParts[1]));
    }
}

// == Model ==

flashcards.applyObject = function(obj, elem) {
    for (var key in obj) {
        elem.find('[data-name="' + key + '"]').text(obj[key])
    }
}



// == View ==

flashcards.cardView = function(number) {
    var view = $('.templates .card-view').clone()
    view.find('.title').text('Card #' + number)
    flashcards.applyObject(flashcards.cards[number - 1], view)
    view.find('.answer').hide()
    view.find('.next').attr('href','#card-' + (parseInt(number)+1));
    return view
}
