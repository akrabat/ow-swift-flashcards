'use strict';

var flashcards = {}

flashcards.cards = [
    {
        "front": "Author of Rogue Genesis",
        "back": "Ceri London"
    },
    {
        "front": "Author of Shadow Over Avalon",
        "back": "C.N. Lesley"
    },
    {
        "front": "Author of Kindred",
        "back": "Octavia E. Butler"
    },
    {
        "front": "Author of Beholder's Eye",
        "back": "Julie E. Czerneda"
    },
    {
        "front": "Author of Harry Potter and the Philospoher's Stone",
        "back": "J. K. Rowling"
    },
    {
        "front": "Author of Interview with the Vampire",
        "back": "Anne Rice"
    },
    {
        "front": "Author of To Kill a Mockingbird",
        "back": "Harper Lee"
    },
    {
        "front": "Author of The Talented Mr Ripley",
        "back": "Patricia Highsmith"
    },
    {
        "front": "Author of The Awakening",
        "back": "Kate Chopin"
    },
    {
        "front": "Author of Middlemarch",
        "back": "George Eliot"
    },
    {
        "front": "Author of The Dispossessed",
        "back": "Ursula K. Le Guin"
    },
    {
        "front": "Author of Frankenstein",
        "back": "Mary Shelly"
    },
    {
        "front": "Author of Starshine",
        "back": "G.S. Jennsen"
    },
    {
        "front": "Author of The Hunger Games",
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
    return card
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
    view.find('.next').attr('href','#card-' + (parseInt(number)+1));
    return view
}

flashcards.addCardView = function(number) {
    var view = $('.templates .addcard-view').clone()

    view.find(".add-btn").click(flashcards.addButtonClick)
    
    return view
}
